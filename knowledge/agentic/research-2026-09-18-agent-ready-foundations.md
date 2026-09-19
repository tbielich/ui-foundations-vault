---
id: knowledge.agentic.research-2026-09-18
title: Research Notes — Agent-ready Foundations, Accessibility Trust, and Token Resolution
type: research
status: draft
owners:
  - ui-foundations
created: 2026-09-19
updated: 2026-09-19
authority: supporting
summary: Candidate findings from September 2026 research on agent-ready design systems, accessibility trust boundaries, token resolution, and governed agent workflows.
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
---

# Research Notes — Agent-ready Foundations, Accessibility Trust, and Token Resolution

## Purpose

Capture external research and practitioner evidence as candidate knowledge. These notes are intentionally non-governing. They may later support ADRs, specifications, workflows, or governance proposals after source verification and UIF-specific evaluation.

## 1. Canonical knowledge with replaceable agent interfaces

### External signal

Atlassian described a design-system architecture that exposes the same typed design-system knowledge through Skill, MCP, and CLI interfaces, with shared underlying handlers. Their internal benchmarking reported that Skill + CLI maintained task quality while reducing execution time and token use relative to Skill + MCP in their tested setup.

Source:
- Atlassian Engineering, September 2026, practitioner report on providing design-system context to AI agents.

### Candidate UIF interpretation

The durable architectural asset should be canonical typed knowledge and shared capabilities/handlers. MCP, CLI, Skills, and future agent protocols should remain replaceable projections or adapters.

Candidate principle:

> The interface is a projection, not the architecture.

### Possible ADR questions

- Should UIF formally define shared provider-neutral capability handlers beneath CLI/MCP/Skill projections?
- Should retrieval and ranking be a reusable service independent of transport?
- Which semantics belong in UIF-VLT versus executable capability contracts in UIF-INT?

## 2. Accessibility semantics create an agent trust boundary

### External signal

The paper *When Agents See Differently: Exposing UI Desynchronization Threats in Mobile Agents* studies human-agent UI desynchronization: agents may consume accessibility metadata that differs materially from what a human perceives in the rendered interface. The reported experiments demonstrate that accessibility-tree information can become an attack surface for UI-operating agents.

Source:
- *When Agents See Differently: Exposing UI Desynchronization Threats in Mobile Agents*, September 2026.

### Candidate UIF interpretation

Accessibility metadata should be treated both as assistive semantics and as a machine-readable interface. Agent-facing semantics therefore require explicit trust boundaries and consistency validation.

Candidate invariants to investigate:

- visible label ↔ accessible name
- visible state ↔ semantic state
- visible action ↔ exposed action
- hidden content ↔ accessibility-tree exposure
- user-confirmed intent ↔ executable agent capability

Candidate principle:

> Accessible semantics should describe the human experience rather than create an unobservable agent-only reality.

### Possible ADR questions

- Should UIF component/pattern contracts define human-visible ↔ accessibility-semantic consistency assertions?
- Where should agent authorization be separated from accessibility semantics?
- Which checks can be deterministic and which require AI evaluation?

## 3. Token resolution should be deterministic infrastructure

### External signal

Recent DTCG work on token format, color, and resolver concerns reinforces that mature token infrastructure must handle references, aliases, context, and deterministic resolution rather than treating token serialization as the complete problem.

Source:
- Design Tokens Community Group, 2025.10 stable specification and subsequent technical-report work.

### Candidate UIF interpretation

Token choice may involve AI reasoning; token resolution should not.

Target capability shape:

```text
resolve(token, context, version)
→ value
→ dependency path
→ provenance
```

Candidate principle:

> AI may select semantic intent; deterministic automation resolves canonical token values.

### Possible ADR questions

- Should UIF-RUN expose one canonical resolver used by all projections?
- What resolution provenance must be returned for verification?
- How should version, mode, appearance, and semantic context be represented in the resolver contract?

## 4. Governed agent loops should separate reasoning from verification

### External signal

Recent engineering practice describes governed agent loops in which humans define intent and guardrails, agents execute, deterministic systems validate, and human approval is reserved for appropriate boundaries.

### Candidate UIF interpretation

The reusable pattern is not an unlimited autonomous repair loop. It is bounded execution with independent evidence:

```text
Intent / bounded contract
→ agent execution
→ deterministic verification
→ evidence
→ bounded repair or human decision
```

This aligns with UIF-INT's existing separation between execution, verification, persisted evidence, and bounded repair. It should therefore be treated as supporting evidence rather than as a new governing rule.

### Possible ADR questions

- Which verification gates should be mandatory for mutating capabilities?
- Which failures may enter REPAIR automatically and which require a new bounded task?
- What evidence schema should remain provider-neutral?

## Cross-cutting candidate architecture

```text
Canonical knowledge
      ↓
shared capabilities / deterministic services
      ↓
CLI / MCP / Skill / future adapters
      ↓
AI reasoning and bounded execution
      ↓
deterministic verification
      ↓
evidence
      ↓
bounded repair or human decision
```

## Research status

These findings are supporting research only.

Before promotion into an ADR or higher-authority UIF artifact:

1. verify the primary source and exact claim;
2. identify the affected UIF concern and repository authority;
3. compare the finding with existing accepted/stable Vault decisions;
4. state the architectural choice and alternatives explicitly;
5. promote only the resulting durable decision, not the external source's implementation details.
