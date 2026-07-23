---
id: publication.audit.vault-frontmatter-triage
title: Vault Frontmatter Audit Triage
type: publication
status: review
owners:
  - ui-foundations
created: 2026-07-23
updated: 2026-07-23
authority: supporting
summary: Classifies current vault-frontmatter-audit findings without changing metadata, governance, or repository content.
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
    - governance.verification-review
  references:
    - workflow.operational.vault-frontmatter-audit
    - registry.vault-audits
    - schema.vault-audit-result
    - specification.vault-metadata
    - specification.document-structure
    - reference.relationship-types
    - reference.document-types
---

# Vault Frontmatter Audit Triage

## Summary

This report triages the current output of:

```sh
ruby schemas/validate-vault-audits.rb --audit frontmatter --format json
```

The audit emitted 62 findings:

| Status | Count |
|---|---:|
| `fail` | 53 |
| `warn` | 9 |

This triage does not fix repository content. It classifies each current finding so future work can separate safe metadata cleanup from governance or specification decisions.

## Findings by rule

| Rule ID | Status | Count | Affected document types | Category | Likely root cause |
|---|---|---:|---|---|---|
| `frontmatter.present` | `fail` | 1 | unknown | defect | One derived projection still uses HTML-comment metadata instead of vault YAML frontmatter. |
| `frontmatter.related.key` | `fail` | 22 | pattern, checklist, experiment | specification-gap | Several files use `related.derived_from`, but `derived_from` is not an allowed relationship key. |
| `frontmatter.related.target` | `fail` | 27 | adr, pattern | mixed | One ADR references an artifact id that is not a document id; pattern provenance targets use external or local paths where relationships require document ids. |
| `frontmatter.title_heading` | `warn` | 9 | adr, export-pack, publication, template | accepted-exception | Several document families intentionally include a type prefix, placeholder heading, or slide title that does not exactly equal `title`. |
| `frontmatter.type` | `fail` | 3 | checklist, experiment | specification-gap | Existing support files use `checklist` and `experiment`, but those values are not in the canonical document type taxonomy. |

## Classification

Each finding is assigned exactly one category.

| Finding group | Count | Category | Affected paths |
|---|---:|---|---|
| Missing YAML frontmatter | 1 | defect | `exports/perplexity/research-projection.md` |
| `related.derived_from` key | 22 | specification-gap | `patterns/base/accordion.pattern.md`, `patterns/base/avatar.pattern.md`, `patterns/base/badge.pattern.md`, `patterns/base/button.pattern.md`, `patterns/base/calendar.pattern.md`, `patterns/base/checkbox.pattern.md`, `patterns/base/divider.pattern.md`, `patterns/base/form.pattern.md`, `patterns/base/icon.pattern.md`, `patterns/base/input.pattern.md`, `patterns/base/label.pattern.md`, `patterns/base/link.pattern.md`, `patterns/base/radio.pattern.md`, `patterns/base/select.pattern.md`, `patterns/base/switch.pattern.md`, `patterns/base/table.pattern.md`, `patterns/base/tabs.pattern.md`, `patterns/base/textarea.pattern.md`, `patterns/base/tooltip.pattern.md`, `patterns/composition/date-picker.pattern.md`, `patterns/experiments/button-proof-of-use/README.md`, `patterns/experiments/button-proof-of-use/button.a11y-checklist.md` |
| Non-document relationship target in ADR | 1 | defect | `decisions/uif-public-api-namespace.md` |
| External or path-based provenance targets | 26 | specification-gap | `patterns/base/accordion.pattern.md`, `patterns/base/avatar.pattern.md`, `patterns/base/badge.pattern.md`, `patterns/base/button.pattern.md`, `patterns/base/calendar.pattern.md`, `patterns/base/checkbox.pattern.md`, `patterns/base/divider.pattern.md`, `patterns/base/form.pattern.md`, `patterns/base/icon.pattern.md`, `patterns/base/input.pattern.md`, `patterns/base/label.pattern.md`, `patterns/base/link.pattern.md`, `patterns/base/radio.pattern.md`, `patterns/base/select.pattern.md`, `patterns/base/switch.pattern.md`, `patterns/base/table.pattern.md`, `patterns/base/tabs.pattern.md`, `patterns/base/textarea.pattern.md`, `patterns/base/tooltip.pattern.md`, `patterns/composition/date-picker.pattern.md` |
| Title and first heading differ | 9 | accepted-exception | `decisions/uif-public-api-namespace.md`, `exports/agent-pack/projections/github-copilot-design-review.md`, `knowledge/lessons/lesson-template.md`, `patterns/templates/base-pattern.template.md`, `patterns/templates/composition-pattern.template.md`, `patterns/templates/product-pattern.template.md`, `publications/presentations/beyond-components-management/slides.md`, `templates/adr-template.md`, `templates/workflow-template.md` |
| Noncanonical `type: checklist` or `type: experiment` | 3 | specification-gap | `patterns/checklists/pattern-spec-review-checklist.md`, `patterns/experiments/button-proof-of-use/README.md`, `patterns/experiments/button-proof-of-use/button.a11y-checklist.md` |

No current finding is classified as `legacy-drift`. The recurring drift-like cases all raise a specification question because they are repeated enough to imply a missing or unclear canonical representation rather than isolated stale metadata.

## Root causes

### Projection metadata drift

`exports/perplexity/research-projection.md` has structured metadata in an HTML comment, not YAML frontmatter. Because it is a Markdown document in the vault export tree, the current metadata specification treats this as a deterministic defect.

### Provenance modeled as relationships

Pattern and experiment files use `related.derived_from` for provenance. The metadata specification says relationships are expressed through document ids, and `reference.relationship-types` does not define `derived_from`. The same root cause also produces target failures when the values are absolute paths, relative paths, or source notes rather than vault document ids.

### Artifact ids mixed with document ids

`decisions/uif-public-api-namespace.md` references `export-pack.governance.naming-contract`, but the machine-readable artifact id is `governance-pack.naming-contract` and the governed manifest document id is `export-pack.governance.manifest`. The finding is a deterministic defect because `related` targets are expected to resolve to document ids.

### Support-file types outside canonical taxonomy

The vault contains `type: checklist` and `type: experiment`, but `specification.vault-metadata` and `reference.document-types` do not allow those values. This is a specification gap until maintainers decide whether these are valid document types or should be represented using existing types.

### Intentional title-heading mismatch

Template, ADR, projection, and slide files use headings that include placeholders, type prefixes, or presentation section titles. The audit correctly emits warnings rather than failures because `specification.vault-metadata` says title should match or closely align with the first heading.

## Safe metadata fixes

These can be handled later without changing governance meaning, but were not applied in this step:

- Add YAML frontmatter to `exports/perplexity/research-projection.md` while preserving its derived-projection boundary.
- Change `decisions/uif-public-api-namespace.md` so `related.governs` points only at governed document ids, likely `export-pack.governance.manifest` or another existing source document id.
- Leave title-heading warnings unchanged unless a reviewer wants editorial alignment; current warnings are not deterministic failures.

## Governance decisions required

These should not be fixed mechanically until the canonical model is clarified:

- Decide whether provenance belongs in a new metadata field, an allowed relationship key, `verification.evidence`, or another existing field.
- Decide whether external source paths may appear in metadata and, if so, which field owns them.
- Decide whether `checklist` and `experiment` should become allowed document types or whether these files should use existing types such as `template`, `pattern`, `publication`, or `index`.
- Decide whether title-heading mismatch warnings should have documented exceptions for templates, ADRs, projections, and slide decks.

## Accepted exceptions

Current accepted-exception findings:

- `templates/adr-template.md`: template heading intentionally uses a placeholder decision title.
- `templates/workflow-template.md`: template heading intentionally uses a placeholder workflow title.
- `knowledge/lessons/lesson-template.md`: template-like lesson heading intentionally uses a placeholder.
- `patterns/templates/base-pattern.template.md`: pattern template heading intentionally uses a placeholder pattern name.
- `patterns/templates/composition-pattern.template.md`: pattern template heading intentionally uses a placeholder pattern name.
- `patterns/templates/product-pattern.template.md`: pattern template heading intentionally uses a placeholder pattern name.
- `decisions/uif-public-api-namespace.md`: first heading includes the ADR document family prefix.
- `exports/agent-pack/projections/github-copilot-design-review.md`: first heading includes projection formatting.
- `publications/presentations/beyond-components-management/slides.md`: first heading is the first slide title, not the metadata title.

These exceptions should remain warnings unless a future specification defines exact matching rules or documented exception handling.

## Contract validation status

The emitted JSON includes the required result-contract fields for every current finding:

- `audit_id`
- `audit_version`
- `executed_at`
- `scope`
- `status`
- `rule_id`
- `file_path`
- `evidence`
- `remediation`
- `classification`
- `certainty`

All current `rule_id` values are stable dotted identifiers. Messages are concise, evidence is concrete, remediation text is present, and every current frontmatter finding has `classification: deterministic` and `certainty: confirmed`.

The output does not contain a literal `deterministic: true` boolean. The current contract represents that concept as `classification: deterministic`. If consumers require a boolean, the result contract should be revised deliberately rather than inferred.

The output is now machine-enforced by a Ruby stdlib contract check inside `schemas/validate-vault-audits.rb`. The contract file remains the canonical human-readable source rather than a full JSON Schema.

The contract check validates:

- required keys
- allowed `status`
- allowed `classification`
- allowed `certainty`
- stable `rule_id` format
- `warn` status for `certainty: uncertain`
- field types
- registered audit ids and matching audit versions
- repository-relative `file_path` values

Contract failures are reported to stderr as internal audit runner failures. They are not converted into ordinary audit findings, and partially valid JSON is not emitted.

## Recommended migration order

1. Fix the isolated deterministic metadata defects:
   - add frontmatter to `exports/perplexity/research-projection.md`
   - correct the ADR relationship target in `decisions/uif-public-api-namespace.md`
2. Decide the provenance model for `derived_from` and external path references.
3. Decide whether `checklist` and `experiment` are canonical document types.
4. Document accepted title-heading exceptions or leave them as warnings.
5. Keep the lightweight contract validation in place and harden it only when new consumers require additional fields.
6. Only after those decisions, consider suppression or exception support.

## Execution model recommendation

Individual audit IDs remain the stable registry identities:

- `vault-frontmatter-audit`
- `vault-link-audit`
- `vault-taxonomy-audit`

The CLI currently uses short selectors:

- `--audit frontmatter`
- `--audit links`
- `--audit taxonomy`

`--audit all` should mean: run every currently implemented individual audit and include a pass finding for audits with no findings.

`vault-quick-audit` should mean: the registry-declared composition that currently maps to `ruby schemas/validate-vault-audits.rb --audit all`. It should remain a composition name rather than a fourth independent audit.

No rename is required. The only ambiguity to resolve later is whether the CLI should also accept full registry audit IDs as aliases for the short selectors.
