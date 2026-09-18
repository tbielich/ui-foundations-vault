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

def read_manifest
  raw = File.read(MANIFEST_PATH)
  YAML.safe_load(raw, permitted_classes: [Date], aliases: false)
end

def required_string(value, path, errors)
  if !value.is_a?(String) || value.strip.empty?
    errors << "Missing or invalid required field: #{path}"
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

def document_id(content)
  frontmatter = content.match(/\A---\s*\n(.*?)\n---\s*\n/m)
  return nil unless frontmatter

  data = YAML.safe_load(frontmatter[1], permitted_classes: [Date], aliases: false)
  data.is_a?(Hash) ? data["id"] : nil
end

def extract_fenced_section(content, section, language)
  heading = /^##\s+#{Regexp.escape(section)}\s*$/
  match = content.match(heading)
  raise "Section not found: #{section.inspect}" unless match

  tail = content[match.end(0)..]
  fence = /^\`\`\`#{Regexp.escape(language)}\s*\n(.*?)^\`\`\`\s*$/m
  fenced = tail.match(fence)
  raise "Fenced #{language.inspect} block not found after section #{section.inspect}" unless fenced

  fenced[1].sub(/\n\z/, "")
end

def validate_projection(entry)
  errors = []

  required_string(entry["id"], "projections[].id", errors)
  required_string(entry["consumer"], "#{entry["id"]}.consumer", errors)
  required_string(entry["source_document_id"], "#{entry["id"]}.source_document_id", errors)
  required_string(entry["source_section"], "#{entry["id"]}.source_section", errors)
  required_string(entry["source_fence_language"], "#{entry["id"]}.source_fence_language", errors)
  required_string(entry["sync_mode"], "#{entry["id"]}.sync_mode", errors)

  source_path = repository_path(entry["source_path"], "#{entry["id"]}.source_path", errors)
  output_path = repository_path(entry["output_path"], "#{entry["id"]}.output_path", errors)

  unless ALLOWED_DELIVERY.include?(entry["delivery"])
    errors << "#{entry["id"]}.delivery must be one of #{ALLOWED_DELIVERY.join(", ")}"
  end

  unless ALLOWED_MATERIALIZATION.include?(entry["materialization"])
    errors << "#{entry["id"]}.materialization must be generated"
  end

  max_characters = entry.dig("limits", "max_characters")
  unless max_characters.is_a?(Integer) && max_characters.positive?
    errors << "#{entry["id"]}.limits.max_characters must be a positive integer"
  end

  if output_path && !output_path.start_with?("#{GENERATED_ROOT}#{File::SEPARATOR}")
    errors << "#{entry["id"]}.output_path must stay under .generated/project-projections/"
  end

  if source_path && !File.file?(source_path)
    errors << "#{entry["id"]}.source_path does not exist: #{entry["source_path"]}"
  end

  raise errors.join("\n") unless errors.empty?

  content = File.read(source_path)
  actual_id = document_id(content)
  unless actual_id == entry["source_document_id"]
    raise "#{entry["id"]}.source_document_id #{entry["source_document_id"].inspect} does not match source id #{actual_id.inspect}"
  end

  artifact = extract_fenced_section(
    content,
    entry["source_section"],
    entry["source_fence_language"]
  )

  if artifact.length > max_characters
    raise "#{entry["id"]} exceeds character limit: #{artifact.length}/#{max_characters}"
  end

  Array(entry["required_contains"]).each do |required|
    required_string(required, "#{entry["id"]}.required_contains[]", errors)
    next unless required.is_a?(String) && !required.empty?
    errors << "#{entry["id"]} is missing required content: #{required.inspect}" unless artifact.include?(required)
  end

  raise errors.join("\n") unless errors.empty?

  {
    id: entry["id"],
    output_path: output_path,
    artifact: artifact,
    characters: artifact.length,
    max_characters: max_characters,
    sha256: Digest::SHA256.hexdigest(artifact)
  }
end

def preflight(manifest)
  unless manifest.is_a?(Hash)
    raise "Projection registry must be a YAML object"
  end

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
    preflight(read_manifest)
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

  # All projections have passed preflight before any output is replaced.
  plans.each { |plan| write_atomically(plan) }

  plans.each do |plan|
    puts "Generated #{plan[:output_path].sub("#{ROOT}/", "")}: #{plan[:characters]} chars sha256=#{plan[:sha256]}"
  end
end

main
