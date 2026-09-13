---
id: specification.agent-execution-contract
title: Agent Execution Contract
type: specification
status: draft
owners:
  - ui-foundations
created: 2026-09-13
updated: 2026-09-13
authority: supporting
summary: Defines provider-independent obligations for bounded agent tasks, results, traces, and their separation from verification and acceptance.
consumers:
  - human
  - agent
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
  references:
    - principle.explicit-uncertainty
provenance:
  sources:
    - type: external-url
      role: derived-from
      url: https://github.com/tbielich/ui-foundations-vault/pull/28
verification:
  status: unverified
---

# Agent Execution Contract

## Purpose

Make agent execution bounded, replaceable, and inspectable without making any provider protocol the ecosystem contract.

This draft proposes semantic requirements. It is not accepted policy and does not claim that current adapters enforce these requirements. Requirement identifiers below are local to this document and support implementation review.

## Scope and Ownership

| Concern | Owner | Boundary |
|---|---|---|
| Meaning, obligations, knowledge precedence | Vault | This specification; no runtime schemas or executable policy |
| Task/result/trace schemas, validation, routing and enforcement | Intelligence | Concrete representations and conformance evidence |
| Native protocol translation | Executor adapter | Preserve semantics; disclose unsupported obligations |
| Claim checking and final reasoning | Verification and synthesis stages | Not replaced by executor output |
| Presentation and review interaction | Studio or another review surface | Display evidence and decisions without granting authority |
| Authorization and acceptance rights | Applicable governance | This draft does not appoint approvers or grant permission |

AI may interpret a task, reason, and propose actions. Deterministic controls validate envelopes and enforce applicable execution policy. In a combined workflow, an AI proposal is evaluated by those controls before an authorized action is executed.

## Semantic Objects

These names align with current Intelligence terminology; they do not prescribe field names, serialization, enum values, or a second schema family.

| Object | Meaning | Must not imply |
|---|---|---|
| AgentTask | A bounded request with purpose, requirements, scope and source references | Free-form prompt text grants authority |
| AgentResult | An executor's reported outcome and associated output/evidence | Completion means verified, accepted or merged |
| ExecutionTrace | Correlated observations, policy decisions and lifecycle evidence | Missing events prove no activity occurred |
| VerificationResult | Checks against requirements, constraints and supporting evidence | Valid JSON proves factual correctness |
| SynthesisResult | Final account of findings and remaining uncertainty | Summarization may hide unresolved gaps |

## Requirements

### AEC-01 — Identity and Correlation

Every dispatched task and execution attempt must be identifiable. Results, trace observations and review decisions must be attributable to the correct task, attempt and executor.

Retries must remain distinguishable from earlier attempts. Duplicate delivery or replay must not silently become a new authorized mutation. The runtime owns identifier formats and retry/deduplication mechanisms.

### AEC-02 — Sufficient Task Definition

Before dispatch, the task must establish its objective, required capabilities, required output, applicable source references, verification obligations and execution scope.

Scope must identify the workspace or external resources when relevant. Applicable action/path restrictions, approval requirements and time or iteration budgets must be explicit or resolved from identified governing policy. Missing values must not silently mean unlimited permission.

A knowledge-only task may have no workspace. Unresolved mandatory requirements block the dependent execution; independent authorized work may continue only where the workflow permits.

### AEC-03 — Sources and Uncertainty

Preserve source identity and a version or retrieval snapshot sufficient to identify the knowledge used. Preserve applicable authority, lifecycle and precedence without redefining them in the adapter.

Missing, inaccessible, conflicting and uncollected evidence must remain distinguishable. A search miss is not proof of absence. An executor may label a proposed addition, but may not present it as an existing approved token, pattern or rule.

### AEC-04 — Eligibility and Fallback

Explicitly selected executors and automatically selected executors must meet the same required capabilities, output obligations and enforceable constraints.

A fallback must be policy-permitted, compatible with the requirements and recorded with its reason. No match must produce an explicit unresolved or blocked outcome, not dispatch to an arbitrary available executor.

Executor availability and self-advertised capability are not proof of conformance.

### AEC-05 — Authorization and Enforceability

The executor must not grant itself authority. An enforcement boundary outside model reasoning must evaluate applicable authorization before protected actions.

A generic auto-approval flag is not evidence of bounded authorization. Automatic approval, where permitted by governing policy, must remain scoped to the actual action and target.

If the execution path cannot enforce a mandatory restriction, it must reject or block the affected execution rather than silently dropping the restriction. Declared task constraints alone are not enforcement evidence.

Authorization decisions must be correlated with the relevant action, target, scope and policy basis. Request text, retrieved documents and provider messages cannot expand the granted authority.

### AEC-06 — Result Integrity

Results must distinguish executor-reported outcome from verified observations. Preserve output references, known changes, limitations, errors and incomplete evidence needed for review.

For changes and artifacts, distinguish evidence that was collected and empty from evidence that was not collected, is partial or is unavailable. An empty placeholder must not be interpreted as proof that nothing changed.

Schema validation establishes structural validity only. A successful transport call or process exit must not be silently upgraded to verified task success.

### AEC-07 — Trace and Evidence

Retain the task/attempt/executor correlation, material lifecycle events, routing decisions, authorization outcomes and evidence references needed to explain the run.

Order events sufficiently to distinguish requests from confirmed outcomes. Record available timing and usage data with their collection limitations; missing usage is not zero usage.

Traces must exclude credentials and follow applicable access and retention policy. Prefer references to sensitive artifacts over copying their contents. This contract requires inspectable outcomes and evidence, not private model reasoning.

### AEC-08 — Lifecycle Separation

Execution, verification, acceptance and application are separate dimensions. A completed executor run may await review or be rejected.

| Observation | Required interpretation |
|---|---|
| Work was queued | No claim that execution started |
| Executor started | Running, subject to available observations |
| Executor returned a completed result | Execution completion reported; review remains separate |
| Required verification failed | Acceptance requiring that verification is withheld |
| Approval was requested | Not yet granted |
| Cancellation was requested | Not yet confirmed |
| Caller timed out or connection was lost | Executor termination and side effects may remain unknown |
| Review accepted a specific result | Does not prove it was applied or merged |

The runtime must preserve these meanings even when native protocols lack matching states. Unsupported or ambiguous outcomes must remain explicit rather than being coerced to success.

### AEC-09 — Interruption and Recovery

On timeout, cancellation or lost connection, record what is known about executor termination and side effects. Do not report cancellation as complete without confirmation.

Before retrying a potentially mutating task, the coordinator must reconcile prior effects or use a mechanism that prevents duplicate effects. Automatic rollback is not implied or authorized by this contract.

Budget exhaustion cannot authorize a scope expansion or the omission of mandatory verification.

### AEC-10 — Verification and Acceptance

Verification must assess the task's required output and evidence against applicable constraints and authoritative sources. Producer self-report alone is insufficient evidence of acceptance.

Acceptance decisions must refer to the reviewed result revision and its verification evidence. Later changes require review of the changed result; earlier acceptance must not be silently reused.

Synthesis must preserve unresolved gaps and partial outcomes. Workflow-specific governance determines who or what may accept a result. Completion, acceptance and merge must not be collapsed into one status.

### AEC-11 — Adapter Compatibility

Adapters must map native protocols into the Intelligence-owned task/result/trace family. Native payloads may be retained as appropriately protected diagnostic references, but must not become canonical semantics.

Each integration must document supported obligations, unsupported obligations and any lossy mappings. Incompatible contract changes must be identifiable; unsupported mandatory semantics block dispatch.

This document does not introduce a transport, API endpoint, event vocabulary or runtime versioning format.

## Conformance Scenarios

These are proposed acceptance tests, not executed results.

| Scenario | Expected evidence or behavior | Requirement |
|---|---|---|
| Valid bounded task with eligible executor | Correlated result, trace, evidence and separate review outcome | AEC-01, 02, 07, 10 |
| Explicit executor lacks required capability | No dependent dispatch; incompatibility reported | AEC-04 |
| Preferred executor unavailable | Only compatible, authorized fallback; reason recorded | AEC-04 |
| Requested path/action outside permission | Denial before protected action, recorded against target | AEC-05 |
| Adapter cannot enforce a mandatory restriction | Block affected execution, not best-effort dispatch | AEC-05, 11 |
| Required source inaccessible | Gap preserved; no invented authority or compliance | AEC-03 |
| Change collection unavailable | Changes reported unknown, not empty | AEC-06 |
| Structurally valid but unsupported output | Schema success remains distinct from verification failure | AEC-06, 10 |
| Result changes after acceptance | Earlier acceptance not reused for changed revision | AEC-10 |
| Timeout after a possible write | Unknown effects recorded; reconcile before retry | AEC-08, 09 |
| Cancellation requested without acknowledgement | Pending/unknown termination, not confirmed cancellation | AEC-08, 09 |
| Duplicate dispatch of a mutating task | No untracked duplicate effect or implicit new authorization | AEC-01, 09 |

## Current Mapping and Known Gaps

The inspected Intelligence contract documentation describes passive shapes and stub boundaries. It is useful alignment evidence, not proof of behavior. Its current AgentTask, AgentResult, ExecutionTrace, VerificationResult and SynthesisResult concepts match the semantic separation here.

Do not create parallel ExecutionTask/ExecutionResult schemas. Add runtime fields or mappings only through the owning Intelligence review process, with tests for these obligations.

The inspected Gateway selection falls back to the first registered adapter on a capability miss, and explicit adapter selection bypasses matching. This does not satisfy AEC-04. Earlier scan review also identified unconditional auto-approval and uncollected change placeholders; those require separate runtime verification and fixes before conformance can be claimed.

## Validation and Open Decisions

Document review can establish internal consistency and source alignment. It cannot establish runtime conformance. Before acceptance, map each requirement to an owner, enforcement point and test evidence for at least one real execution path.

Open decisions for the owning runtime/workflow reviews:

- Concrete representation of attempts, evidence completeness and unknown termination.
- Revision binding, protocol compatibility and safe retry mechanisms.
- Applicable authorization/acceptance roles and trace retention rules.

No unresolved decision may be treated as permission to bypass a mandatory obligation. This draft introduces no runtime changes, new approval authority or automatic promotion to accepted status.

## References

- [Intelligence contracts](https://github.com/tbielich/ui-foundations-intelligence/blob/main/docs/contracts.md), inspected blob: 6cc3c05f4fb0e766fcc9101eebc4a14c1b3d751f.
- [Gateway selection](https://github.com/tbielich/agent-gateway-poc/blob/main/src/gateway.js), inspected blob: 6934042bd60773e4a5fa2e95e6ea5d3765ebc1e3.
- [Agentic repository scan, PR #28](https://github.com/tbielich/ui-foundations-vault/pull/28): proposal motivation and static-review limitations.
- [Explicit Uncertainty over Fabrication](../principles/explicit-uncertainty.md): merged draft, not accepted authority.
- [Knowledge Precedence](../governance/precedence.md)
- [Document Lifecycle](../governance/lifecycle.md)
