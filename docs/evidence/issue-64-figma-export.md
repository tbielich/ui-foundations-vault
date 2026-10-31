---
id: docs.evidence.issue-64-figma-export
title: Issue 64 Figma Export Evidence
type: lesson
status: draft
owners:
  - ui-foundations
created: 2026-10-30
updated: 2026-10-31
authority: supporting
summary: Draft evidence log for the read-only Figma guidelines export adapter (UIF-VLT issue 64).
related:
  references:
    - docs.figma-guidelines-export
    - registry.governance-packs
    - export-pack.governance.manifest
provenance:
  sources:
    - type: issue
      role: source
      repository: ui-foundations-vault
      number: 64
---

# Issue 64 Figma Export Evidence

## Summary

This log records what was implemented for the read-only deterministic Figma
guidelines export adapter, what was verified, and what remains blocked. It is a
draft. The issue must remain open. Human approval is pending.

## Practical Figma evaluation (2026-10-31)

This section supersedes earlier statements that no Figma library or manual test
was supplied. Earlier verification sections remain execution history.

A manually curated experimental pack was uploaded by the owner to the published
UIF library. It contained seven Markdown files (26517 UTF-8 bytes), assembled
from Vault revision `f2f21e45399315acb0ad50e1a101b82043ceabe5`. Each file explicitly
said TEST ONLY and retained source lifecycle labels. This was NOT output from
an eligible authoritative exporter run and did not promote Governance Pack
0.8.0 or approve draft/review sources. Its local provenance JSON and checksums
were kept separate from the uploaded Markdown files.

Observed evidence:

- The Figma agent reported reading all seven files and correctly identified the
  experimental status. Its quoted guidance matched the supplied files.
- The agent created the [settings smoke-test frame](https://www.figma.com/design/fsbgTfP30XZGuawayhgDGn/UIF-Agents-Test-File?node-id=2-2191).
  Codex independently inspected it through the desktop UI: two Button library
  instances (Solid and Outline), a Switch Field instance, Heading/Heading 4,
  variable-bound surface/text colors, Form/Gap, Size/Spacing Spacious, and
  Button/Group/Gap were confirmed. No claim is made that all 31 bindings reported
  by the agent were independently counted.
- A separate [320 px Dark test](https://www.figma.com/design/fsbgTfP30XZGuawayhgDGn/UIF-Agents-Test-File?node-id=6-23)
  retained the instances and exposed a real library/version mismatch: dark text
  and switch parts resolved to #333333 on black; Outline text and border resolved
  to black. Codex independently read the mode and resolved bindings through MCP.
  The agent left the defect visible rather than masking it with local colors.
- The token-structure Figma branch was the code projection's recorded source.
  Codex checked 452 color variables / 565 mode values against Runtime revision
  `aa153b79668df7c3b655a96d9541171de1899580`, with no mismatches. After the owner
  reported merging, the same comparison passed on the Figma main file.
  The consumer test frame still used older published values at last readback;
  publication, consumer update and a passing Dark retest are not claimed.

Outcome: manual Markdown delivery, agent readability, source-status recognition,
and practical use with real library instances are demonstrated. This supports
adopting the adapter workflow, but does not establish an approved-pack export,
prove that the adapter generated the tested files, or isolate guideline influence
from the task prompt/library defaults. Keyboard behavior, screen-reader behavior,
all component states and all brands were not evaluated in Figma. No WCAG or
production-library release approval follows from this smoke test.

Implementation approval and governance-pack eligibility are separate. The owner
requested permanent implementation after this evaluation; no merge, lifecycle
promotion or automated Figma publication is inferred from that request.

## Scope Delivered

- `scripts/export-figma-guidelines.rb`: read-only, fail-closed export adapter
  (Ruby stdlib only). Preserves source bodies verbatim in attributed per-source
  blocks, classifies normative/informative by governed document type and
  `governance.precedence` defaults, records rule-level provenance plus
  registry/pack/schema/artifact input checksums, reads everything through a
  safe-path resolver, and refuses to overwrite or delete any existing output.
- `scripts/test-figma-export.rb`: deterministic stdlib tests using explicitly
  synthetic temporary fixtures, plus the real-pack expected-rejection negative
  test (asserting the specific channel eligibility diagnostic), a standalone
  loadability test, and a no-canonical-mutation test.
- `schemas/figma-export-manifest.schema.json`: committed manifest schema,
  enforced by the adapter before any output is written. The adapter rejects any
  schema dialect or keyword its bundled subset validator does not implement.
- `docs/figma-guidelines-export.md`: workflow documentation.
- `.github/workflows/ci.yml`: runs the new tests and existing projection,
  governance-pack, and audit self-test validations.

### Repair notes (2026-10-30)

An independent review of the first implementation found blocking correctness
issues, repaired here within the same six paths:

- Added `require "date"` so the script works standalone and when required.
- Set a conservative default total budget of 100000 UTF-8 bytes and an immutable
  200000-byte compatibility cap (clamped even if a larger value is configured),
  matching Figma's documented guidelines limits. The manifest is not uploaded to
  Figma and does not count toward the budget.
- Replaced heading-substring classification with type-based normativity; an
  informative source never becomes normative because a heading says "rules".
- Preserved source bodies verbatim per source rather than dropping continuation
  lines, paragraphs, nested lists, code, tables, and h3 sections.
- Added rule/block-level provenance and manifest input checksums so `--check`
  invalidates on pack, registry, schema, or consumed-artifact changes.
- Routed all reads through the safe-path resolver; rejected escaping symlinks,
  duplicate/aliased/invalid YAML metadata, invalid UTF-8, and unknown artifact
  types.
- Hardened output handling: refuse existing output, refuse Vault root/ancestors,
  resolve symlinked parents physically, stage in a fresh `mktmpdir`, rename
  atomically, and never `rm_rf` an arbitrary target.
- Made schema validation reject unsupported dialects/keywords instead of
  silently accepting them.
- Verified `governance.precedence` and `governance.lifecycle` resolve and are
  accepted/stable, and rejected sources with unresolved `conflicts_with`.

Out of scope and not performed: runtime application code, orchestration,
dependencies, canonical content changes, status promotion, publishing, git
mutations, and cross-repo changes.

### Repair notes (2026-10-31)

A sequence of independent acceptance runs found substantive bugs and drove the
suite from an earlier green baseline to the current final state. The four
acceptance failures below were repaired within the same six writable paths,
with regression tests added, and further hardening landed subsequently. The
final suite is 313 assertions across 66 tests (see Verification Status). Earlier
intermediate counts (for example 197/45 and 258/50) are superseded and are
retained here only as a repair history, not as the current result:

1. Unknown source metadata accepted. A referenced eligible source with
   `authority: rogue` (or any value outside the vault-metadata authority enum),
   or a document `type` outside the canonical vault-metadata taxonomy, exported
   at exit 0. The adapter now validates each referenced eligible source's
   `authority` against `source/supporting/derived/example` and its `type`
   against the canonical document taxonomy, failing closed with a controlled
   diagnostic. The synthetic fixtures were corrected to use valid governed
   document types (`governance`/`specification`/`principle`) for sources instead
   of pack artifact types (`naming-rule`/`token-governance`/...); ids and names
   are unchanged, and no new canonical type was invented. `NORMATIVE_DOC_TYPES`
   was trimmed to the canonical taxonomy.
   Regression: `test_negative_source_unknown_authority`,
   `test_negative_source_unknown_document_type`.
2. `artifacts: [null]` crashed. A null/scalar artifact list element reached
   `artifact["id"]` and raised an unhandled `NoMethodError` (undefined method
   `[]' for nil) at the artifact loop, leaking a stack trace. The loop now
   validates each element is a mapping (and that path is a non-empty string and
   `source_references`, when present, is a list) and fails closed at exit 1 with
   a specific diagnostic and no backtrace.
   Regression: `test_negative_artifact_list_null_element_controlled`.
3. Approved artifact body omitted. The export recorded artifact checksums but
   never consumed artifact content, so an appended `## Rules` section in an
   accepted artifact did not appear in the output. Each selected approved pack
   artifact is now consumed faithfully as an attributed DERIVED/INFORMATIVE
   block (Markdown body preserved byte-for-byte) alongside its eligible
   canonical sources, with artifact provenance. Derived artifact text is not
   relabelled as authoritative original governance.
   Regression: `test_artifact_body_consumed_into_export`.
4. Blanket naming-contract rejection removed. The adapter now deterministically
   projects an accepted naming-contract's `rules` and `non_normative_examples`
   into fenced JSON blocks under explicit "Normative constraints" and
   "Non-normative examples" headings, preserving the contract's declared
   `rules_are_normative: true` / `examples_are_normative: false` and its source
   eligibility, without inventing rules, aliases, or token ids. This mapping is
   reviewed in the draft PR; no human approval is invented. The real review-
   channel pack stays blocked.
   Regression: `test_naming_contract_projected_into_export`.

Also: unsupported-vendor assertions were removed. The verified Figma help
("Add guidelines files to a design library",
https://help.figma.com/hc/en-us/articles/23540976923671-Add-guidelines-files-to-a-design-library,
verified 2026-10-30) establishes accepted extensions, access, size limits, and
the upload flow; it does not establish that Markdown images or raw HTML are
unsupported. Those refusals are now labelled conservative adapter restrictions,
not Figma facts.

All previously proven protections were retained: immutable 200000-byte hard cap
(default 100000), no existing-output deletion, physical path/symlink checks,
exact output entries, byte-preserved source bodies, strict duplicate/alias YAML,
real-pack eligibility diagnostic, required canonical governance path/type/
authority/lifecycle and input hashes, schema enforcement, and `--check` source/
input invalidation with no writes.

### CI repair notes (2026-11-01): portable duplicate-JSON-key detection

Hosted CI reported one failure that did NOT reproduce locally. This revision
records that discrepancy and the fix; it does not alter any prior historical
counts, commit hashes, or evidence rows above.

- Initial hosted FAIL (authoritative): the `pull_request` run on head
  `4e4a7fbee0288e973321c93cdf2d1d4baeaf7af2`
  (https://github.com/tbielich/ui-foundations-vault/actions/runs/41183607422/job/124485905975)
  reported, for the export suite, 312 assertions passing with 1 failure across
  66 tests: `test_negative_contract_duplicate_json_key` — "diagnostic must cite
  the duplicate JSON key". All earlier CI steps passed.
- Local PASS at the same point: the same 66 tests / 313 assertions passed on
  Ruby 2.6.10, including on a clean committed checkout. The failure was therefore
  a cross-version portability gap, not a local regression.
- Root cause: duplicate-key detection relied on `JSON.parse`'s handling of a
  custom `object_class`. The earlier `StrictJSONHash < Hash` override was
  bypassed by the optimized JSON C extension on the hosted runner; a subsequent
  non-Hash `object_class` wrapper still delegated object construction to the
  backend and also failed to surface the duplicate on that runner. In that case
  the duplicate `status` key was silently resolved to the later value and the
  contract fell through to a generic ineligible-status rejection (still exit 1,
  but WITHOUT the explicit "Duplicate JSON key" diagnostic the test asserts).
- Fix: duplicate-key detection no longer depends on any JSON backend. The
  adapter now parses contract JSON with `StrictJSONParser`, a small
  self-contained recursive-descent scanner. It tracks string state explicitly
  (no regex that could confuse string contents with structural punctuation),
  decodes `\uXXXX` escapes (including surrogate pairs) before comparing keys,
  and raises a controlled `DuplicateJSONKeyError` on the first repeated key in
  any object at any depth — in BOTH orders (accepted-then-draft and
  draft-then-accepted). After a successful parse it yields ordinary
  Hash/Array/scalar values with keys in textual insertion order, so downstream
  behaviour and valid-input manifest bytes are unchanged. `parse_json_strict`
  maps the duplicate error to a fail-closed `ExportError` whose message retains
  the explicit "Duplicate JSON key" text; no partial export is written.
- Regressions added (inside `scripts/test-figma-export.rb`): the existing
  `test_negative_contract_duplicate_json_key` assertion is kept unchanged, plus
  `test_negative_contract_duplicate_json_key_reverse_order`,
  `test_negative_contract_duplicate_nested_json_key`,
  `test_negative_contract_unicode_escaped_duplicate_key`, a direct in-process
  parser unit test `test_strict_json_parser_unit_behaviour` (duplicate detection
  both orders, nested, Unicode-escaped collision, surrogate decoding, malformed
  input, and a positive nested baseline whose result equals `JSON.parse` with
  stable key order and ordinary Hash/Array types), and
  `test_strict_json_parser_positive_contract_baseline` (a valid nested contract
  still exports). Only `scripts/export-figma-guidelines.rb` and
  `scripts/test-figma-export.rb` were edited; schema and CI were not changed.
- New local result (2026-11-01, Ruby 2.6.10): `ruby scripts/test-figma-export.rb`
  exits 0 with 349 assertions passing, 0 failures across 71 tests
  (ALL TESTS PASSED). `ruby schemas/validate-governance-packs.rb` exits 0;
  `ruby scripts/generate-project-projections.rb --check` exits 0;
  `ruby -c` on both edited scripts reports Syntax OK.
- Hosted status: the hosted fix is PENDING. It must not be claimed green until
  Codex commits and pushes this change and the hosted `pull_request` run reports
  the duplicate-key test passing on the CI Ruby. Draft PR65 on
  `head4e4a7fbee0288e973321c93cdf2d1d4baeaf7af2` requested review from tbielich;
  no git, push, PR, merge, or Figma actions were taken in this session. Final
  committed content hashes for the two edited scripts are to be recorded by
  Codex at commit time.

### CI repair notes (2026-10-31, follow-up): stdlib JSON grammar + scanner-only duplicate detection

A follow-up to the duplicate-key repair. Codex independently found two concrete
FALSE ACCEPTANCES in the handwritten standalone scanner that
`parse_json_strict` had been using as its grammar authority:

1. `FigmaGuidelinesExport.parse_json_strict('{"a":01}', 'probe')` returned
   `{"a" => 1}` — a leading-zero number is invalid JSON grammar but was accepted.
2. `FigmaGuidelinesExport.parse_json_strict('{"a":1e999}', 'probe')` returned
   `{"a" => Infinity}` — a non-finite value that cannot be safely JSON-generated
   afterwards was accepted.

Fix (small, no new architecture), in `scripts/export-figma-guidelines.rb` only:

- `parse_json_strict` now validates the actual JSON grammar with the Ruby
  standard library parser FIRST: `JSON.parse(raw, create_additions: false,
  allow_nan: false, max_nesting: 100)`. This rejects the leading-zero number and
  the non-finite token as grammar/value errors instead of silently decoding
  them.
- The parsed value is then round-tripped through
  `JSON.generate(parsed, allow_nan: false)` as an explicit finite /
  JSON-generatable guard.
- The existing `StrictJSONParser` scanner is retained but is now run ONLY to
  detect a duplicate decoded key in the original text (Unicode-escaped keys
  decoded before comparison, both orders, any depth). Its own decoded value is
  discarded.
- On success, `parse_json_strict` RETURNS THE STANDARD PARSER RESULT: a plain
  `Hash`/`Array` with object keys in the original textual order and ordinary
  scalar values, not the handwritten scanner's numeric/string interpretation.
- stdlib parser, nesting, and generator errors are converted to controlled
  `ExportError`/exit 1 (`JSON::ParserError`, `JSON::NestingError`,
  `JSON::GeneratorError`); no raw backtrace is leaked. The explicit
  "Duplicate JSON key" diagnostic is preserved.

Regressions added (inside `scripts/test-figma-export.rb`,
`test_parse_json_strict_grammar_and_value_validation`): leading-zero number
rejected; non-finite number rejected; over-100-depth JSON rejected cleanly
before any recursion overflow; a positive nested structure returns the standard
parser result with original key order and `JSON.parse`-equal shape; and a
duplicate key still fails closed with the explicit diagnostic. Every prior
duplicate-key test (both orders, nested, Unicode-escaped) and the full existing
suite continue to pass. No existing check was weakened. Only
`scripts/export-figma-guidelines.rb` and `scripts/test-figma-export.rb` were
edited; schema, CI, and canonical content were not changed.

Evidence correction (applied in source comments and here): the prior note's
claim that a NON-HASH `object_class` wrapper was tested on the hosted runner and
failed there is incorrect — that variant was NOT pushed or tested on the hosted
runner, so no claim is made about its hosted behaviour. The only observed hosted
failure is head `4e4a7fbee0288e973321c93cdf2d1d4baeaf7af2`, which used
`StrictJSONHash < Hash`; the observed CI failure there was the missing explicit
duplicate diagnostic (the duplicate-key test's assertion). The explanation of
the JSON C backend not routing every member through an overridden `[]=` is an
inference from that observed behaviour, not an independently proven internal
fact. The source comment and this log now state only observed facts and drop the
universal "every Ruby/backend" qualification; the duplicate scanner is described
as an independent check layered on top of stdlib grammar validation, not as a
portability guarantee across all backends.

New local result (2026-10-31 follow-up, Ruby 2.6.10):
`ruby scripts/test-figma-export.rb` exits 0 with 359 assertions passing, 0
failures across 72 tests (ALL TESTS PASSED).
`ruby schemas/validate-governance-packs.rb` exits 0;
`ruby scripts/generate-project-projections.rb --check` exits 0;
`ruby -c` on both edited scripts reports Syntax OK.

Hosted status: the hosted fix remains PENDING. It must not be claimed green
until Codex commits, pushes, and the hosted `pull_request` run reports these
tests passing on the CI Ruby. The historical failed-run link above
(runs/41183607422) and the prior local results are preserved; the initial CI is
not marked green. No git, push, PR, merge, or Figma actions were taken in this
session.

## Current Pack Reality

The current `governance-pack` is version `0.8.0` on the `review` channel, with
`review`/`draft` artifacts. An authoritative export of the current pack is
expected to FAIL CLOSED. This is encoded as a passing negative test
(`test_real_pack_rejected_with_specific_diagnostic`, which asserts the specific
channel eligibility diagnostic, exit 1, and no output).

There is still no approved authoritative export. A supplied Figma library and a
manual experimental upload were evaluated later; see Practical Figma evaluation.
Approved-pack export/import acceptance remains blocked by pack eligibility.

## Verification Status

The three checks below were re-run on 2026-10-31 after the stdlib JSON grammar +
scanner-only duplicate-detection fix (see "CI repair notes (2026-10-31,
follow-up)"). Actual results captured this turn. The current local suite is 359
assertions across 72 tests. The prior 349/71 count is the immediately preceding
local baseline (after the first duplicate-key fix), and 313/66 is the superseded
pre-fix local baseline that remains accurate for the hosted run that reported
the single duplicate-key failure.

| Command | Exit code | Result |
|---|---|---|
| `ruby scripts/test-figma-export.rb` | 0 | 359 assertions passed, 0 failures across 72 tests (ALL TESTS PASSED) |
| `ruby schemas/validate-governance-packs.rb` | 0 | Governance pack validation passed |
| `ruby scripts/generate-project-projections.rb --check` | 0 | PASS chatgpt-project; PASS kiro-uif-int (no drift) |
| `ruby -c scripts/export-figma-guidelines.rb` | 0 | Syntax OK |
| `ruby -c scripts/test-figma-export.rb` | 0 | Syntax OK |

The hosted CI result for this fix is PENDING; it is verified by Codex after
commit/push and must not be claimed green here.

Scope of this turn: a small, focused code fix plus its docs. Native write access
was limited to `scripts/export-figma-guidelines.rb`,
`scripts/test-figma-export.rb`, this evidence log, and
`docs/figma-guidelines-export.md`, with permission to run only the authorized
native commands above. Schema, CI, canonical content, dependencies, and git were
not changed, and no exporter was invoked directly; all probes live in the test
file and run via `ruby scripts/test-figma-export.rb`. The real-pack expected
rejection is already exercised inside the test suite
(`test_real_pack_rejected_with_specific_diagnostic`), so no separate exporter
invocation is needed.

The current local suite is 359 assertions / 72 tests. Earlier counts (197/45,
258/50, 313/66, and 349/71) are superseded repair-history, not the current
result.

Independent counterprobes: Codex independently performed 14 additional
counterprobes that PASS (unknown authority, draft pack, wrong governance path,
malformed artifact, exact Markdown/fences, artifact rule consumption, existing
output preservation, positive JSON+schema_version, required owners, YAML
registry projection, and JSON draft/version/channel/canonical-path negatives).
These counterprobes were run by Codex, not by Kiro, and are recorded here as
independent verification rather than as this turn's command output.

No Figma upload has been performed and no human approval has been recorded;
those remain blocked.

## Evidence Table

All test rows below were run on 2026-10-31 via `ruby scripts/test-figma-export.rb`
(exit 0, 359 assertions, 72 tests, ALL TESTS PASSED). The table lists
representative named tests; the full suite includes additional cases covering
JSON grammar/value validation, eligibility/pack/version/channel/id/path/schema
binding, governed YAML registry sources, and strict required-source-metadata and
duplicate JSON/YAML checks.

| # | Check | How verified | Expected | Status |
|---|---|---|---|---|
| 1 | Standalone script loadable (has `require "date"`) | `test_script_standalone_loadable` | `ruby -c` and `require` succeed | passed |
| 2 | Positive synthetic export | `test_positive_synthetic_export` | 7 files + manifest, valid schema, rule-level provenance, input checksums | passed |
| 3 | Multiline body preserved verbatim | `test_multiline_body_preserved_verbatim` | continuation lines, nested lists, code, tables survive | passed |
| 4 | Informative source stays informative | `test_informative_source_not_normative` | workflow with "Rules" heading classified informative | passed |
| 5 | Deterministic bytes + `--check` no-write + no overwrite | `test_determinism_byte_identical_and_check_no_write` | refuses overwrite; check passes without writing | passed |
| 6 | Output tampering detected | `test_check_detects_tampering` | `--check` fails on byte mismatch | passed |
| 7 | Extra/symlink/dir output entries detected | `test_check_detects_extra_file_and_symlink_and_dir` | `--check` rejects unexpected entries | passed |
| 8 | Source content change invalidates check | `test_source_content_change_invalidates_check` | `--check` fails after source edit | passed |
| 9 | Pack/registry/schema/artifact invalidation | `test_pack_registry_schema_changes_invalidate_manifest` | `--check` fails on any input change | passed |
| 10 | Ineligible source lifecycle | `test_negative_source_not_eligible` | fail closed, no output | passed |
| 11 | Unresolved `conflicts_with` | `test_negative_unresolved_conflict` | fail closed | passed |
| 12 | Missing precedence governance | `test_negative_missing_governance_precedence` | fail closed | passed |
| 13 | Broken source reference | `test_negative_broken_reference` | fail closed | passed |
| 13a | Unknown source authority rejected (rogue) | `test_negative_source_unknown_authority` | fail closed, controlled diagnostic, no backtrace | passed |
| 13b | Unknown source document type rejected | `test_negative_source_unknown_document_type` | fail closed, controlled diagnostic, no backtrace | passed |
| 14 | Ineligible artifact status | `test_negative_artifact_status` | fail closed | passed |
| 14a | Null artifact list element controlled | `test_negative_artifact_list_null_element_controlled` | exit 1, cites non-mapping element, no NoMethodError/backtrace, no output | passed |
| 14b | Approved artifact body consumed | `test_artifact_body_consumed_into_export` | sentinel rule appears in tokens.md; block is derived + informative | passed |
| 14c | Naming-contract projected | `test_naming_contract_projected_into_export` | rule/example sentinels in fenced JSON under normative/non-normative headings; derived + informative | passed |
| 14d | Duplicate JSON key (accepted-then-draft) | `test_negative_contract_duplicate_json_key` | fail closed, cites "Duplicate JSON key", no output | passed |
| 14e | Duplicate JSON key (draft-then-accepted) | `test_negative_contract_duplicate_json_key_reverse_order` | fail closed, cites "Duplicate JSON key" (not a generic status failure) | passed |
| 14f | Duplicate NESTED JSON key | `test_negative_contract_duplicate_nested_json_key` | fail closed, cites "Duplicate JSON key" | passed |
| 14g | Unicode-escaped duplicate key collides | `test_negative_contract_unicode_escaped_duplicate_key` | `\u0073tatus` collides with `status` after decoding; fail closed | passed |
| 14h | Strict JSON parser unit behaviour | `test_strict_json_parser_unit_behaviour` | both-order/nested/Unicode duplicates raise; surrogate decode; positive nested baseline == `JSON.parse`, ordinary Hash/Array, stable order | passed |
| 14i | Valid nested contract still exports | `test_strict_json_parser_positive_contract_baseline` | nested rule/example sentinels survive the strict parse at exit 0 | passed |
| 14j | `parse_json_strict` stdlib grammar + value + duplicate guards | `test_parse_json_strict_grammar_and_value_validation` | leading-zero and non-finite numbers rejected; over-100-depth rejected cleanly; valid nested returns `JSON.parse`-equal result in original key order; duplicate still cites "Duplicate JSON key" | passed |
| 15 | Manifest/document status mismatch | `test_negative_artifact_status_mismatch_with_document` | fail closed | passed |
| 16 | Unknown artifact type | `test_negative_unknown_artifact_type` | fail closed, not silently ignored | passed |
| 17 | Non-stable pack channel | `test_negative_pack_channel` | fail closed | passed |
| 18 | Conflicting registry/manifest metadata | `test_negative_conflicting_metadata` | fail closed | passed |
| 19 | Duplicate source id | `test_negative_duplicate_source_id` | fail closed | passed |
| 20 | Duplicate YAML key | `test_negative_duplicate_yaml_key` | fail closed | passed |
| 21 | Invalid UTF-8 source | `test_negative_invalid_utf8_source` | fail closed | passed |
| 22 | Per-file size budget | `test_negative_size_budget` | fail closed, cites UTF-8 bytes | passed |
| 23 | Total size budget | `test_negative_total_budget` | fail closed | passed |
| 24 | Hard cap clamp | `test_hard_cap_clamp` | configured total clamped to 200000 | passed |
| 25 | Output inside vault refused | `test_negative_output_inside_vault` | fail closed | passed |
| 26 | Output parent symlink into vault refused | `test_negative_output_parent_symlink_into_vault` | fail closed | passed |
| 27 | Source symlink escape refused | `test_negative_source_symlink_escape` | fail closed | passed |
| 28 | Traversal artifact path | `test_negative_path_traversal_reference` | fail closed | passed |
| 29 | Category without eligible source | `test_negative_category_without_source` | fail closed, refuses fabrication | passed |
| 30 | Schema violation enforced | `test_negative_schema_violation` | fail closed | passed |
| 31 | Unsupported schema keyword rejected | `test_negative_unsupported_schema_keyword` | fail closed | passed |
| 32 | Unsupported schema dialect rejected | `test_negative_unsupported_schema_dialect` | fail closed | passed |
| 33 | Unsupported body content rejected | `test_negative_unsafe_body_content` | fail closed (conservative adapter restriction) | passed |
| 34 | Broken local link in body rejected | `test_negative_broken_local_link_in_body` | fail closed | passed |
| 35 | Current real pack rejected with specific diagnostic | `test_real_pack_rejected_with_specific_diagnostic` | fail closed, cites channel eligibility | passed |
| 36 | No canonical mutation | `test_no_canonical_mutation` | canonical snapshot unchanged | passed |
| 37 | Sentinel preserved + symlink cannot mutate vault | `test_sentinel_and_symlink_cannot_mutate_vault` | preexisting file untouched, canonical snapshot unchanged | passed |
| 38 | Real Figma upload | manual, requires approved export + Figma access | n/a | BLOCKED |
| 39 | Figma-agent task set run | manual, requires approved export + Figma access | n/a | BLOCKED |

## Outstanding Definition of Done

The following remain open and require separate, human-approved work:

- Promote an eligible governance pack (stable channel, accepted/stable
  artifacts, source references at accepted/stable + source authority). Not done
  here; status promotion is out of scope.
- Produce an approved authoritative export from an eligible pack.
- Obtain Figma edit access for the target file/project.
- Execute the manual Figma import procedure and the Figma-agent task set against
  a supplied Figma library.
- Confirm current Figma UI steps against the live Figma version.
- Record real import evidence (pack version, channel, per-file and per-source
  checksums) replacing the BLOCKED rows.

- Run CI on the pull request. CI is PENDING remote PR execution; it has not been
  observed green here and must not be claimed green until the remote run reports.

Until these are complete and approved, issue 64 remains OPEN, no merge has
occurred, and this document remains a draft. The small repeatable Figma-agent
task set and human evidence review remain documented for later, approved export
and library access.

## Independent Codex verification (2026-10-31)

Codex independently repeated the 66 export tests (313 assertions), governance
pack validator, project-projection checks, and both audit self-tests: all exited
0. Fourteen additional counterprobes passed against external synthetic fixtures,
covering unknown authority, draft pack metadata, canonical governance identity,
malformed artifacts, exact Markdown/fence preservation, read-only checks and
authority-input invalidation, artifact content consumption, existing-output
preservation, a positive JSON baseline with schema version, required source
owners, governed YAML registry projection, and JSON lifecycle/version/channel/
canonical-path rejection. These are tooling checks, not real Figma-agent evidence.

The final Kiro ACP documentation/handoff session was
`sess_02d3aeae-0112-44f0-af82-a88027c5411d`, using installed Kiro CLI 2.34.2 via
`kiro-cli acp --agent-engine=v3 --auth-method=cli`. Its observed terminal result
was `end_turn`, all tools were complete, all three final test commands returned
0, and the worker was reaped. The final turn could write only the two new docs;
Codex checked that all previously verified code/schema/CI bytes stayed unchanged.
Earlier failed tests and scope-stopped attempts were not counted as acceptance.

The proposed change is based on main commit
`995c580ce6f162fbf9baa2f5e4819da1aa3384d8`. The bounded repository paths are the
two new scripts, the new manifest schema, the two new docs, and the existing
CI workflow. Canonical governance, pack, registry, source documents, and existing
projection tooling are unchanged by this proposal. Local ACP orchestration and
profiles are outside the proposed repository changes.

Verified content SHA-256 values (snapshot from the earlier Codex verification;
the two edited scripts below were changed again by the 2026-10-31 follow-up fix,
so their hashes here are SUPERSEDED and the final values are recorded by Codex at
commit time):

- `scripts/export-figma-guidelines.rb`: `81a76ca2c89a67012cd2902a8714ff59d4033690565cf5579d7fa5ecd3d28125` (superseded by the follow-up fix)
- `scripts/test-figma-export.rb`: `a5370eec4cac40b9ea98e651a3772b3deb8e9ceb6787f329552349d7194667ce` (superseded by the follow-up fix)
- `schemas/figma-export-manifest.schema.json`: `7b6dff3ce9a5115eb2e73ebede39303ad4db30681208954272cc7b9e142b6c44` (unchanged)
- `.github/workflows/ci.yml`: `885da0643172d65aec0c381411b24c268ea5adf7584c11c3fa32c1eaefe063bb` (unchanged)

Local baseline audit limitation: the unmodified full frontmatter audit
(`schemas/validate-vault-audits.rb --audit frontmatter --format json`) cannot
complete on system Ruby 2.6.10 because its existing `repository_names` method
uses `Array#filter_map`. This failure was not counted as a pass or repaired
outside scope. Both audit self-tests passed; a focused metadata check of the
two new documents also passed. The exporter and its 66 tests run on this Ruby.
### CI repair notes (2026-11-01, follow-up): fail CLOSED on duplicate-scanner uncertainty

An independent Codex review found a fail-OPEN branch in `parse_json_strict`.
After the stdlib parser accepted an input, the duplicate-key scanner was run,
but its `rescue StrictJSONParser::ParseError` branch returned `nil` and then let
the method return the stdlib `parsed` result. That treated an INCOMPLETE or
FAILED duplicate scan as a successful validation: the stdlib grammar verdict
cannot prove the ABSENCE of a duplicate object key (`JSON.parse` silently keeps
the last value for a repeated key), so a document whose duplicate scan did not
complete could still be returned as validated.

Fix (small, one branch only), in `scripts/export-figma-guidelines.rb`:

- The scanner's `StrictJSONParser::ParseError` rescue no longer returns `nil`
  and no longer falls through to `parsed`. It now raises a controlled
  `ExportError`: "Cannot validate duplicate JSON keys in <where>: duplicate
  scanner could not complete (unsupported validation path): ...". It describes
  an unsupported validation path rather than re-declaring the stdlib-valid input
  ungrammatical, and `parse_json_strict` never returns a parsed result after
  scanner uncertainty.
- All prior behaviour is preserved: stdlib `JSON.parse` grammar/finite/nesting
  guards, the `JSON.generate(allow_nan: false)` finite guard, the explicit
  "Duplicate JSON key" diagnostic, and returning the standard stdlib result only
  after a SUCCESSFUL complete scan.

Regression added (inside `scripts/test-figma-export.rb`):
`test_parse_json_strict_fails_closed_on_scanner_uncertainty` temporarily
replaces `StrictJSONParser.parse` with a singleton method that raises its
`ParseError` for an otherwise-valid JSON input, asserts `parse_json_strict`
RAISES an `ExportError` (never returns a value), checks the diagnostic explains
the scan could not complete and does not re-declare the input ungrammatical, and
restores the original singleton method in an `ensure` so no other test is
affected. Normal input, both duplicate orders, nested/Unicode-escaped,
leading-zero, and finite/depth cases all remain green.

New local result (2026-11-01 follow-up, Ruby 2.6.10):
`ruby scripts/test-figma-export.rb` exits 0 with 365 assertions passing, 0
failures across 73 tests (ALL TESTS PASSED).
`ruby schemas/validate-governance-packs.rb` exits 0;
`ruby scripts/generate-project-projections.rb --check` exits 0;
`ruby -c` on both edited scripts reports Syntax OK. Only
`scripts/export-figma-guidelines.rb` and `scripts/test-figma-export.rb` were
edited (one error branch plus its regression); schema, CI, dependencies, and
canonical content were not changed.

Hosted status: the hosted CI repair remains PENDING and is not yet green. The
initial failed hosted run on head `4e4a7fbee0288e973321c93cdf2d1d4baeaf7af2`
(runs/41183607422) is preserved above and is not marked green. No human approval
is invented. Codex independently verifies and pushes to the existing draft PR65;
no git, push, PR, merge, or Figma actions were taken in this session.

## Final independent verification after CI portability repair

Codex independently repeated the repaired suite on 2026-10-31: 365 assertions
across 73 tests passed, as did governance-pack validation and project-projection
checks. Seventeen additional independent counterprobes passed, including both
duplicate-key orders, nested and Unicode-equivalent keys, standard JSON grammar,
finite-value/nesting rejection, and fault injection proving that a failed
duplicate scan blocks acceptance. These later counts supersede earlier local
counts in this history; they are not real Figma-agent evidence.

The final Kiro correction session was
`sess_9cfb9ee4-96d2-48f8-bbdd-cfa44f75d07d` via actual ACP, with `end_turn`,
complete tools, all final authorized checks returning 0, and the worker reaped.
The initial hosted failures at commit `4e4a7fb` remain recorded above. Hosted
validation of this correction is pending a new push and is not claimed here.

Final independently checked source/schema/CI SHA-256 values for this correction:

- `scripts/export-figma-guidelines.rb`: `3f3c200887779b3be241fe7ad33ed377b2095fccc2cc42c003fb9bac3d548a14`
- `scripts/test-figma-export.rb`: `f5bdb5941181a49d40a2b24ecba37a56627ffc43ac0303ae8680f6af5c69acd9`
- `schemas/figma-export-manifest.schema.json`: `7b6dff3ce9a5115eb2e73ebede39303ad4db30681208954272cc7b9e142b6c44`
- `.github/workflows/ci.yml`: `885da0643172d65aec0c381411b24c268ea5adf7584c11c3fa32c1eaefe063bb`
