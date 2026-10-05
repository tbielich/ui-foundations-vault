---
id: knowledge.agentic.spike-2026-10-05-agentic-load-matrix
title: Agentic Load Spike — Initial UIF Workflow Matrix
type: research
status: draft
owners:
  - ui-foundations
created: 2026-10-05
updated: 2026-10-05
authority: supporting
summary: Artifact-based classification of real UIF workflow profiles, evidence gaps, and a proposed calibration sample.
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
  references:
    - knowledge.agentic.research-2026-10-05-human-agent-span-of-control
    - specification.agent-execution-contract
    - workflow.component-review
    - workflow.design-knowledge-pilot
verification:
  status: partially-verified
assumptions:
  - Review demand and risk classifications are analyst estimates, not measured human workload.
  - Documented execution boundaries do not establish current provider permissions or production enforcement.
---

# Agentic Load Spike — Initial UIF Workflow Matrix

## Purpose and result

Apply the [Human–Agent Span of Control research](./research-2026-10-05-human-agent-span-of-control.md) to existing UIF artifacts. This is a completed artifact-classification spike, not a completed longitudinal capacity pilot. It introduces no ADR, governance rule, execution-contract fields, permission grants, automation, or agent-count limit. UIF remains separate from TUI UILib.

The sample shows why workflow count alone loses useful information: a research synthesis, a bounded accessibility implementation, and a token/Figma repair expose different review surfaces and consequences. Two actual change records contain concrete exceptions. None of the reviewed cases contains sufficient human time data to calculate net capacity or a reliable exception rate.

## Method and evidence boundaries

Unit of analysis: one bounded workflow from intake through its review handoff, including its execution and verification stages. Agent/provider names are provenance, not load categories. A role or capability description alone is not proof that a workflow ran.

Reviewed on 2026-10-05:

- Vault snapshot `e6e893fdcffadeff8f02d3c45894ee45fa4bd28b` (the still-open research PR #57, based on current main). All relative Vault source links below refer to files in this snapshot.
- Intelligence committed snapshot `186161048465e9d182b11696c8af7aa958429fbc`. Local uncommitted changes were excluded from the classification.
- GitHub PR state, body and changed-file metadata for Runtime #317 and #310, and Vault #57. PR bodies are author-reported historical evidence, not independently rerun test results. Runtime #317's committed REPORT was also read.

Evidence labels: **recorded case** means an actual PR/artifact exists; **documented profile** means existing workflow or implementation artifacts were inspected without observing a live run. Confidence applies to the boundary classification; all workload estimates remain provisional. Exceptions below distinguish observed issues from possible failure modes. Unknown rates remain unknown, never zero.

## Working rubric for this spike

These labels are comparison aids only. They are not policy tiers and do not determine allowed autonomy.

| Dimension | Working anchors |
| --- | --- |
| Autonomy | A0: recommendations only; A1: bounded artifact changes with review handoff; A2: bounded sequencing/revision through an executor and verification lifecycle; A3: ongoing or externally consequential execution. No A3 operation is demonstrated here. |
| Risk | Low: local advisory/document errors; medium: reusable guidance or bounded implementation errors; high: accessibility/brand behavior or coupled external state. Rate consequences for the stated scope, not the provider. |
| Review demand | Low: one short output with sources; medium: several sources/diff plus authority checks; high: independent execution evidence, rendered behavior, failures or multiple systems. These are anticipated effort bands, not minutes. |
| Exceptions | Record actual blocker/rework separately from anticipated modes. Rate requires a run denominator and observation window. |
| Reversibility | High: pre-merge Git/document changes; conditional: rollback needs external readback or repair, or publication has already occurred. Reversion does not recover consumed human time or disclosure. |
| System / permission scope | List read and write surfaces separately. Task authorization is distinct from the account's available capability. Final acceptance/merge is distinct from tool approval. |

## Initial matrix

Risk, review and overall load are hypotheses from the inspected artifacts. Overall load is a qualitative synthesis with an explicit reason, not a sum or calibrated score.

| ID / workflow and evidence | Autonomy | Risk | Review demand | Exceptions: observed / anticipated; rate | Reversibility | System / permission scope | Initial load / confidence |
| --- | --- | --- | --- | --- | --- | --- | --- |
| W1 External research → Vault synthesis; recorded [PR #57](https://github.com/tbielich/ui-foundations-vault/pull/57), [research projection](../../exports/agent-pack/projections/perplexity-research.md) | A0 research → A1 documentation; original research tool access not inspected | Medium: unsupported external claims can become reusable guidance | Medium: primary-source traceability, uncertainty, supporting authority | Observed: research note marks Asana time-saving claim unverified. Anticipated: missing uploaded context mistaken for a repository gap. Rate unknown | High for pre-merge docs; external sharing cannot be recalled by Git | Research/source reads and Vault branch/PR writes; no implementation ownership or new governance authority | Medium: evidence checking dominates / medium; underlying research not revalidated here |
| W2 Component proposal review; documented [workflow](../../workflows/component-review.md), [verification capability](../../agents/capabilities/verification.md) | A0 recommendation; follow-up decisions/specs remain separate work | Medium, potentially high for accessibility findings relied upon downstream | High: anatomy, states, semantics, tokens, responsive and accessibility evidence | No run observed. Anticipated: absent visual/state evidence or conflicting guidance; rate unknown | High for recommendation; downstream adoption changes exposure | Vault/proposal/evidence reads; recommendation output; source workflow does not grant implementation writes | Medium–high: broad judgment surface despite no writes / medium |
| W3 Bounded issue → executor → verification → human review; documented Intelligence implementation [S1–S3] | A2 bounded lifecycle; actual run autonomy not observed | Medium for allowlisted code; consequence depends on task | High: inspect complete changed paths, validations, task/result/trace correlation and residual uncertainty | No run observed. Anticipated: missing changed-path evidence, verifier error, uncertain worker, retry/resume mismatch; rate unknown | High for isolated unmerged changes; conditional if task permits external effects | GitHub issue read, local workspace writes and optional local trace writes. Tool policy and path bounds are task-specific; completion does not grant merge approval | High: evidence reconstruction and exception handling / medium; runtime not exercised |
| W4 Accessibility implementation and evidence handoff; recorded [Runtime PR #310](https://github.com/tbielich/ui-foundations-runtime/pull/310) | A1 bounded Cline implementation; sequencing observed only through author report | High: false accessibility acceptance affects users; implementation scope is bounded | High: browser evidence, failures, freshness, checklist scoring and independent verification | Observed in PR body: 2 browser criteria fail; mixed Checkbox/axe issue; independent verification pending. Not 2 agent exceptions or a rate. PR open at inspection; later repair status not inferred | High for unmerged implementation; component repair is a separate decision | Runtime allowlisted code/evidence writes and local Chromium checks; PR records no component/token repair or merge/release authority | High: unresolved correctness and independent review / medium; historical body not rerun |
| W5 Action label / Outline border repair across tokens and Figma; recorded [Runtime PR #317](https://github.com/tbielich/ui-foundations-runtime/pull/317), [S4] | A1 bounded edits; source artifacts do not prove unattended autonomy | High: brand identity, contrast and live variable parity | High: Brand × Scheme × State, aliases, IDs/scopes, readback, screenshots and CI | Observed: first independent projection check found stale default-alias metadata; correction/final pass recorded. Rate unknown; no run denominator | Conditional: Git changes revert separately from Figma; external variable rollback requires prior-state restoration and readback | Runtime token exports/tests/evidence writes plus authorized Figma slots/scope change. Report records 767-variable fingerprint comparison; no broad Figma permission claim | High: coupled state and multidimensional review / medium–high for recorded boundaries |
| W6 Vault → consumer guidance projection; documented [sync](../../docs/cross-repo-knowledge-sync.md), [Kiro projection](../../exports/agent-pack/projections/kiro-bootstrap.md) | A0 reference use; A1 only when a reviewed patch is separately requested | Medium: copied/duplicated instructions can drift or overstate authority | Medium–high: source precedence, ownership, protected files and consumer diff | No sync run observed. Anticipated: duplicate steering, stale projection, unintended protected-file overwrite; rate unknown | High before merge; conditional after guidance is distributed/adopted | Vault reads; live repository reference needs no extra copy. Consumer patch writes require their own bounded scope | Medium for reference; high for cross-repo patch / medium |

## Source ledger and traceability

Vault sources also inspected: [Execution Contract](../../specifications/agent-execution-contract.md), [Architecture Review](../../operational/architecture-review.md), [Release Review](../../operational/release-review.md), [Design Knowledge Pilot](../../workflows/design-knowledge-pilot.md). Their lifecycle/authority remains as declared; a draft obligation is not evidence of enforcement.

Pinned implementation/case sources:

- **S1:** [Intelligence agentic workflow](https://github.com/tbielich/ui-foundations-intelligence/blob/186161048465e9d182b11696c8af7aa958429fbc/docs/agentic-workflow.md): Issue-Driven Dispatch, Execution Verification, Evidence Requirements and Trace Expectations. The verifier evaluates supplied evidence; it does not collect actual diffs/run checks or grant GitHub merge approval.
- **S2:** [Supervision contracts](https://github.com/tbielich/ui-foundations-intelligence/blob/186161048465e9d182b11696c8af7aa958429fbc/src/intelligence/contracts/supervision.py): `SupervisedState` and `SupervisedRun` expose attempt, repair, inspection, worker uncertainty and feedback state.
- **S3:** [Executor boundary](https://github.com/tbielich/ui-foundations-intelligence/blob/186161048465e9d182b11696c8af7aa958429fbc/src/intelligence/runtime/executors.py): `SupervisedAgentExecutor` describes tool-boundary enforcement, resume behavior and complete evidence obligations; a protocol declaration alone does not prove every adapter conforms.
- **S4:** [Runtime #317 report at its head SHA](https://github.com/tbielich/ui-foundations-runtime/blob/517fb9ff1631b007c778d89cac8576a17e5ffe83/figma/migrations/action-label-border-parity-2026-09-30/REPORT.md): explicit first-check failure, correction and final pass, brand-specific behavior and bounded live-variable comparison. GitHub records #317 merged; this spike did not rerun its tests or read Figma.

No credentials, private trace payloads or local session content are copied here. Existing public PR/source links provide the evidence boundary. The sample is purposive, not representative of every UIF agent, release or connector; documented profiles must not be counted as successful production runs.

## Findings and calibration limits

1. Write scope alone underestimates review demand: W2 is recommendation-only but requires several kinds of judgment.
2. Test completion alone underestimates supervision: W4 preserves failures and a pending independent gate; W5 needed metadata correction despite a bounded change surface.
3. System coupling changes reversibility: W5 spans Git and Figma; W6 may distribute knowledge into multiple consumers.
4. An executor's terminal result is not human acceptance. W3 exposes a useful evidence lifecycle, but no measured attention budget or capacity gain follows from its existence.
5. There is no empirical basis here for numeric weights, thresholds, an agent-per-person cap, or permission expansion. Risk remains visible independently of workload; low estimated load cannot cancel a material risk.

Change frequency, concurrent exceptions, response latency, and shared-owner/context switching are unmeasured. W4 and W5 may compete for the same accessibility/brand reviewer; W1 and W6 may share knowledge provenance. These are portfolio hypotheses, not observed concurrent operations. Autonomy may reduce routine attention while making exceptional interventions harder; the rubric is not monotonic proof that higher autonomy always costs more.

## Proposed next calibration sample — not executed

Compare W1, W4 and W5 over repeated comparable runs, as a low-coupling documentation case, a bounded implementation with failed checks, and a coupled Git/Figma case. If W4/W5 are unavailable, choose equivalent future tasks rather than replaying or broadening their old authorization. This proposal does not authorize provider access or writes.

For each run, record task scope and source SHA, reviewer/owner role, start/end, active human minutes for orchestration, verification, exception handling, coordination and maintenance, rework, intervention count, quality outcome, and evidence locator. Record elapsed executor/wait time separately: it is not human effort. An exception is an unplanned intervention outside the normal review step; one failed criterion is not automatically one exception. Report exceptions per completed/attempted run with the denominator and window, and retain blocked/canceled runs to avoid survivor bias.

| Run / workflow | Avoided manual minutes and baseline basis | Orchestration | Verification | Exceptions | Coordination | Maintenance | Net capacity | Intervention count / attempted runs | Quality / risk outcome | Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Not collected | Unknown; no comparable manual baseline | Unknown | Unknown | Unknown | Unknown | Unknown | Not calculable | Unknown | See historical evidence above, not a measured pilot | Pending |

Candidate calculation: `net capacity = avoided manual work − orchestration − verification − exceptions − coordination − maintenance`. Use mutually exclusive time categories to avoid double counting; disclose baseline estimation uncertainty. Include setup/maintenance in the observation window. Correctness and existing approval boundaries stay independently visible even when capacity appears positive.

For calibration, have a second reviewer classify the same tasks before seeing the first ratings, record disagreements, and compare the predicted review/load bands with observed active effort. A later decision would need repeatable evidence about effort, rework, quality and portfolio coupling. This spike supplies the source-linked starting matrix and measurement gaps only.
