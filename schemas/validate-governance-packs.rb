#!/usr/bin/env ruby
# Validates local governance pack registry and manifest structure without syncing or mutating repositories.

require "yaml"
require "date"

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
  end
end

puts "Governance pack validation passed."
