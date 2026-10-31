---
id: docs.figma-guidelines-export
title: Figma Guidelines Export
type: workflow
status: draft
owners:
  - ui-foundations
created: 2026-10-30
updated: 2026-10-31
authority: supporting
summary: Describes the read-only deterministic adapter that projects eligible governance guidance into Figma-consumable guideline files.
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
  references:
    - registry.governance-packs
    - export-pack.governance.manifest
    - specification.vault-metadata
---

# Figma Guidelines Export

## Goal

Provide a deterministic, read-only adapter that projects eligible UI Foundations
governance guidance into a small set of Figma-consumable guideline files plus a
machine-readable manifest.

The adapter is a projection tool. It does not create, promote, publish, or
mutate canonical Vault content, and it never writes into the Vault tree. Derived
output does not become normative by being copied. Normative authority remains
with the cited source documents at their recorded content checksums, under the
precedence and lifecycle governance.

Each guideline file preserves the source document body verbatim (byte-for-byte,
headings not demoted and trailing whitespace not stripped) inside a clearly
attributed per-source block. Whether a block is normative or informative is
decided by the source's governed document type and the normative defaults in
`governance.precedence`, not by heading text. An informative source (for example
a workflow or pattern) never becomes normative because one of its headings
contains the word "rules".

Alongside the canonical source blocks, each selected approved pack artifact is
consumed faithfully:

- A Markdown artifact body is reproduced verbatim as an attributed DERIVED /
  INFORMATIVE block (artifact id, path, status, type, content checksum, and the
  backing canonical source references). Checksums alone do not consume artifact
  content; the artifact's own body (for example a `## Rules` section) is emitted
  in full. Derived artifact text is never relabelled as authoritative original
  governance.
- A naming-contract JSON artifact is deterministically projected into guideline
  Markdown: its `rules` object and `non_normative_examples` are re-emitted with
  `JSON.pretty_generate` inside fenced JSON blocks, under explicit "Normative
  constraints" and "Non-normative examples" headings, preserving the contract's
  declared `rules_are_normative: true` / `examples_are_normative: false`
  distinction. The projection records the contract id, path, status, channel,
  authority, version, checksum, and canonical source references. No rules,
  aliases, or token ids are invented; the projection is a derived view, not
  authoritative original governance.

## Scope and Boundaries

- Read-only. No canonical source edits, no status promotion, no publishing, no
  git mutation, no dependencies, no network.
- Fails closed. If any eligibility or safety invariant fails, the adapter prints
  actionable diagnostics and writes no partial output.
- External output only. Generated files must be written to a directory outside
  the Vault.

## Eligibility Model

Authoritative export requires all of the following:

- Pack channel is `stable` in `registry/governance-packs.yml`.
- Registry version/channel match the pack manifest (no conflicting metadata).
- `governance.precedence` and `governance.lifecycle` resolve and are `accepted`
  or `stable`, so type-based normativity classification can be trusted.
- Each contributing artifact has status `accepted` or `stable`, a known governed
  type, and (for Markdown artifacts) a frontmatter status matching the manifest.
  Unknown artifact types fail closed rather than being silently ignored.
- A naming-contract JSON artifact satisfies the required contract shape
  (`schemas/naming-contract.schema.yml`) and is then deterministically projected
  into guideline Markdown. There is no governance requiring the JSON->Markdown
  mapping to be approved before it can be implemented for review, so the adapter
  no longer blanket-rejects naming contracts; the projection is reviewed in the
  draft PR.
- Each exported source reference resolves to a governed document with status
  `accepted` or `stable`, a document `type` within the canonical vault-metadata
  taxonomy, and an `authority` within the vault-metadata enum (`source`,
  `supporting`, `derived`, `example`). An unknown `type` or `authority` is
  malformed metadata and fails closed with a controlled diagnostic. Normativity
  is gated by authority above the type default: only `authority: source`
  material can be normative.
- No exported source declares an unresolved `conflicts_with` relationship.
- Declared `compatible_repo_types` overlap the applicable export repo types
  (`docs`, `runtime`), and those types exist in `registry/repos.yml`.
- Source references are unambiguous (no broken or duplicate ids), all reads go
  through the safe-path resolver, YAML metadata is valid (no duplicate keys or
  aliases), and source bodies are valid UTF-8.
- Naming-contract JSON grammar and values are validated by the Ruby standard
  library JSON parser first (`JSON.parse` with `create_additions: false`,
  `allow_nan: false`, and an explicit `max_nesting` of 100). This rejects
  invalid JSON grammar (for example a leading-zero number such as `01`) and
  non-finite values (for example `1e999`, which would decode to `Infinity` and
  could not be safely JSON-generated afterwards), and rejects an over-deep
  document cleanly before any recursive descent. The parsed value is then
  round-tripped through `JSON.generate(..., allow_nan: false)` as a finite /
  JSON-generatable guard. A self-contained scanner is run over the same text
  ONLY to detect duplicate object keys at any nesting depth, in either order,
  treating a Unicode-escaped key (e.g. `\u0073tatus`) as colliding with its
  decoded plain-text equivalent; duplicate keys fail closed with an explicit
  "Duplicate JSON key" diagnostic and no partial export, so a repeated key
  cannot overwrite status or source metadata during parsing. On success the
  standard parser result is returned (ordinary Hash/Array values with object
  keys in their original textual order), not the scanner's own numeric/string
  interpretation. Any stdlib parser, nesting, or generator error is converted to
  a controlled fail-closed diagnostic. If the duplicate-key scanner itself
  cannot complete on a stdlib-valid input, the adapter fails CLOSED rather than
  fall through: because the stdlib result cannot prove the absence of a
  duplicate key, it raises a controlled "duplicate scanner could not complete"
  error and never returns a parsed value after scanner uncertainty.
- Artifact and source paths are safe (no absolute paths, traversal, or symlink
  escapes). Each artifact list entry is a well-formed mapping with the required
  id/type/path/status; a null or scalar list entry fails closed with a
  controlled diagnostic (never an unhandled `NoMethodError`).
- Source bodies satisfy the adapter's conservative content restrictions. These
  are adapter choices, not verified Figma limitations: the verified Figma help
  establishes accepted extensions, access, size, and the upload flow, but does
  not establish that Markdown images or raw HTML are unsupported in guideline
  files. The adapter conservatively refuses raw HTML/scripts, image embeds, and
  Vault-relative links (which have no reviewed canonical-URL mapping yet and
  would dangle once exported), and labels each refusal as a conservative adapter
  restriction rather than a Figma fact.
- Each guideline category has eligible source coverage. Categories without an
  eligible source fail closed rather than fabricating content. Topic text is
  never invented from naming rules.

The current `governance-pack` is version `0.8.0` on the `review` channel with
`review`/`draft` artifacts. An authoritative export of the current pack is
therefore expected to fail closed. That rejection is the correct outcome, not a
successful export.

## Output

The adapter emits exactly seven guideline files and one manifest:

- `overview.md`
- `foundations.md`
- `tokens.md`
- `components.md`
- `composition.md`
- `accessibility.md`
- `anti-patterns.md`
- `manifest.json`

The seven guideline Markdown files are the only files uploaded to Figma. The
`manifest.json` is local provenance and is not uploaded; it does not count
toward the Figma upload budget.

Each guideline file carries one attributed block per contributing canonical
source and one per consumed pack artifact. Each block records the id, path,
governed/artifact type, lifecycle status, authority, content checksum, and
whether it is normative or informative. Source blocks reproduce the source body
verbatim; Markdown artifact blocks reproduce the artifact body verbatim as a
derived/informative block; a naming-contract block emits a deterministic JSON
projection of the contract's normative rules and non-normative examples.

## Verified Figma Reference

The single external source relied on for file format, upload flow, and access is
Figma's help article "Add guidelines files to a design library":

- https://help.figma.com/hc/en-us/articles/23540976923671-Add-guidelines-files-to-a-design-library

Verified 2026-10-30 for accepted file extensions, who can upload, size limits,
and the upload flow. Everything the adapter refuses beyond what this article
states (raw HTML/scripts, image embeds, Vault-relative links) is a conservative
adapter restriction and is labelled as such, not a vendor-stated limitation.
Figma's UI and article content can change; reconfirm against the live article
before relying on specific menu labels or limits.

## Budgets

Figma's "Add guidelines files to a design library" documentation (verified
2026-10-30, URL above) establishes accepted file extensions, who can upload, and
size limits for guideline files: it accepts Markdown guideline files and
documents a combined upload size limit. The adapter adopts a conservative budget within that
documented limit. The recommendation to keep files small and focused is an
adapter convention, not a verified Figma requirement.

Accordingly:

- The default total guideline budget is a conservative `100000` UTF-8 bytes.
- The default per-file budget is `65536` UTF-8 bytes.
- An immutable compatibility cap of `200000` UTF-8 bytes applies to the combined
  guideline files. The configured total budget is always clamped to this cap and
  cannot be raised above it from the CLI.
- Only the guideline files count toward these budgets; the manifest does not.

## Manifest

The manifest conforms to `schemas/figma-export-manifest.schema.json`. The
adapter first rejects any schema whose dialect or keywords the bundled validator
does not implement (so it never claims a complete JSON Schema implementation),
then validates the generated manifest against that committed schema before
writing output. Key fields:

- `generator`: adapter id and version.
- `generated_from`: pack id, version, channel, registry and manifest paths.
- `input_checksums`: SHA-256 of the registry, pack manifest, manifest schema,
  and each consumed artifact. Any change to these inputs changes the manifest
  bytes, so `--check` fails when a pack, registry, schema, or consumed artifact
  changes.
- `size_unit`: always `utf-8-bytes`.
- `manifest_uploaded_to_figma`: always `false`.
- `budgets`: `max_file_bytes`, `max_total_bytes`, and the immutable
  `hard_max_total_bytes`.
- `total_bytes`: total UTF-8 byte size of all guideline files.
- `files[]`: per-file category, path, byte size, `sha256`, and `source_blocks`
  with per-source id, path, type, status, authority, normativity, and `sha256`.

## CLI

The adapter uses Ruby stdlib only.

Generate (external output directory required):

```
ruby scripts/export-figma-guidelines.rb --out /tmp/figma-guidelines --vault-root .
```

Verify existing output byte-for-byte without writing:

```
ruby scripts/export-figma-guidelines.rb --out /tmp/figma-guidelines --vault-root . --check
```

Size budgets are expressed in UTF-8 bytes and are configurable:

```
ruby scripts/export-figma-guidelines.rb --out /tmp/figma-guidelines \
  --max-file-bytes 65536 --max-total-bytes 100000
```

The output directory must not already exist. The adapter refuses to overwrite or
delete an existing output directory, refuses the Vault root or any ancestor of
it, resolves any symlinked parent to its physical path before validating, stages
output in a fresh temporary directory inside the verified parent, and renames it
atomically into the absent target. It only cleans up the staging directory it
created.

`--check` performs no writes. It regenerates the plan in memory and compares the
exact output file set, each file's bytes, and the manifest bytes against the
on-disk output. It rejects symlinked entries and any entry that is not one of
the expected regular files (including unexpected directories). Any missing file,
unexpected entry, or byte mismatch (tampering, or a changed pack, registry,
schema, or source) fails the check.

## Manifest Verification

To confirm an export was not tampered with:

1. Re-run with `--check` against the same vault revision and output directory.
2. Independently, recompute SHA-256 over each guideline file and compare to the
   matching `files[].sha256` in `manifest.json`.
3. Confirm `total_bytes` equals the sum of `files[].bytes`.
4. Confirm each `files[].source_blocks[].sha256` matches the current checksum of
   the cited source document in the Vault, and that `input_checksums` still
   match the registry, pack manifest, schema, and consumed artifacts.

A mismatch means the output no longer matches the eligible source content and
must be regenerated from an eligible pack.

## Manual Figma Import Procedure

This procedure uploads the generated guideline Markdown files to a Figma
published design library, following Figma's "Add guidelines files to a design
library" documentation (verified 2026-10-30 for accepted extensions, access,
size limits, and the upload flow). Figma's interface can change; confirm the
current menu labels in your version before relying on them.

Prerequisites:

- A published design library (guidelines attach to a published library).
- Edit access to that library through your team's normal Figma access process.
- A Figma plan that supports library guidelines (per Figma's documentation,
  this is a Professional, Organization, or Enterprise capability).

Steps:

1. Confirm you have a generated, eligible export (see Eligibility Model). If the
   authoritative export fails closed, there is nothing approved to upload yet.
2. Verify the manifest and per-file checksums (see Manifest Verification).
3. In the file for the published design library, open the Figma main menu and go
   to **Library > Manage guidelines**.
4. Choose **Upload** and select the generated guideline Markdown files (the
   seven `*.md` files). Do not upload `manifest.json`; it is local provenance
   and is kept outside Figma.
5. Confirm the combined upload stays within Figma's limits (recommended under
   ~100 KB combined, hard limit ~200 KB combined). The adapter already enforces
   this, so an eligible export is within range.
6. Choose **Apply changes** to attach the guidelines to the published library.
7. Keep the `manifest.json` provenance (pack version, channel, and per-file and
   per-source checksums) in the Vault or your tracking system so reviewers can
   trace each uploaded guideline back to its eligible source.
8. Do not mark uploaded content as approved library guidance until the Vault
   export itself is approved and an eligible pack exists.

This procedure refers to Figma design library guidelines, not Figma Make or any
other feature. This adapter does not provision Figma access and performs no
network calls to Figma.

## Repeatable Figma-Agent Task Set

A small, repeatable task set for a Figma-capable agent, once an approved export
exists:

1. Fetch the latest eligible export directory and its `manifest.json`.
2. Verify the export (`--check` plus independent checksum recomputation).
3. Open **Library > Manage guidelines** on the target published design library.
4. Upload the seven guideline Markdown files via **Upload**, preserving each
   file's per-source attribution blocks, and choose **Apply changes**. Do not
   upload `manifest.json`.
5. Attach provenance (pack version, channel, source ids and checksums) in the
   Vault or tracking system.
6. Record an evidence entry (see the evidence log) noting which pack version and
   checksums were uploaded.

## Status

This is a draft implementation. The adapter and tests run against explicitly
synthetic fixtures and against the current real pack, which is correctly
rejected (its channel is `review`). The 2026-10-31 repair turn fixed four
independent acceptance failures (unknown source authority/type accepted,
`artifacts: [null]` crashing with an unhandled `NoMethodError`, approved
artifact bodies omitted from the export, and the blanket naming-contract
rejection) and added regression tests for each. A subsequent 2026-10-31
follow-up fixed two concrete false acceptances in the JSON parsing path: a
leading-zero number (`{"a":01}`) and a non-finite number (`{"a":1e999}`) were
accepted by the handwritten scanner. `parse_json_strict` now validates JSON
grammar and finite values with the Ruby standard library parser first (and a
`JSON.generate` finite guard) and keeps the self-contained scanner only for
duplicate-key detection, returning the standard parser result. All retained
protections (hard cap, no-overwrite, path/symlink safety, byte-preserved bodies,
strict YAML, schema enforcement, `--check` invalidation, real-pack eligibility,
and duplicate JSON/YAML-key rejection) still hold.

No approved export, no eligible stable pack, and no Figma library have been
produced. Real Figma upload and human review remain blocked. See the evidence
log for the outstanding Definition of Done.
