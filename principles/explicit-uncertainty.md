---
id: principle.explicit-uncertainty
title: Explicit Uncertainty over Fabrication
type: principle
status: draft
owners:
  - ui-foundations
created: 2026-09-13
updated: 2026-09-13
authority: supporting
summary: Preserve the distinction between supported knowledge, uncertainty, and proposals instead of inventing authority to complete a task.
consumers:
  - human
  - agent
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
provenance:
  sources:
    - type: external-url
      role: derived-from
      url: https://github.com/tbielich/ui-foundations-vault/pull/28
verification:
  status: unverified
---

# Explicit Uncertainty over Fabrication

## Purpose

Protect the trustworthiness of design-system knowledge and agent-assisted work when required evidence, authoritative guidance, or permission is unavailable.

This is a proposed principle, not accepted policy. Its effectiveness and runtime enforcement have not been evaluated.

## Core Principle

Represent uncertainty explicitly. Never present invented knowledge, inferred permission, or an unverified result as an established fact merely to complete a task.

A useful result preserves the boundary between what is supported, what is unknown, what is inferred, and what is proposed. Completeness is not worth false authority.

## Guidance

### Missing evidence is not evidence of absence

An unsuccessful search establishes that a source was not found within the search performed. It does not establish that the source does not exist.

Missing knowledge, inaccessible sources, conflicting guidance, and uncollected evidence have different meanings. Preserve those distinctions and describe the affected scope without inventing a cause.

### Proposals remain possible

This principle permits brainstorming, design exploration, and new token or pattern proposals. Label proposed additions and explain relevant assumptions; do not describe them as existing or approved system knowledge.

An inference should state its supporting evidence and limits. A proposal or inference does not become authoritative through repetition, confidence, or inclusion in a generated artifact.

### Stop only the work that depends on the gap

When a decision depends on missing mandatory governance, accessibility, security, permission, or verification evidence, do not take the dependent action or claim compliance.

Independent work may continue within its authorized scope. Partial delivery is appropriate only when the governing workflow permits it and the unresolved limitations remain visible. An uncertainty label does not authorize an otherwise prohibited action.

The owning workflow defines clarification and escalation behavior; this principle does not prescribe retry counts, retrieval mechanisms, or approval roles.

### Preserve uncertainty through handovers

Summaries, context packages, executor outputs, verification, and final responses should retain material gaps, assumptions, and unresolved conflicts. A downstream consumer must not receive a stronger claim than the evidence supports.

Schema validity, successful execution, and model confidence are not substitutes for factual verification or acceptance.

## Examples

These are illustrative interpretations, not runtime status values or a new taxonomy.

| Situation | Appropriate interpretation | Unsupported interpretation |
|---|---|---|
| A token is not found in the searched sources | State the search scope and unresolved reference; offer a labeled proposal if requested. | Invent a token and call it canonical. |
| The authoritative source cannot be accessed | State that it is inaccessible and leave the dependent claim unresolved. | Conclude that no rule exists. |
| No executor meets a required capability | Report the unmet requirement; only use a permitted alternative that still meets it. | Silently choose an incompatible executor. |
| Change evidence was not collected | Report that changes are unknown. | Treat an empty placeholder as proof that no files changed. |
| Required accessibility evidence is missing | Leave the affected compliance claim unverified and withhold acceptance that depends on it. | Claim compliance because the output passes its schema. |
| A requested design exploration introduces a new pattern | Present it as a proposal with assumptions and review needs. | Present it as an already approved pattern. |

## Human, Agent, and System Implications

- Human: reviewers can identify what needs a decision, more evidence, or an owner without losing useful partial work.
- Agent: generation can explore options, but it cannot manufacture facts or grant authority.
- System: automation preserves explicit evidence states; AI may analyze gaps and propose alternatives, while governed workflows control execution and acceptance.

## Boundaries

This principle does not create a universal gap schema, a confidence threshold, or a requirement to ask a human about every uncertainty. It does not promise hallucination-free execution.

Vault knowledge defines durable meaning. Intelligence owns runtime representations and enforcement. Existing precedence and lifecycle rules remain authoritative; this draft cannot override them.

Selective context loading must not turn omitted evidence into an assumption that no constraint applies.

## Review and Evaluation

Before acceptance, review the distinction between exploratory generation and authoritative claims against at least one real UIF workflow.

Evaluation should include missing sources, inaccessible sources, unresolved conflicts, uncollected change evidence, and an explicitly requested new design proposal. Check whether material uncertainty survives synthesis, whether dependent actions remain blocked when required, and whether independent authorized work can continue.

Open question: which workflow-specific obligations determine when partial output is acceptable? Resolve this in the relevant workflow or specification, not through an invented global threshold.

## References

- [Agentic repository scan and code-review qualifications, PR #28](https://github.com/tbielich/ui-foundations-vault/pull/28): motivation for this proposal, not accepted authority.
- [Design AI Orchestrator README](https://github.com/tbielich/design-ai-orchestrator/blob/main/README.md): documented intent to surface missing design-system information rather than invent it.
- [Intelligence context loading](https://github.com/tbielich/ui-foundations-intelligence/blob/main/docs/context-loading.md): planned missing-knowledge handling, not proof of enforcement.
- [Knowledge Precedence](../governance/precedence.md)
- [Document Lifecycle](../governance/lifecycle.md)
