---
id: knowledge.agentic.spike-2026-10-05-agentic-load-retrospective
title: Agentic Load Spike — Retrospective Evidence and Calibration Sheet
type: research
status: draft
owners:
  - ui-foundations
created: 2026-10-05
updated: 2026-10-05
authority: supporting
summary: Extracts bounded historical evidence for three UIF cases and separates machine runs, criteria changes, and unknown human effort.
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
  references:
    - knowledge.agentic.spike-2026-10-05-agentic-load-matrix
    - knowledge.agentic.research-2026-10-05-human-agent-span-of-control
verification:
  status: partially-verified
assumptions:
  - Local retained artifacts are producer evidence; their hashes preserve snapshot identity but do not independently validate their claims.
  - Human intervention counts and active effort cannot be reconstructed from command timestamps or test results alone.
---

# Agentic Load Spike — Retrospective Evidence and Calibration Sheet

## Outcome and scope

This follow-up to the [initial matrix](./spike-2026-10-05-agentic-load-matrix.md) inspects retained artifacts for W1, W4 and W5. It completes a retrospective extraction, not the proposed repeated-run capacity pilot. No provider execution, Figma access, component repair, merge, ADR or governance change was performed for this research.

The evidence supports distinct review surfaces and at least one recorded structural correction cycle. It does not calibrate high/medium workload against active human minutes. The [Span of Control research](./research-2026-10-05-human-agent-span-of-control.md) remains a supporting hypothesis, not a demonstrated capacity gain.

## Evidence extraction

Inspected 2026-10-05. One bounded task case per workflow; multiple checks within a task are not independent workflow runs. Retained artifacts are incomplete execution histories, so counts describe the inspected sample rather than an exhaustive event ledger.

| Case | Source and retained sample | Direct observation | Permitted derivation | Not established |
| --- | --- | --- | --- | --- |
| W1 Research synthesis | [Vault #57](https://github.com/tbielich/ui-foundations-vault/pull/57), head `e6e893fdcffadeff8f02d3c45894ee45fa4bd28b`; PR file metadata and research note | Two changed Markdown files; new note has 299 added lines; Asana time-saving claim marked unverified; PR still open | One recorded documentation task with source-verification demand; no execution log available in reviewed sample | Perplexity execution duration, source-check time, human interruptions, manual baseline or correction count |
| W4 Accessibility evidence | [Runtime #310](https://github.com/tbielich/ui-foundations-runtime/pull/310), head `330c939b1de8d2de442d7ae456f2b69da8c0c331`; locally retained `commands.jsonl`, `first-completed-result.json`, `result.json`, `playwright.json` | 16 command records: 4 docs-server starts, 6 docs builds and 6 accessibility-browser invocations. All 6 browser invocations record exit 1. First result has Checkbox 3/6, final result 4/6. Final browser report: 10 expected, 2 unexpected, 0 skipped, 0 flaky | Six recorded browser attempts inside one task; one criterion status improvement (`checkbox.inert`), two persistent failed criteria (`checkbox.mixed-disabled`, `checkbox.axe`). Final machine-run duration 19.949368 seconds | Six human interventions, six distinct incidents, agent exception frequency, continuous human effort across timestamps, full execution/maintenance history or independent acceptance |
| W5 Token/Figma parity repair | [Runtime #317](https://github.com/tbielich/ui-foundations-runtime/pull/317), head `517fb9ff1631b007c778d89cac8576a17e5ffe83`; committed contract, first/final verification, readback and report | Contract lists 4 alias-slot changes and 1 scope-metadata change. First structural gate FAIL with one alias-ID error; final PASS with no structural errors. Pair gate PASS in both. Readback count 767, errors empty | At least one recorded structural correction cycle and two retained structural evaluations; correctness has multiple independent dimensions. Counts reflect declared and reported scope | Human repair/review minutes, total retries, live state today, complete human intervention count, quantitative risk, or net capacity |

W4's first report is explicitly dirty at base `8c2c2ebd1a2f43270c34f87171a8200fbd38a410`; the final report declares a clean head matching PR #310. These reports are not same-revision repetitions. The changed criterion demonstrates a reported result transition, not proof of what caused the improvement. The final retained run is later than the PR body's last update, so it is identified separately rather than silently substituted for that body.

W4's 11 component criteria and the 12 browser tests are different populations: the suite also includes a negative control. Nine passing component criteria do not contradict ten expected browser tests. `checkbox.mixed-disabled` and `checkbox.axe` remain separate failed criteria but may share the same underlying mixed-state problem; they must not automatically become two incidents.

W5's first JSON already reports the accessibility pair gate PASS while its structural gate fails (`Alias ID mismatch VariableID:2007:345`). The final structural result resolves this recorded error. The producer report identifies stale default-alias metadata as the cause and records correction. Numeric contrast checks alone would have missed the structural failure.

## Source locators and reproducibility

Public, pinned W5 JSON sources:

- [Execution contract](https://github.com/tbielich/ui-foundations-runtime/blob/517fb9ff1631b007c778d89cac8576a17e5ffe83/figma/migrations/action-label-border-parity-2026-09-30/execution-contract.json): `/changes`, `/metadataChanges`.
- [First verification](https://github.com/tbielich/ui-foundations-runtime/blob/517fb9ff1631b007c778d89cac8576a17e5ffe83/figma/migrations/action-label-border-parity-2026-09-30/verification-first.json): `/structuralGate`, `/errors`, `/accessibility/pairGate`.
- [Final verification](https://github.com/tbielich/ui-foundations-runtime/blob/517fb9ff1631b007c778d89cac8576a17e5ffe83/figma/migrations/action-label-border-parity-2026-09-30/verification.json): the same pointers.
- [Readback](https://github.com/tbielich/ui-foundations-runtime/blob/517fb9ff1631b007c778d89cac8576a17e5ffe83/figma/migrations/action-label-border-parity-2026-09-30/readback.json): `/count`, `/errors`.
- [Producer report](https://github.com/tbielich/ui-foundations-runtime/blob/517fb9ff1631b007c778d89cac8576a17e5ffe83/figma/migrations/action-label-border-parity-2026-09-30/REPORT.md): first-check failure and bounded certification statement.

W4 local sources are retained under `artifacts/accessibility/` in the existing #310 checkout. They are ignored local evidence, not published at the PR commit. Do not interpret the following hashes as public download links or independent verification. This note publishes only an aggregate extraction; raw session/trace payloads are not copied. An independent reviewer needs the retained files or equivalent CI artifacts to reproduce these local observations.

| Artifact | SHA-256 at inspection | Locator / use |
| --- | --- | --- |
| `commands.jsonl` | `1155774c7d39e7459fb8b15b4d1e79cb8eb012f573bae3358c5fbacd7a3154a7` | All 16 JSONL records; group by `command`, count `exitCode`; `started` is a timestamp, not effort |
| `first-completed-result.json` | `3c8b4f1a22653585a29761695a4efc388b47cd1d69227f6c69398b528d79a22c` | `/source`, `/results` by criterion ID, `/components/checkbox` |
| `result.json` | `cb52841232be9ec9adb2819f90c1778bca19da17030b967b83f79540474273d8` | `/source`, `/results`, `/components/checkbox`, `/testCounts`, `/executor/independentVerification` |
| `playwright.json` | `2b2891da64e15c5dbe589c244af99772a9b85fc1ea7fb50db7d4431d724b3728` | `/stats`; matches final result's `/testCounts` |

## Rating reconciliation

- **W1 medium:** retained as a provisional review-demand estimate. A longer document and unverified claim do not provide a time measurement.
- **W4 high:** repeated failing runs and unresolved criteria strengthen the rationale for a complex review surface. They do not validate the predicted effort band. Independent verification remains pending in the retained final report.
- **W5 high:** first/final gate disagreement and coupled Git/Figma scope strengthen the rationale for multidimensional checking. A small authorized mutation set does not imply small verification effort.

No numeric score, weight or limit follows from this sample. All active human time, intervention counts, baseline minutes and net capacity remain unknown. A rate such as 6/6 here describes browser command exit status within one selected task, not a workflow population's exception rate. No reviewer disagreement study has been performed.

## Prospective run sheet — ready for a future bounded task

Use this sheet for an already authorized task; it does not authorize a new execution. Freeze the scope and baseline method before the run. Record an actual human reviewer separately from the executor. A model classifying its own output is not an independent human review.

| Field | Value to record before execution |
| --- | --- |
| Case / workflow / date | Explicit task ID and W1/W4/W5 or equivalent profile |
| Source snapshot and allowed scope | Repository SHA, external resources, permitted actions and acceptance boundary |
| Owner and reviewer | Human roles; public artifacts need no personal names |
| Manual baseline | Comparable observed manual task, or clearly labeled estimate with uncertainty; unknown if unavailable |
| Predicted profile | Autonomy, consequence risk, review-demand band, reversal steps and system/permission surfaces |
| Observation window | Include preparation, run, review and the selected maintenance period |

| Event / artifact ID | Phase | Actor: human / executor / system | Active human minutes | Machine elapsed seconds | Planned review or unplanned intervention | Reason and outcome | Source locator |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Not yet collected | Preparation / verification / exception / coordination / maintenance | Unknown | Unknown | Unknown | Unknown | Pending | Pending |

Keep timer categories mutually exclusive. A test retry can be executor activity without human attention; log a human intervention only when the human actually participates. Waiting is elapsed time, not active effort. Record blocked and canceled runs, failed criteria, correction work and unresolved risk alongside successful outcomes. Separate one underlying exception from multiple symptoms while preserving all criterion failures.

For a future comparison, retain the first predicted profile, have another reviewer classify it independently, and report disagreements before reconciling. Compare predicted load with observed effort only after data exists. If the manual baseline is unknown, publish the measured supervision costs and leave net capacity unknown.

The next empirical boundary is therefore explicit: historical artifacts support workflow shape and some rework, while a prospective human time log is needed to test the capacity hypothesis. This research does not turn historical machine duration into a retrospective productivity claim.
