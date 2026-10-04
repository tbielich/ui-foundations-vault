---
id: specification.capability.ux-writing
title: UX Writing
type: specification
status: review
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-10-04
authority: source
summary: Defines the capability to improve interface language.
related:
  references:
    - principle.foundation.information-architecture
    - principle.foundation.accessibility-principles
    - principle.foundation.usability-heuristics
    - reference.terminology
    - governance.natural-writing
---

# UX Writing

## Question

What does it mean to improve interface language?

## Purpose

UX writing improves interface language so people can understand context, make decisions, complete tasks, and recover from errors.

## Inputs

- Existing or proposed interface text
- Component or content context
- User goal and state
- Tone constraints
- Terminology requirements

## Required Knowledge

- Information architecture
- Accessibility principles
- Usability heuristics
- Canonical terminology
- Relevant component or pattern context
- Natural Writing Contract

## Reasoning Method

1. Apply `governance.natural-writing` as the global writing baseline.
2. Identify the text role and user state.
3. Determine what the user needs to know or do.
4. Remove ambiguity, jargon, and unnecessary wording.
5. Preserve canonical terminology.
6. Check that the text works without hidden context.
7. Review the result for writing signals defined by the Natural Writing Contract.
8. Provide a concise recommendation with rationale.

## Outputs

- Improved interface text
- Issue summary when reviewing existing text
- Rationale
- Alternatives when meaningful
- Terminology notes

## Quality Gates

- The language is clear, concise, and action-oriented where appropriate.
- The wording supports accessibility and recognition.
- Terminology is consistent with the vault reference layer.
- The output avoids decorative or promotional language for functional UI.
- The output conforms to the hard rules in `governance.natural-writing`.
- Style signals from `governance.natural-writing` have been reviewed in context rather than mechanically removed.

## Related Documents

- `principle.foundation.information-architecture`
- `principle.foundation.accessibility-principles`
- `principle.foundation.usability-heuristics`
- `reference.terminology`
- `governance.natural-writing`

