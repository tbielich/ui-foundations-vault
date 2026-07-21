---
id: pattern.base.radio
title: Radio Pattern
type: pattern
status: draft
owners:
  - ui-foundations
created: 2026-07-21
updated: 2026-07-21
authority: derived
summary: Agent-readable base pattern contract for radio controls.
related:
  derived_from:
    - /Users/Thomas.Bielich@tui.com/GitHub/uif/ui-foundations-runtime/site/patterns/radio.md
  references:
    - specification.pattern.schema
---

# Radio Pattern

## Metadata

- id: `pattern.base.radio`
- type: base
- status: draft
- source: `/Users/Thomas.Bielich@tui.com/GitHub/uif/ui-foundations-runtime/site/patterns/radio.md`
- related standards: Native radio-group semantics and keyboard interaction patterns
- related components: `Radio`
- related tokens: `radio`, indicator, label, focus, spacing

## Intent

Provide mutually exclusive option selection within a defined group.

## Problem

Interfaces need explicit single-choice controls with predictable group navigation and selection semantics.

## Use When

- Use when exactly one option must be selected from a set.

## Do Not Use When

- Do not use for independent multi-select options; use checkboxes.

## Standard Basis

Native radio input semantics with shared group identity are the baseline.

## Anatomy

- Radio indicator
- Selection dot
- Label
- Group context

## Structure Contract

| Item | Classification | Contract |
|---|---|---|
| Radio input | Required | Native radio semantics. |
| Shared group identity | Required | Radios in a group share a common selection context. |
| Label | Required | Each radio has explicit label text. |
| Group label | Required | Group has a shared descriptive label/legend. |

## Implementation Naming Contract

### CSS Class Contract

- Public radio classes use the `uif-` prefix.

### Token Contract

- Public radio tokens use `--uif-radio-*`.

### Data Attribute Contract

Data attributes may mirror state but do not replace native semantics.

### Native / ARIA Precedence

- Prefer native radio grouping behavior.

### Agent Freedom Boundary

- Mutual-exclusion semantics are not agent freedom.

## Required Semantics

- One selected option at a time within a group.
- Group and option labels are explicit.

## Behaviour

- Selecting one option deselects others in same group.
- Arrow keys move and update group selection.

## Keyboard Interaction

- `Tab`: enter/exit group.
- Arrow keys: move between options.
- `Space`: select focused option.

## Accessibility Rules

- Use native radio inputs and group labeling.
- Maintain visible focus indicator.

## Token Requirements

- Indicator border/background
- Selected dot
- Focus ring
- Label text styling

## Token Slot Matrix

| Part | Property | State / Variant | Required semantic token slot | Notes |
|---|---|---|---|---|
| Indicator | Border/background | Default / hover / disabled | Radio indicator slots | Preserve contrast. |
| Selection dot | Fill | Selected states | Radio selected-dot slots | Must remain clear. |
| Indicator | Focus indicator | Focus-visible | Radio focus slot | Required for keyboard use. |

## States

- Unselected
- Selected
- Focus
- Disabled

## State Semantics

| State | Required semantics | User interaction | Notes |
|---|---|---|---|
| Unselected | Option not selected | Can become selected | Required. |
| Selected | Active group option | Switching selects another | Required. |
| Focus | Focused option indicator visible | Keyboard navigation | Required. |
| Disabled | Non-selectable option | No selection | Optional by context. |

## Variants

- Default
- Disabled

## Responsive / Density Behaviour

Radio controls preserve tappable sizing and readable spacing across density modes.

## Component Dependencies

- `Radio`
- Label primitive

## Minimum Component API

| API | Classification | Default | Contract |
|---|---|---|---|
| `label` | Required | None | Option label text. |
| `name` | Required | None | Shared group identity. |
| `value` | Required | None | Option value identity. |
| `checked` | Optional | `false` | Selected state. |
| `disabled` | Optional | `false` | Native disabled behavior. |

## Agent Freedom

| Decision Area | Freedom Level | Allowed Choices | Requires Human Review |
|---|---|---|---|
| Group semantics | none | Preserve single-selection model. | Yes, for multi-select proposals. |
| Keyboard behavior | none | Preserve native/expected arrow-key behavior. | No. |
| Visual expression | guided | Tokenized state styling. | No. |

## Implementation Contract

- Preserve single-choice group behavior.
- Preserve option/group labeling.
- Preserve keyboard selection model.

## Test Requirements

- Verify single-selection exclusivity.
- Verify arrow-key navigation.
- Verify focus and disabled behavior.

## Negative Test Requirements

- Multiple simultaneous selections in one group fails.
- Missing group label fails.

## Documentation Requirements

Human-facing docs explain radio vs checkbox selection rules and grouping guidance.

## Anti-Patterns

- Using radios for independent toggles.
- Group without contextual label.

## Agent Output

Agents can derive choice-pattern and accessibility checks from this pattern.

Review this pattern against `patterns/checklists/pattern-spec-review-checklist.md` before deriving implementation output.

## Open Questions

- Open question: Should optional per-option descriptions be base-radio guidance or composition-level?

