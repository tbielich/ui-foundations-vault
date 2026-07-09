#!/usr/bin/env ruby
# Validates local governance pack registry and manifest structure without syncing or mutating repositories.

require "yaml"
require "date"
require "json"

ROOT = File.expand_path("..", __dir__)

def load_yaml(path)
  YAML.safe_load(
    File.read(File.join(ROOT, path)),
    permitted_classes: [Date],
    aliases: true
  )
end

def assert(condition, message)
  raise message unless condition
end

def load_json(path)
  JSON.parse(File.read(File.join(ROOT, path)))
end

def validate_naming_contract(path, manifest)
  contract = load_json(path)

  %w[
    contract_id title type status authority owner schema_version contract_version
    governance_pack_version channel release_date updated normativity source_metadata
    rules non_normative_examples
  ].each do |key|
    assert(contract.key?(key), "#{path}: missing #{key}")
  end

  assert(contract["type"] == "naming-contract", "#{path}: type must be naming-contract")
  assert(contract["governance_pack_version"] == manifest.dig("pack", "version"), "#{path}: governance_pack_version must match manifest")
  assert(contract.dig("normativity", "rules_are_normative") == true, "#{path}: rules must be normative")
  assert(contract.dig("normativity", "examples_are_normative") == false, "#{path}: examples must be non-normative")
  assert(contract.dig("normativity", "examples_label") == "non-normative example", "#{path}: examples label must be non-normative example")

  rules = contract["rules"]
  assert(rules.dig("css_class_prefix", "prefix") == "uif-", "#{path}: class prefix must be uif-")
  assert(rules.dig("css_custom_property_prefix", "prefix") == "--uif-", "#{path}: CSS custom property prefix must be --uif-")
  assert(rules.dig("proof_token_prefix", "prefix") == "--uif-proof-", "#{path}: proof token prefix must be --uif-proof-")
  assert(rules.dig("assumption_token_prefix", "prefix") == "--uif-assumption-", "#{path}: assumption token prefix must be --uif-assumption-")
  assert(rules.dig("pattern_id_prefixes", "base_pattern") == "pattern.base.", "#{path}: base pattern prefix must be pattern.base.")
  assert(rules.dig("pattern_id_prefixes", "composition_pattern") == "pattern.composition.", "#{path}: composition pattern prefix must be pattern.composition.")
  assert(rules.dig("pattern_id_prefixes", "product_pattern") == "pattern.product.", "#{path}: product pattern prefix must be pattern.product.")
  assert(rules.key?("compatibility_and_deprecation_policy"), "#{path}: missing compatibility and deprecation policy")

  sources = contract.dig("source_metadata", "canonical_sources")
  assert(sources.is_a?(Array) && sources.any?, "#{path}: source metadata must include canonical sources")
  contract["non_normative_examples"].each do |example|
    assert(example["label"] == "non-normative example", "#{path}: example #{example["kind"] || "(unknown)"} must be marked non-normative")
  end
end

registry_path = "registry/governance-packs.yml"
registry = load_yaml(registry_path)

assert(registry["type"] == "registry", "#{registry_path}: type must be registry")
assert(registry["packs"].is_a?(Array), "#{registry_path}: packs must be a list")

registry["packs"].each do |pack|
  %w[id title current_version channel manifest changelog owner].each do |key|
    assert(pack[key], "#{registry_path}: pack #{pack["id"] || "(unknown)"} missing #{key}")
  end

  manifest_path = pack["manifest"]
  changelog_path = pack["changelog"]

  assert(File.file?(File.join(ROOT, manifest_path)), "#{registry_path}: missing manifest #{manifest_path}")
  assert(File.file?(File.join(ROOT, changelog_path)), "#{registry_path}: missing changelog #{changelog_path}")

  manifest = load_yaml(manifest_path)
  assert(manifest["type"] == "export-pack", "#{manifest_path}: type must be export-pack")
  assert(manifest.dig("pack", "id") == pack["id"], "#{manifest_path}: pack id must match registry")
  assert(manifest.dig("pack", "version") == pack["current_version"], "#{manifest_path}: version must match registry")
  assert(manifest["artifacts"].is_a?(Array), "#{manifest_path}: artifacts must be a list")

  manifest["artifacts"].each do |artifact|
    %w[id title type path status review_required].each do |key|
      assert(artifact.key?(key), "#{manifest_path}: artifact #{artifact["id"] || "(unknown)"} missing #{key}")
    end
    assert(File.file?(File.join(ROOT, artifact["path"])), "#{manifest_path}: missing artifact #{artifact["path"]}")
    assert(artifact["review_required"] == true, "#{manifest_path}: artifact #{artifact["id"]} must require review")

    if artifact["type"] == "naming-contract"
      assert(artifact["schema"], "#{manifest_path}: artifact #{artifact["id"]} missing schema")
      assert(File.file?(File.join(ROOT, artifact["schema"])), "#{manifest_path}: missing artifact schema #{artifact["schema"]}")
      validate_naming_contract(artifact["path"], manifest)
    end
  end
end

puts "Governance pack validation passed."
