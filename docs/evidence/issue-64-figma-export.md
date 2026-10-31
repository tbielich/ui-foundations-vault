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

## Current Pack Reality

The current `governance-pack` is version `0.8.0` on the `review` channel, with
`review`/`draft` artifacts. An authoritative export of the current pack is
expected to FAIL CLOSED. This is encoded as a passing negative test
(`test_real_pack_rejected_with_specific_diagnostic`, which asserts the specific
channel eligibility diagnostic, exit 1, and no output).

There is no approved export and no supplied Figma library. Real Figma import
steps therefore cannot be executed and are marked BLOCKED / not-run.

## Verification Status

The three checks below were re-run on 2026-10-31. Actual results captured this
turn:

| Command | Exit code | Result |
|---|---|---|
| `ruby scripts/test-figma-export.rb` | 0 | 313 assertions passed, 0 failures across 66 tests (ALL TESTS PASSED) |
| `ruby schemas/validate-governance-packs.rb` | 0 | Governance pack validation passed |
| `ruby scripts/generate-project-projections.rb --check` | 0 | PASS chatgpt-project; PASS kiro-uif-int (no drift) |

Scope of this turn: documentation/handoff only, with native write access to
exactly two docs (this evidence log and `docs/figma-guidelines-export.md`) and
permission to run exactly the three commands above. No code, schema, or CI was
changed this turn, and no exporter was invoked directly. An earlier turn's
attempt to run a direct real-pack export fell outside the allowlist and was
stopped by the coordinator; that transport-scope stop is distinct from the
passing checks here, prior effects were reconciled, and no worker remains. The
real-pack expected rejection is already exercised inside the test suite
(`test_real_pack_rejected_with_specific_diagnostic`), so no separate exporter
invocation is needed.

The final suite is 313 assertions / 66 tests. Earlier intermediate counts
(197/45, then 258/50) are superseded repair-history, not the current result.

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
(exit 0, 313 assertions, 66 tests, ALL TESTS PASSED). The table lists
representative named tests; the full suite includes additional cases covering
JSON eligibility/pack/version/channel/id/path/schema binding, governed YAML
registry sources, and strict required-source-metadata and duplicate JSON/YAML
checks.

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

Verified content SHA-256 values:

- `scripts/export-figma-guidelines.rb`: `81a76ca2c89a67012cd2902a8714ff59d4033690565cf5579d7fa5ecd3d28125`
- `scripts/test-figma-export.rb`: `a5370eec4cac40b9ea98e651a3772b3deb8e9ceb6787f329552349d7194667ce`
- `schemas/figma-export-manifest.schema.json`: `7b6dff3ce9a5115eb2e73ebede39303ad4db30681208954272cc7b9e142b6c44`
- `.github/workflows/ci.yml`: `885da0643172d65aec0c381411b24c268ea5adf7584c11c3fa32c1eaefe063bb`

Local baseline audit limitation: the unmodified full frontmatter audit
(`schemas/validate-vault-audits.rb --audit frontmatter --format json`) cannot
complete on system Ruby 2.6.10 because its existing `repository_names` method
uses `Array#filter_map`. This failure was not counted as a pass or repaired
outside scope. Both audit self-tests passed; a focused metadata check of the
two new documents also passed. The exporter and its 66 tests run on this Ruby.
