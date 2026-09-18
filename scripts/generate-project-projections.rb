#!/usr/bin/env ruby
# frozen_string_literal: true

require "date"
require "digest"
require "fileutils"
require "pathname"
require "yaml"

ROOT = File.expand_path("..", __dir__)
MANIFEST_PATH = File.join(ROOT, "registry/project-projections.yml")
GENERATED_ROOT = File.join(ROOT, ".generated/project-projections")
ALLOWED_DELIVERY = %w[snapshot live-reference].freeze
ALLOWED_MATERIALIZATION = %w[generated].freeze

def fail!(message)
  warn message
  exit 1
end

def read_yaml(path)
  YAML.safe_load(File.read(path), permitted_classes: [Date], aliases: false)
end

def required_string(value, field, errors)
  errors << "Missing or invalid required field: #{field}" unless value.is_a?(String) && !value.strip.empty?
end

def required_string_list(value, field, errors)
  unless value.is_a?(Array) && !value.empty? && value.all? { |item| item.is_a?(String) && !item.strip.empty? }
    errors << "#{field} must be a non-empty string list"
  end
end

def repository_path(path, field, errors)
  required_string(path, field, errors)
  return nil unless path.is_a?(String) && !path.strip.empty?

  candidate = Pathname.new(File.expand_path(path, ROOT))
  root = Pathname.new(ROOT)

  unless candidate.to_s == root.to_s || candidate.to_s.start_with?("#{root}#{File::SEPARATOR}")
    errors << "#{field} resolves outside the repository: #{path.inspect}"
    return nil
  end

  candidate.to_s
end

def fragment_index(pack, projection_id)
  fragments = pack["fragments"]
  unless fragments.is_a?(Array) && !fragments.empty?
    raise "#{projection_id} fragment pack must contain a non-empty fragments list"
  end

  ids = fragments.map { |fragment| fragment["id"] }
  duplicates = ids.compact.group_by(&:itself).select { |_id, values| values.length > 1 }.keys
  raise "#{projection_id} fragment pack has duplicate ids: #{duplicates.join(", ")}" unless duplicates.empty?

  index = {}
  fragments.each do |fragment|
    errors = []
    required_string(fragment["id"], "#{projection_id}.fragments[].id", errors)
    required_string(fragment["text"], "#{projection_id}.#{fragment["id"]}.text", errors)

    source_ids = fragment["source_ids"]
    if source_ids && !(source_ids.is_a?(Array) && source_ids.all? { |id| id.is_a?(String) && !id.strip.empty? })
      errors << "#{projection_id}.#{fragment["id"]}.source_ids must be a string list when present"
    end

    raise errors.join("\n") unless errors.empty?
    index[fragment["id"]] = fragment
  end

  index
end

def compose_fragment_projection(entry, errors)
  projection_id = entry["id"]
  pack_path = repository_path(entry["fragment_pack_path"], "#{projection_id}.fragment_pack_path", errors)
  required_string(entry["fragment_pack_id"], "#{projection_id}.fragment_pack_id", errors)
  required_string_list(entry["fragment_ids"], "#{projection_id}.fragment_ids", errors)

  if pack_path && !File.file?(pack_path)
    errors << "#{projection_id}.fragment_pack_path does not exist: #{entry["fragment_pack_path"]}"
  end

  raise errors.join("\n") unless errors.empty?

  pack = read_yaml(pack_path)
  unless pack.is_a?(Hash)
    raise "#{projection_id} fragment pack must be a YAML object"
  end
  unless pack["id"] == entry["fragment_pack_id"]
    raise "#{projection_id}.fragment_pack_id #{entry["fragment_pack_id"].inspect} does not match pack id #{pack["id"].inspect}"
  end

  index = fragment_index(pack, projection_id)
  missing = entry["fragment_ids"].reject { |id| index.key?(id) }
  raise "#{projection_id} references missing fragments: #{missing.join(", ")}" unless missing.empty?

  separator = entry.key?("separator") ? entry["separator"] : "\n\n"
  unless separator.is_a?(String)
    raise "#{projection_id}.separator must be a string"
  end

  entry["fragment_ids"].map { |id| index.fetch(id).fetch("text") }.join(separator)
end

def validate_projection(entry)
  errors = []
  projection_id = entry["id"]

  required_string(projection_id, "projections[].id", errors)
  required_string(entry["consumer"], "#{projection_id}.consumer", errors)
  required_string(entry["sync_mode"], "#{projection_id}.sync_mode", errors)

  output_path = repository_path(entry["output_path"], "#{projection_id}.output_path", errors)

  unless ALLOWED_DELIVERY.include?(entry["delivery"])
    errors << "#{projection_id}.delivery must be one of #{ALLOWED_DELIVERY.join(", ")}"
  end

  unless ALLOWED_MATERIALIZATION.include?(entry["materialization"])
    errors << "#{projection_id}.materialization must be generated"
  end

  max_characters = entry.dig("limits", "max_characters")
  unless max_characters.is_a?(Integer) && max_characters.positive?
    errors << "#{projection_id}.limits.max_characters must be a positive integer"
  end

  if output_path && !output_path.start_with?("#{GENERATED_ROOT}#{File::SEPARATOR}")
    errors << "#{projection_id}.output_path must stay under .generated/project-projections/"
  end

  raise errors.join("\n") unless errors.empty?

  artifact = compose_fragment_projection(entry, errors)

  if artifact.length > max_characters
    raise "#{projection_id} exceeds character limit: #{artifact.length}/#{max_characters}"
  end

  Array(entry["required_contains"]).each do |required|
    required_string(required, "#{projection_id}.required_contains[]", errors)
    next unless required.is_a?(String) && !required.empty?
    errors << "#{projection_id} is missing required content: #{required.inspect}" unless artifact.include?(required)
  end

  raise errors.join("\n") unless errors.empty?

  {
    id: projection_id,
    output_path: output_path,
    artifact: artifact,
    characters: artifact.length,
    max_characters: max_characters,
    sha256: Digest::SHA256.hexdigest(artifact)
  }
end

def preflight(manifest)
  raise "Projection registry must be a YAML object" unless manifest.is_a?(Hash)

  projections = manifest["projections"]
  unless projections.is_a?(Array) && !projections.empty?
    raise "Projection registry must contain a non-empty projections list"
  end

  ids = projections.map { |entry| entry["id"] }
  duplicates = ids.compact.group_by(&:itself).select { |_id, values| values.length > 1 }.keys
  raise "Duplicate projection ids: #{duplicates.join(", ")}" unless duplicates.empty?

  outputs = projections.map { |entry| entry["output_path"] }
  duplicate_outputs = outputs.compact.group_by(&:itself).select { |_path, values| values.length > 1 }.keys
  raise "Duplicate projection output paths: #{duplicate_outputs.join(", ")}" unless duplicate_outputs.empty?

  projections.map { |entry| validate_projection(entry) }
end

def stale_generated_artifact?(plan)
  return false unless File.file?(plan[:output_path])

  File.read(plan[:output_path]) != "#{plan[:artifact]}\n"
end

def write_atomically(plan)
  FileUtils.mkdir_p(File.dirname(plan[:output_path]))
  tmp = "#{plan[:output_path]}.tmp"
  File.write(tmp, "#{plan[:artifact]}\n")
  File.rename(tmp, plan[:output_path])
end

def main
  check = ARGV.include?("--check")

  plans = begin
    preflight(read_yaml(MANIFEST_PATH))
  rescue StandardError => e
    fail!("Projection preflight failed:\n#{e.message}")
  end

  if check
    stale = plans.select { |plan| stale_generated_artifact?(plan) }
    unless stale.empty?
      stale.each { |plan| warn "STALE #{plan[:id]}: regenerate #{plan[:output_path].sub("#{ROOT}/", "")}" }
      exit 1
    end

    plans.each do |plan|
      puts "PASS #{plan[:id]}: #{plan[:characters]}/#{plan[:max_characters]} chars sha256=#{plan[:sha256]}"
    end
    return
  end

  # Every projection has passed source resolution and validation before any output is replaced.
  plans.each { |plan| write_atomically(plan) }

  plans.each do |plan|
    puts "Generated #{plan[:output_path].sub("#{ROOT}/", "")}: #{plan[:characters]} chars sha256=#{plan[:sha256]}"
  end
end

main
