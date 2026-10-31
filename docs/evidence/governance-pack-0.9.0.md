---
id: docs.evidence.governance-pack-0.9.0
title: Governance Pack 0.9.0 Release Review
type: lesson
status: draft
owners:
  - ui-foundations
created: 2026-10-31
updated: 2026-10-31
authority: supporting
summary: Records proposed lifecycle transitions, source review, validation and publication boundaries for Governance Pack 0.9.0.
related:
  references:
    - governance.lifecycle
    - governance.precedence
    - registry.governance-packs
    - export-pack.governance.manifest
    - docs.figma-guidelines-export
---

# Governance Pack 0.9.0 Release Review

## Approval Boundary

Issue: https://github.com/tbielich/ui-foundations-vault/issues/67

This branch proposes a first stable-channel consumption release. Its accepted
source/artifact metadata and stable channel describe the requested post-review
state, not an approval already given. Owner review and merge are the acceptance
step for these transitions. Until then, generated output is a release candidate
and must not replace approved consumer guidance. No release tag, Figma upload,
consumer adoption, or cross-repository write is performed by this proposal.

The previous Figma test used manually curated TEST ONLY Markdown. It demonstrated
readability and real library use, but did not approve Vault sources or prove the
exporter produced those particular files. This release instead exercises the
exporter against the actual candidate sources and retains negative eligibility
tests. Final Figma-agent evaluation of the candidate remains outstanding.

## Explicit Lifecycle Decisions Requested

| Source | Previous state | Proposed state | Review basis |
|---|---|---|---|
| `registry/sync-contract.yml` | draft | accepted | Keeps implementation/build/tests local; reviewed text consumption; no silent overwrite or automatic cross-repo mutation. Body unchanged. |
| `reference/terminology.md` | review | accepted | Defines stable IDs and shared vocabulary, not tool-generated asset names. Body unchanged. |
| `patterns/schemas/pattern.schema.md` | draft | accepted | Explicit Required/Optional/Out-of-scope/Open-question classifications, native/ARIA precedence and naming boundaries. Clarifies the already accepted token ADR's compatibility exception and makes pattern-ID prefixes explicit. |
| `decisions/uif-public-api-namespace.md` | review | accepted | Public macro invocation/tag namespace only; does not approve adjacent JavaScript/package renames or migration behavior. Body unchanged. |
| `foundations/accessibility-principles.md` | review | accepted | Durable perceivable/operable/understandable/robust, semantic, focus, color-independent and recovery principles. Body unchanged; does not claim implementation compliance. |
| `registry/governance-packs.yml` | review | accepted | Release/version/channel authority, with previous release history retained. |

The manifest, README, changelog and five derived artifacts (including JSON naming
contract) also propose accepted status; the pack channel becomes stable. Derived
material remains `authority: derived` and is not relabelled canonical source.
Review here must cover the source documents, not merely the generated output.

Already accepted/stable sources remain at their existing lifecycle:
`governance.precedence`, `governance.lifecycle`,
`principle.foundation.design-principles`, and
`adr.token-model-and-figma-projection`. No new source ID is introduced.

The three draft pattern templates remain draft and unchanged. The JSON naming
contract no longer treats them as canonical sources; their naming guidance is
already governed by the explicit pattern schema. Removing template references
does not approve template examples. Related source IDs in document metadata
remain relationships, not an automatic transitive promotion of all related
Vault documents.

## Source and Meaning Review

- Naming contract 0.3.0 retains public CSS, custom-property, macro, Custom Element,
  proof-token, assumption-token and pattern-ID rules and non-normative examples.
  Its schema remains 1.0.0; the additive compatibility note expresses the
  already accepted token ADR rather than creating a new exception.
- The accepted token ADR supplies the actual layer model and separates Brand,
  Scheme and Scale. Its legacy primitive CSS/export-path exception takes
  precedence over blanket interpretations of the public component namespace.
  No primitive migration or token IDs/values are invented by this release.
- Surface, Content, Foreground and Border stay distinct. Brand hue/inversion
  and contrast are independent gates; every affected Brand × Scheme × State
  combination requires evidence. UIF remains separate from TUI UILib.
- Component guidance cites the schema's native semantics, structure and ownership
  boundaries. Accessibility guidance includes the accepted token ADR and the
  accessibility-principle proposal; static designs do not certify runtime
  keyboard, screen-reader or focus behavior.
- Runtime owners retain implementation/tests/build ownership. A stable pack does
  not authorize changes in a consumer. Existing consumed pack snapshots are not
  rewritten; adoption needs a reviewed local consumer change.

## Reproduction and Size

From this branch (or the reviewed merged source revision):

```sh
ruby schemas/validate-governance-packs.rb
ruby scripts/test-figma-export.rb
ruby scripts/generate-project-projections.rb --check
ruby schemas/validate-vault-audits.rb --self-test-contract
ruby schemas/validate-vault-audits.rb --self-test-frontmatter
ruby scripts/export-figma-guidelines.rb --vault-root . --out /tmp/figma-pack-0.9.0 --max-total-bytes 200000
ruby scripts/export-figma-guidelines.rb --vault-root . --out /tmp/figma-pack-0.9.0 --max-total-bytes 200000 --check
```

Choose a fresh output directory; the exporter never overwrites an existing one.
The full-fidelity sources are repeated across guideline categories. This pack
requires the explicit 200000 UTF-8-byte budget; the conservative 100000-byte
default must still reject it. The 200000-byte hard cap and 65536-byte per-file
limit are unchanged. A smaller future projection would require a separately
reviewed content strategy; this release does not silently summarize or truncate
source bodies. Exact output sizes/hashes are in the candidate manifest.

Only the seven Markdown files are Figma upload inputs. Keep `manifest.json`,
source revision, checksums and this review record outside the uploaded inputs.
The registry's `git_ref: pending-review` remains explicit until release review;
it is not an immutable release locator. Reproduction must use the exact Git
commit accompanying the delivered candidate and its input hashes, not a moving
`main` branch or an inferred release tag.

## Validation and Remaining Acceptance

The real-source integration test checks version/channel, seven files, every
output hash, `--check` and byte-identical second generation. A mutated external
copy of the real pack on the review channel must still fail with a specific
channel-eligibility diagnostic and no output. A separate regression proves the
conservative default-budget rejection. Real successful export non-mutation and
pre-existing-output/symlink protection are exercised with a sufficient budget,
so an unrelated eligibility/size failure cannot make those protections appear
proven. Synthetic malformed-source, schema, path, JSON/YAML and oversize tests
remain intact. The exporter implementation and its safety gates are unchanged.

An initial local run found that the old sentinel test was stopped by the size
budget before reaching output protection. It was corrected to supply the
explicit budget and to require the overwrite-specific diagnostic. That failed
run was not counted as a pass.

Before publication: owner accepts all source/status decisions and the derived
release, hosted checks pass on the exact PR head, and the final source commit is
recorded with the export. Then run the documented manual Figma import and
independent frame acceptance. A passing local or hosted test is not human
approval, a published Figma library, or functional accessibility certification.

## Captured Local Results (2026-10-31)

- Export suite: 392 assertions passed, zero failures, 75 tests.
- Governance-pack validator, project projections, contract/frontmatter audit
  self-tests, Ruby syntax and `git diff --check`: passed.
- Real candidate export plus `--check`: passed; seven Markdown files, 188744
  UTF-8 bytes combined, largest file 55435 bytes (below 65536 per-file limit).
- Independent readback checked 39 attributed source blocks covering 14 unique
  source/artifact inputs: SHA-256, eligible declared lifecycle, derived authority,
  exact Markdown bodies, output entries and size totals passed. Registry,
  manifest, repos and schema input hashes matched. Draft templates were absent.
- No exporter implementation change, consumer code change, source-template
  promotion, Figma write, merge, release tag or publication was performed.

Hosted checks on the exact submitted PR head are recorded by GitHub and must be
reviewed independently of these local results. Re-export from that exact commit
or the reviewed merge commit; retain its immutable identifier with the manifest.
