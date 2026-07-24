---
id: workflow.operational.vault-frontmatter-audit
title: Vault Frontmatter Audit
type: workflow
status: draft
owners:
  - ui-foundations
created: 2026-07-23
updated: 2026-07-24
authority: supporting
summary: Describes how to audit vault markdown frontmatter against canonical metadata and lifecycle rules.
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
  references:
    - specification.vault-metadata
    - specification.document-structure
    - reference.document-types
    - reference.relationship-types
    - registry.repos
    - registry.vault-audits
    - schema.vault-audit-result
---

# Vault Frontmatter Audit

## Purpose

Use this workflow to check whether governed markdown documents expose the metadata needed for discovery, lifecycle tracking, precedence, and relationship validation.

This audit also validates the shape of optional provenance metadata. Provenance records origin and lineage; it does not change authority, precedence, lifecycle, or semantic document relationships.

## Inputs

- Markdown files in the vault
- `specification.vault-metadata`
- `specification.document-structure`
- `governance.lifecycle`
- `reference.document-types`
- `reference.relationship-types`
- `registry.repos`

## Steps

1. Run deterministic validation:

```sh
ruby schemas/validate-vault-audits.rb --audit frontmatter
```

2. Review `fail` findings as required fixes.
3. Review `warn` findings for metadata quality or lifecycle concerns.
4. Use AI only to interpret ambiguous ownership, authority, or remediation questions.

## Outputs

- Human-readable audit summary
- Machine-readable findings when run with `--format json`
- Findings using `schema.vault-audit-result`

## Deterministic Checks

- Frontmatter exists and parses as YAML.
- Required metadata fields are present.
- Metadata enum values are valid.
- Dates use `YYYY-MM-DD`.
- `updated` is not earlier than `created`.
- Document ids are unique.
- Relationship keys and targets are valid.
- `related` contains only canonical relationship keys and governed vault document ids.
- `provenance.sources`, when present, is non-empty and uses supported source types and roles.
- Provenance source objects include the required fields for their type.
- Provenance vault document ids exist.
- Provenance repository names exist in `registry.repos`.
- Provenance repository paths are relative and do not traverse outside the repository.
- Provenance issue numbers are positive.
- Provenance URLs are valid.

## AI-Evaluated Checks

- Whether `authority` is appropriate for the document's actual role.
- Whether ownership is semantically correct.
- Whether remediation should create, move, merge, deprecate, or leave a document unchanged.

## Safety

This audit is read-only. Do not apply fixes, change `main`, or merge changes without a separate explicit instruction.
