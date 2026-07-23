#!/usr/bin/env ruby
# encoding: UTF-8
# Runs read-only vault audits and emits human-readable text or JSON findings.

require "yaml"
require "date"
require "json"
require "time"
require "optparse"
require "set"

ROOT = File.expand_path("..", __dir__)

AUDITS = {
  "frontmatter" => {
    id: "vault-frontmatter-audit",
    version: "0.1",
    scope: "**/*.md"
  },
  "links" => {
    id: "vault-link-audit",
    version: "0.1",
    scope: "**/*.md"
  },
  "taxonomy" => {
    id: "vault-taxonomy-audit",
    version: "0.1",
    scope: "patterns/**/*.md and governed markdown metadata"
  }
}.freeze
AUDITS_BY_ID = AUDITS.values.map { |audit| [audit[:id], audit] }.to_h
AUDIT_RESULT_REQUIRED_FIELDS = %i[
  audit_id audit_version scope status rule_id file_path evidence remediation classification
].freeze
AUDIT_RESULT_STRING_FIELDS = %i[
  audit_id audit_version scope status rule_id file_path evidence remediation classification certainty
].freeze
AUDIT_RESULT_STATUSES = %w[pass warn fail error].freeze
AUDIT_RESULT_CLASSIFICATIONS = %w[deterministic interpretive deterministic-evidence].freeze
AUDIT_RESULT_CERTAINTY = %w[confirmed uncertain].freeze


REQUIRED_FIELDS = %w[id title type status owners created updated authority].freeze
ALLOWED_TYPES = %w[
  principle governance workflow prompt specification adr agent-capability registry
  lesson export-pack schema template glossary pattern index publication
].freeze
ALLOWED_STATUS = %w[draft review accepted stable deprecated archived].freeze
ALLOWED_AUTHORITY = %w[source supporting derived example].freeze
ALLOWED_RELATIONSHIPS = %w[
  depends_on supports supersedes superseded_by implements implemented_by governs
  governed_by references conflicts_with
].freeze
ALLOWED_VERIFICATION_STATUS = %w[
  unverified assumption partially-verified verified
].freeze

options = {
  audit: "all",
  format: "text",
  self_test_contract: false
}

OptionParser.new do |parser|
  parser.banner = "Usage: ruby schemas/validate-vault-audits.rb [--audit frontmatter|links|taxonomy|all] [--format text|json]"
  parser.on("--audit AUDIT", "Audit to run") { |value| options[:audit] = value }
  parser.on("--format FORMAT", "Output format: text or json") { |value| options[:format] = value }
  parser.on("--self-test-contract", "Run audit result contract self-tests") { options[:self_test_contract] = true }
end.parse!

unless (%w[all] + AUDITS.keys).include?(options[:audit])
  warn "Unknown audit: #{options[:audit]}"
  exit 2
end

unless %w[text json].include?(options[:format])
  warn "Unknown format: #{options[:format]}"
  exit 2
end

def governed_files
  patterns = ["**/*.md", "registry/*.yml", "exports/governance-pack/pack.yml", "schemas/vault-audit-result.schema.yml"]
  patterns.flat_map { |pattern| Dir.glob(File.join(ROOT, pattern), File::FNM_DOTMATCH) }
    .uniq
    .reject { |path| path.include?("/.git/") }
    .reject { |path| path.include?("/exports/agent-pack/skills/") }
    .map { |path| relative_path(path) }
    .sort
end

def markdown_files
  governed_files.select { |path| path.end_with?(".md") }
end

def relative_path(path)
  path.sub("#{ROOT}/", "")
end

def full_path(path)
  File.join(ROOT, path)
end

def read_file(path)
  File.binread(full_path(path)).force_encoding("UTF-8").encode("UTF-8", invalid: :replace, undef: :replace)
end

def parse_frontmatter(path)
  content = read_file(path)
  return [nil, "missing frontmatter"] unless content.start_with?("---\n")

  closing = content.index("\n---", 4)
  if closing
    raw = content[4...closing]
  elsif path.end_with?(".yml", ".yaml")
    raw = content
  else
    return [nil, "unterminated frontmatter"]
  end
  [YAML.safe_load(raw, permitted_classes: [Date], aliases: true), nil]
rescue Psych::SyntaxError => error
  [nil, "invalid YAML: #{error.message.lines.first&.strip || error.message}"]
end

def first_heading(path)
  read_file(path).each_line.find { |line| line.start_with?("# ") }&.sub(/^#\s+/, "")&.strip
end

def finding(audit_key, status, rule_id, file_path, evidence, remediation, classification: "deterministic", certainty: "confirmed")
  audit = AUDITS.fetch(audit_key)
  {
    audit_id: audit[:id],
    audit_version: audit[:version],
    executed_at: $executed_at,
    scope: audit[:scope],
    status: status,
    rule_id: rule_id,
    file_path: file_path,
    evidence: evidence,
    remediation: remediation,
    classification: classification,
    certainty: certainty
  }
end

def contract_string?(value)
  value.is_a?(String) && !value.strip.empty?
end

def audit_result_contract_errors(findings)
  errors = []
  return ["audit result payload must be an array"] unless findings.is_a?(Array)

  findings.each_with_index do |item, index|
    context = "finding[#{index}]"
    unless item.is_a?(Hash)
      errors << "#{context}: expected object"
      next
    end

    AUDIT_RESULT_REQUIRED_FIELDS.each do |field|
      errors << "#{context}: missing #{field}" unless item.key?(field)
    end

    if !item.key?(:executed_at) && item[:executed_at_omitted] != true
      errors << "#{context}: missing executed_at without executed_at_omitted: true"
    end

    AUDIT_RESULT_STRING_FIELDS.each do |field|
      next unless item.key?(field)
      errors << "#{context}: #{field} must be a non-empty string" unless contract_string?(item[field])
    end

    if item.key?(:executed_at) && contract_string?(item[:executed_at])
      begin
        Time.iso8601(item[:executed_at])
      rescue ArgumentError
        errors << "#{context}: executed_at must be ISO 8601"
      end
    elsif item.key?(:executed_at)
      errors << "#{context}: executed_at must be a non-empty string"
    end

    audit = AUDITS_BY_ID[item[:audit_id]]
    if audit.nil?
      errors << "#{context}: audit_id is not registered"
    elsif item[:audit_version] != audit[:version]
      errors << "#{context}: audit_version #{item[:audit_version].inspect} does not match registered version #{audit[:version].inspect}"
    end

    unless item[:rule_id].is_a?(String) && item[:rule_id].match?(%r{\A[a-z0-9]+(?:[._-][a-z0-9]+)*\z})
      errors << "#{context}: rule_id must be a stable lowercase identifier"
    end

    errors << "#{context}: status is not allowed" if item.key?(:status) && !AUDIT_RESULT_STATUSES.include?(item[:status])
    errors << "#{context}: classification is not allowed" if item.key?(:classification) && !AUDIT_RESULT_CLASSIFICATIONS.include?(item[:classification])
    errors << "#{context}: certainty is not allowed" if item.key?(:certainty) && !AUDIT_RESULT_CERTAINTY.include?(item[:certainty])

    if item[:certainty] == "uncertain" && item[:status] != "warn"
      errors << "#{context}: uncertain findings must use warn status"
    end

    if item.key?(:file_path) && contract_string?(item[:file_path])
      path = item[:file_path]
      if path.start_with?("/") || path.include?("\0") || path.split("/").include?("..")
        errors << "#{context}: file_path must be repository-relative or ."
      end
    end

    if item.key?(:executed_at_omitted) && ![true, false].include?(item[:executed_at_omitted])
      errors << "#{context}: executed_at_omitted must be boolean when present"
    end
  end

  errors
end

def validate_audit_result_contract!(findings)
  errors = audit_result_contract_errors(findings)
  return if errors.empty?

  warn "Audit result contract violation:"
  errors.each { |error| warn "- #{error}" }
  exit 3
end

def contract_self_test_fixture
  $executed_at = "2026-07-23T00:00:00Z"
  valid_deterministic = finding("links", "fail", "link.local.exists", "README.md", "link target missing", "Update the link target.")
  valid_interpretive = finding(
    "taxonomy",
    "warn",
    "taxonomy.pattern.semantic_review",
    "patterns/",
    "semantic pattern classification requires review",
    "Review with vault-taxonomy-audit workflow.",
    classification: "interpretive",
    certainty: "uncertain"
  )

  {
    valid: [valid_deterministic, valid_interpretive],
    invalid_cases: {
      missing_required_field: valid_deterministic.reject { |key, _value| key == :evidence },
      invalid_enum: valid_deterministic.merge(status: "bad-status"),
      invalid_field_type: valid_deterministic.merge(audit_version: 0.1)
    }
  }
end

def run_contract_self_tests
  fixture = contract_self_test_fixture
  valid_errors = audit_result_contract_errors(fixture[:valid])
  raise "valid fixture failed contract: #{valid_errors.join("; ")}" unless valid_errors.empty?

  fixture[:invalid_cases].each do |name, item|
    errors = audit_result_contract_errors([item])
    raise "#{name} unexpectedly passed contract" if errors.empty?
  end

  puts "Audit result contract self-test passed."
end

def scalar_string?(value)
  value.is_a?(String) && !value.strip.empty?
end

def valid_date_string?(value)
  value.is_a?(Date) || (value.is_a?(String) && value.match?(/\A\d{4}-\d{2}-\d{2}\z/))
end

def date_value(value)
  value.is_a?(Date) ? value : Date.iso8601(value)
rescue ArgumentError
  nil
end

def frontmatter_audit(files)
  findings = []
  ids = Hash.new { |hash, key| hash[key] = [] }
  metadata = {}

  files.each do |path|
    data, error = parse_frontmatter(path)
    if error
      findings << finding("frontmatter", "fail", "frontmatter.present", path, error, "Add valid YAML frontmatter using specification.vault-metadata.")
      next
    end

    unless data.is_a?(Hash)
      findings << finding("frontmatter", "fail", "frontmatter.object", path, "frontmatter is not a YAML object", "Use key-value YAML frontmatter.")
      next
    end

    metadata[path] = data
    id = data["id"]
    ids[id] << path if scalar_string?(id)

    REQUIRED_FIELDS.each do |field|
      unless data.key?(field)
        findings << finding("frontmatter", "fail", "frontmatter.required.#{field}", path, "missing required field #{field}", "Add #{field} according to specification.vault-metadata.")
      end
    end

    data.keys.each do |key|
      next if key.to_s.match?(/\A[a-z][a-z0-9_]*\z/)
      findings << finding("frontmatter", "fail", "frontmatter.field_name", path, "field #{key} is not lowercase snake_case", "Rename metadata field to lowercase snake_case or document a governed exception.")
    end

    if data.key?("id") && !data["id"].to_s.match?(/\A[a-z0-9]+(?:[.-][a-z0-9]+)*\z/)
      findings << finding("frontmatter", "fail", "frontmatter.id_format", path, "id #{data["id"].inspect} is not lowercase dot-separated/kebab-safe", "Use a stable lowercase id from specification.vault-metadata.")
    end

    if data.key?("type") && !ALLOWED_TYPES.include?(data["type"])
      findings << finding("frontmatter", "fail", "frontmatter.type", path, "type #{data["type"].inspect} is not allowed", "Use a type defined by specification.vault-metadata.")
    end

    if data.key?("status") && !ALLOWED_STATUS.include?(data["status"])
      findings << finding("frontmatter", "fail", "frontmatter.status", path, "status #{data["status"].inspect} is not allowed", "Use a lifecycle state from governance.lifecycle.")
    end

    if data.key?("authority") && !ALLOWED_AUTHORITY.include?(data["authority"])
      findings << finding("frontmatter", "fail", "frontmatter.authority", path, "authority #{data["authority"].inspect} is not allowed", "Use an authority value from specification.vault-metadata.")
    end

    if data.key?("owners") && !(data["owners"].is_a?(Array) && data["owners"].all? { |owner| scalar_string?(owner) })
      findings << finding("frontmatter", "fail", "frontmatter.owners", path, "owners is not a non-empty string list", "Set owners to a list of stable owner names.")
    end

    %w[created updated].each do |field|
      next unless data.key?(field)
      next if valid_date_string?(data[field])
      findings << finding("frontmatter", "fail", "frontmatter.date.#{field}", path, "#{field} is not YYYY-MM-DD", "Use ISO date format YYYY-MM-DD.")
    end

    if valid_date_string?(data["created"]) && valid_date_string?(data["updated"])
      created = date_value(data["created"])
      updated = date_value(data["updated"])
      if created && updated && updated < created
        findings << finding("frontmatter", "fail", "frontmatter.date.order", path, "updated is earlier than created", "Set updated to the material change date.")
      end
    end

    if data["title"] && first_heading(path) && data["title"].to_s != first_heading(path).to_s
      findings << finding("frontmatter", "warn", "frontmatter.title_heading", path, "title does not match first H1", "Align title and first H1 unless the difference is intentional.")
    end

    if data["verification"].is_a?(Hash) && data["verification"].key?("status") && !ALLOWED_VERIFICATION_STATUS.include?(data["verification"]["status"])
      findings << finding("frontmatter", "fail", "frontmatter.verification_status", path, "verification.status #{data["verification"]["status"].inspect} is not allowed", "Use a verification status from specification.vault-metadata.")
    end

    if data["verification"].is_a?(Hash) && data["verification"]["status"] == "assumption" && !data.key?("assumptions")
      findings << finding("frontmatter", "warn", "frontmatter.assumptions", path, "verification.status is assumption but assumptions is missing", "Add assumptions or revise verification.status.")
    end

    next unless data["related"]

    unless data["related"].is_a?(Hash)
      findings << finding("frontmatter", "fail", "frontmatter.related.object", path, "related is not an object", "Use relationship keys with lists of document ids.")
      next
    end

    data["related"].each do |relationship, targets|
      unless ALLOWED_RELATIONSHIPS.include?(relationship)
        findings << finding("frontmatter", "fail", "frontmatter.related.key", path, "relationship #{relationship.inspect} is not allowed", "Use a relationship key from reference.relationship-types.")
      end
      unless targets.is_a?(Array) && targets.all? { |target| scalar_string?(target) }
        findings << finding("frontmatter", "fail", "frontmatter.related.targets", path, "relationship #{relationship.inspect} does not contain a string list", "Use a list of document ids for relationship targets.")
      end
    end
  end

  ids.each do |id, paths|
    next if paths.length == 1
    paths.each do |path|
      findings << finding("frontmatter", "fail", "frontmatter.id_unique", path, "id #{id.inspect} is also used by #{(paths - [path]).join(", ")}", "Give each governed document a stable unique id.")
    end
  end

  known_ids = ids.keys.to_set
  metadata.each do |path, data|
    next unless data["related"].is_a?(Hash)
    data["related"].each do |_relationship, targets|
      next unless targets.is_a?(Array)
      targets.each do |target|
        next if known_ids.include?(target)
        findings << finding("frontmatter", "fail", "frontmatter.related.target", path, "relationship target #{target.inspect} does not match a document id", "Reference an existing document id or add the missing governed document.")
      end
    end
  end

  findings
end

def markdown_links(content)
  content.scan(/(?<!!)\[[^\]]+\]\(([^)\s]+)(?:\s+"[^"]*")?\)/).flatten
end

def local_link?(href)
  return false if href.start_with?("#")
  return false if href.match?(/\A[a-z][a-z0-9+.-]*:/i)
  return false if href.start_with?("mailto:")
  true
end

def strip_fragment(href)
  href.split("#", 2).first
end

def link_target_path(source_path, href)
  target = strip_fragment(href)
  return nil if target.empty?

  if target.start_with?("/")
    target.delete_prefix("/")
  else
    File.expand_path(target, File.dirname(full_path(source_path))).sub("#{ROOT}/", "")
  end
end

def links_audit(files)
  findings = []

  files.each do |path|
    markdown_links(read_file(path)).each do |href|
      next unless local_link?(href)

      target = link_target_path(path, href)
      next unless target

      if target.start_with?("..")
        findings << finding("links", "fail", "link.local.boundary", path, "link #{href.inspect} resolves outside repository", "Use a repository-local target or an explicit external URL.")
        next
      end

      next if File.file?(full_path(target)) || File.directory?(full_path(target))

      findings << finding("links", "fail", "link.local.exists", path, "link #{href.inspect} target #{target.inspect} does not exist", "Update the link target or create the referenced file through a reviewed change.")
    end
  end

  findings
end

def taxonomy_audit(files)
  findings = []
  pattern_files = files.select { |path| path.start_with?("patterns/") }

  pattern_files.each do |path|
    data, error = parse_frontmatter(path)
    next if error || !data.is_a?(Hash)

    if path.end_with?(".pattern.md")
      unless data["type"] == "pattern"
        findings << finding("taxonomy", "fail", "taxonomy.pattern.type", path, "pattern spec has type #{data["type"].inspect}", "Set type: pattern for pattern spec files.")
      end

      expected_prefix =
        if path.start_with?("patterns/base/")
          "pattern.base."
        elsif path.start_with?("patterns/composition/")
          "pattern.composition."
        elsif path.start_with?("patterns/product/") || path.start_with?("patterns/experience/")
          "pattern.experience."
        end

      if expected_prefix && data["id"] && !data["id"].start_with?(expected_prefix)
        findings << finding("taxonomy", "fail", "taxonomy.pattern.id_prefix", path, "id #{data["id"].inspect} does not start with #{expected_prefix}", "Align the pattern id with reference.pattern-taxonomy or move the file.")
      end

      references = data.dig("related", "references")
      unless references.is_a?(Array) && references.include?("specification.pattern.schema")
        findings << finding("taxonomy", "warn", "taxonomy.pattern.schema_reference", path, "pattern spec does not reference specification.pattern.schema", "Add a related.references entry to the pattern authoring schema if this is an operational pattern spec.")
      end
    elsif path.match?(%r{\Apatterns/(base|composition|product|experience)/}) && !path.end_with?("README.md")
      findings << finding("taxonomy", "warn", "taxonomy.pattern.filename", path, "pattern-family file does not use .pattern.md suffix", "Use .pattern.md for pattern specs or move supporting material under maps, schemas, templates, checklists, or experiments.")
    end
  end

  findings << finding(
    "taxonomy",
    "warn",
    "taxonomy.pattern.semantic_review",
    "patterns/",
    "semantic pattern classification cannot be proven mechanically",
    "Use vault-taxonomy-audit workflow with AI or human review for base/composition/experience fit.",
    classification: "deterministic-evidence",
    certainty: "uncertain"
  )

  findings
end

if options[:self_test_contract]
  run_contract_self_tests
  exit 0
end

$executed_at = Time.now.utc.iso8601
selected = options[:audit] == "all" ? AUDITS.keys : [options[:audit]]
governed = governed_files
markdown = markdown_files
findings = selected.flat_map do |audit|
  audit_findings = case audit
                   when "frontmatter"
                     frontmatter_audit(governed)
                   when "links"
                     links_audit(markdown)
                   when "taxonomy"
                     taxonomy_audit(markdown)
                   end
  audit_findings.empty? ? [finding(audit, "pass", "#{audit}.pass", ".", "No findings.", "None required.")] : audit_findings
end

validate_audit_result_contract!(findings)

if options[:format] == "json"
  puts JSON.pretty_generate(findings)
else
  grouped = findings.group_by { |item| item[:audit_id] }
  grouped.each do |audit_id, audit_findings|
    puts "#{audit_id}: #{audit_findings.count} finding(s)"
    audit_findings.each do |item|
      puts "- #{item[:status].upcase} #{item[:rule_id]} #{item[:file_path]}: #{item[:evidence]}"
      puts "  remediation: #{item[:remediation]}"
    end
  end
end

exit(findings.any? { |item| %w[fail error].include?(item[:status]) } ? 1 : 0)
