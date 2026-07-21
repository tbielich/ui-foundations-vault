---
id: pattern.base.switch
title: Switch Pattern
type: pattern
status: draft
owners:
  - ui-foundations
created: 2026-07-21
updated: 2026-07-21
authority: derived
summary: Agent-readable base pattern contract for switches.
related:
  derived_from:
    - /Users/Thomas.Bielich@tui.com/GitHub/uif/ui-foundations-runtime/site/patterns/switch.md
  references:
    - specification.pattern.schema
---

# Switch Pattern

## Metadata

- id: `pattern.base.switch`
- type: base
- status: draft
- source: `/Users/Thomas.Bielich@tui.com/GitHub/uif/ui-foundations-runtime/site/patterns/switch.md`
- related standards: Binary control semantics and focus accessibility requirements
- related components: `Switch`
- related tokens: `switch`, track, thumb, label, focus

## Intent

Provide an immediate on/off setting control.

## Problem

Interfaces need a binary control where state changes take effect immediately without additional submission.

## Use When

- Use for immediate setting toggles.

## Do Not Use When

- Do not use for consent acknowledgments in forms; use checkbox.

## Standard Basis

Switch follows binary toggle semantics with explicit on/off meaning and visible state affordance.

## Anatomy

- Track
- Thumb
- Label

## Structure Contract

| Item | Classification | Contract |
|---|---|---|
| Binary control | Required | On/off state control. |
| Label | Required | Describes the setting. |
| Disabled support | Optional | Non-interactive state when unavailable. |

## Implementation Naming Contract

### CSS Class Contract

- Public switch classes use the `uif-` prefix.

### Token Contract

- Public switch tokens use `--uif-switch-*`.

### Data Attribute Contract

Data attributes may mirror checked state metadata.

### Native / ARIA Precedence

- Preserve native checkbox semantics with switch role where needed.

### Agent Freedom Boundary

- Immediate-effect binary semantics are not agent freedom.

## Required Semantics

- On/off state is explicit and programmatically determinable.
- Label describes setting noun, not a command phrase.

## Behaviour

- Toggle updates state immediately.
- Thumb position and track style reflect state.

## Keyboard Interaction

- `Tab`: focus traversal.
- `Space`: toggles state.

## Accessibility Rules

- Ensure programmatic label association.
- Preserve visible focus indicator.
- Avoid color-only state signaling.

## Token Requirements

- Track color by state
- Thumb color/position
- Focus indicator
- Label typography/color

## Token Slot Matrix

| Part | Property | State / Variant | Required semantic token slot | Notes |
|---|---|---|---|---|
| Track | Background | Off / on / disabled | Switch track slots | Must distinguish on/off. |
| Thumb | Fill / position affordance | Off / on / disabled | Switch thumb slots | Position is key state cue. |
| Control | Focus indicator | Focus-visible | Switch focus slot | Required. |

## States

- Off
- On
- Focus
- Disabled

## State Semantics

| State | Required semantics | User interaction | Notes |
|---|---|---|---|
| Off | Setting disabled | Toggle to on | Required. |
| On | Setting enabled | Toggle to off | Required. |
| Focus | Focus indicator visible | Keyboard interaction | Required. |
| Disabled | Non-interactive | No toggle | Optional by context. |

## Variants

- Default
- Disabled

## Responsive / Density Behaviour

Switch sizing and label spacing scale via tokens while preserving tap and focus usability.

## Component Dependencies

- `Switch`
- Label primitive

## Minimum Component API

| API | Classification | Default | Contract |
|---|---|---|---|
| `label` | Required | None | Setting label text. |
| `checked` | Optional | `false` | On/off state. |
| `disabled` | Optional | `false` | Non-interactive state. |

## Agent Freedom

| Decision Area | Freedom Level | Allowed Choices | Requires Human Review |
|---|---|---|---|
| Semantic meaning | none | Preserve immediate on/off semantics. | Yes, for delayed-submit behavior. |
| Visual expression | guided | Tokenized track/thumb state styling. | No. |
| Labeling pattern | limited | Setting-name labels preferred. | No. |

## Implementation Contract

- Preserve immediate toggle behavior.
- Preserve binary state clarity.
- Preserve accessible labeling and focus.

## Test Requirements

- Verify keyboard and pointer toggling.
- Verify state visuals for on/off/disabled.
- Verify label association.

## Negative Test Requirements

- Switch used for non-immediate consent flow fails.
- State distinguished by color only fails.

## Documentation Requirements

Human-facing docs explain switch-vs-checkbox boundaries and immediate-effect behavior.

## Anti-Patterns

- Command-style labels for switch settings.
- Deferred-submit switch semantics.

## Agent Output

Agents can derive binary-control review checks and accessibility criteria from this pattern.

Review this pattern against `patterns/checklists/pattern-spec-review-checklist.md` before deriving implementation output.

## Open Questions

- Open question: Should loading/pending switch transitions be base-level or composition-level behavior?

