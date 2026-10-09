---
id: publication.local-model-benchmark-series-2026-10-09
title: Local Model Benchmark Series v1–v3 — Research Synthesis
type: publication
status: draft
owners:
  - ui-foundations
created: 2026-10-09
updated: 2026-10-09
authority: supporting
summary: Consolidates three bounded local-model experiments and their limits without proposing an automatic UIF-INT routing or verification policy change.
tags:
  - agentic
  - evaluation
  - local-models
  - verification
consumers:
  - human
  - agent
applies_to:
  - ui-foundations-intelligence
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
    - governance.verification-review
verification:
  status: unverified
assumptions:
  - Aggregate results are transcribed from supplied Codex reports; raw local artifacts were not independently inspected for this synthesis.
  - v1 and v2 differ in both prompts and fixtures; cross-version changes do not isolate prompt effects.
  - Three deterministic repetitions of a fixture are not three independent tasks.
review_cycle: on-change
stability: experimental
---

# Local Model Benchmark Series v1–v3 — Research Synthesis

## Purpose and status

Record the evidence and limitations of the October 9, 2026 local-model experiments relevant to UIF-INT. This is **candidate research**, not an accepted capability specification, routing decision, verification policy, or ADR. The series is closed for now; a new benchmark requires a separately bounded research question.

**Evidence boundary:** This synthesis uses the three Codex outcome reports supplied by the operator. The reports state that inputs, outputs and scoring can be reconstructed from local artifacts, but those artifacts have not been independently opened or replayed during preparation of this Vault note. Accordingly, the document is marked `verification.status: unverified`. The figures below are **reported results**, not a second verification of the underlying runs.

## Experimental inventory

| Experiment | Model calls | Design | Reported outcome |
| --- | ---: | --- | --- |
| v1: local model capability screening | 108/108 | 12 synthetic cases × 3 models × 3 repetitions; token, contract, evidence, code categories | Execution completed; initial task-specific signals, including false PASS outcomes |
| v2: revised capability screening | 108/108 | 12 revised synthetic cases × 3 models × 3 repetitions; explicit contract rules | Execution completed; Qwen3-Coder 36/36 for the revised bounded tasks |
| v3: verification evidence analysis | 120/120 | 40 new synthetic evidence cases × 1 model × 3 repetitions; five categories | Execution and evidence integrity PASS; model classified not suitable for the tested capability |
| **Total** | **336** | Different task families and evaluation regimes | **Do not aggregate accuracy across experiments** |

The environments were reported as a MacBook Pro with an Apple M3 Pro, 36 GB RAM and macOS 27.0.1, running on battery. Qwen used Q4_K_M quantization, a 4096-token context, temperature 0 and seed 42; Qwen3 thinking was disabled. Apple FM used greedy decoding; its exact system-model weights were unavailable. Runtime, output lengths, model implementations and prompts can confound comparisons.

## Results: v1 and v2

**Reported exact-match successful runs (out of 36 per model and experiment):**

| Model | v1 total | v2 total | v2 tokens | v2 contracts | v2 evidence | v2 code |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Apple FM | 9/36 | 3/36 | 0/9 | 3/9 | 0/9 | 0/9 |
| Qwen3:14B | 21/36 | 21/36 | 0/9 | 9/9 | 3/9 | 9/9 |
| Qwen3-Coder:30B | 21/36 | 36/36 | 9/9 | 9/9 | 9/9 | 9/9 |

- **v1**: Apple FM returned three incorrect PASS outcomes for the E3 defective-evidence case. None of the models achieved 9/9 in contract cases. The contract labels were enumerated but their semantics were not fully specified, so the results also reflect an instruction-design limitation.
- **v2**: Contract rules were explicit. Qwen3-Coder:30B completed all revised tests successfully. No false PASS outcomes were reported in v2. Code tasks selected among supplied repair codes; they did not test independent implementation or free-form code repair.
- **Comparability**: Both fixtures and prompts changed between v1 and v2. Their score differences are **not** controlled evidence of prompt improvement or a change in intrinsic model capability.
- Reported warm response medians were v1: Apple 0.92 s, Qwen3:14B 1.70 s, Qwen3-Coder:30B 0.77 s; v2: Apple 0.91 s, Qwen3:14B 2.31 s, Qwen3-Coder:30B 0.77 s. These are not matched-token throughput benchmarks.

## Results: v3 evidence-analysis challenge

v3 tested only `qwen3-coder:30b` (reported digest prefix `06c1097efce0`, Q4_K_M, Ollama 0.40.2, context 4096, temperature 0, seed 42, output limit 1536). Inputs and grading were frozen before inference. All 120 runs completed without technical errors; stored pass results agreed with two score replays, and 120 unique run identities were recorded.

| Evidence category | Fully correct runs | Critical `no_concerns` on defective evidence |
| --- | ---: | ---: |
| Valid evidence | 24/24 | 0 |
| Missing evidence | 0/24 | 3 |
| Contradictory evidence | 0/24 | 0 |
| Misleading evidence | 0/24 | 0 |
| Scope violations | 3/24 | 15 |
| **Total** | **27/120** | **18** |

Across the v3 outputs, the report records **81 of 102 expected findings recovered**, **141 unsupported additional findings**, **36.5% precision**, and **79.4% recall**. The 18 critical missed-concern outcomes came from six distinct fixtures. All responses had structurally valid output; 15 deviations shortened original quotations rather than inventing sources, while qualitative review also found unsupported conclusions. No authoritative UIF-INT verification gate was changed.

Reported full warm response time: median 6.73 s, p95 9.80 s, range 0.78–11.13 s; observed host swap 0 MB. v3's time is **not comparable as a matched-workload performance claim** against v1/v2.

## Interpretation: what the evidence does and does not support

1. **Bounded selection is not open-ended evidence analysis.** Qwen3-Coder's 36/36 on the revised v2 fixtures did not transfer to v3's multi-finding evidence-analysis task. The benchmarks cover different tasks, so this is a difference in demonstrated capability, not a measured degradation.
2. **Syntactic validity is not factual or governance validity.** All v3 answers were structurally valid while 141 extra findings lacked support. JSON/schema checks alone cannot establish trustworthy verification reasoning.
3. **False reassurance is a high-consequence failure mode.** In v1 Apple FM produced false PASS outcomes; in v3 Qwen3-Coder returned `no_concerns` 18 times for defective evidence. These were model evaluations, not changed production gates.
4. **Deterministic validation is preferable when the rule is explicit.** Contract consistency, allowed-path checks, command/result matching and required-evidence presence should be assessed against source contracts, rather than entrusted to a generative judgment. This is an architectural **candidate interpretation** consistent with existing UIF-INT evidence boundaries, not a newly authorized implementation mandate.
5. **Model selection must be capability-specific and evidence-bounded.** Model size, warm latency and a perfect score on small synthetic tasks are insufficient to establish production suitability. None of v1–v3 measures general agent execution ability or independent coding proficiency.

### Human, agent and system consequences

- **Human:** Avoid burdening reviewers with large numbers of ungrounded findings. Prefer traceable, cited exceptions over an AI-generated all-clear.
- **Agent:** A model may propose or explain bounded findings, but such output remains advisory unless an independent, authoritative acceptance procedure validates it.
- **System:** Preserve provider-neutral execution contracts, deterministic verification gates and persisted raw evidence. Treat model-evaluation claims as versioned and task-specific.

## Current recommendation (non-normative)

- **Do not** promote Apple FM or Qwen to a verification authority on this evidence.
- **Do not** add or change UIF-INT routing, adapters, contracts or gates as an automatic consequence of this report.
- Retain deterministic verification as the existing authoritative boundary; do not interpret model self-assessment as proof of PASS.
- Keep the benchmark series **closed** unless a concrete new capability decision calls for further evidence.
- If reopened, prefer previously unseen cases, separately checked ground truth, a controlled prompt A/B on fixed fixtures when prompt effects matter, and an explicit cost-of-review metric for unsupported findings. Predeclare failure thresholds before inference.

**No ADR is proposed by default.** A future ADR would require a specific architecture choice not already resolved by existing UIF-VLT governance and UIF-INT contracts.

## Sources, traceability and outstanding verification

Operator-reported Codex artifacts, created October 9, 2026, were kept **outside repository sources**:

- `local-model-benchmark-v1/`: report, manifest, fixtures, raw responses, scoring and diagnostics (as reported).
- `local-model-benchmark-v2/`: corresponding revised fixtures, reports and replayable scores (as reported).
- `verification-evidence-benchmark-v3/`: `report.md`, `README.md`, 40 fixtures, ground truth, 120 raw runs and scoring evidence (as reported).

These names identify local experiment collections; **they are not GitHub repository paths or verified hyperlinks**. Do not infer their existence in UIF-INT from this Vault note. Before elevating the findings, obtain the original artifact manifests, hashes, scorer and raw outputs through an approved evidence channel and independently re-run the recorded scoring. Confirm fixture freeze chronology, the reported model digests and the exact meaning of a critical failure.

Applicable authority already exists in [UIF-VLT verification review](../../governance/verification-review.md), [Vault precedence](../../governance/precedence.md), and the UIF-INT repository's own `AGENTS.md`, contracts and tests. This document supports those sources and does not replace them.
