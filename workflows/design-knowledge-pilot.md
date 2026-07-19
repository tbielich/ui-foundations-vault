---
id: workflow.design-knowledge-pilot
title: Design Knowledge Pilot
type: workflow
status: draft
owners:
  - ui-foundations
created: 2026-07-16
updated: 2026-07-16
authority: supporting
summary: Defines a bounded comparison of current-source discovery and governed design knowledge using the Button Pattern.
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
    - governance.verification-review
  references:
    - pattern.base.button
    - map.pattern-to-component
    - map.pattern-to-token
    - map.pattern-to-standard
    - docs.reflection-loop
    - index.publication.whitepaper.beyond-components
---

# Design Knowledge Pilot

## Goal

Test whether governed design knowledge helps people and AI find applicable guidance, avoid repeated deviations, and correct review findings with less effort.

This pilot tests one bounded case. It does not validate the full Beyond Components thesis or authorize runtime changes.

## Pilot Question

When reviewing a Button usage decision, does a governed knowledge set improve discovery, interpretation, traceability, and correction compared with the current working approach?

## Scope

Use one shared brief covering:

- A standard action button.
- An icon-only action with an accessible name.
- A disabled action.
- Required semantics, states, tokens, and review evidence.

Loading behavior is out of scope because the current Button Pattern records unresolved loading semantics.

## Inputs

- One facilitator who does not complete the task.
- One independent reviewer who applies the same rubric to every output.
- At least two human participants familiar with design or engineering work.
- One AI model and one fixed task prompt for both AI conditions.
- A timer and the measurement table in this workflow.

### Current-source condition

Participants use their normal discovery process and record every source consulted. Do not provide the governed knowledge set.

### Governed-knowledge condition

Provide only this bounded knowledge set in addition to the shared task brief:

- `patterns/base/button.pattern.md`
- `patterns/maps/pattern-to-component-map.md`
- `patterns/maps/pattern-to-token-map.md`
- `patterns/maps/pattern-to-standard-map.md`
- `governance/precedence.md`
- `governance/verification-review.md`

## Outputs Per Run

Each run produces:

- A short implementation or usage recommendation.
- A list of applicable requirements and constraints.
- A list of sources used.
- Open questions and decisions requiring human judgment.
- A completed review against the shared rubric.

Outputs are evidence only. They must not be merged into a runtime repository as production guidance.

## Steps

1. Freeze the task brief, rubric, AI prompt, and knowledge set before the first run.
2. Assign participants so prior exposure does not influence both conditions. If participants repeat, reverse the condition order.
3. Run the human current-source condition and record all measures.
4. Run the human governed-knowledge condition and record all measures.
5. Start fresh AI sessions for the current-source and governed-knowledge conditions using the same model and prompt.
6. Remove condition labels from outputs where practical before independent review.
7. Apply the same rubric and severity model to every output.
8. Record findings, correction work, participant observations, and unexpected effects.
9. Compare results by condition without claiming statistical significance from the small sample.
10. Run the Reflection Loop after agreeing the pilot outcome.

## Measures

| Measure | Definition | Record as |
| --- | --- | --- |
| Discovery time | Time until the participant identifies applicable sources and can state the main requirements | Minutes |
| Repeated deviations | The same incorrect or unsupported interpretation appearing in more than one output | Count |
| Review findings | Accessibility, semantic, governance, traceability, or completeness issues found by the reviewer | Count by severity |
| Correction cost | Active effort required to resolve review findings | Minutes |
| Source traceability | Requirements linked to an identifiable source | Supported requirements / total requirements |
| Open-question recognition | Known uncertainties identified instead of guessed | Identified / expected |

## Review Rubric

Check every output for:

- Native Button semantics and correct action behavior.
- An accessible name for the icon-only action.
- Correct disabled-state guidance.
- Clear separation between requirements, optional choices, and open questions.
- Traceability to consulted sources.
- No invented token, component, or runtime contract.

## Evidence Table

| Run | Consumer | Condition | Discovery time | Repeated deviations | Review findings | Correction cost | Traceability | Open questions | Notes |
| --- | --- | --- | ---: | ---: | --- | ---: | --- | --- | --- |
| 1 | Human | Current sources |  |  |  |  |  |  |  |
| 2 | Human | Governed knowledge |  |  |  |  |  |  |  |
| 3 | AI | Current sources |  |  |  |  |  |  |  |
| 4 | AI | Governed knowledge |  |  |  |  |  |  |  |

## Decision Rules

Recommend **continue** when the governed-knowledge condition shows a useful improvement in at least two primary measures without introducing a critical finding.

Recommend **revise and rerun** when the knowledge set appears useful but creates ambiguity, missing context, or excessive maintenance effort.

Recommend **stop** when the governed-knowledge condition provides no clear benefit or performs worse in correctness and correction cost.

This pilot provides directional evidence only. A positive result supports a broader pilot; it does not support organization-wide adoption.

## Constraints

- Do not modify runtime code, schemas, contracts, or synchronization behavior.
- Do not change source material between conditions after the run begins.
- Do not give the governed knowledge set to the current-source condition.
- Do not treat faster completion as success when correctness declines.
- Do not publish participant or internal product information in public artifacts.

## Verification

The pilot is complete when:

- All four runs use the frozen brief, rubric, and condition rules.
- Every measure has a value or a recorded reason why it could not be measured.
- Review findings use the same severity model across conditions.
- Assumptions, limitations, and unexpected effects are recorded.
- The result is classified as continue, revise and rerun, or stop.
- Reusable findings enter the Reflection Loop with source evidence.

## Related

- `patterns/base/button.pattern.md`
- `patterns/experiments/button-proof-of-use/README.md`
- `governance/verification-review.md`
- `docs/reflection-loop.md`
- `publications/whitepapers/beyond-components/README.md`
