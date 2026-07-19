#!/usr/bin/env ruby
# Validates local governance pack registry and manifest structure without syncing or mutating repositories.

require "yaml"
require "date"
require "json"

ROOT = File.expand_path("..", __dir__)

def repo_path(path)
  File.join(ROOT, path)
end

def load_yaml(path)
  YAML.safe_load(
    File.read(repo_path(path)),
    permitted_classes: [Date],
    aliases: true
  )
end

def assert(condition, message)
  raise message unless condition
end

def load_json(path)
  JSON.parse(File.read(repo_path(path)))
end

def assert_required_keys(value, keys, context)
  assert(value.is_a?(Hash), "#{context}: expected object")
  keys.each do |key|
    assert(value.key?(key), "#{context}: missing #{key}")
  end
end

def validate_naming_contract(path, manifest)
  contract = load_json(path)
  assert(contract.is_a?(Hash), "#{path}: contract must be an object")

  assert_required_keys(contract, %w[
    contract_id title type status authority owner schema_version contract_version
    governance_pack_version channel release_date updated normativity source_metadata
    rules non_normative_examples
  ], path)

  assert(contract["type"] == "naming-contract", "#{path}: type must be naming-contract")
  assert(contract["governance_pack_version"] == manifest.dig("pack", "version"), "#{path}: governance_pack_version must match manifest")
  assert(contract.dig("normativity", "rules_are_normative") == true, "#{path}: rules must be normative")
  assert(contract.dig("normativity", "examples_are_normative") == false, "#{path}: examples must be non-normative")
  assert(contract.dig("normativity", "examples_label") == "non-normative example", "#{path}: examples label must be non-normative example")

  rules = contract["rules"]
  assert(rules.is_a?(Hash), "#{path}: rules must be an object")
  assert(rules.dig("css_class_prefix", "prefix") == "uif-", "#{path}: class prefix must be uif-")
  assert(rules.dig("css_custom_property_prefix", "prefix") == "--uif-", "#{path}: CSS custom property prefix must be --uif-")
  assert(rules.dig("nunjucks_macro_namespace", "alias") == "uif", "#{path}: Nunjucks macro alias must be uif")
  assert(rules.dig("nunjucks_macro_namespace", "invocation_pattern") == "uif.*", "#{path}: Nunjucks macro invocation pattern must be uif.*")
  assert(rules.dig("custom_element_tag_prefix", "prefix") == "uif-", "#{path}: Custom Element tag prefix must be uif-")
  assert(rules.dig("proof_token_prefix", "prefix") == "--uif-proof-", "#{path}: proof token prefix must be --uif-proof-")
  assert(rules.dig("assumption_token_prefix", "prefix") == "--uif-assumption-", "#{path}: assumption token prefix must be --uif-assumption-")
  assert(rules.dig("pattern_id_prefixes", "base_pattern") == "pattern.base.", "#{path}: base pattern prefix must be pattern.base.")
  assert(rules.dig("pattern_id_prefixes", "composition_pattern") == "pattern.composition.", "#{path}: composition pattern prefix must be pattern.composition.")
  assert(rules.dig("pattern_id_prefixes", "product_pattern") == "pattern.product.", "#{path}: product pattern prefix must be pattern.product.")
  assert(rules.key?("compatibility_and_deprecation_policy"), "#{path}: missing compatibility and deprecation policy")

  sources = contract.dig("source_metadata", "canonical_sources")
  assert(sources.is_a?(Array) && sources.any?, "#{path}: source metadata must include canonical sources")
  examples = contract["non_normative_examples"]
  assert(examples.is_a?(Array) && examples.any?, "#{path}: non_normative_examples must be a non-empty list")
  examples.each do |example|
    assert(example.is_a?(Hash), "#{path}: each non-normative example must be an object")
    assert(example["label"] == "non-normative example", "#{path}: example #{example["kind"] || "(unknown)"} must be marked non-normative")
  end
end

registry_path = "registry/governance-packs.yml"
registry = load_yaml(registry_path)
assert(registry.is_a?(Hash), "#{registry_path}: registry must be an object")

assert(registry["type"] == "registry", "#{registry_path}: type must be registry")
assert(registry["packs"].is_a?(Array) && registry["packs"].any?, "#{registry_path}: packs must be a non-empty list")

registry["packs"].each do |pack|
  assert_required_keys(pack, %w[id title current_version channel manifest changelog owner], "#{registry_path}: pack #{pack["id"] || "(unknown)"}")

  manifest_path = pack["manifest"]
  changelog_path = pack["changelog"]

  assert(File.file?(repo_path(manifest_path)), "#{registry_path}: missing manifest #{manifest_path}")
  assert(File.file?(repo_path(changelog_path)), "#{registry_path}: missing changelog #{changelog_path}")

  manifest = load_yaml(manifest_path)
  assert(manifest["type"] == "export-pack", "#{manifest_path}: type must be export-pack")
  assert(manifest.dig("pack", "id") == pack["id"], "#{manifest_path}: pack id must match registry")
  assert(manifest.dig("pack", "version") == pack["current_version"], "#{manifest_path}: version must match registry")
  assert(manifest["artifacts"].is_a?(Array), "#{manifest_path}: artifacts must be a list")

  manifest["artifacts"].each do |artifact|
    assert_required_keys(artifact, %w[id title type path status review_required], "#{manifest_path}: artifact #{artifact["id"] || "(unknown)"}")
    assert(File.file?(repo_path(artifact["path"])), "#{manifest_path}: missing artifact #{artifact["path"]}")
    assert(artifact["review_required"] == true, "#{manifest_path}: artifact #{artifact["id"]} must require review")

    if artifact["type"] == "naming-contract"
      assert(artifact["schema"], "#{manifest_path}: artifact #{artifact["id"]} missing schema")
      assert(File.file?(repo_path(artifact["schema"])), "#{manifest_path}: missing artifact schema #{artifact["schema"]}")
      validate_naming_contract(artifact["path"], manifest)
    end
  end
end

puts "Governance pack validation passed."
