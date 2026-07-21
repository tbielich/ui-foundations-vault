---
id: pattern.base.checkbox
title: Checkbox Pattern
type: pattern
status: draft
owners:
  - ui-foundations
created: 2026-07-21
updated: 2026-07-21
authority: derived
summary: Agent-readable base pattern contract for checkboxes.
related:
  derived_from:
    - /Users/Thomas.Bielich@tui.com/GitHub/uif/ui-foundations-runtime/site/patterns/checkbox.md
  references:
    - specification.pattern.schema
---

# Checkbox Pattern

## Metadata

- id: `pattern.base.checkbox`
- type: base
- status: draft
- source: `/Users/Thomas.Bielich@tui.com/GitHub/uif/ui-foundations-runtime/site/patterns/checkbox.md`
- related standards: Native HTML checkbox semantics; WCAG focus and use-of-color requirements
- related components: `Checkbox`
- related tokens: `checkbox`, control, mark, label, focus, spacing

## Intent

Provide a binary or multi-select control for independent choices.

## Problem

Forms need a native, accessible control for on/off and partial-group selection while preserving clear labels and state meaning.

## Use When

- Use for independent options where multiple selections are allowed.
- Use indeterminate state for parent summary of partial child selection.

## Do Not Use When

- Do not use for mutually exclusive choices; use radio buttons.

## Standard Basis

Native `<input type="checkbox">` semantics are the base, including checked and indeterminate state behavior.

## Anatomy

- Control box
- State indicator (check or indeterminate mark)
- Label

## Structure Contract

| Item | Classification | Contract |
|---|---|---|
| Native checkbox input | Required | Preserve native checked semantics. |
| Label association | Required | Checkbox must have associated label text. |
| Indeterminate support | Optional | Programmatic partial-selection state. |
| Disabled support | Required | Disabled state is native and non-interactive. |

## Implementation Naming Contract

### CSS Class Contract

- Public checkbox classes use the `uif-` prefix.

### Token Contract

- Public checkbox tokens use `--uif-checkbox-*`.

### Data Attribute Contract

Data attributes may mirror checked state but do not replace native state attributes.

### Native / ARIA Precedence

- Prefer native checkbox semantics and `checked`/`disabled`.
- Use ARIA only for supplemental relationships.

### Agent Freedom Boundary

- Native checkbox semantics and label relationships are not agent freedom.

## Required Semantics

- Every checkbox has a programmatic label.
- Checked/unchecked state is programmatically determinable.
- Indeterminate is used only for partial group summary.

## Behaviour

- Pointer and keyboard activation toggle checked state.
- Indeterminate is set programmatically.
- Disabled state prevents interaction.

## Keyboard Interaction

- `Tab`: focus navigation.
- `Space`: toggle checked state.

## Accessibility Rules

- Use native checkbox input.
- Keep labels explicit and readable.
- Do not rely on color alone for state.

## Token Requirements

- Control background, border, and mark
- Focus indicator
- Label text
- Disabled and indeterminate visuals

## Token Slot Matrix

| Part | Property | State / Variant | Required semantic token slot | Notes |
|---|---|---|---|---|
| Control | Border / background | Default / checked / disabled | Checkbox control slots | Preserve contrast. |
| Mark | Check / indeterminate color | Checked / indeterminate | Checkbox mark slots | Distinguish both states. |
| Control | Focus indicator | Focus-visible | Checkbox focus slot | Required for keyboard users. |

## States

- Unchecked
- Checked
- Indeterminate
- Focus
- Disabled

## State Semantics

| State | Required semantics | User interaction | Notes |
|---|---|---|---|
| Unchecked | Not selected | Toggle to checked | Required. |
| Checked | Selected | Toggle to unchecked | Required. |
| Indeterminate | Partial group summary | Usually resolves to checked/unchecked on interaction | Optional. |
| Disabled | Non-interactive | No toggle | Required when disabled. |

## Variants

- Default
- Indeterminate

## Responsive / Density Behaviour

Checkbox and label spacing scale through tokens while preserving tap and focus usability.

## Component Dependencies

- `Checkbox`
- Label primitive

## Minimum Component API

| API | Classification | Default | Contract |
|---|---|---|---|
| `label` | Required | None | Visible label content. |
| `checked` | Optional | `false` | Selected state. |
| `indeterminate` | Optional | `false` | Partial state. |
| `disabled` | Optional | `false` | Native disabled behavior. |

## Agent Freedom

| Decision Area | Freedom Level | Allowed Choices | Requires Human Review |
|---|---|---|---|
| Native semantics | none | Preserve native checkbox behavior. | Yes, for non-native control proposals. |
| Indeterminate usage | limited | Parent-summary use only. | No. |
| Visual expression | guided | Use semantic token slots by state. | No. |

## Implementation Contract

- Preserve native toggle semantics.
- Preserve label association.
- Preserve indeterminate semantics where used.

## Test Requirements

- Verify checked/unchecked toggling.
- Verify keyboard toggle with `Space`.
- Verify indeterminate behavior.
- Verify disabled non-interaction.

## Negative Test Requirements

- Checkbox without label fails.
- Indeterminate represented only by color fails.

## Documentation Requirements

Human-facing docs explain independent-choice use, indeterminate meaning, and checkbox vs radio boundaries.

## Anti-Patterns

- Using checkbox for exclusive options.
- Missing or ambiguous labels.

## Agent Output

Agents can derive form acceptance criteria and accessibility checks from this pattern.

Review this pattern against `patterns/checklists/pattern-spec-review-checklist.md` before deriving implementation output.

## Open Questions

- Open question: Should parent-child aggregation behavior be standardized in base or composition guidance?

