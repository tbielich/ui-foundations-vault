---
id: specification.vault-metadata
title: Vault Metadata Specification
type: specification
status: stable
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: source
summary: Defines minimal frontmatter metadata for markdown documents in the vault.
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
---

# Vault Metadata Specification

## Design Rationale

The vault is the primary knowledge source for humans and AI agents. Its metadata must support discovery, filtering, relationship graphs, lifecycle tracking, and governance without making documents unpleasant to edit.

This specification uses YAML frontmatter because it is widely understood by markdown tools, static site generators, editors, AI agents, and future MCP servers. The schema is intentionally small. The document body remains the primary source of meaning; metadata makes that meaning easier to locate, evaluate, and connect.

The metadata model favors semantic names over tool-specific names. It avoids runtime fields, automation directives, and vendor-specific prompt formats.

## Complete Metadata Specification

Every markdown document should begin with YAML frontmatter.

```yaml
---
id: principle.design-intelligence
title: Design Intelligence
type: principle
status: accepted
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: source
---
```

## Required Fields

### `id`

Stable, unique identifier for the document.

- Type: string
- Required: yes
- Format: `<type>.<slug>` or `<type>.<area>.<slug>`
- Example: `workflow.component-review`

The `id` should not change when a file is moved.

### `title`

Human-readable document title.

- Type: string
- Required: yes
- Example: `Component Review Workflow`

The `title` should match or closely align with the first heading in the document.

### `type`

Document taxonomy type.

- Type: string
- Required: yes
- Allowed values:
  - `principle`
  - `governance`
  - `workflow`
  - `prompt`
  - `specification`
  - `adr`
  - `agent-capability`
  - `template`
  - `glossary`
  - `pattern`
  - `index`

### `status`

Lifecycle state.

- Type: string
- Required: yes
- Allowed values:
  - `draft`
  - `review`
  - `accepted`
  - `stable`
  - `deprecated`
  - `archived`

### `owners`

People, teams, or roles responsible for stewardship.

- Type: list of strings
- Required: yes
- Example:

```yaml
owners:
  - ui-foundations
```

Use stable role names when individual ownership is not useful.

### `created`

Date the document was introduced.

- Type: date
- Required: yes
- Format: `YYYY-MM-DD`

### `updated`

Date the document was last materially changed.

- Type: date
- Required: yes
- Format: `YYYY-MM-DD`

### `authority`

How authoritative the document is.

- Type: string
- Required: yes
- Allowed values:
  - `source`: authoritative source for the topic
  - `supporting`: supporting context for another source
  - `derived`: derived summary or reusable interpretation
  - `example`: illustrative, not normative

Agents should prefer `source` documents when resolving conflicts.

## Optional Fields

### `summary`

Short description for search results and generated indexes.

- Type: string

### `tags`

Small set of semantic labels.

- Type: list of strings
- Example:

```yaml
tags:
  - components
  - review
```

Tags should help filtering. Do not use them to duplicate `type`, `status`, or `owners`.

### `consumers`

Intended consumers.

- Type: list of strings
- Suggested values:
  - `human`
  - `agent`
  - `codex`
  - `goose`
  - `chatgpt`
  - `claude-code`
  - `github-copilot`
  - `kiro`
  - `a2a`
  - `studio`
  - `mcp`

Use `human` and `agent` for general-purpose documents. Use named consumers only when the document has a specific consumption path.

### `applies_to`

Repositories, domains, or systems affected by the document.

- Type: list of strings
- Example:

```yaml
applies_to:
  - ui-foundations
  - ui-foundations-studio
```

### `related`

Explicit relationships to other vault documents.

- Type: object
- Keys: relationship types
- Values: lists of document ids

Allowed relationship keys:

- `depends_on`
- `supports`
- `supersedes`
- `superseded_by`
- `implements`
- `implemented_by`
- `governs`
- `governed_by`
- `references`
- `conflicts_with`

Example:

```yaml
related:
  depends_on:
    - principle.design-intelligence
  governs:
    - workflow.component-review
```

### `verification`

Verification posture of the document.

- Type: object
- Optional keys:
  - `status`
  - `evidence`
  - `reviewed`
  - `reviewers`

Allowed `verification.status` values:

- `unverified`
- `assumption`
- `partially-verified`
- `verified`

Example:

```yaml
verification:
  status: verified
  evidence:
    - governance.verification-review
  reviewed: 2026-07-07
  reviewers:
    - ui-foundations
```

### `assumptions`

Known assumptions that affect interpretation.

- Type: list of strings

Keep assumptions short. Explain complex assumptions in the document body.

### `review_cycle`

Expected review cadence.

- Type: string
- Suggested values:
  - `none`
  - `quarterly`
  - `biannual`
  - `annual`
  - `on-change`

### `stability`

Expected rate of change.

- Type: string
- Allowed values:
  - `experimental`
  - `evolving`
  - `stable`

### `version`

Document schema or content version when useful.

- Type: string
- Example: `1.0`

Do not add `version` unless external consumers need it.

## Metadata Naming Conventions

- Use lowercase snake_case for field names.
- Use lowercase kebab-case for tags and consumer names.
- Use lowercase dot-separated ids.
- Prefer singular field names for scalar values.
- Prefer plural field names for lists.
- Use ISO dates: `YYYY-MM-DD`.
- Avoid tool-specific field names such as `codex_prompt`, `goose_mode`, or `mcp_resource`.
- Avoid ambiguous names such as `category`, `kind`, or `state` when `type` and `status` already exist.

## Document Taxonomy

### `principle`

Durable belief, quality bar, or design philosophy.

Use for guidance that should remain stable across tools and implementations.

### `governance`

Decision rights, review rules, lifecycle rules, and verification expectations.

Use for rules about how work is approved, trusted, changed, or deprecated.

### `workflow`

Repeatable human or agent process.

Use for step-by-step activity that produces an output.

### `prompt`

Reusable agent session starter or instruction pattern.

Use for prompts that operationalize vault knowledge.

### `specification`

Normative requirements, constraints, data shapes, or expected behavior.

Use for documents that other repositories or tools can implement against.

### `adr`

Architecture decision record or durable operating decision.

Use for choices with context, tradeoffs, and consequences.

### `agent-capability`

Description of what an agent role can do, when to use it, and what constraints apply.

Use for tool-independent agent capability definitions, not vendor-specific setup.

### `template`

Reusable document structure.

Use for markdown templates that help create consistent vault documents.

### `glossary`

Shared term definition.

Use for vocabulary that should be stable across humans and agents.

### `pattern`

Reusable design, workflow, or knowledge pattern.

Use for repeatable approaches that are less normative than specifications.

### `index`

Navigation document or map.

Use for curated entry points once the vault grows.

## Relationship Model

Relationships are expressed through document ids, not file paths. This allows files to move without breaking graphs.

Use relationships only when they add value. A sparse accurate graph is better than a dense noisy graph.

Relationship semantics:

- `depends_on`: this document needs another document to be understood or applied.
- `supports`: this document provides evidence or context for another document.
- `supersedes`: this document replaces another document.
- `superseded_by`: this document has been replaced by another document.
- `implements`: this document operationalizes another document.
- `implemented_by`: this document is operationalized by another document.
- `governs`: this document sets rules for another document.
- `governed_by`: this document is constrained by another document.
- `references`: this document cites or points to another document.
- `conflicts_with`: this document has a known unresolved conflict with another document.

Agents should use `superseded_by` with `status: deprecated` or `status: archived` to avoid applying stale guidance.

## Governance Rules

1. Every markdown document should have frontmatter before it is considered governed vault content.
2. `id`, `title`, `type`, `status`, `owners`, `created`, `updated`, and `authority` are required.
3. `id` values are stable and unique.
4. `status: accepted` and `status: stable` documents with `authority: source` take precedence over supporting, derived, or example documents.
5. Deprecated and archived documents should remain in Git for traceability unless removal is explicitly approved.
6. A replaced document should include `related.superseded_by` when replacement guidance exists.
7. A replacement document should include `related.supersedes`.
8. Assumptions should be explicit when guidance is incomplete or based on inference.
9. Prompts should not redefine principles; they should reference or operationalize them.
10. Workflows should not define governance rules; they should reference governance documents.
11. Governance documents should define rules, not execution steps beyond review expectations.
12. Tool-specific fields require a new accepted specification before adoption.

## Validation Rules

These rules can be checked manually now and automated later.

Required validation:

- Frontmatter exists and is valid YAML.
- Required fields are present.
- `id` is unique across the vault.
- `type` is one of the allowed taxonomy values.
- `status` is one of the allowed lifecycle values.
- `authority` is one of the allowed authority values.
- `created` and `updated` use `YYYY-MM-DD`.
- `updated` is not earlier than `created`.
- Relationship targets refer to existing document ids.
- Deprecated or archived documents include `related.superseded_by` when replacement guidance exists.
- `verification.status`, when present, is one of the allowed values.
- Tags use lowercase kebab-case.
- Metadata field names use lowercase snake_case.

Recommended validation:

- `title` matches the first markdown heading.
- `summary` is no more than one sentence.
- `tags` are limited to a small useful set.
- `consumers` use general values unless a named consumer is necessary.
- Documents with `authority: source` should include verification metadata once accepted.
- Documents with `verification.status: assumption` should include `assumptions`.

## Future Extensibility

The schema can grow by adding optional fields, not by changing existing required field meanings.

Potential future extensions:

- `schema_version` if automated validators need schema migration.
- `canonical_url` if documents are published outside Git.
- `source_refs` for external authoritative references.
- `language` if multilingual documentation becomes necessary.
- `security` if access tiers are introduced.
- `machine_summary` if generated indexes need a constrained abstract.
- `embedding_hint` if future retrieval systems need chunking guidance.

Do not add these fields until there is a real consumer or governance need.

## Migration Strategy

1. Adopt this specification as stable.
2. Add frontmatter to existing documents gradually, starting with source documents.
3. Assign stable ids before adding cross-document relationships.
4. Mark uncertain documents with `verification.status: assumption` or `unverified`.
5. Add relationships only when they are obvious and useful.
6. Review the schema after the first meaningful batch of documents is migrated.
7. Automate validation only after manual usage proves the schema is stable.

## Examples by Document Type

### Principle

```yaml
---
id: principle.design-intelligence
title: Design Intelligence
type: principle
status: accepted
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: source
summary: Design knowledge should be explicit enough for humans and agents to apply without guessing.
tags:
  - design
  - quality
consumers:
  - human
  - agent
verification:
  status: partially-verified
---
```

### Governance

```yaml
---
id: governance.verification-review
title: Verification Review
type: governance
status: review
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: source
summary: Defines how proposed changes are checked against evidence.
consumers:
  - human
  - agent
verification:
  status: verified
---
```

### Workflow

```yaml
---
id: workflow.component-review
title: Component Review Workflow
type: workflow
status: review
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: source
summary: Reviews whether a component proposal belongs in UI Foundations.
applies_to:
  - ui-foundations
related:
  governed_by:
    - governance.verification-review
  depends_on:
    - principle.design-intelligence
verification:
  status: partially-verified
---
```

### Prompt

```yaml
---
id: prompt.spec-session
title: Specification Session Prompt
type: prompt
status: review
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: supporting
summary: Starts an agent session for drafting or revising a vault specification.
consumers:
  - agent
related:
  implements:
    - governance.verification-review
verification:
  status: unverified
---
```

### Specification

```yaml
---
id: specification.vault-metadata
title: Vault Metadata Specification
type: specification
status: stable
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: source
summary: Defines minimal frontmatter metadata for markdown documents in the vault.
consumers:
  - human
  - agent
  - studio
  - mcp
verification:
  status: assumption
assumptions:
  - YAML frontmatter remains broadly consumable across expected tools.
---
```

### ADR

```yaml
---
id: adr.0001-vault-boundary
title: Vault Boundary
type: adr
status: review
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: source
summary: Records that the vault stores knowledge and governance, not runtime implementation.
applies_to:
  - ui-foundations-vault
related:
  references:
    - specification.vault-metadata
verification:
  status: partially-verified
---
```

### Agent Capability

```yaml
---
id: agent-capability.component-reviewer
title: Component Reviewer
type: agent-capability
status: draft
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: source
summary: Defines a tool-independent agent capability for reviewing component proposals.
consumers:
  - agent
  - a2a
related:
  implements:
    - workflow.component-review
verification:
  status: assumption
---
```

### Template

```yaml
---
id: template.adr
title: ADR Template
type: template
status: review
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: example
summary: Provides a reusable structure for architecture decision records.
consumers:
  - human
  - agent
verification:
  status: unverified
---
```

### Glossary

```yaml
---
id: glossary.design-intelligence
title: Design Intelligence
type: glossary
status: review
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: source
summary: Defines design intelligence for the UI Foundations ecosystem.
tags:
  - vocabulary
verification:
  status: partially-verified
---
```

### Pattern

```yaml
---
id: pattern.verification-first-generation
title: Verification-First Generation
type: pattern
status: draft
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: supporting
summary: Describes an agent pattern for checking evidence before generating implementation guidance.
consumers:
  - agent
related:
  supports:
    - governance.verification-review
verification:
  status: assumption
---
```

## Standard Review

### Human Maintainability

The required core is small enough to edit manually. The most important risk is frontmatter becoming longer than the document itself for simple glossary or template files. To avoid that, optional fields should remain truly optional and relationships should be added only when they improve discovery or governance.

Guidance: keep optional metadata optional. Use the required core first, then add relationships, consumers, and verification details only when they improve understanding.

### AI Agent Consumption

The schema gives agents stable ids, taxonomy, lifecycle, authority, consumers, verification posture, and relationships. This is enough for retrieval, filtering, graph building, and conflict resolution. The `authority` and `verification` fields are especially important for distinguishing source knowledge from assumptions.

Guidance: agents should rely first on `type`, `status`, `authority`, and `related`. Consumer-specific metadata is optional and should not be treated as a hard access rule.

### Long-Term Governance

The model separates governance from workflow and prompt content. It also creates a path for deprecation and supersession without deleting history. The schema can support future MCP servers and Studio indexing without locking the vault to either.

Guidance: future schema changes should be added as optional fields first. Required field changes should go through governance review.
