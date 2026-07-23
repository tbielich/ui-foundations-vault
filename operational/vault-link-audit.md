---
id: workflow.operational.vault-link-audit
title: Vault Link Audit
type: workflow
status: draft
owners:
  - ui-foundations
created: 2026-07-23
updated: 2026-07-23
authority: supporting
summary: Describes how to audit markdown links and metadata relationships for missing local targets.
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
  references:
    - agent-capability.vault-maintainer
    - specification.vault-metadata
    - reference.relationship-types
    - registry.vault-audits
    - schema.vault-audit-result
---

# Vault Link Audit

## Purpose

Use this workflow to check that local markdown links and metadata relationship targets resolve to existing vault files or document ids.

## Inputs

- Markdown files in the vault
- `AGENTS.md`
- `specification.vault-metadata`
- `reference.relationship-types`

## Steps

1. Run deterministic validation:

```sh
ruby schemas/validate-vault-audits.rb --audit links
```

2. Treat broken local file links as deterministic failures.
3. Treat external links as out of scope for this local audit unless a separate network-enabled audit is explicitly requested.
4. Use AI only to judge whether a valid link points to the best source.

## Outputs

- Human-readable link findings
- Machine-readable findings when run with `--format json`
- Findings using `schema.vault-audit-result`

## Deterministic Checks

- Relative markdown links resolve to existing files or headings in existing files.
- Root-relative repository links resolve to existing files.
- Metadata relationship targets resolve to known document ids.

## AI-Evaluated Checks

- Whether a link cites the most authoritative source.
- Whether a relationship should be represented as metadata, prose, or both.
- Whether a valid link creates a misleading authority chain.

## Safety

This audit is read-only. Do not rewrite links without a separate explicit instruction.
