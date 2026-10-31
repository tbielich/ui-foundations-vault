#!/usr/bin/env ruby
# frozen_string_literal: true

# Deterministic, read-only tests for scripts/export-figma-guidelines.rb.
#
# Ruby stdlib only. No network, no dependencies, no publishing, no git mutation.
#
# Positive tests build EXPLICITLY SYNTHETIC temporary vault fixtures in a system
# temp directory. These fixtures are NOT approved UI Foundations exports; they
# exist solely to prove determinism, provenance traceability, schema enforcement,
# verbatim body preservation, type-based normativity, input invalidation, path
# safety, and fail-closed behavior. All generated output goes to external temp
# dirs only.
#
# The real 0.9.0 release candidate must export deterministically within the
# explicit 200000-byte budget. Synthetic negative cases still reject review
# channels, draft sources and malformed metadata without changing eligibility.

require "fileutils"
require "json"
require "tmpdir"
require "digest"
require "open3"
require "yaml"
require "date"

SCRIPT_DIR = __dir__
EXPORTER = File.join(SCRIPT_DIR, "export-figma-guidelines.rb")
REAL_VAULT_ROOT = File.expand_path("..", SCRIPT_DIR)

# Load the exporter in-process so the strict JSON parser can be unit-tested
# directly (its module body guards `main` behind `$PROGRAM_NAME == __FILE__`, so
# requiring it here does not run the CLI). This lets the duplicate-key
# regressions assert the parser behaviour itself, independent of any JSON
# backend, in addition to the end-to-end exporter subprocess checks.
require EXPORTER

$failures = []
$passed = 0

def assert(condition, message)
  if condition
    $passed += 1
  else
    $failures << message
    warn "FAIL: #{message}"
  end
end

def run_exporter(args)
  out, err, status = Open3.capture3("ruby", EXPORTER, *args)
  [status.exitstatus, out, err]
end

# Assert the exporter script is itself loadable as a standalone Ruby file
# (catches missing requires like `date`), without running the CLI body.
def test_script_standalone_loadable
  # Open3.capture3 returns [stdout, stderr, Process::Status]; the status is the
  # THIRD value. Binding it to the first name and calling .exitstatus on a
  # String was the defect that made this test raise instead of asserting.
  _out, err, status = Open3.capture3("ruby", "-c", EXPORTER)
  assert(status.exitstatus.zero?, "exporter must pass `ruby -c` syntax check: #{err}")
  _out2, err2, status2 = Open3.capture3("ruby", "-e", "require #{EXPORTER.inspect}")
  assert(status2.exitstatus.zero?, "exporter must be requirable standalone (missing require?): #{err2}")
end

# ---- Synthetic fixture builder ---------------------------------------------

SYNTH_BANNER = "SYNTHETIC TEST FIXTURE - NOT AN APPROVED UI FOUNDATIONS EXPORT"

def frontmatter(fields)
  lines = ["---"]
  fields.each do |k, v|
    if v.is_a?(Array)
      lines << "#{k}:"
      v.each { |item| lines << "  - #{item}" }
    else
      lines << "#{k}: #{v}"
    end
  end
  lines << "---"
  lines.join("\n") + "\n"
end

# A line ending in two spaces is a Markdown hard line break. It is built via
# interpolation (not literal trailing whitespace) so editors and linters cannot
# silently strip the significant trailing spaces from the fixture.
HARD_BREAK_LINE = "first hard-break line#{"  "}"

# A rich, multi-construct body to prove verbatim preservation: continuation
# lines, paragraphs, nested lists, a fenced code block, a table, an h3, and a
# two-space Markdown hard break whose trailing spaces must survive byte-for-byte.
RICH_BODY = <<~BODY.freeze
  # Heading One

  A leading paragraph that spans
  more than one physical line and must survive verbatim.

  #{HARD_BREAK_LINE}
  next line after a hard break.

  ## Rules

  - First rule with a trailing clause
    that continues on the next line.
  - Second rule
    - nested detail A
    - nested detail B

  ### Subsection

  Some code:

  ```ruby
  def example
    :ok
  end
  ```

  A table:

  | Col A | Col B |
  |-------|-------|
  | x     | y     |

  ## Non-Normative Rules

  Despite the word "rules" in this heading, this is an informative source by
  governed type and must not become normative.
BODY

def build_eligible_vault(root)
  FileUtils.mkdir_p(File.join(root, "registry"))
  FileUtils.mkdir_p(File.join(root, "schemas"))
  FileUtils.mkdir_p(File.join(root, "governance"))
  FileUtils.mkdir_p(File.join(root, "exports/synthetic-pack"))
  FileUtils.mkdir_p(File.join(root, "sources"))

  FileUtils.cp(
    File.join(REAL_VAULT_ROOT, "schemas/figma-export-manifest.schema.json"),
    File.join(root, "schemas/figma-export-manifest.schema.json")
  )
  # Copy the REAL committed naming-contract schema into the fixture rather than
  # inventing an alternative, so a projected synthetic contract is validated
  # against the same schema the real artifact declares.
  FileUtils.cp(
    File.join(REAL_VAULT_ROOT, "schemas/naming-contract.schema.yml"),
    File.join(root, "schemas/naming-contract.schema.yml")
  )

  # A referenced changelog file the pack manifest and naming-contract point at.
  File.write(File.join(root, "exports/synthetic-pack/CHANGELOG.md"),
             "# Synthetic Pack Changelog\n\n#{SYNTH_BANNER}\n")

  # Required governance documents, stable.
  %w[precedence lifecycle].each do |name|
    File.write(File.join(root, "governance/#{name}.md"),
               frontmatter("id" => "governance.#{name}", "title" => name.capitalize,
                           "type" => "governance", "status" => "stable",
                           "owners" => ["ui-foundations"], "created" => "2026-01-01",
                           "updated" => "2026-01-02", "authority" => "source") +
               "# #{name.capitalize}\n\n#{SYNTH_BANNER}\n")
  end

  File.write(File.join(root, "registry/repos.yml"), <<~YAML)
    ---
    id: registry.repos
    repo_types:
      - vault
      - runtime
      - docs
    repositories:
      - name: synthetic-docs
        type: docs
  YAML

  File.write(File.join(root, "registry/governance-packs.yml"), <<~YAML)
    ---
    id: registry.governance-packs
    type: registry
    packs:
      - id: governance-pack
        title: Synthetic Pack
        current_version: 1.0.0
        channel: stable
        manifest: exports/synthetic-pack/pack.yml
        changelog: exports/synthetic-pack/CHANGELOG.md
        owner: ui-foundations
        compatible_repo_types:
          - docs
          - runtime
  YAML

  # Normative sources (governed type -> normative). One informative source
  # (workflow) whose heading says "rules" to prove it stays informative.
  write_source = lambda do |filename, id, type, body|
    fm = frontmatter(
      "id" => id, "title" => id, "type" => type, "status" => "accepted",
      "owners" => ["ui-foundations"], "created" => "2026-01-01",
      "updated" => "2026-01-02", "authority" => "source"
    )
    File.write(File.join(root, "sources", filename), fm + body)
  end

  # Source documents must use canonical vault-metadata document TYPES, not pack
  # artifact types. These are governed governance/specification/principle
  # sources (all normative by type + source authority); the artifact types
  # (naming-rule, token-governance, ...) live on the pack artifacts below, not
  # on the governed source documents. IDs and names are unchanged.
  write_source.call("naming.md", "synthetic.source.naming", "specification", RICH_BODY)
  write_source.call("tokens.md", "synthetic.source.tokens", "governance",
                    "# Tokens\n\n## Rules\n\n- Synthetic token rule.\n")

  # An accepted governed registry YAML source (whole YAML document, no closing
  # frontmatter delimiter), referenced by the naming-contract below. It uses the
  # governed registry convention: top-level metadata (id/title/type/status/
  # owners/created/updated/authority) and body content, preserved verbatim as an
  # informative fenced-YAML block.
  File.write(File.join(root, "registry/synthetic-naming-registry.yml"), <<~YAML)
    ---
    id: synthetic.registry.naming
    title: Synthetic Naming Registry
    type: registry
    status: accepted
    owners:
      - ui-foundations
    created: 2026-01-01
    updated: 2026-01-02
    authority: source
    summary: #{SYNTH_BANNER}
    entries:
      - name: synthetic-registry-entry
        value: synthetic
  YAML
  write_source.call("components.md", "synthetic.source.components", "governance",
                    "# Components\n\n## Rules\n\n- Synthetic component rule.\n")
  write_source.call("a11y.md", "synthetic.source.accessibility", "principle",
                    "# Accessibility\n\n## Rules\n\n- Synthetic a11y rule.\n")

  %w[naming-rules token-governance component-governance accessibility-baseline].each do |name|
    File.write(File.join(root, "exports/synthetic-pack/#{name}.md"),
               frontmatter("id" => "synthetic.artifact.#{name}", "title" => name,
                           "type" => "governance", "status" => "accepted",
                           "owners" => ["ui-foundations"], "created" => "2026-01-01",
                           "updated" => "2026-01-02", "authority" => "derived") +
               "# #{name}\n\n#{SYNTH_BANNER}\n")
  end

  File.write(File.join(root, "exports/synthetic-pack/pack.yml"), <<~YAML)
    ---
    id: export-pack.synthetic.manifest
    type: export-pack
    status: accepted
    pack:
      id: governance-pack
      title: Synthetic Pack
      version: 1.0.0
      channel: stable
      owner: ui-foundations
      registry: registry/governance-packs.yml
      changelog: exports/synthetic-pack/CHANGELOG.md
    artifacts:
      - id: synthetic.naming-rules
        title: Naming Rules
        type: naming-rule
        path: exports/synthetic-pack/naming-rules.md
        status: accepted
        review_required: true
        source_references:
          - synthetic.source.naming
      - id: synthetic.token-governance
        title: Token Governance
        type: token-governance
        path: exports/synthetic-pack/token-governance.md
        status: accepted
        review_required: true
        source_references:
          - synthetic.source.tokens
      - id: synthetic.component-governance
        title: Component Governance
        type: component-governance
        path: exports/synthetic-pack/component-governance.md
        status: accepted
        review_required: true
        source_references:
          - synthetic.source.components
      - id: synthetic.accessibility-baseline
        title: Accessibility Baseline
        type: accessibility-baseline
        path: exports/synthetic-pack/accessibility-baseline.md
        status: accepted
        review_required: true
        source_references:
          - synthetic.source.accessibility
  YAML
end

# Add an explicitly synthetic ACCEPTED naming-contract artifact to an eligible
# vault, shaped after schemas/naming-contract.schema.yml. The rule/example
# sentinels let a test prove the projection reproduces the contract's own
# normative rules and non-normative examples. The artifact is registered in the
# pack manifest with type naming-contract and an eligible source reference.
def add_naming_contract_artifact(vault, rule_sentinel, example_sentinel)
  contract = {
    # Declared schema rebases from the contract's directory to the committed
    # schema copied into the fixture; the adapter validates against it and
    # rejects an alternate unverified path.
    "$schema" => "../../../schemas/naming-contract.schema.yml",
    # contract_id must agree with the manifest artifact id below.
    "contract_id" => "synthetic.naming-contract",
    "title" => "Synthetic Naming Contract",
    "type" => "naming-contract",
    "status" => "accepted",
    "authority" => "derived",
    "owner" => "ui-foundations",
    "schema_version" => "1.0.0",
    "contract_version" => "1.0.0",
    # governance_pack_version/channel must agree with the resolved synthetic
    # pack/manifest (version 1.0.0, channel stable).
    "governance_pack_version" => "1.0.0",
    "channel" => "stable",
    "release_date" => "2026-01-01",
    "updated" => "2026-01-02",
    "normativity" => {
      "rules_are_normative" => true,
      "examples_are_normative" => false,
      "examples_label" => "non-normative example",
      "runtime_consumption" => "Synthetic fixture; not an approved contract."
    },
    "source_metadata" => {
      "pack_manifest" => "exports/synthetic-pack/pack.yml",
      "pack_changelog" => "exports/synthetic-pack/CHANGELOG.md",
      # Each entry binds to an actually-indexed eligible source and must be
      # declared in the artifact's source_references below. Includes an accepted
      # governed registry YAML source to exercise the registry convention.
      "canonical_sources" => [
        { "id" => "synthetic.source.naming", "path" => "sources/naming.md", "sections" => ["Rules"] },
        { "id" => "synthetic.registry.naming", "path" => "registry/synthetic-naming-registry.yml",
          "sections" => ["entries"] }
      ]
    },
    "rules" => {
      "css_class_prefix" => { "prefix" => "uif-", "note" => rule_sentinel },
      "css_custom_property_prefix" => { "prefix" => "--uif-" },
      "nunjucks_macro_namespace" => {
        "alias" => "uif", "invocation_pattern" => "uif.*", "scope" => "public",
        "required" => true, "consumer_selected_alias" => true, "does_not_govern" => ["module path"]
      },
      "custom_element_tag_prefix" => {
        "prefix" => "uif-", "tag_pattern" => "uif-[component]", "scope" => "public",
        "required" => true, "governs" => ["tag names"], "does_not_govern" => ["class names"]
      },
      "proof_token_prefix" => { "prefix" => "--uif-proof-" },
      "assumption_token_prefix" => { "prefix" => "--uif-assumption-" },
      "pattern_id_prefixes" => {
        "base_pattern" => "pattern.base.", "composition_pattern" => "pattern.composition.",
        "product_pattern" => "pattern.product."
      },
      "compatibility_and_deprecation_policy" => {
        "versioning_scheme" => "semantic", "major" => "breaking", "minor" => "additive",
        "patch" => "editorial", "deprecated_names" => "traceable", "runtime_adoption" => "reviewed only"
      }
    },
    "non_normative_examples" => [
      { "label" => "non-normative example", "kind" => "public_component_class", "value" => example_sentinel }
    ]
  }

  FileUtils.mkdir_p(File.join(vault, "exports/synthetic-pack/contracts"))
  File.write(File.join(vault, "exports/synthetic-pack/contracts/naming-contract.json"),
             "#{JSON.pretty_generate(contract)}\n")

  pack = File.join(vault, "exports/synthetic-pack/pack.yml")
  # Modify the manifest as a parsed YAML mapping and re-dump it, rather than
  # appending indentation-sensitive text. Prior turns had two fixture
  # indentation failures from string appends; a structured modify + YAML.dump
  # avoids ambiguous indentation entirely while continuing the same artifact
  # list. The appended artifact declares its committed schema and lists both the
  # Markdown and the governed registry YAML source references that the
  # contract's canonical_sources bind to.
  manifest = YAML.safe_load(File.read(pack), permitted_classes: [Date], aliases: false)
  manifest["artifacts"] << {
    "id" => "synthetic.naming-contract",
    "title" => "Synthetic Naming Contract",
    "type" => "naming-contract",
    "path" => "exports/synthetic-pack/contracts/naming-contract.json",
    "status" => "accepted",
    "review_required" => true,
    "schema" => "schemas/naming-contract.schema.yml",
    "source_references" => [
      "synthetic.source.naming",
      "synthetic.registry.naming"
    ]
  }
  File.write(pack, YAML.dump(manifest))
end

def with_eligible_vault
  Dir.mktmpdir("figma-export-vault-") do |vault|
    build_eligible_vault(vault)
    Dir.mktmpdir("figma-export-outparent-") do |outparent|
      out = File.join(outparent, "figma-guidelines")
      yield vault, out
    end
  end
end

CONTRACT_REL = "exports/synthetic-pack/contracts/naming-contract.json"

def contract_path(vault)
  File.join(vault, CONTRACT_REL)
end

# Read, mutate, and rewrite the synthetic naming-contract JSON through a block,
# so negative tests mutate ONLY the contract (never the baseline fixture YAML).
# Returns the mutated parsed Hash so a test can assert the mutation took effect.
def mutate_contract(vault)
  path = contract_path(vault)
  data = JSON.parse(File.read(path))
  yield data
  File.write(path, "#{JSON.pretty_generate(data)}\n")
  data
end

def read_manifest(out)
  JSON.parse(File.read(File.join(out, "manifest.json")))
end

# ---- Positive + determinism -------------------------------------------------

def test_positive_synthetic_export
  with_eligible_vault do |vault, out|
    code, _stdout, stderr = run_exporter(["--out", out, "--vault-root", vault])
    assert(code.zero?, "positive synthetic export should succeed (exit #{code}): #{stderr}")

    files = Dir.children(out).sort
    expected = (%w[overview foundations tokens components composition accessibility anti-patterns].map { |c| "#{c}.md" } + ["manifest.json"]).sort
    assert(files == expected, "exact output file set mismatch: #{files.inspect} vs #{expected.inspect}")

    manifest = read_manifest(out)
    assert(manifest["size_unit"] == "utf-8-bytes", "size unit must be utf-8-bytes")
    assert(manifest["manifest_uploaded_to_figma"] == false, "manifest must declare it is not uploaded to Figma")
    assert(manifest["files"].length == 7, "manifest must list 7 files")
    assert(manifest.dig("generated_from", "pack_channel") == "stable", "manifest records stable channel")
    assert(manifest.dig("budgets", "hard_max_total_bytes") == 200_000, "manifest records immutable hard cap")
    assert(manifest["total_bytes"] <= 100_000, "default guideline total must be within conservative budget")

    checks = manifest["input_checksums"]
    %w[registry pack_manifest schema].each do |k|
      assert(checks[k].to_s.match?(/\A[0-9a-f]{64}\z/), "input checksum #{k} present")
    end
    assert(checks["artifacts"].is_a?(Hash) && !checks["artifacts"].empty?, "per-artifact checksums present")

    manifest["files"].each do |f|
      assert(!f["source_blocks"].empty?, "file #{f["category"]} must carry source blocks")
      f["source_blocks"].each do |b|
        assert(%w[accepted stable].include?(b["status"]), "source status must be eligible")
        assert(b["sha256"].match?(/\A[0-9a-f]{64}\z/), "source sha256 must be present")
        assert(!b["type"].to_s.empty?, "source block records governed type")
        assert([true, false].include?(b["normative"]), "source block records normativity")
      end
      body = File.binread(File.join(out, f["path"])).force_encoding("UTF-8")
      assert(body.bytesize == f["bytes"], "manifest bytes must match file for #{f["path"]}")
      assert(Digest::SHA256.hexdigest(body) == f["sha256"], "manifest sha256 must match file for #{f["path"]}")
    end
  end
end

def test_multiline_body_preserved_verbatim
  with_eligible_vault do |vault, out|
    code, = run_exporter(["--out", out, "--vault-root", vault])
    assert(code.zero?, "export should succeed for multiline preservation test")
    overview = File.read(File.join(out, "overview.md"))

    # The exporter now reproduces the source body EXACTLY (no rstrip, no heading
    # demotion). The whole body the exporter read from the source must appear as
    # an intact substring of the emitted file. We reconstruct that body the same
    # way the exporter's parse_document does: drop the frontmatter and a single
    # leading newline, leaving the rest byte-for-byte.
    src_content = File.read(File.join(vault, "sources/naming.md"))
    closing = src_content.index("\n---", 4)
    body = src_content[(closing + "\n---".length)..] || ""
    body = body.sub(/\A\n/, "")
    assert(overview.include?(body),
           "the full exact source body must be preserved as an intact substring")

    # Spot checks for individual constructs, matched against the ACTUAL body
    # content rather than guessed indentation.
    assert(overview.include?("more than one physical line and must survive verbatim."),
           "paragraph continuation must be preserved")
    assert(overview.include?("  that continues on the next line."),
           "list continuation line must be preserved with its exact indentation")
    assert(overview.include?("  - nested detail A"), "nested list must be preserved")
    assert(overview.include?("def example") && overview.include?(":ok"), "fenced code must be preserved")
    assert(overview.include?("| Col A | Col B |"), "table must be preserved")

    # Hard-break trailing spaces must survive verbatim (item: do not rstrip).
    assert(body.include?(HARD_BREAK_LINE), "fixture body must contain a hard-break line (test invariant)")
    assert(overview.include?(HARD_BREAK_LINE),
           "two-space Markdown hard break must be preserved byte-for-byte")
  end
end

def test_informative_source_not_normative
  with_eligible_vault do |vault, out|
    # Change the naming source from naming-rule (normative) to workflow
    # (informative). Its heading still contains "Rules", but it must be marked
    # informative by governed type.
    src = File.join(vault, "sources/naming.md")
    File.write(src, File.read(src).sub("type: specification", "type: workflow"))
    code, _o, _err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code.zero?, "workflow source should still export (informative)")
    manifest = read_manifest(out)
    overview = manifest["files"].find { |f| f["category"] == "overview" }
    block = overview["source_blocks"].find { |b| b["source_id"] == "synthetic.source.naming" }
    assert(block && block["normative"] == false,
           "workflow source with a 'Rules' heading must be classified informative, not normative")
  end
end

def test_determinism_byte_identical_and_check_no_write
  with_eligible_vault do |vault, out|
    code1, = run_exporter(["--out", out, "--vault-root", vault])
    assert(code1.zero?, "first export should succeed")
    first = Dir.children(out).sort.map { |n| [n, Digest::SHA256.hexdigest(File.binread(File.join(out, n)))] }

    # Second export must refuse to overwrite the existing output directory.
    code2, _o2, err2 = run_exporter(["--out", out, "--vault-root", vault])
    assert(code2 == 1, "export must refuse to overwrite an existing output directory")
    assert(err2.include?("Refusing to overwrite existing output"), "refusal diagnostic must mention existing output")

    # Output is unchanged by the refused second run.
    second = Dir.children(out).sort.map { |n| [n, Digest::SHA256.hexdigest(File.binread(File.join(out, n)))] }
    assert(first == second, "refused re-export must not modify existing output")

    before = Dir.children(out).sort.map { |n| File.mtime(File.join(out, n)) }
    ccode, cout, = run_exporter(["--out", out, "--vault-root", vault, "--check"])
    assert(ccode.zero?, "--check should pass on clean output")
    assert(cout.include?("PASSED"), "--check should report PASSED")
    after = Dir.children(out).sort.map { |n| File.mtime(File.join(out, n)) }
    assert(before == after, "--check must not write (mtimes unchanged)")
  end
end

def test_check_detects_tampering
  with_eligible_vault do |vault, out|
    run_exporter(["--out", out, "--vault-root", vault])
    tampered = File.join(out, "overview.md")
    File.write(tampered, File.read(tampered) + "\ninjected tampering line\n")
    code, _out, err = run_exporter(["--out", out, "--vault-root", vault, "--check"])
    assert(code == 1, "tampered output must fail --check")
    assert(err.include?("Byte mismatch"), "tamper diagnostic must mention byte mismatch")
  end
end

def test_check_detects_extra_file_and_symlink_and_dir
  with_eligible_vault do |vault, out|
    run_exporter(["--out", out, "--vault-root", vault])

    File.write(File.join(out, "rogue.md"), "unexpected\n")
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault, "--check"])
    assert(code == 1, "extra file must fail --check")
    assert(err.include?("Unexpected output entries"), "diagnostic must mention unexpected entries")
    File.delete(File.join(out, "rogue.md"))

    Dir.mkdir(File.join(out, "unexpected-dir"))
    code2, _o2, err2 = run_exporter(["--out", out, "--vault-root", vault, "--check"])
    assert(code2 == 1, "unexpected directory must fail --check")
    assert(err2.include?("not a regular file") || err2.include?("Unexpected output entries"),
           "diagnostic must reject non-regular-file entry")
    Dir.rmdir(File.join(out, "unexpected-dir"))

    # Replace a legit file with a symlink to the same content; --check must
    # reject the symlink entry even though bytes would match.
    legit = File.join(out, "tokens.md")
    content = File.read(legit)
    target = File.join(out, ".tokens-real")
    File.write(target, content)
    File.delete(legit)
    File.symlink(target, legit)
    code3, _o3, err3 = run_exporter(["--out", out, "--vault-root", vault, "--check"])
    assert(code3 == 1, "symlink output entry must fail --check")
    assert(err3.include?("symlink"), "diagnostic must mention symlink entry")
  end
end

def test_source_content_change_invalidates_check
  with_eligible_vault do |vault, out|
    run_exporter(["--out", out, "--vault-root", vault])
    src = File.join(vault, "sources/naming.md")
    File.write(src, File.read(src) + "\n- Synthetic rule C added later\n")
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault, "--check"])
    assert(code == 1, "source change must be detected by --check")
    assert(err.include?("mismatch"), "source change diagnostic must mention mismatch")
  end
end

def test_pack_registry_schema_changes_invalidate_manifest
  # The manifest records registry/pack/schema/artifact checksums, so changing
  # any consumed input changes the manifest bytes and fails --check.
  %w[registry pack schema artifact].each do |which|
    with_eligible_vault do |vault, out|
      run_exporter(["--out", out, "--vault-root", vault])
      case which
      when "registry"
        p = File.join(vault, "registry/governance-packs.yml")
        File.write(p, File.read(p) + "\n# trailing comment to change bytes\n")
      when "pack"
        p = File.join(vault, "exports/synthetic-pack/pack.yml")
        File.write(p, File.read(p) + "\n# trailing comment\n")
      when "schema"
        p = File.join(vault, "schemas/figma-export-manifest.schema.json")
        s = JSON.parse(File.read(p))
        s["description"] = "#{s["description"]} (edited)"
        File.write(p, JSON.pretty_generate(s))
      when "artifact"
        p = File.join(vault, "exports/synthetic-pack/naming-rules.md")
        File.write(p, File.read(p) + "\nMore artifact body.\n")
      end
      code, _o, err = run_exporter(["--out", out, "--vault-root", vault, "--check"])
      assert(code == 1, "#{which} change must invalidate --check")
      assert(err.include?("mismatch"), "#{which} change must produce a manifest/byte mismatch")
    end
  end
end

# ---- Negative eligibility ---------------------------------------------------

def test_negative_source_not_eligible
  with_eligible_vault do |vault, out|
    src = File.join(vault, "sources/tokens.md")
    File.write(src, File.read(src).sub("status: accepted", "status: review"))
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code == 1, "ineligible source lifecycle must fail closed")
    assert(err.include?("lifecycle status"), "diagnostic must mention source lifecycle")
    assert(!File.exist?(out), "no partial output on fail-closed")
  end
end

def test_negative_unresolved_conflict
  with_eligible_vault do |vault, out|
    src = File.join(vault, "sources/components.md")
    File.write(src, File.read(src).sub("authority: source\n",
                                       "authority: source\nrelated:\n  conflicts_with:\n    - some.other.doc\n"))
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code == 1, "unresolved conflicts_with must fail closed")
    assert(err.include?("conflicts_with"), "diagnostic must cite the unresolved conflict")
  end
end

def test_negative_missing_governance_precedence
  with_eligible_vault do |vault, out|
    File.delete(File.join(vault, "governance/precedence.md"))
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code == 1, "missing precedence governance must fail closed")
    assert(err.include?("governance.precedence"), "diagnostic must cite missing precedence")
  end
end

# Required governance documents must be type: governance. A governance id that
# resolves to a non-governance type must fail closed.
def test_negative_governance_wrong_type
  with_eligible_vault do |vault, out|
    doc = File.join(vault, "governance/lifecycle.md")
    File.write(doc, File.read(doc).sub("type: governance", "type: workflow"))
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code == 1, "non-governance type for a required governance doc must fail closed")
    assert(err.include?("must be type governance"), "diagnostic must cite the required governance type")
  end
end

# Required governance documents must carry authority: source. supporting /
# example / derived authority must not be treated as authoritative.
def test_negative_governance_wrong_authority
  with_eligible_vault do |vault, out|
    doc = File.join(vault, "governance/precedence.md")
    File.write(doc, File.read(doc).sub("authority: source", "authority: supporting"))
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code == 1, "non-source authority for a required governance doc must fail closed")
    assert(err.include?("must be authority source"), "diagnostic must cite the required governance authority")
  end
end

# A governance-typed SOURCE with supporting/example/derived authority must stay
# informative: authority gates normativity above the type default.
def test_supporting_authority_source_stays_informative
  with_eligible_vault do |vault, out|
    # Make the naming source governance-typed but supporting-authority. By type
    # alone it would be normative; by authority it must be informative.
    src = File.join(vault, "sources/naming.md")
    content = File.read(src).sub("type: specification", "type: governance")
    content = content.sub("authority: source", "authority: supporting")
    File.write(src, content)
    code, _o, _err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code.zero?, "supporting-authority source should still export as informative")
    manifest = read_manifest(out)
    overview = manifest["files"].find { |f| f["category"] == "overview" }
    block = overview["source_blocks"].find { |b| b["source_id"] == "synthetic.source.naming" }
    assert(block && block["normative"] == false,
           "governance-typed but supporting-authority source must be classified informative")
  end
end

# The precedence/lifecycle authority inputs are hashed into input_checksums, so
# editing either must change the manifest bytes and fail --check even though no
# exported source body changed.
def test_governance_authority_change_invalidates_check
  %w[precedence lifecycle].each do |name|
    with_eligible_vault do |vault, out|
      run_exporter(["--out", out, "--vault-root", vault])
      doc = File.join(vault, "governance/#{name}.md")
      File.write(doc, File.read(doc) + "\nAn authority-input edit that must invalidate the manifest.\n")
      code, _o, err = run_exporter(["--out", out, "--vault-root", vault, "--check"])
      assert(code == 1, "#{name} authority-input change must invalidate --check")
      assert(err.include?("mismatch"), "#{name} change must produce a manifest/byte mismatch")
    end
  end
end

# Editing registry/repos.yml must also invalidate --check (it is now hashed).
def test_repos_change_invalidates_check
  with_eligible_vault do |vault, out|
    run_exporter(["--out", out, "--vault-root", vault])
    p = File.join(vault, "registry/repos.yml")
    File.write(p, File.read(p) + "\n# trailing comment to change bytes\n")
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault, "--check"])
    assert(code == 1, "repos registry change must invalidate --check")
    assert(err.include?("mismatch"), "repos change must produce a manifest/byte mismatch")
  end
end

# Malformed, non-hash frontmatter metadata must produce a controlled
# ExportError (exit 1), never an unhandled exception/stack trace.
def test_negative_nonhash_frontmatter_controlled
  with_eligible_vault do |vault, out|
    src = File.join(vault, "sources/tokens.md")
    # Replace the whole document with frontmatter that parses to a YAML list,
    # not a mapping. parse_document must reject it, not crash.
    File.write(src, "---\n- just\n- a\n- list\n---\n# body\n")
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code == 1, "non-hash frontmatter must fail closed with a controlled error")
    assert(err.include?("not an object") || err.include?("FAILED"),
           "diagnostic must be a controlled export failure, not a stack trace")
    assert(!err.include?("stack") && !err.match?(/\.rb:\d+:in /),
           "controlled failure must not leak a Ruby backtrace")
  end
end

def test_negative_broken_reference
  with_eligible_vault do |vault, out|
    pack = File.join(vault, "exports/synthetic-pack/pack.yml")
    File.write(pack, File.read(pack).sub("synthetic.source.naming", "synthetic.source.missing"))
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code == 1, "broken source reference must fail closed")
    assert(err.include?("broken reference") || err.include?("does not resolve"), "diagnostic must mention broken reference")
  end
end

# REGRESSION (independent acceptance failure 1): a referenced eligible source
# with an unknown `authority` value (e.g. rogue) must fail closed with a
# controlled diagnostic, not export at exit 0. The authority enum is defined by
# specifications/vault-metadata.md.
def test_negative_source_unknown_authority
  with_eligible_vault do |vault, out|
    src = File.join(vault, "sources/tokens.md")
    File.write(src, File.read(src).sub("authority: source", "authority: rogue"))
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code == 1, "unknown source authority must fail closed (not exit 0)")
    assert(err.include?("unknown authority"), "diagnostic must cite the unknown authority")
    assert(!err.match?(/\.rb:\d+:in /), "controlled failure must not leak a backtrace")
    assert(!File.exist?(out), "no partial output on fail-closed")
  end
end

# REGRESSION (independent acceptance failure 1): a referenced eligible source
# with a document `type` outside the canonical vault-metadata taxonomy must fail
# closed; we never invent a new canonical type to make the reference resolve.
def test_negative_source_unknown_document_type
  with_eligible_vault do |vault, out|
    src = File.join(vault, "sources/tokens.md")
    # token-governance is a pack ARTIFACT type, not a governed document type.
    File.write(src, File.read(src).sub("type: governance", "type: token-governance"))
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code == 1, "unknown source document type must fail closed")
    assert(err.include?("unknown document type"), "diagnostic must cite the unknown document type")
    assert(!err.match?(/\.rb:\d+:in /), "controlled failure must not leak a backtrace")
  end
end

# REGRESSION (independent acceptance failure 2): a malformed artifacts list with
# a null/scalar element (artifacts: [null]) previously raised an unhandled
# NoMethodError (undefined method `[]' for nil) with a stack trace. It must now
# produce a controlled ExportError at exit 1 with a specific diagnostic and no
# backtrace, and write no output.
def test_negative_artifact_list_null_element_controlled
  with_eligible_vault do |vault, out|
    man = File.join(vault, "exports/synthetic-pack/pack.yml")
    original = File.read(man)
    # Replace the whole artifacts block with a single null list element.
    content = original.sub(/\nartifacts:\n.*\z/m, "\nartifacts:\n  - null\n")
    assert(content != original, "test setup must replace the artifacts list with a null element")
    assert(content.include?("- null"), "mutated fixture must declare a null artifact element")
    File.write(man, content)
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code == 1, "null artifact element must fail closed at exit 1")
    assert(err.include?("not a mapping"), "diagnostic must cite the non-mapping artifact element")
    assert(!err.include?("NoMethodError") && !err.match?(/\.rb:\d+:in /),
           "must not leak a NoMethodError / Ruby backtrace")
    assert(!File.exist?(out), "no partial output on fail-closed")
  end
end

# REGRESSION (independent acceptance failure 3): the body of a selected approved
# Markdown artifact must be consumed faithfully into the exported category file,
# not omitted while only its checksum is recorded. Append a unique sentinel rule
# to the accepted token-governance.md artifact and assert it appears verbatim in
# the exported tokens.md.
def test_artifact_body_consumed_into_export
  with_eligible_vault do |vault, out|
    sentinel = "INDEPENDENT-ARTIFACT-RULE-814690"
    artifact = File.join(vault, "exports/synthetic-pack/token-governance.md")
    File.write(artifact, File.read(artifact) + "\n## Rules\n\n- #{sentinel}\n")
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code.zero?, "export should succeed with the appended artifact rule (exit #{code}): #{err}")

    tokens = File.read(File.join(out, "tokens.md"))
    assert(tokens.include?(sentinel),
           "the approved artifact body (including the appended rule) must appear in tokens.md")

    # The artifact must be attributed as a DERIVED/INFORMATIVE block, never as
    # authoritative original governance.
    manifest = read_manifest(out)
    tokens_file = manifest["files"].find { |f| f["category"] == "tokens" }
    art = tokens_file["source_blocks"].find { |b| b["source_id"] == "synthetic.token-governance" }
    assert(art, "manifest tokens file must record the derived artifact block")
    assert(art["authority"] == "derived" && art["normative"] == false,
           "consumed artifact must be derived + informative, not authoritative original governance")
  end
end

# REGRESSION (self-imposed JSON limitation): an accepted naming-contract artifact
# must be deterministically projected into guideline Markdown, preserving the
# normative rules and non-normative examples, rather than blanket-rejected. A
# unique rule and example sentinel must appear in the output.
def test_naming_contract_projected_into_export
  with_eligible_vault do |vault, out|
    rule_sentinel = "uif-contract-sentinel-rule-551903"
    example_sentinel = "uif-contract-sentinel-example-551903"
    add_naming_contract_artifact(vault, rule_sentinel, example_sentinel)

    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code.zero?, "export should succeed with a projected naming-contract (exit #{code}): #{err}")

    overview = File.read(File.join(out, "overview.md"))
    assert(overview.include?("Normative constraints"),
           "projection must carry an explicit normative constraints heading")
    assert(overview.include?("Non-normative examples"),
           "projection must carry an explicit non-normative examples heading")
    assert(overview.include?(rule_sentinel),
           "the contract's normative rule sentinel must appear in the projection")
    assert(overview.include?(example_sentinel),
           "the contract's non-normative example sentinel must appear in the projection")
    assert(overview.include?("```json"), "projection must emit fenced JSON blocks")

    # The accepted governed registry YAML source the contract declares must be
    # resolved and preserved verbatim as an informative fenced-YAML block.
    assert(overview.include?("synthetic.registry.naming"),
           "the declared registry YAML source must be attributed in the projection")
    assert(overview.include?("```yaml"),
           "a governed registry YAML source must be preserved as a fenced-YAML block")
    assert(overview.include?("synthetic-registry-entry"),
           "the raw registry YAML body must be preserved verbatim")

    manifest = read_manifest(out)
    assert(manifest["schema_version"] == "1.0.0", "manifest must declare the manifest format schema_version")
    assert(manifest.dig("input_checksums", "naming_contract_schema").to_s.match?(/\A[0-9a-f]{64}\z/),
           "manifest must record the consumed naming-contract schema checksum")
    ov = manifest["files"].find { |f| f["category"] == "overview" }
    contract = ov["source_blocks"].find { |b| b["source_id"] == "synthetic.naming-contract" }
    assert(contract, "manifest overview must record the naming-contract projection block")
    assert(contract["authority"] == "derived" && contract["normative"] == false,
           "naming-contract projection must be derived + informative, not authoritative")

    # The registry YAML source is recorded as an informative source block.
    reg = ov["source_blocks"].find { |b| b["source_id"] == "synthetic.registry.naming" }
    assert(reg, "manifest overview must record the registry YAML source block")
    assert(reg["type"] == "registry" && reg["normative"] == false,
           "registry YAML source must be an informative registry block")
  end
end

# POSITIVE baseline-integrity guard: before any negative JSON mutation runs, the
# correctly bound synthetic contract must export at exit 0. This proves the
# negative tests below fail because of the mutation, not because the baseline
# fixture is already broken.
def test_naming_contract_positive_baseline_exports
  with_eligible_vault do |vault, out|
    add_naming_contract_artifact(vault, "rule-x", "example-x")
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code.zero?, "correctly bound baseline contract must export (exit #{code}): #{err}")
    assert(File.exist?(File.join(out, "overview.md")), "baseline export must produce output")
  end
end

# REGRESSION (independent JSON acceptance failure 1): the contract declares
# status=draft while the artifact manifest status is accepted. The export must
# NOT exit 0 just because the outer manifest record claims accepted; the
# contract's own status must itself be eligible and agree with the manifest.
def test_negative_contract_status_draft
  with_eligible_vault do |vault, out|
    add_naming_contract_artifact(vault, "r", "e")
    mutated = mutate_contract(vault) { |c| c["status"] = "draft" }
    assert(mutated["status"] == "draft", "test setup must set contract status to draft")
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code == 1, "draft contract behind an accepted manifest record must fail closed")
    assert(err.include?("contract status") && (err.include?("not eligible") || err.include?("does not match")),
           "diagnostic must cite the contract status eligibility/agreement")
    assert(!err.match?(/\.rb:\d+:in /), "controlled failure must not leak a backtrace")
    assert(!File.exist?(out), "no partial output on fail-closed")
  end
end

# REGRESSION (independent JSON acceptance failure 2): governance_pack_version
# disagrees with the resolved eligible pack/manifest (1.0.0).
def test_negative_contract_governance_pack_version_mismatch
  with_eligible_vault do |vault, out|
    add_naming_contract_artifact(vault, "r", "e")
    mutated = mutate_contract(vault) { |c| c["governance_pack_version"] = "9.9.9" }
    assert(mutated["governance_pack_version"] == "9.9.9", "test setup must set a mismatched pack version")
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code == 1, "mismatched governance_pack_version must fail closed")
    assert(err.include?("governance_pack_version"), "diagnostic must cite the pack version mismatch")
    assert(!File.exist?(out), "no partial output on fail-closed")
  end
end

# REGRESSION (independent JSON acceptance failure 3): channel disagrees with the
# resolved eligible pack/manifest channel (stable).
def test_negative_contract_channel_mismatch
  with_eligible_vault do |vault, out|
    add_naming_contract_artifact(vault, "r", "e")
    mutated = mutate_contract(vault) { |c| c["channel"] = "review" }
    assert(mutated["channel"] == "review", "test setup must set a mismatched channel")
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code == 1, "mismatched contract channel must fail closed")
    assert(err.include?("channel"), "diagnostic must cite the channel mismatch")
    assert(!File.exist?(out), "no partial output on fail-closed")
  end
end

# REGRESSION (independent JSON acceptance failure 4): a canonical_sources entry
# names a path that does not bind to the indexed eligible source record, while
# the artifact source_references still name the real synthetic source.
def test_negative_contract_canonical_source_path_mismatch
  with_eligible_vault do |vault, out|
    add_naming_contract_artifact(vault, "r", "e")
    mutated = mutate_contract(vault) do |c|
      c["source_metadata"]["canonical_sources"][0]["path"] = "sources/missing.md"
    end
    assert(mutated["source_metadata"]["canonical_sources"][0]["path"] == "sources/missing.md",
           "test setup must point the canonical source at an alternate path")
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code == 1, "canonical source path not bound to the indexed record must fail closed")
    assert(err.include?("canonical_sources"), "diagnostic must cite the canonical source binding")
    assert(!File.exist?(out), "no partial output on fail-closed")
  end
end

# The naming JSON is validated against the committed naming-contract schema
# using the stdlib evaluator, not a shallow top-level-keys scan. Breaking a
# NESTED required field must fail closed with a schema diagnostic.
def test_negative_contract_schema_nested_required
  with_eligible_vault do |vault, out|
    add_naming_contract_artifact(vault, "r", "e")
    mutated = mutate_contract(vault) { |c| c["rules"]["css_class_prefix"].delete("prefix") }
    assert(!mutated["rules"]["css_class_prefix"].key?("prefix"),
           "test setup must remove a nested required rule field")
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code == 1, "missing nested required contract field must fail closed")
    assert(err.include?("committed schema") || err.include?("missing required property"),
           "diagnostic must cite the committed schema / missing required property")
  end
end

# A contract field whose value violates the schema enum (status outside the
# lifecycle enum) must fail the deep schema validation.
def test_negative_contract_schema_enum_violation
  with_eligible_vault do |vault, out|
    add_naming_contract_artifact(vault, "r", "e")
    mutate_contract(vault) { |c| c["status"] = "bogus-status" }
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code == 1, "status outside the schema enum must fail closed")
    assert(err.include?("not in enum") || err.include?("committed schema"),
           "diagnostic must cite the schema enum violation")
  end
end

# A contract whose declared $schema points at an alternate path must be rejected
# rather than silently trusted.
def test_negative_contract_alternate_schema_path
  with_eligible_vault do |vault, out|
    add_naming_contract_artifact(vault, "r", "e")
    mutate_contract(vault) { |c| c["$schema"] = "../../../schemas/figma-export-manifest.schema.json" }
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code == 1, "alternate declared $schema path must fail closed")
    assert(err.include?("alternate unverified schema path") || err.include?("committed"),
           "diagnostic must cite the alternate schema path refusal")
  end
end

# Duplicate JSON keys must be rejected during parsing so draft/accepted or
# source metadata cannot be overwritten. We inject a textual duplicate key into
# the contract JSON; the self-contained strict parser must raise the explicit
# Duplicate JSON key diagnostic (this is the CI-reproducing case).
def test_negative_contract_duplicate_json_key
  with_eligible_vault do |vault, out|
    add_naming_contract_artifact(vault, "r", "e")
    path = contract_path(vault)
    raw = File.read(path)
    # Add a second "status" member right after the first, declaring draft after
    # accepted. A lenient parser would keep the last; strict parsing must reject.
    dup = raw.sub(/("status":\s*"accepted",)/, "\\1\n  \"status\": \"draft\",")
    assert(dup != raw, "test setup must inject a duplicate status key")
    assert(dup.scan(/"status":/).length >= 2, "mutated JSON must contain two status members")
    File.write(path, dup)
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code == 1, "duplicate JSON key must fail closed")
    assert(err.include?("Duplicate JSON key"), "diagnostic must cite the duplicate JSON key")
    assert(!File.exist?(out), "no partial output on fail-closed")
  end
end

# The reverse order (draft declared BEFORE accepted) must also be rejected with
# the same explicit diagnostic. A parser that merely kept the last value would
# accept this one as `accepted` and silently export a draft-influenced contract.
def test_negative_contract_duplicate_json_key_reverse_order
  with_eligible_vault do |vault, out|
    add_naming_contract_artifact(vault, "r", "e")
    path = contract_path(vault)
    raw = File.read(path)
    # Insert "draft" BEFORE the real "accepted" status member.
    dup = raw.sub(/("status":\s*"accepted",)/, "\"status\": \"draft\",\n  \\1")
    assert(dup != raw, "test setup must inject a leading duplicate status key")
    assert(dup.scan(/"status":/).length >= 2, "mutated JSON must contain two status members")
    File.write(path, dup)
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code == 1, "duplicate JSON key (draft-then-accepted) must fail closed")
    assert(err.include?("Duplicate JSON key"),
           "reverse-order duplicate must still cite the duplicate JSON key, not a generic status failure")
    assert(!File.exist?(out), "no partial output on fail-closed")
  end
end

# A duplicate key NESTED inside an object (here inside the rules mapping) must be
# rejected too; detection is not limited to top-level keys.
def test_negative_contract_duplicate_nested_json_key
  with_eligible_vault do |vault, out|
    add_naming_contract_artifact(vault, "r", "e")
    path = contract_path(vault)
    raw = File.read(path)
    # css_class_prefix is an object with a "prefix" member; add a second one.
    dup = raw.sub(/("prefix":\s*"uif-",)/, "\\1\n        \"prefix\": \"evil-\",")
    assert(dup != raw, "test setup must inject a duplicate nested prefix key")
    File.write(path, dup)
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code == 1, "duplicate nested JSON key must fail closed")
    assert(err.include?("Duplicate JSON key"), "nested duplicate must cite the duplicate JSON key")
    assert(!File.exist?(out), "no partial output on fail-closed")
  end
end

# A Unicode-escaped key must collide with its plain-text equivalent after JSON
# decoding. "\u0073tatus" decodes to "status"; pairing it with a plain "status"
# is a duplicate and must be rejected rather than treated as two distinct keys.
def test_negative_contract_unicode_escaped_duplicate_key
  with_eligible_vault do |vault, out|
    add_naming_contract_artifact(vault, "r", "e")
    path = contract_path(vault)
    raw = File.read(path)
    # Inject a Unicode-escaped "status" (\u0073 == 's') carrying draft, next to
    # the real plain-text accepted status.
    dup = raw.sub(/("status":\s*"accepted",)/,
                  "\\1\n  \"\\u0073tatus\": \"draft\",")
    assert(dup != raw, "test setup must inject a unicode-escaped duplicate status key")
    assert(dup.include?("\\u0073tatus"), "mutated JSON must contain the escaped key form")
    File.write(path, dup)
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code == 1, "unicode-escaped duplicate key must fail closed")
    assert(err.include?("Duplicate JSON key"),
           "unicode-escaped duplicate must collide after decoding and cite the duplicate JSON key")
    assert(!File.exist?(out), "no partial output on fail-closed")
  end
end

# Direct unit tests of the self-contained strict JSON parser, independent of any
# JSON backend. These lock in the portable behaviour the hosted CI needs and
# make a backend-specific regression impossible to hide behind the subprocess.
def test_strict_json_parser_unit_behaviour
  parser = FigmaGuidelinesExport::StrictJSONParser

  # Positive nested baseline: object/array/string/number/bool/null round-trip
  # into ORDINARY Hash/Array with stable, textual insertion order.
  raw = <<~JSON
    {
      "b": 1,
      "a": "x",
      "nested": { "k2": [1, 2, {"deep": true}], "k1": null },
      "list": ["s", 2.5, false]
    }
  JSON
  value = parser.parse(raw)
  assert(value.is_a?(Hash) && !value.is_a?(FigmaGuidelinesExport::StrictJSONParser),
         "parser must return an ordinary Hash")
  assert(value.keys == %w[b a nested list], "top-level keys must preserve textual insertion order")
  assert(value["nested"].is_a?(Hash), "nested object must be an ordinary Hash")
  assert(value["nested"].keys == %w[k2 k1], "nested keys must preserve textual insertion order")
  assert(value["nested"]["k2"].is_a?(Array), "nested array must be an ordinary Array")
  assert(value["nested"]["k2"][2]["deep"] == true, "deeply nested boolean must decode")
  assert(value["nested"]["k1"].nil?, "null must decode to nil")
  assert(value["list"] == ["s", 2.5, false], "array of mixed scalars must decode with order and types")
  assert(value["b"] == 1 && value["b"].is_a?(Integer), "integer must decode as Integer")

  # The parser output must match the shape stdlib JSON.parse produces for the
  # same valid input (so downstream code is unaffected for valid contracts).
  assert(value == JSON.parse(raw), "strict parse of valid JSON must equal stdlib JSON.parse result")

  # Duplicate top-level key, both orders, raises the controlled duplicate error.
  [
    '{"status":"accepted","status":"draft"}',
    '{"status":"draft","status":"accepted"}'
  ].each do |dup_raw|
    raised =
      begin
        parser.parse(dup_raw)
        false
      rescue FigmaGuidelinesExport::DuplicateJSONKeyError => e
        assert(e.message.include?("Duplicate JSON key"), "duplicate error must carry the explicit text")
        true
      end
    assert(raised, "duplicate top-level key must raise DuplicateJSONKeyError for #{dup_raw.inspect}")
  end

  # Duplicate nested key is detected.
  nested_dup = '{"outer":{"k":1,"k":2}}'
  nested_raised =
    begin
      parser.parse(nested_dup)
      false
    rescue FigmaGuidelinesExport::DuplicateJSONKeyError
      true
    end
  assert(nested_raised, "duplicate nested key must raise DuplicateJSONKeyError")

  # Unicode-escaped key collides with its decoded plain-text equivalent.
  unicode_dup = '{"status":"accepted","\u0073tatus":"draft"}'
  unicode_raised =
    begin
      parser.parse(unicode_dup)
      false
    rescue FigmaGuidelinesExport::DuplicateJSONKeyError
      true
    end
  assert(unicode_raised, "unicode-escaped key must collide with its decoded equivalent")

  # A non-duplicate escaped key decodes correctly and is preserved.
  decoded = parser.parse('{"\u0073tatus":"accepted"}')
  assert(decoded == { "status" => "accepted" }, "escaped key must decode to its plain-text form")

  # Surrogate pair decoding (astral character) so escaped keys cannot smuggle a
  # distinct byte sequence for a logically equal key.
  emoji = parser.parse('{"k":"\uD83D\uDE00"}')
  assert(emoji["k"].bytesize == 4, "surrogate pair must decode to a single 4-byte UTF-8 character")

  # Malformed JSON raises a ParseError (mapped to a controlled ExportError by
  # parse_json_strict), not a silent acceptance.
  bad_raised =
    begin
      parser.parse('{"a":}')
      false
    rescue FigmaGuidelinesExport::StrictJSONParser::ParseError
      true
    end
  assert(bad_raised, "malformed JSON must raise a ParseError")
end

# Direct unit tests of parse_json_strict, which now delegates JSON grammar and
# value validation to the Ruby standard library parser (create_additions:false,
# allow_nan:false, max_nesting:100), round-trips through JSON.generate with
# allow_nan:false as a finite/generatable guard, then runs the internal scanner
# ONLY for duplicate-key detection and RETURNS the stdlib result. These probes
# lock in the two concrete false acceptances that were found in the handwritten
# scanner, plus clean rejection of over-deep nesting and preservation of the
# valid path.
def test_parse_json_strict_grammar_and_value_validation
  mod = FigmaGuidelinesExport
  err_class = FigmaGuidelinesExport::ExportError

  # Regression 1: a leading-zero number is invalid JSON grammar. The handwritten
  # scanner previously accepted '{"a":01}' as {"a" => 1}; the stdlib parser must
  # now reject it with a controlled ExportError.
  leading_zero_raised =
    begin
      mod.parse_json_strict('{"a":01}', "probe")
      false
    rescue err_class
      true
    end
  assert(leading_zero_raised, "a leading-zero number must be rejected as invalid JSON grammar")

  # Regression 2: a non-finite number ('{"a":1e999}' -> Infinity) cannot be
  # safely JSON-generated and must be rejected, not decoded to Infinity.
  non_finite_raised =
    begin
      mod.parse_json_strict('{"a":1e999}', "probe")
      false
    rescue err_class
      true
    end
  assert(non_finite_raised, "a non-finite number must be rejected (not decoded to Infinity)")

  # Over-100-depth JSON must be rejected cleanly up front (max_nesting) before
  # any recursive descent could overflow. Build 200 nested arrays.
  deep = ("[" * 200) + ("]" * 200)
  deep_raised =
    begin
      mod.parse_json_strict(deep, "probe")
      false
    rescue err_class => e
      assert(e.message.include?("Invalid JSON"), "deep-nesting rejection must be a controlled JSON error")
      true
    end
  assert(deep_raised, "over-100-depth JSON must be rejected cleanly (no recursion overflow)")

  # Positive nested structure: the stdlib result is returned, as an ordinary
  # Hash with keys in original order and identical to JSON.parse of the same
  # input. Numbers keep their standard stdlib interpretation.
  raw = '{"b":1,"a":"x","nested":{"k2":[1,2.5,{"deep":true}],"k1":null},"n":10}'
  value = mod.parse_json_strict(raw, "probe")
  assert(value == JSON.parse(raw), "valid JSON must return the standard parser result")
  assert(value.keys == %w[b a nested n], "object keys must be preserved in original order")
  assert(value["nested"]["k2"] == [1, 2.5, { "deep" => true }], "nested values must decode via stdlib")
  assert(value["n"] == 10 && value["n"].is_a?(Integer), "plain integers decode as Integer")

  # Duplicate keys are still rejected with the explicit diagnostic, via the
  # internal scanner, even though the stdlib parser would silently keep the last.
  dup_raised =
    begin
      mod.parse_json_strict('{"status":"accepted","status":"draft"}', "probe")
      false
    rescue err_class => e
      assert(e.message.include?("Duplicate JSON key"), "duplicate must cite the explicit diagnostic")
      true
    end
  assert(dup_raised, "duplicate key must still be rejected through parse_json_strict")
end

# Fault-injection regression: if the internal duplicate-key scanner cannot
# complete (it raises its ParseError) for an input the stdlib parser accepted,
# parse_json_strict MUST fail CLOSED with a controlled ExportError and MUST NOT
# return the stdlib result. A returned value would treat an incomplete duplicate
# scan as a successful validation, letting an unverified document through. We
# temporarily replace StrictJSONParser.parse to raise ParseError for otherwise
# valid JSON, then restore the original singleton method in an ensure so no
# other test is affected.
def test_parse_json_strict_fails_closed_on_scanner_uncertainty
  mod = FigmaGuidelinesExport
  err_class = FigmaGuidelinesExport::ExportError
  parser = FigmaGuidelinesExport::StrictJSONParser

  raw = '{"status":"accepted","title":"ok"}'

  # Sanity: this input is accepted and returned normally before injection.
  baseline = mod.parse_json_strict(raw, "probe")
  assert(baseline == JSON.parse(raw), "baseline valid JSON must parse before fault injection")

  original = parser.method(:parse)
  begin
    parser.define_singleton_method(:parse) do |_raw|
      raise FigmaGuidelinesExport::StrictJSONParser::ParseError,
            "injected scanner uncertainty"
    end

    raised =
      begin
        result = mod.parse_json_strict(raw, "injected-probe")
        $failures << "fail-closed violation: parse_json_strict returned #{result.inspect} " \
                     "after scanner uncertainty instead of raising"
        false
      rescue err_class => e
        assert(e.message.include?("duplicate scanner could not complete"),
               "scanner-uncertainty error must explain the duplicate scan could not complete")
        assert(e.message.include?("injected-probe"),
               "scanner-uncertainty error must name the where context")
        assert(!e.message.include?("invalid JSON grammar"),
               "must not re-declare stdlib-valid input ungrammatical")
        true
      end
    assert(raised, "parse_json_strict must raise (fail closed) on scanner uncertainty, not return a value")
  ensure
    # Restore the original singleton method so later tests are unaffected.
    parser.define_singleton_method(:parse, original)
  end

  # After restore, the scanner behaves normally again.
  restored = mod.parse_json_strict(raw, "probe")
  assert(restored == JSON.parse(raw), "scanner must behave normally after the singleton method is restored")
end

# A positive contract with nested JSON objects/arrays/strings must still export
# cleanly through the strict parser (no false duplicate, stable order preserved),
# proving the robust parser did not regress the valid path.
def test_strict_json_parser_positive_contract_baseline
  with_eligible_vault do |vault, out|
    add_naming_contract_artifact(vault, "nested-rule-sentinel", "nested-example-sentinel")
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code.zero?, "valid nested naming-contract must export through the strict parser: #{err}")
    overview = File.read(File.join(out, "overview.md"))
    assert(overview.include?("nested-rule-sentinel"),
           "projected contract rules (nested JSON) must survive the strict parse")
    assert(overview.include?("nested-example-sentinel"),
           "projected contract non-normative examples (nested JSON) must survive the strict parse")
  end
end

# Changing the committed naming-contract schema the contract is validated
# against must invalidate --check, because its content hash is recorded in
# input_checksums.
def test_contract_schema_change_invalidates_check
  with_eligible_vault do |vault, out|
    add_naming_contract_artifact(vault, "r", "e")
    run_exporter(["--out", out, "--vault-root", vault])
    schema = File.join(vault, "schemas/naming-contract.schema.yml")
    File.write(schema, File.read(schema) + "\n# trailing comment to change bytes\n")
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault, "--check"])
    assert(code == 1, "consumed naming-contract schema change must invalidate --check")
    assert(err.include?("mismatch"), "schema change must produce a manifest/byte mismatch")
  end
end

# An unknown governed source FORMAT must fail explicitly when referenced. A
# reference to a source id that only exists as a non-Markdown, non-registry-YAML
# file does not resolve and fails closed as a broken reference.
def test_negative_unknown_source_format_rejected
  with_eligible_vault do |vault, out|
    # Create a .txt "source" and reference it by id from a pack artifact. It is
    # never indexed (unknown format), so the reference is broken and fails.
    File.write(File.join(vault, "sources/weird.txt"),
               "id: synthetic.source.weird\nnot a governed format\n")
    pack = File.join(vault, "exports/synthetic-pack/pack.yml")
    File.write(pack, File.read(pack).sub("- synthetic.source.tokens",
                                         "- synthetic.source.tokens\n          - synthetic.source.weird"))
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code == 1, "an unknown source format reference must fail closed")
    assert(err.include?("broken reference") || err.include?("does not resolve"),
           "diagnostic must cite the unresolved/broken reference")
  end
end

# REFERENCED source metadata must meet the required Vault shape. Omitting
# required owners must fail closed even though type/authority/status are valid.
def test_negative_source_missing_owners
  with_eligible_vault do |vault, out|
    src = File.join(vault, "sources/tokens.md")
    content = File.read(src)
    content = content.sub(/owners:\n  - ui-foundations\n/, "")
    assert(!content.include?("owners:"), "test setup must remove the owners field from the source")
    File.write(src, content)
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code == 1, "a referenced source missing required owners must fail closed")
    assert(err.include?("owners"), "diagnostic must cite the missing owners")
  end
end

# Omitting the required title must fail closed.
def test_negative_source_missing_title
  with_eligible_vault do |vault, out|
    src = File.join(vault, "sources/tokens.md")
    content = File.read(src).sub(/^title: .*\n/, "")
    assert(!content.match?(/^title:/), "test setup must remove the title field")
    File.write(src, content)
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code == 1, "a referenced source missing required title must fail closed")
    assert(err.include?("title"), "diagnostic must cite the missing title")
  end
end

# An invalid updated date (updated earlier than created) must fail closed.
def test_negative_source_updated_before_created
  with_eligible_vault do |vault, out|
    src = File.join(vault, "sources/tokens.md")
    content = File.read(src).sub("updated: 2026-01-02", "updated: 2025-12-31")
    assert(content.include?("updated: 2025-12-31"), "test setup must set updated earlier than created")
    File.write(src, content)
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code == 1, "updated earlier than created must fail closed")
    assert(err.include?("earlier than created"), "diagnostic must cite the invalid date ordering")
  end
end

# A malformed conflicts_with (a scalar instead of a list) must not evade the
# unresolved-conflict blocker; the source shape validation rejects it.
def test_negative_source_malformed_conflicts_with
  with_eligible_vault do |vault, out|
    src = File.join(vault, "sources/components.md")
    File.write(src, File.read(src).sub("authority: source\n",
                                       "authority: source\nrelated:\n  conflicts_with: some.other.doc\n"))
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code == 1, "a scalar conflicts_with must fail closed (must not evade the blocker)")
    assert(err.include?("conflicts_with") || err.include?("malformed related"),
           "diagnostic must cite the malformed related/conflicts_with")
  end
end

# The manifest format schema_version is required and constrained by the
# committed manifest schema. A missing or wrong value must fail the schema
# enforcement. We prove this by changing the committed manifest schema's
# schema_version const so the generated value no longer matches.
def test_negative_manifest_schema_version_rejected
  with_eligible_vault do |vault, out|
    schema_path = File.join(vault, "schemas/figma-export-manifest.schema.json")
    schema = JSON.parse(File.read(schema_path))
    schema["properties"]["schema_version"]["const"] = "2.0.0"
    File.write(schema_path, JSON.pretty_generate(schema))
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code == 1, "a manifest schema_version that violates the committed const must fail closed")
    assert(err.include?("fails committed schema") && err.include?("schema_version"),
           "diagnostic must cite the schema_version const violation")
  end
end

def test_negative_artifact_status
  with_eligible_vault do |vault, out|
    pack = File.join(vault, "exports/synthetic-pack/pack.yml")
    original = File.read(pack)
    # Demote ONLY the naming-rules artifact's declared status to an ineligible
    # value. The previous version matched against a hard-coded 8-space indent
    # that never existed in the written fixture (squiggly heredocs strip the
    # common leading indent to 4 spaces), so the mutation silently no-oped and
    # the negative test proved nothing. Anchor on the actual written content and
    # assert the mutation took effect before relying on it.
    content = original.sub(
      /(path: exports\/synthetic-pack\/naming-rules\.md\n\s+status: )accepted/,
      '\1review'
    )
    assert(content != original, "test setup must actually demote the naming-rules artifact status")
    assert(content.include?("status: review"), "mutated fixture must contain the ineligible status")
    File.write(pack, content)
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code == 1, "ineligible artifact status must fail closed")
    assert(err.include?("not eligible"), "diagnostic must mention artifact eligibility")
  end
end

def test_negative_artifact_status_mismatch_with_document
  with_eligible_vault do |vault, out|
    # Manifest claims accepted, but the consumed markdown document says draft.
    doc = File.join(vault, "exports/synthetic-pack/naming-rules.md")
    File.write(doc, File.read(doc).sub("status: accepted", "status: draft"))
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code == 1, "manifest/document status mismatch must fail closed")
    assert(err.include?("does not") && err.include?("status"), "diagnostic must cite status mismatch")
  end
end

def test_negative_unknown_artifact_type
  with_eligible_vault do |vault, out|
    pack = File.join(vault, "exports/synthetic-pack/pack.yml")
    File.write(pack, File.read(pack).sub("type: token-governance", "type: mystery-type"))
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code == 1, "unknown artifact type must fail closed")
    assert(err.include?("unknown type"), "diagnostic must cite the unknown type")
  end
end

def test_negative_pack_channel
  with_eligible_vault do |vault, out|
    reg = File.join(vault, "registry/governance-packs.yml")
    File.write(reg, File.read(reg).sub("channel: stable", "channel: review"))
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code == 1, "non-stable pack channel must fail closed")
    assert(err.include?("channel") || err.include?("Conflicting metadata"), "diagnostic must mention channel/metadata conflict")
  end
end

def test_negative_conflicting_metadata
  with_eligible_vault do |vault, out|
    man = File.join(vault, "exports/synthetic-pack/pack.yml")
    File.write(man, File.read(man).sub("version: 1.0.0", "version: 2.0.0"))
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code == 1, "registry/manifest version mismatch must fail closed")
    assert(err.include?("Conflicting metadata"), "diagnostic must mention conflicting metadata")
  end
end

# The pack manifest's own lifecycle status is an eligibility gate in addition
# to the registry channel. A draft/review manifest must fail closed.
def test_negative_pack_manifest_status
  with_eligible_vault do |vault, out|
    man = File.join(vault, "exports/synthetic-pack/pack.yml")
    original = File.read(man)
    content = original.sub(/^status: accepted$/, "status: review")
    assert(content != original, "test setup must demote the pack manifest status")
    File.write(man, content)
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code == 1, "ineligible pack manifest status must fail closed")
    assert(err.include?("pack manifest status") && err.include?("not"),
           "diagnostic must cite the pack manifest status eligibility gate")
  end
end

def test_negative_duplicate_source_id
  with_eligible_vault do |vault, out|
    dup = File.join(vault, "sources/naming-dup.md")
    File.write(dup, File.read(File.join(vault, "sources/naming.md")))
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code == 1, "duplicate source id must fail closed")
    assert(err.include?("Duplicate source document id"), "diagnostic must mention duplicate id")
  end
end

def test_negative_duplicate_yaml_key
  with_eligible_vault do |vault, out|
    src = File.join(vault, "sources/tokens.md")
    # Inject a duplicate status key into frontmatter.
    File.write(src, File.read(src).sub("status: accepted\n", "status: accepted\nstatus: stable\n"))
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code == 1, "duplicate YAML key must fail closed")
    assert(err.include?("duplicate YAML key"), "diagnostic must mention duplicate YAML key")
  end
end

def test_negative_invalid_utf8_source
  with_eligible_vault do |vault, out|
    src = File.join(vault, "sources/tokens.md")
    bytes = File.binread(src) + "\xFF\xFE invalid".b
    File.binwrite(src, bytes)
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code == 1, "invalid UTF-8 source must fail closed")
    assert(err.include?("not valid UTF-8"), "diagnostic must mention invalid UTF-8")
  end
end

def test_negative_size_budget
  with_eligible_vault do |vault, out|
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault, "--max-file-bytes", "10"])
    assert(code == 1, "tiny per-file budget must fail closed")
    assert(err.include?("per-file budget") && err.include?("utf-8-bytes"), "diagnostic must mention byte budget and unit")
    assert(!File.exist?(out), "budget failure writes no output")
  end
end

def test_negative_total_budget
  with_eligible_vault do |vault, out|
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault, "--max-total-bytes", "50"])
    assert(code == 1, "tiny total budget must fail closed")
    assert(err.include?("exceeds configured budget"), "diagnostic must mention total budget")
  end
end

def test_hard_cap_clamp
  # A requested total above the hard cap must be clamped; the manifest records
  # the immutable cap and never a larger configured value.
  with_eligible_vault do |vault, out|
    code, _o, _err = run_exporter(["--out", out, "--vault-root", vault, "--max-total-bytes", "999999"])
    assert(code.zero?, "export within hard cap should still succeed")
    manifest = read_manifest(out)
    assert(manifest.dig("budgets", "max_total_bytes") <= 200_000, "configured total must be clamped to hard cap")
    assert(manifest.dig("budgets", "hard_max_total_bytes") == 200_000, "hard cap recorded immutably")
  end
end

def test_negative_output_inside_vault
  with_eligible_vault do |vault, _out|
    inside = File.join(vault, "exports/figma")
    code, _o, err = run_exporter(["--out", inside, "--vault-root", vault])
    assert(code == 1, "output inside vault must be refused")
    assert(err.include?("external to the vault") || err.include?("inside the vault"),
           "diagnostic must mention external output requirement")
  end
end

def test_negative_output_parent_symlink_into_vault
  # A symlinked parent that physically resolves into the vault must be refused.
  with_eligible_vault do |vault, _out|
    Dir.mktmpdir("figma-export-linkparent-") do |tmp|
      link = File.join(tmp, "sneaky")
      File.symlink(File.join(vault, "exports"), link)
      target = File.join(link, "figma-out")
      code, _o, err = run_exporter(["--out", target, "--vault-root", vault])
      assert(code == 1, "symlinked parent into vault must be refused")
      assert(err.include?("vault"), "diagnostic must cite the vault boundary")
    end
  end
end

def test_negative_source_symlink_escape
  # A governed .md whose realpath escapes the vault must be rejected, not read.
  with_eligible_vault do |vault, out|
    Dir.mktmpdir("figma-export-outside-") do |outside|
      secret = File.join(outside, "secret.md")
      File.write(secret, frontmatter("id" => "synthetic.source.escape", "type" => "naming-rule",
                                     "status" => "accepted", "authority" => "source",
                                     "owners" => ["x"], "created" => "2026-01-01",
                                     "updated" => "2026-01-02", "title" => "escape") + "# escape\n")
      File.symlink(secret, File.join(vault, "sources/escape.md"))
      code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
      assert(code == 1, "symlinked source escaping the vault must fail closed")
      assert(err.include?("escapes the vault"), "diagnostic must cite symlink escape")
    end
  end
end

def test_negative_path_traversal_reference
  with_eligible_vault do |vault, out|
    pack = File.join(vault, "exports/synthetic-pack/pack.yml")
    File.write(pack, File.read(pack).sub("path: exports/synthetic-pack/naming-rules.md",
                                         "path: ../../../etc/passwd"))
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code == 1, "traversal artifact path must fail closed")
    assert(err.include?("traversal") || err.include?("Unsafe"), "diagnostic must mention unsafe path")
  end
end

def test_negative_category_without_source
  with_eligible_vault do |vault, out|
    pack = File.join(vault, "exports/synthetic-pack/pack.yml")
    original = File.read(pack)
    # Drop the accessibility-baseline artifact entry entirely so the
    # accessibility category has no eligible source and the exporter must fail
    # closed rather than fabricate content. The previous regex assumed a
    # 6-space list indent that the written fixture never had (squiggly heredoc
    # normalises list items to a 2-space indent), so nothing was removed and the
    # export wrongly succeeded. Match the real indentation and assert removal.
    content = original.sub(/^\s*- id: synthetic\.accessibility-baseline\b.*\z/m, "")
    assert(content != original, "test setup must actually remove the accessibility-baseline artifact")
    assert(!content.include?("synthetic.accessibility-baseline"),
           "mutated fixture must no longer declare the accessibility-baseline artifact")
    File.write(pack, content)
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code == 1, "missing category source must fail closed")
    assert(err.include?("no eligible source artifact") || err.include?("fabricate"),
           "diagnostic must mention missing category source / refusal to fabricate")
  end
end

def test_negative_schema_violation
  with_eligible_vault do |vault, out|
    schema_path = File.join(vault, "schemas/figma-export-manifest.schema.json")
    schema = JSON.parse(File.read(schema_path))
    schema["properties"]["size_unit"]["const"] = "megabytes"
    File.write(schema_path, JSON.pretty_generate(schema))
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code == 1, "manifest violating schema must fail closed")
    assert(err.include?("fails committed schema"), "diagnostic must mention schema failure")
  end
end

def test_negative_unsupported_schema_keyword
  with_eligible_vault do |vault, out|
    schema_path = File.join(vault, "schemas/figma-export-manifest.schema.json")
    schema = JSON.parse(File.read(schema_path))
    # Introduce a keyword the bundled validator does not implement.
    schema["properties"]["total_bytes"]["multipleOf"] = 2
    File.write(schema_path, JSON.pretty_generate(schema))
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code == 1, "unsupported schema keyword must fail closed")
    assert(err.include?("Unsupported schema keyword"), "diagnostic must cite unsupported keyword")
  end
end

def test_negative_unsupported_schema_dialect
  with_eligible_vault do |vault, out|
    schema_path = File.join(vault, "schemas/figma-export-manifest.schema.json")
    schema = JSON.parse(File.read(schema_path))
    schema["$schema"] = "https://json-schema.org/draft-07/schema"
    File.write(schema_path, JSON.pretty_generate(schema))
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code == 1, "unsupported schema dialect must fail closed")
    assert(err.include?("Unsupported manifest schema dialect"), "diagnostic must cite dialect")
  end
end

def test_negative_unsafe_body_content
  with_eligible_vault do |vault, out|
    src = File.join(vault, "sources/tokens.md")
    File.write(src, File.read(src) + "\n<script>alert(1)</script>\n")
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code == 1, "unsupported raw HTML/script in body must fail closed")
    assert(err.include?("raw HTML") || err.include?("unsupported"), "diagnostic must cite unsupported content")
  end
end

def test_negative_broken_local_link_in_body
  with_eligible_vault do |vault, out|
    src = File.join(vault, "sources/tokens.md")
    File.write(src, File.read(src) + "\nSee [missing](./does-not-exist.md).\n")
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code == 1, "broken local link in body must fail closed")
    assert(err.include?("local link"), "diagnostic must cite the unsafe/missing local link")
  end
end

# A Vault-relative link that resolves safely today is STILL rejected, because
# the adapter has no reviewed canonical-URL mapping and must not silently emit
# a link that would dangle in the external export folder, nor falsely claim it
# was rebased. This proves the honest fail-closed behavior for item: links.
def test_negative_resolvable_relative_link_rejected_until_mapping
  with_eligible_vault do |vault, out|
    # tokens.md and components.md are siblings under sources/, so this link
    # resolves safely inside the Vault.
    src = File.join(vault, "sources/tokens.md")
    File.write(src, File.read(src) + "\nSee [components](./components.md) for details.\n")
    code, _o, err = run_exporter(["--out", out, "--vault-root", vault])
    assert(code == 1, "a resolvable Vault-relative link must still fail closed until a mapping exists")
    assert(err.include?("does not rebase relative links") || err.include?("Unsupported format"),
           "diagnostic must honestly state the adapter does not rebase relative links yet")
    assert(!err.include?("rebased to canonical"), "must not claim the link was rebased")
    assert(!File.exist?(out), "no partial output when a relative link is rejected")
  end
end

# ---- Real pack + non-mutation ----------------------------------------------

# Integration against the real release candidate, not a synthetic approved pack.
# Candidate metadata is proposed for owner approval; a passing test is not approval.
def test_real_pack_release_candidate
  Dir.mktmpdir("figma-export-real-out-") do |outparent|
    out = File.join(outparent, "first")
    other = File.join(outparent, "second")
    args = ["--vault-root", REAL_VAULT_ROOT, "--max-total-bytes", "200000"]
    code, _o, err = run_exporter(args + ["--out", out])
    assert(code.zero?, "real release candidate must export: #{err}")
    return unless code.zero?
    manifest = read_manifest(out)
    assert(manifest.dig("generated_from", "pack_version") == "0.9.0", "real pack version must be 0.9.0")
    assert(manifest.dig("generated_from", "pack_channel") == "stable", "candidate proposes stable channel")
    assert(manifest["files"].size == 7, "real pack exports seven guideline files")
    assert(manifest["total_bytes"] <= 200000, "real pack must fit immutable upload cap")
    manifest["files"].each do |f|
      bytes = File.binread(File.join(out, f["path"]))
      assert(Digest::SHA256.hexdigest(bytes) == f["sha256"], "real guideline hash must match #{f['path']}")
    end
    check, _o, err = run_exporter(args + ["--out", out, "--check"])
    assert(check.zero?, "real pack --check must pass: #{err}")
    again, _o, err = run_exporter(args + ["--out", other])
    assert(again.zero?, "repeat real export must succeed: #{err}")
    if again.zero?
      assert(Dir.children(out).sort == Dir.children(other).sort, "repeat exports have identical entries")
      Dir.children(out).each do |name|
        assert(File.binread(File.join(out, name)) == File.binread(File.join(other, name)), "repeat real export must be byte-identical: #{name}")
      end
    end
  end
end

# Preserve the real-source fail-closed check even after proposing a stable pack.
# Only an external copy is mutated; the candidate source tree stays untouched.
def test_real_pack_review_channel_rejected
  Dir.mktmpdir("figma-real-review-copy-") do |vault|
    canonical_snapshot(REAL_VAULT_ROOT).each do |rel, _sha|
      next if rel == ".git"
      target = File.join(vault, rel)
      FileUtils.mkdir_p(File.dirname(target))
      FileUtils.cp(File.join(REAL_VAULT_ROOT, rel), target)
    end
    registry = File.join(vault, "registry/governance-packs.yml")
    before = File.read(registry)
    changed = before.sub("    channel: stable", "    channel: review")
    assert(changed != before, "real review-channel negative must mutate the current registry channel")
    File.write(registry, changed)
    Dir.mktmpdir("figma-real-review-output-") do |parent|
      out = File.join(parent, "guidelines")
      code, _o, err = run_exporter(["--out", out, "--vault-root", vault, "--max-total-bytes", "200000"])
      assert(code == 1, "real review-channel copy must fail closed")
      assert(err.include?("channel") && err.include?("not eligible"), "real review rejection cites channel eligibility")
      assert(!File.exist?(out), "real review-channel rejection writes no partial output")
    end
  end
end

def test_real_pack_default_budget_rejected
  Dir.mktmpdir("figma-real-budget-output-") do |parent|
    out = File.join(parent, "guidelines")
    code, _o, err = run_exporter(["--out", out, "--vault-root", REAL_VAULT_ROOT])
    assert(code == 1, "full real-source pack requires an explicit upload budget")
    assert(err.include?("exceeds configured budget"), "default-budget rejection must identify size")
    assert(!File.exist?(out), "budget rejection writes no partial output")
  end
end

def test_no_canonical_mutation
  before = canonical_snapshot(REAL_VAULT_ROOT)
  Dir.mktmpdir("figma-export-nomut-out-") do |outparent|
    code, _o, err = run_exporter(["--out", File.join(outparent, "fig"), "--vault-root", REAL_VAULT_ROOT, "--max-total-bytes", "200000"])
    assert(code.zero?, "real non-mutation probe must actually export: #{err}")
  end
  with_eligible_vault do |vault, out|
    run_exporter(["--out", out, "--vault-root", vault])
  end
  after = canonical_snapshot(REAL_VAULT_ROOT)
  assert(before == after, "running the exporter must not mutate any canonical Vault file")
end

# Prove a symlink-to-vault output target plus a preexisting sentinel cannot
# mutate canonical content and cannot be clobbered by the exporter.
def test_sentinel_and_symlink_cannot_mutate_vault
  before = canonical_snapshot(REAL_VAULT_ROOT)
  Dir.mktmpdir("figma-export-sentinel-") do |parent|
    out = File.join(parent, "figma-out")
    FileUtils.mkdir_p(out)
    sentinel = File.join(out, "SENTINEL.txt")
    File.write(sentinel, "preexisting user content")

    # Refuse to overwrite the existing output directory (so the sentinel lives).
    code, _o, err = run_exporter(["--out", out, "--vault-root", REAL_VAULT_ROOT, "--max-total-bytes", "200000"])
    assert(code == 1, "exporter must refuse a preexisting output directory")
    assert(err.include?("Refusing to overwrite"),
           "refusal diagnostic expected")
    assert(File.read(sentinel) == "preexisting user content", "preexisting sentinel must be preserved untouched")

    # A symlink whose name points back into the vault must be refused as an
    # output target, protecting canonical content.
    link = File.join(parent, "link-into-vault")
    File.symlink(REAL_VAULT_ROOT, link)
    code2, _o2, err2 = run_exporter(["--out", File.join(link, "nested-out"), "--vault-root", REAL_VAULT_ROOT, "--max-total-bytes", "200000"])
    assert(code2 == 1, "symlinked output target into the vault must be refused")
    assert(err2.include?("vault"), "refusal must cite the vault boundary")
  end
  after = canonical_snapshot(REAL_VAULT_ROOT)
  assert(before == after, "no canonical content may change during sentinel/symlink tests")
end

def canonical_snapshot(root)
  Dir.glob(File.join(root, "**/*"), File::FNM_DOTMATCH)
     .reject { |p| p.include?("/.git/") }
     .select { |p| File.file?(p) }
     .sort
     .map { |p| [p.sub("#{root}/", ""), Digest::SHA256.hexdigest(File.binread(p))] }
end

# ---- Runner -----------------------------------------------------------------

TESTS = [
  :test_script_standalone_loadable,
  :test_positive_synthetic_export,
  :test_multiline_body_preserved_verbatim,
  :test_informative_source_not_normative,
  :test_determinism_byte_identical_and_check_no_write,
  :test_check_detects_tampering,
  :test_check_detects_extra_file_and_symlink_and_dir,
  :test_source_content_change_invalidates_check,
  :test_pack_registry_schema_changes_invalidate_manifest,
  :test_negative_source_not_eligible,
  :test_negative_unresolved_conflict,
  :test_negative_missing_governance_precedence,
  :test_negative_governance_wrong_type,
  :test_negative_governance_wrong_authority,
  :test_supporting_authority_source_stays_informative,
  :test_governance_authority_change_invalidates_check,
  :test_repos_change_invalidates_check,
  :test_negative_nonhash_frontmatter_controlled,
  :test_negative_broken_reference,
  :test_negative_source_unknown_authority,
  :test_negative_source_unknown_document_type,
  :test_negative_artifact_list_null_element_controlled,
  :test_artifact_body_consumed_into_export,
  :test_naming_contract_projected_into_export,
  :test_naming_contract_positive_baseline_exports,
  :test_negative_contract_status_draft,
  :test_negative_contract_governance_pack_version_mismatch,
  :test_negative_contract_channel_mismatch,
  :test_negative_contract_canonical_source_path_mismatch,
  :test_negative_contract_schema_nested_required,
  :test_negative_contract_schema_enum_violation,
  :test_negative_contract_alternate_schema_path,
  :test_negative_contract_duplicate_json_key,
  :test_negative_contract_duplicate_json_key_reverse_order,
  :test_negative_contract_duplicate_nested_json_key,
  :test_negative_contract_unicode_escaped_duplicate_key,
  :test_strict_json_parser_unit_behaviour,
  :test_parse_json_strict_grammar_and_value_validation,
  :test_parse_json_strict_fails_closed_on_scanner_uncertainty,
  :test_strict_json_parser_positive_contract_baseline,
  :test_contract_schema_change_invalidates_check,
  :test_negative_unknown_source_format_rejected,
  :test_negative_source_missing_owners,
  :test_negative_source_missing_title,
  :test_negative_source_updated_before_created,
  :test_negative_source_malformed_conflicts_with,
  :test_negative_manifest_schema_version_rejected,
  :test_negative_artifact_status,
  :test_negative_artifact_status_mismatch_with_document,
  :test_negative_unknown_artifact_type,
  :test_negative_pack_channel,
  :test_negative_conflicting_metadata,
  :test_negative_pack_manifest_status,
  :test_negative_duplicate_source_id,
  :test_negative_duplicate_yaml_key,
  :test_negative_invalid_utf8_source,
  :test_negative_size_budget,
  :test_negative_total_budget,
  :test_hard_cap_clamp,
  :test_negative_output_inside_vault,
  :test_negative_output_parent_symlink_into_vault,
  :test_negative_source_symlink_escape,
  :test_negative_path_traversal_reference,
  :test_negative_category_without_source,
  :test_negative_schema_violation,
  :test_negative_unsupported_schema_keyword,
  :test_negative_unsupported_schema_dialect,
  :test_negative_unsafe_body_content,
  :test_negative_broken_local_link_in_body,
  :test_negative_resolvable_relative_link_rejected_until_mapping,
  :test_real_pack_release_candidate,
  :test_real_pack_review_channel_rejected,
  :test_real_pack_default_budget_rejected,
  :test_no_canonical_mutation,
  :test_sentinel_and_symlink_cannot_mutate_vault
].freeze

def main
  TESTS.each do |name|
    send(name)
  rescue StandardError => e
    $failures << "#{name} raised #{e.class}: #{e.message}"
    warn "ERROR in #{name}: #{e.class}: #{e.message}"
    warn e.backtrace.first(5).join("\n")
  end

  puts
  puts "Figma export tests: #{$passed} assertions passed, #{$failures.length} failure(s) across #{TESTS.length} tests."
  if $failures.empty?
    puts "ALL TESTS PASSED"
    exit 0
  else
    warn "FAILURES:"
    $failures.each { |f| warn "- #{f}" }
    exit 1
  end
end

main if $PROGRAM_NAME == __FILE__
