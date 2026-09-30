---
id: workflow.research-to-decision
title: Research to Decision
type: workflow
status: review
owners:
  - ui-foundations
created: 2026-09-19
updated: 2026-09-19
authority: source
summary: Defines the evidence-driven path from external or internal research to durable UIF architectural decisions.
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
  references:
    - specification.document-structure
---

# Workflow: Research to Decision

## Goal

Turn promising external research, internal observations, experiments, or practitioner evidence into durable UIF decisions without allowing trends, vendor implementations, or unverified assumptions to silently become architecture.

The workflow is:

```text
Research → Hypothesis → ADR → Spike → Evidence → Decision
```

Each stage has a distinct purpose and authority. Progression is deliberate; later stages must not be inferred merely because an earlier artifact exists.

## Inputs

One or more of:

- external research, standards, papers, or practitioner reports;
- internal UIF observations or lessons;
- repeated implementation friction;
- an architectural question with multiple reasonable options;
- a proposed capability or pattern whose consequences are not yet sufficiently evidenced.

## Steps

### 1. Research

Capture the source, claim, context, and potential relevance to UIF.

Research is supporting knowledge, not a UIF decision. External implementation details remain evidence about another system until their applicability to UIF is evaluated.

Expected questions:

- What exactly is claimed or observed?
- What is the primary source?
- What evidence supports the claim?
- Which UIF concern could this affect?
- Does an existing accepted or stable UIF source already govern the concern?

Output: a research note or lesson with supporting authority.

### 2. Hypothesis

Translate the research signal into a falsifiable UIF-specific architectural hypothesis.

A hypothesis should state what we expect to be true in UIF without prematurely defining it as policy.

Example:

> Shared transport-neutral capability handlers can support CLI and MCP projections without duplicating execution semantics.

Expected questions:

- What UIF outcome do we expect?
- What assumptions does the hypothesis depend on?
- What would disprove it?
- Which Human, Agent, and System consequences matter?

Output: an explicit hypothesis recorded in the research, ADR context, issue, or bounded experiment contract.

### 3. ADR

When the hypothesis concerns a durable architectural choice, create an ADR in review state.

The ADR defines the decision boundary, alternatives, trade-offs, consequences, and required verification. It should decide the durable architectural concern rather than prematurely standardizing one vendor, tool, or implementation technique.

An ADR in review is a proposal to evaluate. It is not yet evidence that the architecture works.

Output: review-stage ADR with explicit verification criteria.

### 4. Spike

Run the smallest bounded experiment capable of testing the material assumptions behind the ADR.

A spike is implementation evidence, not production scope. It should avoid unrelated refactoring and should use the same contracts and boundaries proposed by the ADR wherever practical.

The spike contract should define:

- hypothesis under test;
- bounded scope;
- baseline or comparison where relevant;
- success and failure criteria;
- measurements to collect;
- prohibited scope expansion.

Output: bounded experimental implementation and reproducible execution instructions.

### 5. Evidence

Verify the spike independently of executor self-report.

Evidence should be persisted and sufficient to determine whether the hypothesis was supported, contradicted, or remains inconclusive.

Depending on the decision, useful evidence may include:

- deterministic test/check results;
- semantic equivalence;
- latency;
- tool-call count;
- context or token consumption;
- failure behavior;
- maintainability or duplication indicators;
- consumer dependency impact;
- trace or provenance records.

Evidence must distinguish observation from interpretation.

Output: persisted verification evidence and an explicit PASS, FAIL, or BLOCKED assessment for the bounded hypothesis.

### 6. Decision

Revisit the ADR using the collected evidence.

Possible outcomes:

- **Accept** — evidence supports the decision and no blocking conflict remains.
- **Revise** — evidence supports the direction but requires a material change to the proposed decision.
- **Reject** — evidence contradicts the hypothesis or demonstrates unacceptable consequences.
- **Keep in review** — evidence is insufficient or blocked.

Only the resulting durable UIF decision should be promoted. Vendor-specific details, experimental scaffolding, and temporary implementation choices remain supporting evidence unless separately justified.

Output: updated ADR lifecycle state and links to the evidence that justified the outcome.

## Outputs

A complete path should leave repository state sufficient to reconstruct why the decision exists:

```text
Research
  ↓ source + claim + relevance
Hypothesis
  ↓ testable UIF expectation
ADR (review)
  ↓ decision boundary + alternatives + verification criteria
Spike
  ↓ bounded experiment
Evidence
  ↓ independent verification
Decision
  ↓ accepted / revised / rejected / remains review
```

Conversation history is not required to reconstruct the decision.

## Constraints

- Research does not override accepted or stable UIF governance, principles, ADRs, or specifications.
- An external vendor's architecture is evidence, not UIF authority.
- Do not create a spike merely to confirm a preferred conclusion; define failure criteria first.
- Keep experimental implementation bounded to the assumptions that need evidence.
- Executor self-report is not verification evidence.
- Verification must not silently create new implementation scope.
- Provider-specific behavior belongs in adapters or experiment-specific configuration unless the ADR explicitly concerns that provider.
- Not every research finding requires an ADR. Use an ADR only when a durable choice with meaningful alternatives or consequences exists.
- Not every ADR requires a code spike. When documentary, standards-based, or already-existing evidence sufficiently verifies the decision, record that evidence instead.

## Verification

This workflow is working when:

- a reviewer can trace a durable decision back to its research and evidence;
- hypotheses are distinguishable from decisions;
- review-stage ADRs state what evidence is required before acceptance;
- spikes are bounded and reproducible;
- evidence is persisted independently of executor claims;
- failed or inconclusive experiments can keep an ADR in review or cause revision/rejection without forcing adoption;
- accepted decisions do not depend on reconstructing ChatGPT or agent conversation history.

## Related

- `governance/lifecycle.md`
- `governance/precedence.md`
- `templates/adr-template.md`
- `templates/workflow-template.md`
- `knowledge/agentic/research-2026-09-18-agent-ready-foundations.md`
- `decisions/transport-neutral-capabilities.md`
