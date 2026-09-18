---
id: specification.project-bootstrap
title: UIF Project Bootstrap Specification
type: specification
status: review
owners:
  - ui-foundations
created: 2026-09-18
updated: 2026-09-18
authority: source
summary: Defines the provider-neutral bootstrap contract for projecting UI Foundations governance and operating context into agent, workspace, and repository instruction surfaces.
consumers:
  - human
  - agent
  - chatgpt
  - codex
  - github-copilot
  - kiro
  - a2a
  - mcp
applies_to:
  - ui-foundations
  - ui-foundations-vault
  - ui-foundations-intelligence
  - ui-foundations-studio
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
  references:
    - specification.document-structure
    - specification.vault-metadata
    - docs.architecture
    - docs.cross-repo-knowledge-sync
    - registry.sync-contract
    - export-pack.agent
    - lesson.uilib-consumer-capability-projection
    - lesson.uilib-generated-projection-materialization
    - lesson.uilib-projection-preflight
    - lesson.uilib-projection-delivery-semantics
verification:
  status: partially-verified
assumptions:
  - Consumer instruction surfaces will continue to differ in format, size limits, and supported capabilities.
  - Repository-local execution policy remains owned by the consuming repository unless separately promoted into canonical Vault knowledge.
---

# UIF Project Bootstrap Specification

## Purpose

The UIF Project Bootstrap defines how UI Foundations context is introduced into an agent, project workspace, repository, executor, or other instruction surface without turning that surface into a second source of truth.

The bootstrap is a thin, provider-neutral contract between canonical UI Foundations knowledge and consumer-specific projections.

Its purpose is to make a new consumer understand:

- what ecosystem it is operating in;
- where canonical knowledge lives;
- which authority boundaries apply;
- what context must not be inferred from conversation or memory;
- which concerns remain local to the consuming repository or platform;
- how derived instructions are synchronized and reviewed.

The bootstrap must reduce setup drift without duplicating durable governance.

## Scope

This specification governs bootstrap projections for instruction-bearing surfaces such as:

- project or workspace custom instructions;
- repository-level agent instructions such as `AGENTS.md`;
- provider-specific steering or rule files;
- executor adapter guidance;
- agent-pack projections;
- MCP- or service-facing instruction layers;
- future equivalent instruction surfaces.

This specification does not define:

- runtime implementation behavior;
- repository-specific build or test commands;
- current issue or task state;
- provider credentials or secrets;
- component, token, accessibility, or product specifications;
- executor routing semantics owned by UIF-INT;
- tool configuration that belongs to a consuming repository;
- conversational memory as a source of execution state.

## Core Principle

> Bootstrap context; do not duplicate authority.

A bootstrap projection exists to route a consumer to the right sources and boundaries. It should contain only the minimum stable guidance required for the consumer to operate safely and consistently.

Durable knowledge remains canonical in UIF-VLT. Runtime repositories remain canonical for their implementation, build, tests, runtime behavior, and local configuration.

## Requirements

### 1. Canonical source first

Every bootstrap projection must be derived from identified canonical or repository-owned sources.

A projection must not introduce new durable governance, principles, specifications, workflow semantics, or architecture decisions.

If new reusable guidance is needed, it should be promoted to the appropriate canonical Vault document before being projected.

### 2. Thin projection

A bootstrap projection should contain only guidance needed at consumer startup or instruction resolution.

It should prefer references, compact summaries, managed regions, or generated fragments over copying complete source documents.

A projection must not become a parallel knowledge base.

### 3. Provider neutrality at the source layer

Canonical bootstrap requirements must be provider-neutral.

ChatGPT-, Codex-, Cline-, Kiro-, Copilot-, Goose-, MCP-, or other provider-specific behavior belongs in derived projections, adapters, or repository-local configuration.

Provider-specific projections may adapt syntax and interaction patterns, but they must not redefine the underlying UIF authority model.

### 4. Explicit ecosystem boundary

A UIF bootstrap must identify UI Foundations as its own ecosystem boundary.

External projects, design systems, organizational knowledge, remembered conversations, or similarly named systems must not be treated as UIF sources unless they are explicitly referenced by the active task or by a governed UIF source.

Context availability does not imply authority.

### 5. Persist state, not conversation

A bootstrap must not require chat history to reconstruct task scope, execution state, verification state, or repository state.

Conversation and memory may improve orientation, but persisted contracts, files, issues, traces, tests, and repository state must remain sufficient to continue governed work.

Volatile task state must not be embedded in a durable bootstrap projection.

### 6. Authority must remain concern-specific

A projection must preserve the distinction between:

- canonical Vault knowledge and governance;
- repository-owned implementation and validation behavior;
- bounded task or execution contracts;
- provider-specific operating guidance;
- conversational context.

A projection must not flatten these sources into one global instruction layer.

When material authorities conflict and the conflict cannot be resolved from persisted sources, the consumer should surface the conflict rather than silently choosing an interpretation.

### 7. Local ownership must be preserved

Consuming repositories and platforms retain ownership of local concerns that are not governed by canonical Vault sources.

Examples include:

- build and test commands;
- dependency and environment configuration;
- runtime behavior;
- CI and deployment behavior;
- local issue intake rules;
- executor-specific invocation details;
- secrets and credentials.

A bootstrap projection must not overwrite such local concerns.

### 8. Managed regions for shared files

When Vault-derived guidance is projected into a file that also contains repository-owned guidance, the projection should use explicit managed boundaries.

A managed-region projection must define:

- one unambiguous begin marker;
- one unambiguous end marker;
- the exact projected content;
- ownership of content outside the markers;
- behavior when markers are missing, duplicated, malformed, or nested.

Content outside the managed region must remain untouched by bootstrap synchronization.

If ownership cannot be determined safely, synchronization must stop rather than guess.

### 9. Reviewable synchronization

Bootstrap synchronization must use a mode allowed by `registry.sync-contract`.

Generated changes must be inspectable as plain text before merge when they modify repository-owned files.

Silent overwrite is not a valid bootstrap mechanism.

### 10. Evidence and verification

A bootstrap projection must not convert executor self-report into verified state.

Where the consumer performs implementation or verification, evidence requirements must come from the applicable repository, execution contract, or canonical verification source.

The bootstrap may remind the consumer that evidence is required, but it must not invent repository-specific validation rules.

### 11. Consumer-native projection shape

A bootstrap projection must adapt to the native capability model of its consumer.

Provider neutrality requires stable source semantics and explicit adapter boundaries; it does not require identical artifact formats across heterogeneous consumers.

When a consumer natively accepts references, skills, structured contracts, managed instruction regions, or another bounded artifact type, prefer that form over wrapping every consumer in the same generic projection format.

### 12. Generated materialization when deterministic

When projection output can be derived deterministically from canonical sources and explicit consumer constraints, prefer generated materialization over independently authored copies.

The durable source should be the canonical knowledge, projection intent, and generation/validation rules. Generated consumer artifacts remain derived and replaceable even when they are cached, published, or reviewed.

Hand-authored projections may remain as reference implementations until generation rules are proven. Their presence must not create a second source of truth.

### 13. Preflight before destructive mutation

A projection generator that replaces an existing materialization should resolve required inputs and run deterministic validation before destructive mutation.

If preflight fails, the generator should preserve the last known valid materialization when the target storage model permits it.

The requirement is atomic replacement semantics, not a specific filesystem implementation.

### 14. Explicit delivery semantics

A projection must identify whether its consumer receives:

- a live reference or service that resolves current state at use time; or
- a snapshot materialization that represents source state at build time.

Snapshot materializations require an explicit refresh or rebuild path and must not imply current-state semantics.

Volatile values that can be safely resolved from an authoritative runtime source should remain references where practical instead of being copied into durable projection artifacts.

## Bootstrap Contract

Every bootstrap projection should make the following concepts recoverable, either directly or by reference.

| Concept | Required intent |
|---|---|
| Ecosystem identity | Identify the consumer as operating within UI Foundations. |
| Scope boundary | State what is inside and outside UIF context. |
| Canonical source | Point to UIF-VLT for durable reusable knowledge. |
| Repository authority | Preserve local ownership of implementation and configuration. |
| Authority routing | Explain which source owns which concern. |
| State model | Make clear that durable state is persisted rather than reconstructed from conversation. |
| Projection status | Identify the projection as derived rather than canonical. |
| Local exclusions | State which local concerns the projection intentionally does not own. |
| Sync model | Define reference, managed-region, or other reviewed consumption mode. |
| Failure behavior | Stop or surface ambiguity instead of guessing ownership or authority. |

A consumer-specific projection may omit literal wording from this table if the same intent is unambiguously expressed.

## Projection Classes

### Workspace or project instructions

Examples include ChatGPT project instructions or equivalent workspace-level instruction surfaces.

These projections should emphasize:

- ecosystem scope;
- authority routing;
- durable-state expectations;
- project boundaries;
- provider-neutral operating principles.

They should avoid:

- current task state;
- issue-specific context;
- repository commands that can be discovered from the repository;
- copied component or design specifications;
- credentials or local environment details.

### Repository agent instructions

Examples include `AGENTS.md`.

These projections may combine:

- a Vault-managed shared region; and
- repository-owned implementation guidance.

The managed region should remain small. Repository-local architecture, tests, commands, stop conditions, and runtime policies stay outside the Vault-managed region unless separately governed.

### Provider steering and rule files

Examples include provider-specific steering, rule, or instruction formats.

These are derived consumer adaptations.

They may translate canonical concepts into provider-specific syntax, but should prefer references to repository-owned instructions and canonical Vault sources over duplicating them.

### Executor and adapter guidance

Executor-specific guidance may define invocation behavior, result formatting, or adapter constraints.

It must not change provider-neutral execution semantics owned elsewhere.

## Materialization Model

The bootstrap follows this flow:

```text
Canonical UIF knowledge
        |
        v
UIF Project Bootstrap Specification
        |
        v
Consumer capability resolution
        |
        v
Consumer-specific projection plan
        |
        v
Preflight + deterministic validation
        |
        v
Reviewed materialization
        |
        +--> Project / workspace instructions
        +--> AGENTS.md managed region
        +--> Provider steering / rules
        +--> Structured executor / service contracts
        +--> Live references or snapshot artifacts
```

The projection layer is replaceable. The canonical source layer is not tied to any one consumer.

## Constraints

A bootstrap projection must not:

- redefine Vault precedence or lifecycle;
- copy large canonical documents merely for convenience;
- encode secrets, tokens, credentials, or private environment values;
- make memory or conversation history authoritative;
- embed volatile project status;
- silently overwrite repository-owned content;
- move runtime implementation rules into UIF-VLT without governance review;
- make provider-specific behavior canonical by repetition;
- infer relationships to external systems from naming similarity or remembered context.

## Relationships

This specification works with:

- `governance.precedence` for conflict resolution;
- `governance.lifecycle` for document state and review expectations;
- `specification.document-structure` for canonical specification structure;
- `specification.vault-metadata` for metadata and authority fields;
- `docs.cross-repo-knowledge-sync` for consumption and feedback flow;
- `registry.sync-contract` for allowed synchronization behavior;
- `export-pack.agent` for derived agent-facing packaging.

Existing projections such as the UIF-INT `AGENTS.md` managed region are examples of the materialization pattern. They do not define this specification.

## Validation

A bootstrap implementation is conformant when:

1. Canonical source documents are identifiable.
2. The projection is explicitly derived and does not claim source authority.
3. UIF ecosystem scope and external-context boundaries are clear.
4. Repository-local ownership is preserved.
5. Durable task state does not depend on conversation history.
6. Provider-specific guidance is isolated to a derived projection or adapter.
7. Shared files use explicit ownership boundaries when partially managed.
8. Synchronization is reviewable and allowed by `registry.sync-contract`.
9. Missing or ambiguous ownership causes a stop or review path rather than guessed mutation.
10. No secrets or volatile execution state are embedded in the bootstrap.
11. The projection can be regenerated or reviewed from persisted sources.
12. Removing one provider-specific projection does not remove the canonical knowledge needed to create another.
13. The projection shape matches the consumer's native capability model rather than an artificial cross-provider format.
14. Deterministically derivable projections can be regenerated from persisted canonical sources and explicit consumer constraints.
15. Destructive materialization is preceded by source resolution and deterministic preflight validation when applicable.
16. Delivery semantics identify live-reference/service behavior versus snapshot materialization, including the required refresh path for snapshots.

## Example

A project-instruction projection may summarize:

```text
UI Foundations is the active ecosystem.
UIF-VLT is canonical for durable shared knowledge.
Each runtime repository remains canonical for implementation and local configuration.
Conversation and memory are context, not execution state.
Provider-specific instructions are derived and may not override canonical or repository-local authority.
Reusable findings should be promoted to UIF-VLT before being duplicated across consumers.
```

The exact wording is consumer-specific. The authority and ownership model is not.

## Adoption

Initial adoption should be incremental:

1. Use this specification as the canonical bootstrap contract.
2. Keep the existing UIF-INT `AGENTS.md` projection as a compatible first example.
3. Add new consumer projections only when a real consumer exists.
4. Prefer one thin projection per instruction surface.
5. Review repeated projection content and promote reusable meaning back into canonical Vault sources.
6. Add registry automation only after multiple projections demonstrate a stable machine-readable need.

This avoids introducing a new bootstrap framework before the projection model has enough real consumers to justify one.
