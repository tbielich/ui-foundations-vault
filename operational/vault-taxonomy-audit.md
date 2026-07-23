---
id: workflow.operational.vault-taxonomy-audit
title: Vault Taxonomy Audit
type: workflow
status: draft
owners:
  - ui-foundations
created: 2026-07-23
updated: 2026-07-23
authority: supporting
summary: Describes how to audit pattern and document taxonomy placement using deterministic evidence and bounded AI judgment.
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
  references:
    - reference.pattern-taxonomy
    - specification.pattern.schema
    - specification.classification-model
    - specification.vault-metadata
    - registry.vault-audits
    - schema.vault-audit-result
---

# Vault Taxonomy Audit

## Purpose

Use this workflow to check whether pattern files and governed documents are mechanically consistent with vault taxonomy expectations, then reserve semantic classification questions for AI or human review.

## Inputs

- Pattern markdown files
- Governed markdown files
- `reference.pattern-taxonomy`
- `specification.pattern.schema`
- `specification.classification-model`
- `specification.vault-metadata`

## Steps

1. Run deterministic evidence collection:

```sh
ruby schemas/validate-vault-audits.rb --audit taxonomy
```

2. Treat mechanical placement, naming, and metadata mismatches as deterministic findings.
3. Use AI review for semantic classification questions that the script cannot prove.
4. Mark uncertain classification findings as `warn`, not `fail`.

## Outputs

- Human-readable taxonomy findings
- Machine-readable findings when run with `--format json`
- Findings using `schema.vault-audit-result`

## Deterministic Checks

- Pattern files use `type: pattern`.
- Pattern ids align with known pattern directory families where mechanically inferable.
- Pattern filenames use the `.pattern.md` suffix outside index, map, schema, template, checklist, and experiment files.
- Pattern documents reference the pattern authoring schema when they are pattern specs.

## AI-Evaluated Checks

- Whether a pattern is actually base, composition, or experience.
- Whether ownership boundaries are coherent.
- Whether a document duplicates an existing authority.
- Whether remediation should move, split, merge, or reclassify the document.

## Safety

This audit is read-only. Taxonomy fixes require a separate explicit instruction because moves and reclassification can affect relationships and exports.
