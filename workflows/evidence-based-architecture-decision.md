---
id: workflow.evidence-based-architecture-decision
title: Evidence-Based Architecture Decision
type: workflow
status: review
owners:
  - ui-foundations
created: 2026-10-03
updated: 2026-10-03
authority: source
summary: Defines the canonical UIF workflow from research through hypothesis, ADR, spike, evidence, and final decision.
related:
  references:
    - governance.precedence
    - governance.lifecycle
    - adr.agent-collaboration-protocol-boundaries
    - adr.capability-based-execution
---

# Workflow: Evidence-Based Architecture Decision

## Purpose

Use this workflow when a UIF architecture, governance, protocol, capability, or system-boundary question has enough blast radius, uncertainty, or expected lifetime that it should not be resolved as an ad-hoc implementation choice.

The workflow separates discovery, proposed reasoning, normative decision-making, implementation experiments, observed evidence, and final acceptance.

It is intended for humans, agents, and mixed human-agent workflows.

The canonical progression is:

```text
Research
  ↓
Hypothesis
  ↓
ADR
  ↓
Spike
  ↓
Evidence
  ↓
Decision
```

The stages describe governance maturity, not delivery status. Operational project status such as Backlog, Ready, In progress, Review, or Done remains a separate dimension.

## Inputs

- A concrete architecture, governance, protocol, capability, or system-boundary question.
- Existing higher-precedence Vault knowledge relevant to the question.
- Known constraints, dependencies, risks, and unresolved assumptions.
- External or internal research where evidence is needed.
- A named workflow owner.

## Preconditions

Before entering the workflow:

- search existing Vault decisions and specifications to avoid duplicate decisions;
- identify the highest-precedence relevant source;
- distinguish an implementation defect from a durable architecture question;
- record material uncertainty rather than silently resolving it;
- define the decision boundary narrowly enough to evaluate.

Not every change requires this workflow. Local, reversible, low-blast-radius implementation choices may remain in normal delivery flow.

## Stages

### 1. Research

Collect evidence relevant to the decision question.

Research may include:

- standards and protocol specifications;
- framework or vendor guidance;
- implementation examples;
- benchmarks and experiments;
- existing UIF repository evidence;
- operational incidents or failure modes;
- prior ADRs and governance documents.

Research is informative. It does not become normative merely by being collected.

**Exit criteria:**

- the question is explicit;
- the strongest available evidence is summarized;
- source limitations and uncertainty are visible;
- relevant prior UIF knowledge has been checked;
- material alternatives are identified.

**Primary output:**

- research artifact or evidence set.

### 2. Hypothesis

Convert research into a falsifiable architectural proposition.

A useful hypothesis states:

- what UIF should do;
- why this is expected to improve the system;
- under which conditions it should hold;
- what evidence could disprove or narrow it.

Example form:

> If UIF uses protocol-neutral work and event contracts with orchestration-first collaboration, then multiple agents and automations can participate without provider coupling, while A2A can be introduced later only at genuine service boundaries.

**Exit criteria:**

- the proposition is specific enough to evaluate;
- expected benefits and risks are explicit;
- required evidence is identified;
- the hypothesis does not silently become policy.

**Primary output:**

- hypothesis statement linked to research evidence.

### 3. ADR

Record the durable proposed architecture decision.

The ADR should define:

- context;
- decision;
- consequences;
- alternatives considered;
- verification criteria;
- relationships to higher-precedence governance and principles.

An ADR in `review` is not authoritative. It becomes normative only according to the Vault document lifecycle.

**Exit criteria:**

- the decision boundary is explicit;
- alternatives and tradeoffs are recorded;
- verification criteria are measurable enough for a spike or implementation check;
- no unresolved conflict with higher-precedence knowledge is hidden.

**Primary output:**

- review-stage ADR.

### 4. Spike

Perform the smallest bounded implementation or experiment needed to test the decision.

A spike should:

- test the hypothesis rather than build the full product;
- declare scope and acceptance criteria;
- use bounded authority;
- preserve existing production or canonical behavior unless explicitly approved;
- produce inspectable artifacts;
- avoid converting experimental behavior into hidden architecture.

Possible spike outputs include:

- branch or pull request;
- prototype;
- schema;
- adapter;
- benchmark;
- integration test;
- workflow simulation;
- UI prototype.

**Exit criteria:**

- the experiment ran against the defined conditions;
- deviations from the planned test are recorded;
- outputs are reproducible or inspectable;
- failures are preserved as evidence rather than discarded.

**Primary output:**

- experimental implementation and execution artifacts.

### 5. Evidence

Evaluate the spike against the hypothesis and ADR verification criteria.

Evidence should distinguish:

- observed result;
- interpretation;
- limitation;
- unresolved uncertainty.

Evidence may include:

- test results;
- pull-request checks;
- performance or cost measurements;
- failure and retry behavior;
- accessibility or browser results;
- audit findings;
- human review;
- artifact lineage;
- comparison against the baseline.

Agent self-assessment is not sufficient evidence when independent verification is available or required.

**Exit criteria:**

- each relevant verification criterion is addressed;
- contradictory or negative evidence is preserved;
- evidence can be traced to source artifacts and revisions;
- the remaining uncertainty is explicit.

**Primary output:**

- evidence record linked to the ADR and spike.

### 6. Decision

Use the accumulated evidence to accept, revise, reject, supersede, or defer the proposed decision.

Possible outcomes:

- **accept** — the ADR can move to an authoritative lifecycle state;
- **revise** — evidence changes the proposed decision and the ADR returns to review;
- **reject** — the hypothesis is not supported or the tradeoff is unacceptable;
- **defer** — evidence is insufficient or a dependency is unresolved;
- **supersede** — a newer decision replaces an existing one.

Human approval is required where governance or the affected ADR defines it.

**Exit criteria:**

- the outcome is explicit;
- the decision owner is identifiable;
- evidence supporting the outcome is linked;
- follow-up work is separated from the decision itself;
- affected lower-precedence specifications, workflows, or implementation tasks are identified.

**Primary output:**

- accepted/revised/rejected/deferred decision state and follow-up work.

## Workflow Rules

- Research does not override governance.
- A hypothesis is a proposal, not a decision.
- An ADR defines a decision; it should not contain the complete experimental implementation.
- A spike tests the decision and must remain bounded.
- Evidence records observations before interpretation.
- Negative evidence is first-class evidence.
- A decision must be attributable to a defined owner.
- Delivery status and governance stage are separate dimensions.
- Free-form agent conversation is not authoritative workflow state.
- Durable artifacts and explicit state transitions should be preferred over conversational memory.

## GitHub Project Projection

When represented in the UIF GitHub Project, use a dedicated governance-stage dimension rather than overloading operational status.

Recommended single-select field:

`Governance stage`

Recommended values:

- `Research`
- `Hypothesis`
- `ADR`
- `Spike`
- `Evidence`
- `Decision`
- `—`

`—` means the item does not participate in this governance workflow.

Operational project status remains independent.

Example:

```text
Status:            In progress
Layer:             Intelligence
Governance stage:  Evidence
```

Recommended views:

- **Decision Pipeline** — grouped or filtered by governance stage;
- **Agent Ready** — bounded tasks with sufficient specification and authority for execution;
- **Approval Queue** — items requiring an explicit human decision or approval.

The GitHub Project is a planning and portfolio projection of this workflow. It is not the authoritative evidence store or workflow engine.

## Outputs

Depending on the decision, the workflow produces:

- research artifacts;
- a hypothesis;
- an ADR;
- a bounded spike;
- evidence;
- a final decision state;
- follow-up specifications, issues, or implementation work.

## Verification

The workflow is complete when:

- the original decision question has a recorded outcome;
- research, hypothesis, ADR, spike, evidence, and decision are traceable where applicable;
- the final outcome can be explained without relying on hidden chat context;
- evidence supports or challenges the decision explicitly;
- operational delivery state is not confused with governance maturity;
- follow-up implementation work is represented separately from the completed architecture decision.

## Exceptions

A stage may be skipped only when its purpose is already satisfied by durable existing evidence.

Examples:

- an existing accepted external standard may remove the need for a new spike;
- a prior reproducible UIF experiment may already provide sufficient evidence;
- a rejected hypothesis may end the workflow before an ADR is created.

Skipped stages must be intentional and explainable. The workflow must not imply evidence that was never produced.
