#!/usr/bin/env ruby
# frozen_string_literal: true

# Read-only deterministic export adapter for Figma-consumable UI Foundations
# guidelines.
#
# The adapter projects eligible, reviewed governance guidance into a small set
# of Figma-importable Markdown guideline files plus a machine-readable manifest
# written to an EXTERNAL output directory. It never writes into the Vault tree,
# never promotes lifecycle state, never publishes, and makes no network calls.
#
# Normativity is NOT derived from this tool. Each emitted guideline block is a
# verbatim copy of an eligible source document body, attributed to that source
# with its canonical id, repo-relative path, lifecycle status, authority, type,
# and content checksum. Whether a block is normative or informative is decided
# by the governed document type and the precedence defaults in
# governance.precedence, not by heading text. If any eligibility or safety
# invariant fails, the adapter fails closed with diagnostics and writes nothing.
#
# Ruby stdlib only, matching existing Vault tooling.

require "date"
require "digest"
require "fileutils"
require "json"
require "optparse"
require "pathname"
require "tmpdir"
require "yaml"

module FigmaGuidelinesExport
  GENERATOR_ID = "figma-guidelines-export"
  GENERATOR_VERSION = "0.2.0"

  MANIFEST_SCHEMA_REL = "schemas/figma-export-manifest.schema.json"
  # Explicit version for THIS manifest output format (not a governance policy).
  # It is emitted in the manifest and constrained by the committed manifest
  # schema (const), so a wrong/missing value fails closed and reviewers can tell
  # which manifest format produced an output.
  MANIFEST_FORMAT_VERSION = "1.0.0"
  # Committed schema used to validate a naming-contract JSON artifact's shape.
  NAMING_CONTRACT_SCHEMA_REL = "schemas/naming-contract.schema.yml"
  # Semantic version shape shared by contract/schema versions.
  SEMVER_RE = /\A[0-9]+\.[0-9]+\.[0-9]+\z/.freeze
  REGISTRY_REL = "registry/governance-packs.yml"
  REPOS_REL = "registry/repos.yml"
  PRECEDENCE_REL = "governance/precedence.md"
  LIFECYCLE_REL = "governance/lifecycle.md"

  PACK_ID = "governance-pack"

  # Governance documents that must themselves be resolvable and stable/accepted
  # before any precedence/lifecycle-based classification can be trusted.
  REQUIRED_GOVERNANCE = {
    "governance.precedence" => PRECEDENCE_REL,
    "governance.lifecycle" => LIFECYCLE_REL
  }.freeze

  # Lifecycle states that are eligible for authoritative governance inputs.
  ELIGIBLE_GOVERNANCE_STATUSES = %w[accepted stable].freeze

  # Only source-authority material is authoritative. supporting / example /
  # derived material is informative by definition and MUST NOT be promoted to
  # normative, regardless of its governed type. governance.precedence treats
  # authority as the gate above type defaults.
  AUTHORITATIVE_AUTHORITIES = %w[source].freeze

  # The complete `authority` enum from specifications/vault-metadata.md. A
  # referenced eligible source document carrying any other authority value is
  # malformed metadata and must fail closed with a controlled diagnostic rather
  # than being read as if its authority were meaningful.
  KNOWN_AUTHORITIES = %w[source supporting derived example].freeze

  # The complete document `type` taxonomy from specifications/vault-metadata.md.
  # A referenced eligible source whose governed type is outside this enum is
  # malformed and must fail closed; we never invent a new canonical type to make
  # a reference resolve.
  KNOWN_DOCUMENT_TYPES = %w[
    principle governance workflow prompt specification adr agent-capability
    registry lesson export-pack schema template glossary pattern index
    publication
  ].freeze

  # Eligibility gates. Deliberately strict: authoritative export of the current
  # review-channel pack fails closed.
  ELIGIBLE_PACK_CHANNELS = %w[stable].freeze
  ELIGIBLE_ARTIFACT_STATUSES = %w[accepted stable].freeze
  ELIGIBLE_SOURCE_STATUSES = %w[accepted stable].freeze

  # Figma is treated as a docs-type consumer of reviewed governance guidance.
  APPLICABLE_REPO_TYPES = %w[docs runtime].freeze

  # Governed document types that are normative by default (governance.precedence
  # "Normative Defaults"). Everything else is informative. A heading containing
  # the word "rules" never promotes an informative source to normative.
  #
  # These are drawn ONLY from the canonical document taxonomy in
  # specifications/vault-metadata.md. Earlier versions listed invented types
  # (naming-rule, token-governance, component-governance, ...) which are pack
  # ARTIFACT types, not governed document types, and which the metadata spec
  # does not allow. Treating them as source document types was the defect behind
  # the acceptance failure, so they are removed here.
  NORMATIVE_DOC_TYPES = %w[
    governance
    principle
    specification
    glossary
  ].freeze

  # ADRs are normative only when accepted or stable (governance.precedence).
  CONDITIONAL_NORMATIVE_DOC_TYPES = %w[adr decision].freeze

  # Known governed artifact types the pack may declare. An unknown type fails
  # closed rather than being silently bucketed and ignored.
  KNOWN_ARTIFACT_TYPES = %w[
    naming-rule
    naming-contract
    token-governance
    component-governance
    accessibility-baseline
  ].freeze

  # Fixed, ordered set of guideline categories. Determinism depends on order.
  CATEGORIES = %w[
    overview
    foundations
    tokens
    components
    composition
    accessibility
    anti-patterns
  ].freeze

  CATEGORY_TITLES = {
    "overview" => "Overview",
    "foundations" => "Foundations",
    "tokens" => "Tokens",
    "components" => "Components",
    "composition" => "Composition",
    "accessibility" => "Accessibility",
    "anti-patterns" => "Anti-Patterns"
  }.freeze

  # Maps a guideline category to the governed artifact types that may supply its
  # content. A category with no eligible source MUST fail closed; it is never
  # fabricated, and its topic text is never invented from a naming rule.
  CATEGORY_SOURCE_ARTIFACT_TYPES = {
    "overview" => %w[naming-rule naming-contract],
    "foundations" => %w[naming-rule],
    "tokens" => %w[token-governance],
    "components" => %w[component-governance],
    "composition" => %w[component-governance naming-rule],
    "accessibility" => %w[accessibility-baseline],
    "anti-patterns" => %w[naming-rule component-governance]
  }.freeze

  # Conservative Figma guidelines budget. Figma's "Add guidelines files to a
  # design library" documentation (verified 2026-10-30) supports Markdown,
  # recommends 3-8 focused files under ~100 KB combined, and enforces a hard
  # combined upload limit of ~200 KB. The manifest is NOT uploaded to Figma;
  # only the guideline Markdown files are, so only they count toward the budget.
  DEFAULT_MAX_FILE_BYTES = 65_536
  DEFAULT_MAX_TOTAL_BYTES = 100_000
  # Immutable compatibility cap. Even if a larger budget is configured, the
  # guideline total is clamped to this hard limit to stay within Figma's upload
  # ceiling. This cannot be raised via CLI.
  HARD_MAX_TOTAL_BYTES = 200_000

  SIZE_UNIT = "utf-8-bytes"

  # Supported JSON Schema dialect for the manifest schema.
  SUPPORTED_SCHEMA_DIALECTS = [
    "https://json-schema.org/draft/2020-12/schema"
  ].freeze

  # Keywords the bundled validator actually enforces. Any other keyword in the
  # schema is rejected rather than silently ignored, so we never pretend to
  # implement full JSON Schema.
  SUPPORTED_SCHEMA_KEYWORDS = %w[
    $schema $id title description
    type properties required additionalProperties
    items minItems maxItems
    enum const
    minLength pattern
    minimum
  ].freeze

  class ExportError < StandardError
    attr_reader :diagnostics

    def initialize(diagnostics)
      @diagnostics = Array(diagnostics)
      super(@diagnostics.join("\n"))
    end
  end

  # Path resolver that keeps every read inside the physical vault tree and
  # rejects traversal and symlink escapes. All indexed and referenced reads go
  # through here; nothing bypasses it with raw File.read/binread.
  class SafeVault
    attr_reader :root

    def initialize(root)
      @root = Pathname.new(File.realpath(root))
    rescue Errno::ENOENT
      raise ExportError, "Vault root does not exist: #{root}"
    end

    # Resolve a repo-relative path to a physical file inside the vault.
    def resolve(rel, expect: :file)
      raise ExportError, "Empty repository path" if rel.nil? || rel.to_s.strip.empty?
      rel = rel.to_s
      if rel.start_with?("/") || rel.include?("\0") || rel.split("/").include?("..")
        raise ExportError, "Unsafe repository path (absolute or traversal): #{rel.inspect}"
      end

      candidate = @root.join(rel)
      unless candidate.exist?
        raise ExportError, "Referenced path does not exist: #{rel}"
      end

      real = Pathname.new(File.realpath(candidate.to_s))
      unless inside?(real)
        raise ExportError, "Path escapes the vault via symlink: #{rel.inspect}"
      end
      if expect == :file && !real.file?
        raise ExportError, "Referenced path is not a regular file: #{rel}"
      end
      real
    end

    def inside?(real)
      real.to_s == @root.to_s || real.to_s.start_with?("#{@root}#{File::SEPARATOR}")
    end

    # Read a file as UTF-8, failing closed on invalid byte sequences instead of
    # silently replacing them (which could hide tampering or mojibake).
    def read(rel)
      bytes = File.binread(resolve(rel).to_s)
      text = bytes.dup.force_encoding("UTF-8")
      unless text.valid_encoding?
        raise ExportError, "Source is not valid UTF-8: #{rel}"
      end
      text
    end
  end

  # Self-contained scanner used ONLY to detect duplicate object keys at any
  # nesting level. It is NOT the grammar authority: parse_json_strict delegates
  # grammar and value validation to the Ruby standard library JSON parser and
  # keeps the stdlib result. This scanner runs over the same raw text purely to
  # surface a repeated decoded key, which the stdlib parser does not report
  # (it keeps the last value for a repeated key).
  #
  # OBSERVED HISTORY (what was actually run), kept distinct from inference:
  #
  #   * The one observed hosted failure was at head 4e4a7fb, which used a Hash
  #     subclass (StrictJSONHash < Hash) overriding Hash#[]= to detect
  #     duplicates. On the hosted runner a duplicate-key contract was NOT
  #     surfaced with the explicit "Duplicate JSON key" diagnostic; it fell
  #     through to a generic ineligible-status rejection. That is the observed
  #     fact. The exact reason inside the JSON C backend (that it does not route
  #     every textual member through an overridden []=) is INFERRED from that
  #     behaviour, not independently proven here.
  #   * A plain (non-Hash) wrapper passed as object_class was considered but was
  #     NOT pushed to or tested on the hosted runner, so no claim is made about
  #     how it would behave there.
  #
  # Because duplicate detection via an overridden []= depended on parser
  # internals we did not control, detection now lives in this scanner, which we
  # do control. A repeated key in the SAME object is detected here, before any
  # value is kept. It is NOT a regex and never confuses string contents with
  # structural punctuation: it scans character by character and tracks string
  # state explicitly.
  #
  # Decoding happens before key comparison, so a Unicode-escaped key
  # ("\u0073tatus") decodes to "status" and collides with a plain-text "status",
  # which is exactly the evasion we must block.
  #
  # Its own decoded result (ordinary Hash/Array/String/Numeric/true/false/nil
  # with object keys in textual order) is discarded by parse_json_strict; only
  # the stdlib parser's result is returned to callers.
  class StrictJSONParser
    class ParseError < StandardError; end

    WHITESPACE = [" ", "\t", "\n", "\r"].freeze

    def self.parse(raw)
      new(raw).parse
    end

    def initialize(raw)
      # Operate on a decoded UTF-8 character view so \uXXXX escapes and literal
      # multibyte characters compare correctly.
      @chars = raw.dup.force_encoding("UTF-8")
      unless @chars.valid_encoding?
        raise ParseError, "input is not valid UTF-8"
      end
      @scanner = @chars.each_char.to_a
      @pos = 0
      @len = @scanner.length
    end

    def parse
      skip_whitespace
      value = parse_value
      skip_whitespace
      unless @pos >= @len
        raise ParseError, "trailing characters after JSON value at position #{@pos}"
      end
      value
    end

    private

    def parse_value
      skip_whitespace
      raise ParseError, "unexpected end of input" if @pos >= @len
      c = @scanner[@pos]
      case c
      when "{" then parse_object
      when "[" then parse_array
      when '"' then parse_string
      when "t", "f" then parse_boolean
      when "n" then parse_null
      else
        if c == "-" || (c >= "0" && c <= "9")
          parse_number
        else
          raise ParseError, "unexpected character #{c.inspect} at position #{@pos}"
        end
      end
    end

    def parse_object
      expect("{")
      obj = {}
      skip_whitespace
      if peek == "}"
        advance
        return obj
      end
      loop do
        skip_whitespace
        unless peek == '"'
          raise ParseError, "expected string object key at position #{@pos}"
        end
        key = parse_string
        if obj.key?(key)
          # Detected by us, not by an optimized backend: a repeated key in the
          # same object is ambiguous and could overwrite status or source
          # metadata (e.g. draft hidden behind accepted, in either order).
          raise FigmaGuidelinesExport::DuplicateJSONKeyError,
                "Duplicate JSON key #{key.inspect} (refusing ambiguous JSON; a repeated key " \
                "could overwrite status or source metadata during parsing)."
        end
        skip_whitespace
        expect(":")
        value = parse_value
        obj[key] = value
        skip_whitespace
        case peek
        when ","
          advance
          next
        when "}"
          advance
          break
        else
          raise ParseError, "expected ',' or '}' in object at position #{@pos}"
        end
      end
      obj
    end

    def parse_array
      expect("[")
      arr = []
      skip_whitespace
      if peek == "]"
        advance
        return arr
      end
      loop do
        arr << parse_value
        skip_whitespace
        case peek
        when ","
          advance
          next
        when "]"
          advance
          break
        else
          raise ParseError, "expected ',' or ']' in array at position #{@pos}"
        end
      end
      arr
    end

    def parse_string
      expect('"')
      buffer = +""
      loop do
        raise ParseError, "unterminated string" if @pos >= @len
        c = @scanner[@pos]
        advance
        case c
        when '"'
          return buffer
        when "\\"
          buffer << parse_escape
        else
          # Control characters must be escaped in JSON strings.
          if c.ord < 0x20
            raise ParseError, "unescaped control character in string at position #{@pos}"
          end
          buffer << c
        end
      end
    end

    def parse_escape
      raise ParseError, "unterminated escape" if @pos >= @len
      e = @scanner[@pos]
      advance
      case e
      when '"' then '"'
      when "\\" then "\\"
      when "/" then "/"
      when "b" then "\b"
      when "f" then "\f"
      when "n" then "\n"
      when "r" then "\r"
      when "t" then "\t"
      when "u" then parse_unicode_escape
      else
        raise ParseError, "invalid escape \\#{e} at position #{@pos}"
      end
    end

    def parse_unicode_escape
      code = read_hex4
      # Handle UTF-16 surrogate pairs so astral characters decode correctly and
      # cannot be used to smuggle a distinct byte sequence for the same key.
      if code >= 0xD800 && code <= 0xDBFF
        unless @scanner[@pos] == "\\" && @scanner[@pos + 1] == "u"
          raise ParseError, "invalid high surrogate without following low surrogate"
        end
        advance # backslash
        advance # u
        low = read_hex4
        unless low >= 0xDC00 && low <= 0xDFFF
          raise ParseError, "invalid low surrogate in pair"
        end
        code = 0x10000 + ((code - 0xD800) << 10) + (low - 0xDC00)
      elsif code >= 0xDC00 && code <= 0xDFFF
        raise ParseError, "unexpected low surrogate"
      end
      [code].pack("U")
    end

    def read_hex4
      hex = +""
      4.times do
        ch = @scanner[@pos]
        unless ch && ch.match?(/[0-9a-fA-F]/)
          raise ParseError, "invalid \\u escape at position #{@pos}"
        end
        hex << ch
        advance
      end
      hex.to_i(16)
    end

    def parse_number
      start = @pos
      advance if peek == "-"
      consume_digits
      is_float = false
      if peek == "."
        is_float = true
        advance
        consume_digits(require_one: true)
      end
      if peek == "e" || peek == "E"
        is_float = true
        advance
        advance if peek == "+" || peek == "-"
        consume_digits(require_one: true)
      end
      token = @scanner[start...@pos].join
      is_float ? Float(token) : Integer(token, 10)
    rescue ArgumentError
      raise ParseError, "invalid number at position #{start}"
    end

    def consume_digits(require_one: false)
      count = 0
      while (c = peek) && c >= "0" && c <= "9"
        advance
        count += 1
      end
      if require_one && count.zero?
        raise ParseError, "expected digit at position #{@pos}"
      end
      if count.zero? && !require_one
        raise ParseError, "expected digit at position #{@pos}"
      end
    end

    def parse_boolean
      if match_literal("true")
        true
      elsif match_literal("false")
        false
      else
        raise ParseError, "invalid literal at position #{@pos}"
      end
    end

    def parse_null
      return nil if match_literal("null")
      raise ParseError, "invalid literal at position #{@pos}"
    end

    def match_literal(literal)
      literal.each_char.with_index do |ch, i|
        return false unless @scanner[@pos + i] == ch
      end
      @pos += literal.length
      true
    end

    def peek
      @scanner[@pos]
    end

    def advance
      @pos += 1
    end

    def expect(char)
      unless peek == char
        raise ParseError, "expected #{char.inspect} at position #{@pos}"
      end
      advance
    end

    def skip_whitespace
      advance while @pos < @len && WHITESPACE.include?(@scanner[@pos])
    end
  end

  # Raised for a duplicate JSON key. A distinct class lets parse_json_strict
  # distinguish a controlled duplicate-key rejection (which must surface the
  # explicit "Duplicate JSON key" diagnostic) from a generic parse error.
  class DuplicateJSONKeyError < StandardError; end

  module_function

  def byte_size(string)
    string.dup.force_encoding("UTF-8").bytesize
  end

  def sha256(string)
    Digest::SHA256.hexdigest(string.dup.force_encoding("UTF-8"))
  end

  # Maximum JSON nesting depth we are willing to decode. Passed explicitly to
  # the stdlib parser so a deeply nested document is rejected cleanly up front,
  # before any recursive descent could overflow the stack.
  JSON_MAX_NESTING = 100

  # Parse JSON while enforcing real JSON grammar, finite JSON-generatable
  # values, and no duplicate object keys at any level.
  #
  # Grammar + value validation uses the Ruby standard library JSON parser FIRST,
  # so the actual JSON grammar (as implemented by the stdlib) decides what is
  # valid:
  #
  #   * create_additions: false  - never materialise custom classes from JSON.
  #   * allow_nan: false         - reject NaN / Infinity / -Infinity tokens; a
  #                                non-finite number cannot be JSON-generated
  #                                later and must not slip through.
  #   * max_nesting: JSON_MAX_NESTING - reject an over-deep document cleanly up
  #                                front rather than risking a recursion overflow
  #                                in the duplicate scanner below.
  #
  # The handwritten scanner here previously accepted inputs the JSON grammar
  # forbids: a leading-zero number ('{"a":01}' became {"a" => 1}) and a
  # non-finite number ('{"a":1e999}' became {"a" => Infinity}, which cannot be
  # safely JSON-generated afterwards). Delegating grammar and value validation
  # to the stdlib parser removes that class of false acceptance without us
  # reimplementing JSON number grammar by hand.
  #
  # After the stdlib parser accepts the input, the parsed value is round-tripped
  # through JSON.generate(parsed, allow_nan: false) as an explicit finite /
  # JSON-generatable guard, so any value that could not be regenerated (a
  # non-finite float) is rejected with a controlled diagnostic.
  #
  # Duplicate object keys are NOT distinguished by the stdlib parser (it keeps
  # the last value for a repeated key). The self-contained StrictJSONParser
  # scanner is therefore still run over the SAME raw text, but ONLY to detect a
  # repeated decoded key in the original document. It is a character-by-character
  # scanner that tracks string state explicitly (not a regex) and decodes
  # \uXXXX escapes before comparison, so a Unicode-escaped key ("\u0073tatus")
  # collides with a plain-text "status" in either order and at any nesting
  # depth. Its own decoded value is discarded.
  #
  # On success the STANDARD parser result is returned: ordinary Hash / Array /
  # String / Numeric / true / false / nil values with object keys in the
  # original textual order, exactly the shape downstream code expects. Any
  # stdlib parser, nesting, or generator error is converted to a controlled
  # ExportError (exit 1); the process never leaks a raw backtrace.
  def parse_json_strict(raw, where)
    parsed =
      begin
        JSON.parse(
          raw,
          create_additions: false,
          allow_nan: false,
          max_nesting: JSON_MAX_NESTING
        )
      rescue JSON::NestingError => e
        raise ExportError, "Invalid JSON in #{where}: nesting too deep (#{e.message})"
      rescue JSON::ParserError => e
        raise ExportError, "Invalid JSON in #{where}: #{e.message.lines.first&.strip}"
      end

    # Explicit finite / JSON-generatable guard. allow_nan:false here rejects any
    # non-finite float that somehow survived parsing, so we never keep a value
    # that cannot be regenerated as JSON later.
    begin
      JSON.generate(parsed, allow_nan: false)
    rescue JSON::GeneratorError => e
      raise ExportError, "Invalid JSON in #{where}: value is not finite/JSON-generatable (#{e.message})"
    end

    # Duplicate-key detection only. The scanner's decoded value is discarded;
    # the stdlib result above is what callers receive. The same max nesting cap
    # has already been enforced by JSON.parse, so the scanner cannot recurse
    # deeper than an already-accepted document.
    begin
      StrictJSONParser.parse(raw)
    rescue DuplicateJSONKeyError => e
      # Preserve the explicit "Duplicate JSON key" text reviewers and tests
      # assert on.
      raise ExportError, e.message
    rescue StrictJSONParser::ParseError => e
      # Fail CLOSED on scanner uncertainty. The stdlib parser already settled
      # the JSON grammar verdict, so we deliberately do NOT re-declare this
      # stdlib-valid input ungrammatical. But a ParseError here means the
      # duplicate-key scan did not complete, and the stdlib result cannot prove
      # the absence of a duplicate object key (JSON.parse silently keeps the last
      # value for a repeated key). Returning `parsed` in that state would treat
      # an INCOMPLETE duplicate scan as a successful validation, which is exactly
      # the fail-open branch we must not have. Deferring grammar to the stdlib
      # does not authorize bypassing duplicate verification on internal
      # uncertainty, so we raise a controlled ExportError and never return a
      # value after an unresolved scan.
      raise ExportError,
            "Cannot validate duplicate JSON keys in #{where}: duplicate scanner " \
            "could not complete (unsupported validation path): " \
            "#{e.message.lines.first&.strip}"
    end

    parsed
  end

  # Strict YAML load that rejects duplicate keys. Psych merges duplicate keys
  # silently, which could let a malicious document overwrite status/eligibility.
  def safe_load_strict(raw, where)
    YAML.safe_load(
      raw,
      permitted_classes: [Date],
      aliases: false
    ).tap do
      assert_no_duplicate_yaml_keys(raw, where)
    end
  rescue Psych::SyntaxError => e
    raise ExportError, "Invalid YAML in #{where}: #{e.message.lines.first&.strip}"
  rescue Psych::Exception => e
    # Covers AliasesNotEnabled / BadAlias across Psych versions.
    if e.class.name.to_s.include?("Alias")
      raise ExportError, "#{where}: YAML aliases are not allowed (possible eligibility spoofing)."
    end
    raise ExportError, "Invalid YAML in #{where}: #{e.message.lines.first&.strip}"
  end

  # Detect duplicate mapping keys at any level using the Psych node tree.
  def assert_no_duplicate_yaml_keys(raw, where)
    doc = YAML.parse(raw)
    return unless doc

    stack = [doc.root].compact
    until stack.empty?
      node = stack.pop
      next unless node.respond_to?(:children) && node.children

      if node.is_a?(Psych::Nodes::Mapping)
        keys = node.children.each_slice(2).map do |k, _v|
          k.respond_to?(:value) ? k.value : k.object_id.to_s
        end
        dupes = keys.group_by { |k| k }.select { |_k, v| v.length > 1 }.keys
        unless dupes.empty?
          raise ExportError, "#{where}: duplicate YAML key(s) #{dupes.join(", ")} (refusing ambiguous metadata)."
        end
      end
      stack.concat(node.children)
    end
  end

  def load_yaml(vault, rel)
    safe_load_strict(vault.read(rel), rel)
  end

  # Parse YAML frontmatter from a markdown document. Returns [metadata, body].
  def parse_document(content, rel)
    unless content.start_with?("---\n")
      raise ExportError, "Missing frontmatter in source: #{rel}"
    end
    closing = content.index("\n---", 4)
    raise ExportError, "Unterminated frontmatter in source: #{rel}" unless closing

    raw = content[4...closing]
    data = safe_load_strict(raw, "frontmatter of #{rel}")
    raise ExportError, "Frontmatter is not an object in source: #{rel}" unless data.is_a?(Hash)

    body = content[(closing + "\n---".length)..] || ""
    body = body.sub(/\A\n/, "")
    [data, body]
  end

  # ---- Eligibility resolution -----------------------------------------------

  def resolve_pack(registry)
    unless registry.is_a?(Hash) && registry["packs"].is_a?(Array)
      raise ExportError, "#{REGISTRY_REL}: packs must be a non-empty list"
    end

    matches = registry["packs"].select { |p| p.is_a?(Hash) && p["id"] == PACK_ID }
    raise ExportError, "#{REGISTRY_REL}: pack #{PACK_ID.inspect} not found" if matches.empty?
    if matches.length > 1
      raise ExportError, "#{REGISTRY_REL}: ambiguous duplicate pack id #{PACK_ID.inspect}"
    end
    matches.first
  end

  def check_pack_eligibility(pack, repos_data)
    diagnostics = []

    channel = pack["channel"]
    unless ELIGIBLE_PACK_CHANNELS.include?(channel)
      diagnostics << "Pack #{PACK_ID} channel #{channel.inspect} is not eligible " \
        "(requires one of: #{ELIGIBLE_PACK_CHANNELS.join(", ")}). Authoritative export is blocked."
    end

    compatible = Array(pack["compatible_repo_types"])
    applicable = compatible & APPLICABLE_REPO_TYPES
    if applicable.empty?
      diagnostics << "Pack #{PACK_ID} declares no repo types applicable to the Figma export " \
        "(declared: #{compatible.join(", ").inspect}, required overlap: #{APPLICABLE_REPO_TYPES.join(", ")})."
    end

    known_types = Array(repos_data && repos_data["repo_types"])
    unknown = applicable - known_types
    unless unknown.empty?
      diagnostics << "Pack declares repo types unknown to #{REPOS_REL}: #{unknown.join(", ")}"
    end

    diagnostics
  end

  def version_matches_registry?(pack, manifest)
    pack["current_version"] == manifest.dig("pack", "version") &&
      manifest.dig("pack", "channel") == pack["channel"]
  end

  # Index every governed document id -> descriptor, reading only through
  # SafeVault. Fails closed on duplicate ids, invalid UTF-8, and malformed
  # metadata.
  #
  # Two governed source conventions are supported:
  #
  #   * Markdown documents (`**/*.md`) carry YAML frontmatter between `---`
  #     fences; the body is the Markdown after the frontmatter.
  #   * Governed registry YAML documents (`registry/**/*.yml` / `.yaml`) are a
  #     WHOLE YAML document (top-level mapping, no closing frontmatter
  #     delimiter). The "body" is the raw YAML text, which is preserved later as
  #     a clearly attributed informative fenced-YAML block. This matches the
  #     registry source convention the real naming contract references
  #     (registry/*.yml documents such as registry.governance-packs).
  #
  # Any other extension that somehow reaches a reference resolves to no indexed
  # id and fails closed at reference time; indexing itself only recognizes these
  # two known formats.
  def index_sources(vault)
    index = {}

    md_rels = Dir.glob("**/*.md", base: vault.root.to_s, flags: File::FNM_DOTMATCH).sort
    md_rels.each do |rel|
      next if rel.split("/").first == ".git"

      # Reading through SafeVault rejects symlinked .md files that escape the
      # tree and fails on invalid UTF-8.
      content = vault.read(rel)
      next unless content.start_with?("---\n")

      data, body = parse_document(content, rel)
      id = data["id"]
      next unless id.is_a?(String) && !id.strip.empty?

      # Checksum over the full document content (frontmatter + body), preserving
      # the existing provenance meaning for Markdown sources.
      register_source(index, id, rel, data, body, sha256(content), format: "markdown")
    end

    yaml_rels = (
      Dir.glob("registry/**/*.yml", base: vault.root.to_s, flags: File::FNM_DOTMATCH) +
      Dir.glob("registry/**/*.yaml", base: vault.root.to_s, flags: File::FNM_DOTMATCH)
    ).uniq.sort
    yaml_rels.each do |rel|
      next if rel.split("/").first == ".git"

      content = vault.read(rel)
      data =
        begin
          safe_load_strict(content, rel)
        rescue ExportError
          # A registry file that is not valid governed YAML is simply not
          # indexed as a source; an actual reference to it then fails closed as
          # a broken reference with a controlled diagnostic.
          next
        end
      next unless data.is_a?(Hash)
      id = data["id"]
      next unless id.is_a?(String) && !id.strip.empty?

      # The whole raw YAML text is preserved verbatim as the informative body,
      # and the checksum is over that same raw document.
      register_source(index, id, rel, data, content, sha256(content), format: "registry-yaml")
    end

    index
  end

  def register_source(index, id, rel, data, body, checksum, format:)
    if index.key?(id)
      raise ExportError, "Duplicate source document id #{id.inspect} " \
        "(#{index[id][:rel]} and #{rel}); refusing ambiguous provenance."
    end

    index[id] = {
      id: id,
      rel: rel,
      format: format,
      title: data["title"],
      status: data["status"],
      authority: data["authority"],
      type: data["type"],
      owners: data["owners"],
      created: data["created"],
      updated: data["updated"],
      related: data["related"],
      sha256: checksum,
      body: body
    }
  end

  # Verify the precedence and lifecycle governance documents resolve and are
  # accepted/stable before we trust type-based normativity classification.
  def verify_governance(source_index)
    diagnostics = []
    REQUIRED_GOVERNANCE.each do |id, rel|
      src = source_index[id]
      if src.nil?
        diagnostics << "Required governance document #{id} (#{rel}) is missing; " \
          "cannot establish precedence/lifecycle."
        next
      end
      # The required governance id must resolve to the EXACT expected canonical
      # path, not merely to some document that happens to claim the id.
      if src[:rel] != rel
        diagnostics << "Required governance document #{id} resolves to #{src[:rel]} " \
          "but must live at the canonical path #{rel}."
      end
      unless src[:type].to_s == "governance"
        diagnostics << "Required governance document #{id} has type #{src[:type].inspect}; " \
          "must be type governance to be authoritative."
      end
      unless AUTHORITATIVE_AUTHORITIES.include?(src[:authority].to_s)
        diagnostics << "Required governance document #{id} has authority #{src[:authority].inspect}; " \
          "must be authority source to be authoritative."
      end
      unless ELIGIBLE_GOVERNANCE_STATUSES.include?(src[:status])
        diagnostics << "Required governance document #{id} has status #{src[:status].inspect}; " \
          "precedence/lifecycle must be one of #{ELIGIBLE_GOVERNANCE_STATUSES.join(", ")} to be authoritative."
      end
    end
    raise ExportError, diagnostics unless diagnostics.empty?
  end

  # Decide whether a source document is normative, using authority + governed
  # type + lifecycle per governance.precedence. Heading text is irrelevant.
  #
  # Authority gates first: supporting / example / derived material is always
  # informative, even when its governed type (e.g. governance) would otherwise
  # be normative. This prevents promoting supporting examples or workflows to
  # normative status. An accepted informative example therefore keeps its
  # supporting/example authority and stays informative.
  def normative_source?(src)
    return false unless AUTHORITATIVE_AUTHORITIES.include?(src[:authority].to_s)

    type = src[:type].to_s
    return true if NORMATIVE_DOC_TYPES.include?(type)
    if CONDITIONAL_NORMATIVE_DOC_TYPES.include?(type)
      return ELIGIBLE_GOVERNANCE_STATUSES.include?(src[:status])
    end
    false
  end

  # Resolve and gate the source references for one artifact. Rejects explicit
  # unresolved conflicts, ineligible lifecycle, broken/duplicate references, and
  # Figma-unsupported body content. Returns eligible source descriptors.
  def eligible_sources_for(artifact, source_index, vault)
    refs = Array(artifact["source_references"])
    diagnostics = []
    resolved = []
    seen = {}

    refs.each do |ref|
      unless ref.is_a?(String) && !ref.strip.empty?
        diagnostics << "Artifact #{artifact["id"]}: invalid source reference #{ref.inspect}"
        next
      end
      if seen[ref]
        diagnostics << "Artifact #{artifact["id"]}: duplicate source reference #{ref.inspect}"
        next
      end
      seen[ref] = true

      src = source_index[ref]
      unless src
        diagnostics << "Artifact #{artifact["id"]}: source reference #{ref.inspect} " \
          "does not resolve to a governed document id (broken reference)."
        next
      end

      # A referenced eligible source must carry metadata that conforms to the
      # vault-metadata specification before it can be projected. An unknown
      # authority or an unknown document type is malformed metadata; we fail
      # closed with a controlled diagnostic rather than reading it as if it were
      # meaningful (the "authority: rogue" acceptance failure).
      unless KNOWN_DOCUMENT_TYPES.include?(src[:type].to_s)
        diagnostics << "Artifact #{artifact["id"]}: source #{ref.inspect} has unknown document " \
          "type #{src[:type].inspect}; must be one of the canonical types in " \
          "specifications/vault-metadata.md (#{KNOWN_DOCUMENT_TYPES.join(", ")})."
        next
      end
      unless KNOWN_AUTHORITIES.include?(src[:authority].to_s)
        diagnostics << "Artifact #{artifact["id"]}: source #{ref.inspect} has unknown authority " \
          "#{src[:authority].inspect}; must be one of #{KNOWN_AUTHORITIES.join(", ")} " \
          "(specifications/vault-metadata.md). Refusing ambiguous eligibility."
        next
      end

      # Beyond the known-type/known-authority gates, a referenced eligible
      # source must satisfy the required Vault metadata shape: a non-empty
      # title, a non-empty owners list of strings, valid created/updated dates
      # with updated not earlier than created, and a well-formed `related`
      # mapping when present. Earlier code silently accepted sources that
      # omitted required owners/dates/title, so a malformed record could be
      # projected. Validate the REFERENCED record itself (not unrelated historic
      # drafts). A malformed `related.conflicts_with` (e.g. a scalar instead of
      # a list) must not let an unresolved conflict evade the blocker below.
      shape_issues = validate_source_shape(artifact["id"], ref, src)
      unless shape_issues.empty?
        diagnostics.concat(shape_issues)
        next
      end

      unless ELIGIBLE_SOURCE_STATUSES.include?(src[:status])
        diagnostics << "Artifact #{artifact["id"]}: source #{ref.inspect} has lifecycle " \
          "status #{src[:status].inspect}; requires one of #{ELIGIBLE_SOURCE_STATUSES.join(", ")}."
        next
      end

      # Reject exporting a source with an explicit unresolved conflict. We do
      # not merely claim precedence is enforced; a declared conflicts_with is a
      # blocking, unresolved relationship. validate_source_shape has already
      # rejected a malformed `related` or a non-list conflicts_with, so by here
      # a present conflicts_with is a proper list; a non-empty one blocks.
      conflicts = src.dig(:related, "conflicts_with") if src[:related].is_a?(Hash)
      if conflicts.is_a?(Array) && !conflicts.empty?
        diagnostics << "Artifact #{artifact["id"]}: source #{ref.inspect} declares unresolved " \
          "conflicts_with #{conflicts.join(", ")}; resolve the conflict before export."
        next
      end

      # A governed registry YAML source is preserved verbatim as an attributed
      # fenced-YAML block, not interpreted as Markdown, so the Markdown body
      # content restrictions (raw HTML, image embeds, relative links) do not
      # apply to it. Markdown sources still go through the conservative body
      # validation and canonical-link checks.
      if src[:format] != "registry-yaml"
        body_issues = validate_body_content(src, vault)
        unless body_issues.empty?
          diagnostics.concat(body_issues)
          next
        end
      end

      resolved << src
    end

    raise ExportError, diagnostics unless diagnostics.empty?
    resolved
  end

  # The permitted `related` relationship keys from specifications/vault-metadata.md.
  KNOWN_RELATED_KEYS = %w[
    depends_on supports supersedes superseded_by implements implemented_by
    governs governed_by references conflicts_with
  ].freeze

  # Validate the required Vault metadata shape of a REFERENCED eligible source,
  # beyond the already-checked known type/authority. Returns a list of
  # diagnostics (empty when valid). Required: non-empty string id/title, a
  # non-empty owners list of non-empty strings, valid created/updated dates
  # (YYYY-MM-DD, updated >= created), and a well-formed `related` mapping when
  # present (only permitted keys, each value a list of non-empty strings). A
  # malformed conflicts_with (scalar, or non-string items) is rejected here so
  # it cannot slip past the unresolved-conflict blocker.
  def validate_source_shape(artifact_id, ref, src)
    issues = []
    prefix = "Artifact #{artifact_id}: source #{ref.inspect}"

    unless src[:id].is_a?(String) && !src[:id].strip.empty?
      issues << "#{prefix} has a missing/empty id in its metadata."
    end
    unless src[:title].is_a?(String) && !src[:title].strip.empty?
      issues << "#{prefix} has a missing/empty title (required by specifications/vault-metadata.md)."
    end

    owners = src[:owners]
    if !owners.is_a?(Array) || owners.empty? ||
       owners.any? { |o| !o.is_a?(String) || o.strip.empty? }
      issues << "#{prefix} has missing/invalid owners; owners must be a non-empty list of " \
        "non-empty strings (specifications/vault-metadata.md)."
    end

    created = valid_metadata_date(src[:created])
    updated = valid_metadata_date(src[:updated])
    if created.nil?
      issues << "#{prefix} has missing/invalid created date (expected YYYY-MM-DD)."
    end
    if updated.nil?
      issues << "#{prefix} has missing/invalid updated date (expected YYYY-MM-DD)."
    end
    if created && updated && updated < created
      issues << "#{prefix} has updated (#{src[:updated]}) earlier than created (#{src[:created]})."
    end

    related = src[:related]
    unless related.nil?
      if related.is_a?(Hash)
        related.each do |key, value|
          unless KNOWN_RELATED_KEYS.include?(key.to_s)
            issues << "#{prefix} declares an unknown related relationship #{key.inspect} " \
              "(permitted: #{KNOWN_RELATED_KEYS.join(", ")})."
            next
          end
          unless value.is_a?(Array) && value.all? { |v| v.is_a?(String) && !v.strip.empty? }
            issues << "#{prefix} has a malformed related.#{key}: it must be a list of non-empty " \
              "document-id strings (a scalar conflicts_with must not evade the conflict blocker)."
          end
        end
      else
        issues << "#{prefix} has a malformed `related`: it must be a mapping of permitted " \
          "relationships to string lists."
      end
    end

    issues
  end

  # Return a Date for an acceptable YYYY-MM-DD metadata value (Date instances
  # are produced by the strict YAML loader), or nil when missing/malformed.
  def valid_metadata_date(value)
    case value
    when Date
      value
    when String
      return nil unless value.match?(/\A\d{4}-\d{2}-\d{2}\z/)
      begin
        Date.iso8601(value)
      rescue ArgumentError
        nil
      end
    end
  end

  # Validate that a source body is safe and self-contained enough to reproduce
  # verbatim in the exported folder.
  #
  # Every restriction here is a CONSERVATIVE ADAPTER restriction, not a verified
  # vendor fact. The verified Figma "Add guidelines files to a design library"
  # help establishes accepted file extensions, who can upload, size limits, and
  # the upload flow. It does NOT establish that Markdown images or raw HTML are
  # unsupported in guideline files. So we do not claim Figma rejects them.
  # Instead, this adapter conservatively refuses raw HTML/script (a safety and
  # portability choice) and image embeds / Vault-relative links (which have no
  # reviewed canonical-URL mapping yet and would dangle once lifted into an
  # external export folder). Absolute in-page anchors (#...) and fully-qualified
  # external URLs (http:, https:, mailto:, ...) are left untouched because they
  # remain valid outside the Vault.
  def validate_body_content(src, vault)
    issues = []
    body = src[:body]

    if body.match?(/<\s*(script|iframe|object|embed|style)\b/i)
      issues << "Source #{src[:id]}: body contains raw HTML/script. Conservative adapter " \
        "restriction (not a verified Figma limitation): this adapter refuses raw HTML/script " \
        "for safety and portability. Remove it or add a reviewed allowance."
    end
    if body.match?(/!\[[^\]]*\]\([^)]*\)/)
      issues << "Source #{src[:id]}: body embeds images. Conservative adapter restriction (not a " \
        "verified Figma limitation): this adapter has no reviewed mapping for image assets to " \
        "portable URLs yet, so an embedded image would dangle once exported. Add a reviewed " \
        "image mapping or use an absolute image URL."
    end

    body.scan(/(?<!!)\[[^\]]+\]\(([^)\s]+)\)/).flatten.each do |href|
      next if href.start_with?("#") # in-page anchor, valid anywhere
      next if href.match?(/\A[a-z][a-z0-9+.-]*:/i) # external scheme (http:, mailto:, etc.)

      target = href.split("#", 2).first
      next if target.nil? || target.empty?

      # The link is Vault-relative. Prove it resolves safely today (defence in
      # depth against traversal/symlink), then reject it as an unsupported
      # format for export: this adapter has no reviewed canonical-URL mapping,
      # so it will neither rebase nor emit a link that would dangle externally.
      base_dir = File.dirname(src[:rel])
      rebased = File.expand_path(target, "/#{base_dir}").delete_prefix("/")
      begin
        vault.resolve(rebased) # raises on traversal/symlink/missing
        issues << "Source #{src[:id]}: local link #{href.inspect} is a Vault-relative link " \
          "(resolves to #{rebased}). This adapter does not rebase relative links to canonical " \
          "repository URLs yet, so exporting it unchanged would dangle. Unsupported format: " \
          "replace it with an absolute URL or an in-page anchor, or add a reviewed link mapping."
      rescue ExportError => e
        issues << "Source #{src[:id]}: local link #{href.inspect} is unsafe or missing (#{e.diagnostics.first})."
      end
    end

    issues
  end

  # ---- Guideline composition -------------------------------------------------

  # Compose one category file. Each contributing source becomes a clearly
  # attributed block that preserves the source body verbatim (including its own
  # headings), carries full rule-level provenance, and is labelled normative or
  # informative by the source's governed type.
  def compose_category(category, artifacts_by_type, source_index, vault, artifact_checksums)
    allowed_types = CATEGORY_SOURCE_ARTIFACT_TYPES.fetch(category)
    contributing = allowed_types.flat_map { |t| artifacts_by_type.fetch(t, []) }

    if contributing.empty?
      raise ExportError, "Category #{category.inspect} has no eligible source artifact " \
        "(expected types: #{allowed_types.join(", ")}). Refusing to fabricate guideline content."
    end

    blocks = []
    seen_src = {}
    seen_artifact = {}
    contributing.each do |artifact|
      # Source references MUST be eligible before we emit EITHER the artifact's
      # own block or its canonical source blocks. Resolve them first so an
      # ineligible source fails the whole artifact closed.
      sources = eligible_sources_for(artifact, source_index, vault)

      # Faithfully consume the selected approved artifact's OWN content as an
      # attributed derived/informative block, alongside its eligible canonical
      # sources. Checksums alone do not consume artifact content; earlier the
      # artifact body (e.g. a "## Rules" section) was omitted entirely. A
      # naming-contract is JSON and gets a deterministic projection; a Markdown
      # artifact body is preserved byte-for-byte. Derived artifact text is never
      # relabelled as authoritative original governance.
      aid = artifact["id"]
      unless seen_artifact[aid]
        seen_artifact[aid] = true
        blocks << artifact_block(artifact, artifact_checksums, vault, sources)
      end

      sources.each do |src|
        next if seen_src[src[:id]]
        seen_src[src[:id]] = true
        blocks << {
          "kind" => "source",
          "format" => src[:format],
          "source_id" => src[:id],
          "path" => src[:rel],
          "status" => src[:status],
          "authority" => src[:authority],
          "type" => src[:type],
          "sha256" => src[:sha256],
          "normative" => normative_source?(src),
          # Preserve the EXACT source body bytes. Do not rstrip: trailing spaces
          # can be semantically significant Markdown (a two-space hard line
          # break), and fenced code blocks may legitimately carry trailing
          # whitespace. The body is emitted verbatim between attributed
          # boundaries by render_markdown.
          "body" => src[:body]
        }
      end
    end

    if blocks.empty?
      raise ExportError, "Category #{category.inspect} resolved no eligible sources."
    end

    blocks.sort_by! { |b| [b["kind"] == "source" ? 1 : 0, b["source_id"]] }
    text = render_markdown(category, blocks)

    {
      "category" => category,
      "path" => "#{category}.md",
      "title" => CATEGORY_TITLES.fetch(category),
      "text" => text,
      "blocks" => blocks
    }
  end

  # Build an attributed DERIVED/INFORMATIVE block for a selected approved pack
  # artifact. The block consumes the artifact's own content faithfully:
  #
  #   * naming-contract (JSON): a deterministic projection of the contract's
  #     `rules` object and `non_normative_examples`, preserving normative=true /
  #     examples=false exactly as the approved contract declares, emitted as
  #     JSON.pretty_generate inside fenced JSON blocks under explicit
  #     "Normative constraints" and "Non-normative examples" headings. No
  #     invented rules, aliases, or token ids.
  #
  #   * Markdown artifact: the artifact document body is preserved byte-for-byte
  #     (same verbatim boundary treatment as a source body).
  #
  # Every block carries the artifact provenance (artifact id/path/status/type
  # plus content checksum) and the canonical source references that back it.
  # Derived artifact content is always classified informative; it never
  # becomes authoritative original governance by being projected.
  def artifact_block(artifact, artifact_checksums, vault, sources)
    aid = artifact["id"]
    rel = artifact["path"]
    checksum = artifact_checksums.fetch(aid)
    source_refs = sources.map { |s| s[:id] }.sort

    base = {
      "source_id" => aid,
      "path" => rel,
      "status" => artifact["status"],
      "authority" => "derived",
      "type" => artifact["type"],
      "sha256" => checksum,
      "normative" => false,
      "artifact_provenance" => {
        "artifact_id" => aid,
        "artifact_type" => artifact["type"],
        "artifact_path" => rel,
        "artifact_status" => artifact["status"],
        "source_references" => source_refs
      }
    }

    if artifact["type"] == "naming-contract"
      base["kind"] = "contract"
      base["contract"] = project_naming_contract(vault.read(rel), aid)
    else
      base["kind"] = "artifact"
      _data, body = parse_document(vault.read(rel), rel)
      base["body"] = body
    end

    base
  end

  # Project an approved naming-contract JSON into a deterministic, faithful
  # structure for guideline Markdown. We re-emit the contract's own `rules`
  # object and `non_normative_examples` with JSON.pretty_generate; we do not
  # invent, rename, or drop anything. The normative/non-normative distinction is
  # taken verbatim from the contract's declared `normativity` block.
  def project_naming_contract(raw, aid)
    data = parse_json_strict(raw, "naming-contract for #{aid}")

    normativity = data["normativity"]
    unless normativity.is_a?(Hash) &&
           normativity["rules_are_normative"] == true &&
           normativity["examples_are_normative"] == false
      raise ExportError, "Artifact #{aid}: naming-contract normativity does not declare " \
        "rules_are_normative=true and examples_are_normative=false; refusing to project."
    end

    {
      "contract_id" => data["contract_id"],
      "contract_version" => data["contract_version"],
      "schema_version" => data["schema_version"],
      "status" => data["status"],
      "authority" => data["authority"],
      "channel" => data["channel"],
      "examples_label" => normativity["examples_label"],
      # Faithful, unmodified projections of the approved contract content.
      "rules" => data["rules"],
      "non_normative_examples" => data["non_normative_examples"]
    }
  end

  # Render one category file. The per-source body is emitted VERBATIM between
  # clearly attributed boundary markers. We deliberately do NOT demote headings
  # or rstrip lines: doing so changed byte content (e.g. dropping the two
  # trailing spaces that denote a Markdown hard break, or whitespace inside
  # fenced code). The exact source body is guaranteed to appear as an intact
  # substring of the output, so provenance is faithful and the recorded source
  # SHA-256 continues to describe the real source content.
  def render_markdown(category, blocks)
    out = +""
    out << "# #{CATEGORY_TITLES.fetch(category)}\n\n"
    out << "> Derived, read-only projection of eligible UI Foundations governance guidance.\n"
    out << "> This file is not normative on its own. Normative authority remains with the\n"
    out << "> cited source documents at their recorded content checksums, under\n"
    out << "> governance.precedence and governance.lifecycle.\n\n"

    blocks.each do |b|
      case b["kind"]
      when "contract"
        out << render_contract_block(b)
      when "artifact"
        out << render_artifact_block(b)
      else
        out << render_source_block(b)
      end
      out << "\n"
    end

    "#{out.rstrip}\n"
  end

  # An eligible canonical source document, reproduced verbatim.
  def render_source_block(b)
    classification = b["normative"] ? "Normative" : "Informative"
    out = +""
    out << "## Source: `#{b["source_id"]}`\n\n"
    out << "- Canonical path: `#{b["path"]}`\n"
    out << "- Classification: #{classification} (governed type `#{b["type"]}`)\n"
    out << "- Lifecycle status: #{b["status"]}\n"
    out << "- Authority: #{b["authority"]}\n"
    out << "- Source SHA-256: `#{b["sha256"]}`\n\n"
    if b["format"] == "registry-yaml"
      # A governed registry YAML document is preserved verbatim as a clearly
      # attributed INFORMATIVE fenced-YAML block (the whole document, not an
      # interpreted Markdown body). The fenced block makes clear the content is
      # raw source YAML, not guideline Markdown.
      out << "Verbatim governed registry YAML source (reproduced exactly as an " \
        "informative fenced block):\n\n"
      out << registry_yaml_block(b["source_id"], b["body"])
    else
      out << "Verbatim source body (reproduced exactly, headings not demoted):\n\n"
      out << source_body_block(b["source_id"], b["body"])
    end
    out
  end

  # A selected approved pack Markdown artifact, consumed faithfully. Always
  # labelled Informative/Derived: it is a derived artifact, not authoritative
  # original governance. Its backing canonical source references are recorded.
  def render_artifact_block(b)
    prov = b["artifact_provenance"]
    out = +""
    out << "## Derived artifact: `#{b["source_id"]}`\n\n"
    out << "- Artifact path: `#{b["path"]}`\n"
    out << "- Classification: Informative (derived pack artifact, governed type `#{b["type"]}`)\n"
    out << "- Lifecycle status: #{b["status"]}\n"
    out << "- Authority: #{b["authority"]} (derived; not authoritative original governance)\n"
    out << "- Artifact SHA-256: `#{b["sha256"]}`\n"
    out << "- Canonical source references: #{format_refs(prov["source_references"])}\n\n"
    out << "Verbatim derived artifact body (reproduced exactly):\n\n"
    out << source_body_block(b["source_id"], b["body"])
    out
  end

  # A naming-contract projection. The contract's normative `rules` and
  # non-normative `non_normative_examples` are emitted under explicit headings
  # as fenced JSON (JSON.pretty_generate), preserving the approved contract's
  # normative/non-normative distinction. The projection is a derived view, not
  # authoritative original governance.
  def render_contract_block(b)
    c = b["contract"]
    prov = b["artifact_provenance"]
    out = +""
    out << "## Derived naming-contract projection: `#{b["source_id"]}`\n\n"
    out << "- Contract id: `#{c["contract_id"]}`\n"
    out << "- Contract path: `#{b["path"]}`\n"
    out << "- Contract version: #{c["contract_version"]} (schema #{c["schema_version"]})\n"
    out << "- Lifecycle status: #{c["status"]}\n"
    out << "- Channel: #{c["channel"]}\n"
    out << "- Authority: #{c["authority"]} (derived projection; not authoritative original governance)\n"
    out << "- Contract SHA-256: `#{b["sha256"]}`\n"
    out << "- Canonical source references: #{format_refs(prov["source_references"])}\n\n"
    out << "### Normative constraints (rules_are_normative: true)\n\n"
    out << "```json\n#{JSON.pretty_generate(c["rules"])}\n```\n\n"
    out << "### Non-normative examples (#{c["examples_label"]})\n\n"
    out << "```json\n#{JSON.pretty_generate(c["non_normative_examples"])}\n```\n"
    out
  end

  def format_refs(refs)
    return "none" if refs.nil? || refs.empty?
    refs.map { |r| "`#{r}`" }.join(", ")
  end

  # Wrap a source body between explicit begin/end boundary markers so a reader
  # (human or tool) can recover the exact bytes between them. The body is
  # inserted unchanged; a trailing newline is added only as a separator OUTSIDE
  # the end marker, never inside the preserved region. If a body somehow
  # contained our sentinel, we fail closed rather than emit an ambiguous block.
  BODY_BEGIN = "<!-- figma-export:source-body:begin -->"
  BODY_END = "<!-- figma-export:source-body:end -->"

  def source_body_block(source_id, body)
    if body.include?(BODY_BEGIN) || body.include?(BODY_END)
      raise ExportError, "Source #{source_id}: body contains a reserved export boundary marker; " \
        "refusing to emit an ambiguous verbatim block."
    end
    separator = body.end_with?("\n") ? "" : "\n"
    "#{BODY_BEGIN}\n#{body}#{separator}#{BODY_END}\n"
  end

  # Preserve a governed registry YAML source verbatim inside a fenced YAML code
  # block, wrapped in the same attributed begin/end boundary markers so the
  # exact raw document can be recovered. The YAML fence makes the informative,
  # non-Markdown nature explicit. A YAML document containing our boundary marker
  # or a ```-fence that would break out of the block fails closed.
  def registry_yaml_block(source_id, yaml_text)
    if yaml_text.include?(BODY_BEGIN) || yaml_text.include?(BODY_END)
      raise ExportError, "Source #{source_id}: registry YAML contains a reserved export boundary " \
        "marker; refusing to emit an ambiguous block."
    end
    if yaml_text.match?(/^```/)
      raise ExportError, "Source #{source_id}: registry YAML contains a code fence; refusing to " \
        "emit an ambiguous fenced block."
    end
    separator = yaml_text.end_with?("\n") ? "" : "\n"
    "#{BODY_BEGIN}\n```yaml\n#{yaml_text}#{separator}```\n#{BODY_END}\n"
  end

  # ---- Plan + manifest -------------------------------------------------------

  # Validate the markdown artifact's own frontmatter against the manifest entry.
  # The manifest artifact id (e.g. governance-pack.naming-rules) differs from
  # the markdown source id (export-pack.governance.naming-rules) by existing
  # convention, so we match on status rather than forcing an id equality that
  # would be a false mismatch. We still require the markdown id to be present
  # and well-formed.
  def validate_artifact_document(artifact, vault, aid)
    rel = artifact["path"]
    content = vault.read(rel)
    data, = parse_document(content, rel)
    doc_id = data["id"]
    unless doc_id.is_a?(String) && !doc_id.strip.empty?
      raise ExportError, "Artifact #{aid}: consumed document #{rel} has no usable id."
    end
    unless data["status"] == artifact["status"]
      raise ExportError, "Artifact #{aid}: manifest status #{artifact["status"].inspect} does not " \
        "match consumed document #{rel} status #{data["status"].inspect}."
    end
    sha256(content)
  end

  # Load the committed naming-contract schema (YAML) through SafeVault, validate
  # its path safety and shape, and return [schema_hash, schema_checksum]. The
  # schema is validated against the SAME supported-keyword set the stdlib
  # evaluator implements, so we never claim to enforce keywords we do not.
  # Including the checksum in the manifest input checksums means `--check`
  # invalidates when the consumed schema content changes.
  def load_naming_contract_schema(vault)
    rel = NAMING_CONTRACT_SCHEMA_REL
    # Path safety: resolve through SafeVault (rejects traversal/symlink escape).
    vault.resolve(rel)
    raw = vault.read(rel)
    schema = safe_load_strict(raw, rel)
    unless schema.is_a?(Hash)
      raise ExportError, "#{rel}: naming-contract schema must be a mapping."
    end
    assert_schema_supported(schema)
    [schema, sha256(raw)]
  end

  # Deeply validate and cross-check a naming-contract JSON artifact. Returns
  # [contract_checksum, schema_checksum].
  #
  # This is not a shallow required-top-level-keys scan. It:
  #   * resolves the JSON path safely and parses with duplicate-key rejection,
  #   * validates the JSON against the committed naming-contract schema using
  #     the existing stdlib schema evaluator (nested required/enum/type/semver
  #     via the schema's own `pattern`s),
  #   * confirms the contract's declared schema path is the committed schema
  #     (safe, exact) rather than an alternate unverified path,
  #   * cross-checks the contract against the resolved eligible pack / manifest /
  #     artifact: status must itself be accepted/stable AND equal the artifact
  #     manifest status; contract_id must agree with the artifact identity;
  #     authority must be a valid vault authority; schema/contract versions must
  #     be supported semver; governance_pack_version and channel must agree with
  #     the resolved pack/manifest,
  #   * validates every internal source_metadata.canonical_sources entry: a
  #     mapping with a unique valid id bound to an actually-indexed eligible
  #     source record (lifecycle/authority/type enforced), a safe
  #     repository-relative path equal to that indexed record's path, and the id
  #     must be declared in the artifact's own source_references (no alternate
  #     unverified path), and
  #   * confirms the pack_manifest pointer is exactly the resolved manifest and
  #     pack_changelog is a valid referenced file consistent with the manifest.
  def validate_naming_contract(artifact, vault, aid, ctx)
    rel = artifact["path"]
    unless rel.to_s.end_with?(".json")
      raise ExportError, "Artifact #{aid}: naming-contract path #{rel.inspect} must be JSON."
    end
    raw = vault.read(rel)
    data = parse_json_strict(raw, "naming-contract #{rel}")
    unless data.is_a?(Hash)
      raise ExportError, "Artifact #{aid}: naming-contract JSON must be an object."
    end

    # 1) Validate the JSON against the committed naming-contract schema. This
    #    enforces required/nested-required, enums, types, and semver patterns.
    schema = ctx[:contract_schema]
    schema_errors = validate_against_schema(data, schema, "$contract")
    unless schema_errors.empty?
      raise ExportError, (["Artifact #{aid}: naming-contract JSON fails the committed schema " \
        "#{NAMING_CONTRACT_SCHEMA_REL}:"] + schema_errors)
    end

    diagnostics = []

    # 2) The contract's own declared schema reference must point at the committed
    #    schema, resolved safely. We accept a path that, once rebased from the
    #    contract's directory, equals the committed schema path. A missing or
    #    alternate path is rejected rather than trusted.
    declared_schema = data["$schema"]
    if declared_schema.is_a?(String) && !declared_schema.strip.empty?
      base_dir = File.dirname(rel)
      rebased = File.expand_path(declared_schema, "/#{base_dir}").delete_prefix("/")
      if rebased != NAMING_CONTRACT_SCHEMA_REL
        diagnostics << "declared $schema #{declared_schema.inspect} (resolves to #{rebased}) must be " \
          "the committed #{NAMING_CONTRACT_SCHEMA_REL}; refusing an alternate unverified schema path."
      else
        begin
          vault.resolve(rebased)
        rescue ExportError => e
          diagnostics << "declared $schema is unsafe or missing (#{e.diagnostics.first})."
        end
      end
    else
      diagnostics << "contract must declare a $schema pointing at #{NAMING_CONTRACT_SCHEMA_REL}."
    end

    # 3) Cross-check contract identity/status/versions against the eligible
    #    pack / manifest / artifact. Do NOT export a draft merely because the
    #    outer manifest record claims accepted.
    unless ELIGIBLE_ARTIFACT_STATUSES.include?(data["status"])
      diagnostics << "contract status #{data["status"].inspect} is not eligible " \
        "(requires one of #{ELIGIBLE_ARTIFACT_STATUSES.join(", ")}); a draft contract must not export."
    end
    unless data["status"] == artifact["status"]
      diagnostics << "contract status #{data["status"].inspect} does not match the artifact manifest " \
        "status #{artifact["status"].inspect}."
    end
    unless data["authority"].is_a?(String) && KNOWN_AUTHORITIES.include?(data["authority"])
      diagnostics << "contract authority #{data["authority"].inspect} is not a valid vault authority " \
        "(#{KNOWN_AUTHORITIES.join(", ")})."
    end
    unless data["contract_id"] == aid
      diagnostics << "contract_id #{data["contract_id"].inspect} must agree with the artifact id " \
        "#{aid.inspect}."
    end
    %w[schema_version contract_version].each do |k|
      unless data[k].is_a?(String) && data[k].match?(SEMVER_RE)
        diagnostics << "#{k} #{data[k].inspect} must be a supported semver (MAJOR.MINOR.PATCH)."
      end
    end

    pack = ctx[:pack]
    pack_manifest = ctx[:pack_manifest]
    pack_version = pack_manifest.dig("pack", "version")
    pack_channel = pack_manifest.dig("pack", "channel")
    unless data["governance_pack_version"].is_a?(String) &&
           data["governance_pack_version"].match?(SEMVER_RE)
      diagnostics << "governance_pack_version #{data["governance_pack_version"].inspect} must be a " \
        "supported semver."
    end
    if data["governance_pack_version"] != pack_version
      diagnostics << "contract governance_pack_version #{data["governance_pack_version"].inspect} must " \
        "agree with the resolved eligible pack/manifest version #{pack_version.inspect}."
    end
    if data["channel"] != pack_channel
      diagnostics << "contract channel #{data["channel"].inspect} must agree with the resolved " \
        "eligible pack/manifest channel #{pack_channel.inspect}."
    end

    # 4) source_metadata pointers and canonical_sources binding.
    source_metadata = data["source_metadata"]
    if source_metadata.is_a?(Hash)
      if source_metadata["pack_manifest"] != ctx[:manifest_rel]
        diagnostics << "source_metadata.pack_manifest #{source_metadata["pack_manifest"].inspect} must " \
          "be exactly the resolved manifest #{ctx[:manifest_rel].inspect}."
      end

      changelog = source_metadata["pack_changelog"]
      expected_changelog = pack_manifest.dig("pack", "changelog") || pack["changelog"]
      if changelog != expected_changelog
        diagnostics << "source_metadata.pack_changelog #{changelog.inspect} must be consistent with the " \
          "manifest changelog #{expected_changelog.inspect}."
      elsif changelog.is_a?(String) && !changelog.strip.empty?
        begin
          vault.resolve(changelog) # must be a real, safe, referenced file
        rescue ExportError => e
          diagnostics << "source_metadata.pack_changelog is unsafe or missing (#{e.diagnostics.first})."
        end
      end

      declared_refs = Array(artifact["source_references"])
      seen_ids = {}
      Array(source_metadata["canonical_sources"]).each_with_index do |entry, i|
        unless entry.is_a?(Hash)
          diagnostics << "source_metadata.canonical_sources[#{i}] must be a mapping."
          next
        end
        cid = entry["id"]
        cpath = entry["path"]
        unless cid.is_a?(String) && !cid.strip.empty?
          diagnostics << "source_metadata.canonical_sources[#{i}] has a missing/empty id."
          next
        end
        if seen_ids[cid]
          diagnostics << "source_metadata.canonical_sources[#{i}] duplicate id #{cid.inspect}."
          next
        end
        seen_ids[cid] = true

        unless declared_refs.include?(cid)
          diagnostics << "source_metadata.canonical_sources[#{i}] id #{cid.inspect} is not declared in " \
            "the artifact source_references; every JSON-internal source must be declared and validated."
          next
        end

        src = ctx[:source_index][cid]
        unless src
          diagnostics << "source_metadata.canonical_sources[#{i}] id #{cid.inspect} does not resolve to an " \
            "indexed governed document (broken internal source reference)."
          next
        end
        unless cpath.is_a?(String) && !cpath.strip.empty?
          diagnostics << "source_metadata.canonical_sources[#{i}] has a missing/empty path."
          next
        end
        begin
          vault.resolve(cpath) # rejects absolute/traversal/symlink/missing
        rescue ExportError => e
          diagnostics << "source_metadata.canonical_sources[#{i}] path is unsafe or missing " \
            "(#{e.diagnostics.first})."
          next
        end
        if cpath != src[:rel]
          diagnostics << "source_metadata.canonical_sources[#{i}] path #{cpath.inspect} must bind to the " \
            "indexed eligible source record path #{src[:rel].inspect} (no alternate unverified path)."
        end
        unless KNOWN_DOCUMENT_TYPES.include?(src[:type].to_s)
          diagnostics << "source_metadata.canonical_sources[#{i}] source #{cid.inspect} has unknown " \
            "document type #{src[:type].inspect}."
        end
        unless KNOWN_AUTHORITIES.include?(src[:authority].to_s)
          diagnostics << "source_metadata.canonical_sources[#{i}] source #{cid.inspect} has unknown " \
            "authority #{src[:authority].inspect}."
        end
        unless ELIGIBLE_SOURCE_STATUSES.include?(src[:status])
          diagnostics << "source_metadata.canonical_sources[#{i}] source #{cid.inspect} has lifecycle " \
            "status #{src[:status].inspect}; requires one of #{ELIGIBLE_SOURCE_STATUSES.join(", ")}."
        end
      end
    else
      diagnostics << "source_metadata must be an object."
    end

    unless diagnostics.empty?
      raise ExportError, (["Artifact #{aid}: naming-contract JSON fails eligibility/provenance " \
        "validation:"] + diagnostics)
    end

    [sha256(raw), ctx[:contract_schema_checksum]]
  end

  def build_plan(vault, options)
    registry_raw = vault.read(REGISTRY_REL)
    registry = safe_load_strict(registry_raw, REGISTRY_REL)
    repos_raw = vault.read(REPOS_REL)
    repos_data = safe_load_strict(repos_raw, REPOS_REL)
    pack = resolve_pack(registry)

    eligibility = check_pack_eligibility(pack, repos_data)
    raise ExportError, eligibility unless eligibility.empty?

    manifest_rel = pack["manifest"]
    unless manifest_rel.is_a?(String) && !manifest_rel.strip.empty?
      raise ExportError, "#{REGISTRY_REL}: pack #{PACK_ID} has no manifest path"
    end
    pack_manifest_raw = vault.read(manifest_rel)
    pack_manifest = safe_load_strict(pack_manifest_raw, manifest_rel)
    unless pack_manifest.is_a?(Hash)
      raise ExportError, "#{manifest_rel}: pack manifest must be a mapping"
    end

    # The pack manifest document carries its OWN lifecycle status. Validate it
    # as an eligibility gate in addition to the registry channel, so a manifest
    # that is still draft/review cannot be authoritatively exported even if the
    # registry channel were somehow stable.
    manifest_status = pack_manifest["status"]
    unless ELIGIBLE_ARTIFACT_STATUSES.include?(manifest_status)
      raise ExportError, "#{manifest_rel}: pack manifest status #{manifest_status.inspect} is not " \
        "eligible (requires one of #{ELIGIBLE_ARTIFACT_STATUSES.join(", ")}). Authoritative export is blocked."
    end

    unless version_matches_registry?(pack, pack_manifest)
      raise ExportError, "Conflicting metadata: registry version/channel " \
        "#{pack["current_version"].inspect}/#{pack["channel"].inspect} does not match manifest " \
        "#{pack_manifest.dig("pack", "version").inspect}/#{pack_manifest.dig("pack", "channel").inspect}."
    end

    artifacts = pack_manifest["artifacts"]
    unless artifacts.is_a?(Array) && !artifacts.empty?
      raise ExportError, "#{manifest_rel}: artifacts must be a non-empty list"
    end

    source_index = index_sources(vault)
    verify_governance(source_index)

    artifacts_by_type = Hash.new { |h, k| h[k] = [] }
    artifact_checksums = {}
    artifact_diags = []
    seen_artifact_ids = {}
    # Lazily loaded the first time a naming-contract artifact is validated, so a
    # pack without contracts does not require the contract schema to exist. The
    # consumed schema checksum is folded into input_checksums below.
    contract_schema = nil
    contract_schema_checksum = nil
    contract_schema_used = false

    artifacts.each do |artifact|
      # Each artifact list element must itself be a mapping. A null or scalar
      # entry (e.g. `artifacts: [null]`) previously reached `artifact["id"]` and
      # raised an unhandled NoMethodError (undefined method `[]' for nil),
      # leaking a stack trace instead of a controlled failure. Validate the
      # element shape first and fail closed with a diagnostic.
      unless artifact.is_a?(Hash)
        artifact_diags << "Artifact list entry is not a mapping (got #{artifact.class}): " \
          "#{artifact.inspect}. Each artifact must be an object with id/type/path/status."
        next
      end

      aid = artifact["id"]
      unless aid.is_a?(String) && !aid.strip.empty?
        artifact_diags << "Artifact with missing/invalid id: #{artifact.inspect}"
        next
      end
      if seen_artifact_ids[aid]
        artifact_diags << "Duplicate artifact id #{aid.inspect}"
        next
      end
      seen_artifact_ids[aid] = true

      type = artifact["type"]
      unless KNOWN_ARTIFACT_TYPES.include?(type)
        artifact_diags << "Artifact #{aid} has unknown type #{type.inspect}; refusing to " \
          "silently ignore it (known: #{KNOWN_ARTIFACT_TYPES.join(", ")})."
        next
      end

      status = artifact["status"]
      unless ELIGIBLE_ARTIFACT_STATUSES.include?(status)
        artifact_diags << "Artifact #{aid} status #{status.inspect} is not eligible " \
          "(requires one of #{ELIGIBLE_ARTIFACT_STATUSES.join(", ")})."
        next
      end

      # The artifact path must be a non-empty string before SafeVault resolves
      # it, and any declared source_references must be a list (SafeVault.resolve
      # already rejects traversal/symlink/missing). These are controlled shape
      # checks so a malformed manifest fails closed rather than crashing.
      path = artifact["path"]
      unless path.is_a?(String) && !path.strip.empty?
        artifact_diags << "Artifact #{aid} has missing/invalid path #{path.inspect}."
        next
      end
      refs = artifact["source_references"]
      unless refs.nil? || refs.is_a?(Array)
        artifact_diags << "Artifact #{aid} source_references must be a list when present " \
          "(got #{refs.class})."
        next
      end

      vault.resolve(path) # raises on traversal/symlink/missing

      checksum =
        if type == "naming-contract"
          if contract_schema.nil?
            contract_schema, contract_schema_checksum = load_naming_contract_schema(vault)
          end
          contract_schema_used = true
          ctx = {
            pack: pack,
            pack_manifest: pack_manifest,
            manifest_rel: manifest_rel,
            source_index: source_index,
            contract_schema: contract_schema,
            contract_schema_checksum: contract_schema_checksum
          }
          contract_checksum, _schema_checksum = validate_naming_contract(artifact, vault, aid, ctx)
          contract_checksum
        else
          unless artifact["path"].to_s.end_with?(".md")
            artifact_diags << "Artifact #{aid} has unsupported non-Markdown path #{artifact["path"].inspect}."
            next
          end
          validate_artifact_document(artifact, vault, aid)
        end
      artifact_checksums[aid] = checksum

      artifacts_by_type[type] << artifact
    rescue ExportError => e
      artifact_diags.concat(e.diagnostics)
    end
    raise ExportError, artifact_diags unless artifact_diags.empty?

    files = CATEGORIES.map do |category|
      compose_category(category, artifacts_by_type, source_index, vault, artifact_checksums)
    end

    checksums = {
      "registry" => sha256(registry_raw),
      "repos" => sha256(repos_raw),
      "pack_manifest" => sha256(pack_manifest_raw),
      "schema" => sha256(vault.read(MANIFEST_SCHEMA_REL)),
      # Authority inputs: the precedence and lifecycle governance documents
      # whose content decides normativity classification. Including their exact
      # hashes means `--check` invalidates if either authority input changes,
      # even if no source body changed.
      "governance" => REQUIRED_GOVERNANCE.keys.sort.each_with_object({}) do |id, acc|
        acc[id] = source_index.fetch(id)[:sha256]
      end,
      "artifacts" => artifact_checksums.sort.to_h
    }
    # When a naming-contract was consumed, fold the committed naming-contract
    # schema's content hash into the input checksums so `--check` invalidates
    # if that consumed schema changes.
    if contract_schema_used
      checksums["naming_contract_schema"] = contract_schema_checksum
    end

    {
      pack: pack,
      manifest_rel: manifest_rel,
      files: files,
      options: options,
      checksums: checksums
    }
  end

  def build_manifest(plan)
    files = plan[:files].map do |f|
      {
        "category" => f["category"],
        "path" => f["path"],
        "title" => f["title"],
        "bytes" => byte_size(f["text"]),
        "sha256" => sha256(f["text"]),
        "source_blocks" => f["blocks"].map do |b|
          {
            "source_id" => b["source_id"],
            "path" => b["path"],
            "type" => b["type"],
            "status" => b["status"],
            "authority" => b["authority"],
            "normative" => b["normative"],
            "sha256" => b["sha256"]
          }
        end
      }
    end

    total = files.sum { |f| f["bytes"] }
    pack = plan[:pack]

    {
      "schema" => MANIFEST_SCHEMA_REL,
      "schema_version" => MANIFEST_FORMAT_VERSION,
      "generator" => { "id" => GENERATOR_ID, "version" => GENERATOR_VERSION },
      "generated_from" => {
        "pack_id" => pack["id"],
        "pack_version" => pack["current_version"],
        "pack_channel" => pack["channel"],
        "registry_path" => REGISTRY_REL,
        "manifest_path" => plan[:manifest_rel]
      },
      "input_checksums" => plan[:checksums],
      "size_unit" => SIZE_UNIT,
      "manifest_uploaded_to_figma" => false,
      "budgets" => {
        "max_file_bytes" => plan[:options][:max_file_bytes],
        "max_total_bytes" => plan[:options][:max_total_bytes],
        "hard_max_total_bytes" => HARD_MAX_TOTAL_BYTES
      },
      "total_bytes" => total,
      "files" => files
    }
  end

  def enforce_budgets(manifest, options)
    diagnostics = []
    manifest["files"].each do |f|
      if f["bytes"] > options[:max_file_bytes]
        diagnostics << "Category #{f["category"]} exceeds per-file budget: " \
          "#{f["bytes"]}/#{options[:max_file_bytes]} #{SIZE_UNIT}."
      end
    end
    if manifest["total_bytes"] > options[:max_total_bytes]
      diagnostics << "Total guideline output exceeds configured budget: " \
        "#{manifest["total_bytes"]}/#{options[:max_total_bytes]} #{SIZE_UNIT}."
    end
    if manifest["total_bytes"] > HARD_MAX_TOTAL_BYTES
      diagnostics << "Total guideline output exceeds the immutable Figma compatibility cap: " \
        "#{manifest["total_bytes"]}/#{HARD_MAX_TOTAL_BYTES} #{SIZE_UNIT}."
    end
    raise ExportError, diagnostics unless diagnostics.empty?
  end

  # ---- Schema validation -----------------------------------------------------

  def load_manifest_schema(vault)
    raw = vault.read(MANIFEST_SCHEMA_REL)
    JSON.parse(raw)
  rescue JSON::ParserError => e
    raise ExportError, "Invalid manifest schema JSON: #{e.message}"
  end

  # Reject a schema whose dialect or keywords this validator does not actually
  # implement, so we never pretend a manifest was fully checked.
  def assert_schema_supported(schema)
    diagnostics = []
    dialect = schema["$schema"]
    unless SUPPORTED_SCHEMA_DIALECTS.include?(dialect)
      diagnostics << "Unsupported manifest schema dialect #{dialect.inspect}."
    end

    walk_schema_keywords(schema) do |keyword, path|
      next if SUPPORTED_SCHEMA_KEYWORDS.include?(keyword)
      diagnostics << "Unsupported schema keyword #{keyword.inspect} at #{path}; " \
        "the bundled validator does not implement it."
    end
    raise ExportError, diagnostics unless diagnostics.empty?
  end

  # Walk the subschema tree and yield each declared keyword. Only the structural
  # locations the validator understands are descended into.
  def walk_schema_keywords(schema, path = "$", &block)
    return unless schema.is_a?(Hash)

    schema.each_key { |k| yield(k, path) }

    if schema["properties"].is_a?(Hash)
      schema["properties"].each { |name, sub| walk_schema_keywords(sub, "#{path}.properties.#{name}", &block) }
    end
    walk_schema_keywords(schema["items"], "#{path}.items", &block) if schema["items"].is_a?(Hash)
  end

  def validate_against_schema(instance, schema, path = "$")
    errors = []
    type = schema["type"]

    if schema.key?("const") && instance != schema["const"]
      errors << "#{path}: expected const #{schema["const"].inspect}, got #{instance.inspect}"
    end
    if schema["enum"] && !schema["enum"].include?(instance)
      errors << "#{path}: #{instance.inspect} not in enum #{schema["enum"].inspect}"
    end

    case type
    when "object"
      return ["#{path}: expected object, got #{instance.class}"] unless instance.is_a?(Hash)
      Array(schema["required"]).each do |key|
        errors << "#{path}: missing required property #{key.inspect}" unless instance.key?(key)
      end
      props = schema["properties"] || {}
      if schema["additionalProperties"] == false
        extra = instance.keys - props.keys
        errors << "#{path}: unexpected properties #{extra.inspect}" unless extra.empty?
      end
      props.each do |key, subschema|
        next unless instance.key?(key)
        errors.concat(validate_against_schema(instance[key], subschema, "#{path}.#{key}"))
      end
    when "array"
      return ["#{path}: expected array, got #{instance.class}"] unless instance.is_a?(Array)
      if schema["minItems"] && instance.length < schema["minItems"]
        errors << "#{path}: expected at least #{schema["minItems"]} items, got #{instance.length}"
      end
      if schema["maxItems"] && instance.length > schema["maxItems"]
        errors << "#{path}: expected at most #{schema["maxItems"]} items, got #{instance.length}"
      end
      if schema["items"]
        instance.each_with_index do |item, i|
          errors.concat(validate_against_schema(item, schema["items"], "#{path}[#{i}]"))
        end
      end
    when "string"
      if instance.is_a?(String)
        if schema["minLength"] && instance.length < schema["minLength"]
          errors << "#{path}: string shorter than minLength #{schema["minLength"]}"
        end
        if schema["pattern"] && !Regexp.new(schema["pattern"]).match?(instance)
          errors << "#{path}: string #{instance.inspect} does not match pattern #{schema["pattern"].inspect}"
        end
      else
        errors << "#{path}: expected string, got #{instance.class}"
      end
    when "integer"
      if instance.is_a?(Integer)
        if schema["minimum"] && instance < schema["minimum"]
          errors << "#{path}: #{instance} below minimum #{schema["minimum"]}"
        end
      else
        errors << "#{path}: expected integer, got #{instance.class}"
      end
    when "boolean"
      errors << "#{path}: expected boolean, got #{instance.class}" unless [true, false].include?(instance)
    when nil
      # No type constraint at this node; const/enum already checked.
    else
      errors << "#{path}: unsupported schema type #{type.inspect}"
    end

    errors
  end

  def enforce_schema(vault, manifest)
    schema = load_manifest_schema(vault)
    assert_schema_supported(schema)
    errors = validate_against_schema(manifest, schema)
    return if errors.empty?

    raise ExportError, ["Manifest fails committed schema #{MANIFEST_SCHEMA_REL}:"] + errors
  end

  # ---- Output + verification -------------------------------------------------

  # Resolve the output directory to an absolute physical path and prove it is
  # safe to use. Parent symlinks are resolved to their physical path before
  # validation, so a symlinked parent cannot point back into the vault. The
  # target itself must NOT already exist.
  def resolve_external_output(dir, vault)
    abs = File.expand_path(dir)
    parent = File.dirname(abs)
    unless File.directory?(parent)
      raise ExportError, "Output parent directory does not exist: #{parent}"
    end
    real_parent = File.realpath(parent)
    vault_root = vault.root.to_s

    # Refuse writing anywhere inside the vault, and refuse the vault root or any
    # ancestor of the vault (which could clobber the whole tree).
    phys_target = File.join(real_parent, File.basename(abs))
    if phys_target == vault_root || phys_target.start_with?("#{vault_root}#{File::SEPARATOR}")
      raise ExportError, "Output directory must be external to the vault; refusing #{phys_target}."
    end
    if real_parent == vault_root || real_parent.start_with?("#{vault_root}#{File::SEPARATOR}")
      raise ExportError, "Output parent is inside the vault; refusing #{real_parent}."
    end
    if vault_root == phys_target || vault_root.start_with?("#{phys_target}#{File::SEPARATOR}")
      raise ExportError, "Output directory is an ancestor of the vault; refusing #{phys_target}."
    end
    if phys_target == File::SEPARATOR
      raise ExportError, "Refusing to use the filesystem root as the output directory."
    end

    { abs: phys_target, parent: real_parent }
  end

  # Write guideline files and manifest atomically. Never deletes or replaces an
  # existing target or an arbitrary staging path. Stages in a fresh mktmpdir
  # inside the verified parent, then renames into the absent target. Only the
  # staging directory we created is cleaned up.
  def write_output(plan, manifest, resolved)
    target = resolved[:abs]
    if File.exist?(target) || File.symlink?(target)
      raise ExportError, "Refusing to overwrite existing output path: #{target}. " \
        "Remove it yourself or choose a fresh directory."
    end

    staging = Dir.mktmpdir("figma-export-stage-", resolved[:parent])
    begin
      plan[:files].each do |f|
        file_target = File.join(staging, f["path"])
        unless File.realpath(File.dirname(file_target)) == File.realpath(staging)
          raise ExportError, "Refusing to write outside staging: #{f["path"]}"
        end
        File.binwrite(file_target, f["text"])
      end
      File.binwrite(File.join(staging, "manifest.json"), "#{JSON.pretty_generate(manifest)}\n")
      File.rename(staging, target)
    rescue StandardError
      FileUtils.remove_entry(staging) if File.directory?(staging)
      raise
    end
  end

  # Verify an existing output directory byte-for-byte against a freshly
  # regenerated plan. Read-only. Rejects symlink entries, unexpected entries,
  # and any entry that is not a regular file (including directories).
  def verify_output(plan, manifest, resolved)
    diagnostics = []
    target = resolved[:abs]
    unless File.directory?(target) && !File.symlink?(target)
      return ["Output directory does not exist (or is a symlink): #{target}"]
    end

    expected = (plan[:files].map { |f| f["path"] } + ["manifest.json"]).sort
    entries = Dir.children(target).sort

    entries.each do |name|
      full = File.join(target, name)
      if File.symlink?(full)
        diagnostics << "Output entry #{name} is a symlink (refused)."
      elsif !File.file?(full)
        diagnostics << "Output entry #{name} is not a regular file (refused)."
      end
    end

    missing = expected - entries
    extra = entries - expected
    diagnostics << "Missing output files: #{missing.join(", ")}" unless missing.empty?
    diagnostics << "Unexpected output entries (possible tampering): #{extra.join(", ")}" unless extra.empty?

    plan[:files].each do |f|
      full = File.join(target, f["path"])
      next if File.symlink?(full) || !File.file?(full)
      actual = File.binread(full).force_encoding("UTF-8")
      if actual != f["text"]
        diagnostics << "Byte mismatch in #{f["path"]}: " \
          "expected sha256=#{sha256(f["text"])}, got sha256=#{sha256(actual)}."
      end
    end

    manifest_full = File.join(target, "manifest.json")
    if !File.symlink?(manifest_full) && File.file?(manifest_full)
      expected_manifest = "#{JSON.pretty_generate(manifest)}\n"
      actual_manifest = File.binread(manifest_full).force_encoding("UTF-8")
      if actual_manifest != expected_manifest
        diagnostics << "manifest.json byte mismatch: " \
          "expected sha256=#{sha256(expected_manifest)}, got sha256=#{sha256(actual_manifest)}."
      end
    end

    diagnostics
  end

  # ---- Orchestration ---------------------------------------------------------

  def run(argv)
    options = {
      vault_root: Dir.pwd,
      out_dir: nil,
      check: false,
      max_file_bytes: DEFAULT_MAX_FILE_BYTES,
      max_total_bytes: DEFAULT_MAX_TOTAL_BYTES
    }

    parser = OptionParser.new do |o|
      o.banner = "Usage: ruby scripts/export-figma-guidelines.rb --out DIR [--check] " \
        "[--vault-root DIR] [--max-file-bytes N] [--max-total-bytes N]"
      o.on("--out DIR", "External output directory (must be outside the vault and not exist yet)") { |v| options[:out_dir] = v }
      o.on("--vault-root DIR", "Vault root (default: current directory)") { |v| options[:vault_root] = v }
      o.on("--check", "Verify existing output without writing") { options[:check] = true }
      o.on("--max-file-bytes N", Integer, "Per-file UTF-8 byte budget") { |v| options[:max_file_bytes] = v }
      o.on("--max-total-bytes N", Integer, "Total UTF-8 byte budget (clamped to the hard cap)") { |v| options[:max_total_bytes] = v }
    end
    parser.parse!(argv)

    if options[:out_dir].nil? || options[:out_dir].to_s.strip.empty?
      warn "error: --out DIR is required"
      warn parser.help
      return 2
    end
    if options[:max_file_bytes] <= 0 || options[:max_total_bytes] <= 0
      warn "error: byte budgets must be positive integers"
      return 2
    end
    # The configured total budget can never exceed the immutable compatibility
    # cap, regardless of what the caller requested.
    if options[:max_total_bytes] > HARD_MAX_TOTAL_BYTES
      options[:max_total_bytes] = HARD_MAX_TOTAL_BYTES
    end

    vault = SafeVault.new(options[:vault_root])
    resolved = resolve_external_output(options[:out_dir], vault)

    plan = build_plan(vault, options)
    manifest = build_manifest(plan)
    enforce_budgets(manifest, options)
    enforce_schema(vault, manifest)

    if options[:check]
      diagnostics = verify_output(plan, manifest, resolved)
      unless diagnostics.empty?
        warn "Figma guidelines export check FAILED:"
        diagnostics.each { |d| warn "- #{d}" }
        return 1
      end
      puts "Figma guidelines export check PASSED: #{plan[:files].length} files + manifest, " \
        "#{manifest["total_bytes"]} #{SIZE_UNIT}, byte-identical and schema-valid."
      return 0
    end

    write_output(plan, manifest, resolved)
    puts "Generated Figma guidelines export at #{resolved[:abs]}:"
    manifest["files"].each do |f|
      puts "  #{f["path"]}: #{f["bytes"]} #{SIZE_UNIT} sha256=#{f["sha256"]}"
    end
    puts "  manifest.json (not uploaded to Figma): pack #{manifest.dig("generated_from", "pack_version")} " \
      "channel #{manifest.dig("generated_from", "pack_channel")}, guideline total #{manifest["total_bytes"]} #{SIZE_UNIT}"
    0
  rescue ExportError => e
    warn "Figma guidelines export FAILED (closed, no partial output written):"
    e.diagnostics.each { |d| warn "- #{d}" }
    1
  end
end

if $PROGRAM_NAME == __FILE__
  exit FigmaGuidelinesExport.run(ARGV)
end
