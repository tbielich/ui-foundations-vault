---
id: principle.selective-activation
title: Selective Activation over Full Loading
type: principle
status: draft
owners:
  - ui-foundations
created: 2026-09-13
updated: 2026-09-13
authority: supporting
summary: Prefer intent- and capability-driven activation of relevant knowledge and resources over loading the complete available context.
---

# Selective Activation over Full Loading

## Principle

UI Foundations systems should activate only the knowledge, capabilities, and execution resources required for the current task rather than loading the complete available corpus into context by default.

Selective activation is an architectural principle for keeping agent context relevant, bounded, reproducible, and scalable as the Vault and Intelligence layer grow.

## Rationale

Large knowledge systems face a similar constraint to large inference systems: the total available resource set can be much larger than the useful working set for a single task.

Loading everything increases cost and noise without guaranteeing better decisions. The preferred model is therefore:

```text
Intent
  ↓
Capability Resolution
  ↓
Relevant Knowledge Selection
  ↓
Context Assembly
  ↓
Execution
  ↓
Verification
```

The system should resolve what is required before assembling execution context.

## Pattern

Selective activation separates the complete knowledge space from the active working set.

```text
Available Knowledge / Capabilities
              ↓
       Resolution Layer
              ↓
      Relevant Working Set
              ↓
          Execution
```

The resolution layer may use deterministic rules, semantic retrieval, AI-assisted classification, or a combination of these mechanisms. The mechanism is implementation-specific; the principle is not.

## Application to UI Foundations Intelligence

For UI Foundations Intelligence, this implies that an agent request should not automatically receive every available foundation, pattern, governance rule, specification, implementation reference, and operational document.

Instead, Intelligence should determine the required capability and assemble the smallest sufficient authoritative context.

Examples:

- A token naming task should prioritize naming governance, token specifications, relevant foundations, and affected implementation contracts.
- A component accessibility review should prioritize applicable standards, base patterns, accessibility requirements, component specifications, and verification obligations.
- A pattern-generation task should retrieve the pattern schema, closest template, applicable standards, related base patterns, governance constraints, and relevant implementation boundaries.

## Safety and Governance Boundary

Selective activation is an optimization strategy, not permission to omit mandatory constraints.

The system must preserve required governance, precedence, accessibility, security, and verification rules even when minimizing context.

A smaller context is valid only when it remains sufficient to make a compliant decision.

When the system cannot establish that sufficiency, it should expand the context rather than infer missing rules.

## Human, Agent, and System Perspective

### Human

Selective activation should reduce irrelevant information and make decisions easier to inspect. Humans should be able to understand why particular sources or capabilities were selected when traceability is required.

### Agent

Agents should receive focused authoritative context with explicit boundaries. They should not be expected to discover the entire Vault for every task or treat retrieval breadth as a substitute for capability resolution.

### System

The system should separate knowledge storage from knowledge activation. The Vault remains the canonical knowledge space; Intelligence determines the task-specific working set; Runtime executes against resolved contracts.

## Research Reference: Colibri

The Colibri inference project provides a useful external analogy for this principle. In Mixture-of-Experts inference, the complete model can contain a very large set of experts while only a subset is activated for a particular inference step. Resource placement and routing determine the active working set rather than requiring every resource to be simultaneously active.

Reference:

- JustVugg/colibri: https://github.com/JustVugg/colibri

Colibri is a research reference, not a UI Foundations dependency or runtime recommendation. Its relevance is the architectural analogy between expert routing in inference systems and knowledge/capability routing in agent systems.

```text
MoE inference                    UIF Intelligence

Prompt                           Intent
  ↓                                ↓
Router                           Capability Resolution
  ↓                                ↓
Relevant Experts                Relevant Knowledge
  ↓                                ↓
Activate / Load                 Context Assembly
  ↓                                ↓
Inference                       Execution
```

## Research Hypothesis

UI Foundations Intelligence should test whether selective knowledge activation produces better agent outcomes than broad context loading.

Evaluation should consider:

- decision quality
- governance compliance
- context size
- latency
- reproducibility
- traceability
- retrieval precision and recall
- verification success
- failure behavior when required knowledge is missing

The objective is not minimum context size. The objective is the smallest sufficient authoritative context for reliable execution.

## Non-Goals

This principle does not:

- prescribe a specific model, vector database, retrieval framework, MCP service, or inference engine;
- require Colibri or Mixture-of-Experts models;
- define the implementation of Capability Resolution;
- allow mandatory governance or accessibility context to be omitted;
- replace verification with retrieval confidence.

## Related Concerns

- Vault: stores the complete canonical and supporting knowledge space.
- Intelligence: resolves capabilities and assembles task-specific context.
- Runtime: executes implementations against resolved contracts.
- Governance: defines constraints that selective activation must preserve.
- Verification: determines whether the selected context and resulting execution were sufficient.
