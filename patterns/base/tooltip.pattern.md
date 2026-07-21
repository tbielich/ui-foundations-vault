---
id: pattern.base.tooltip
title: Tooltip Pattern
type: pattern
status: draft
owners:
  - ui-foundations
created: 2026-07-21
updated: 2026-07-21
authority: derived
summary: Agent-readable base pattern contract for tooltips.
related:
  derived_from:
    - /Users/Thomas.Bielich@tui.com/GitHub/uif/ui-foundations-runtime/site/patterns/tooltip.md
  references:
    - specification.pattern.schema
---

# Tooltip Pattern

## Metadata

- id: `pattern.base.tooltip`
- type: base
- status: draft
- source: `/Users/Thomas.Bielich@tui.com/GitHub/uif/ui-foundations-runtime/site/patterns/tooltip.md`
- related standards: ARIA tooltip semantics and focus-triggered discoverability
- related components: `Tooltip`
- related tokens: `tooltip`, surface, text, arrow, offset

## Intent

Provide short contextual guidance for a related trigger element.

## Problem

Interfaces need lightweight supplementary hints without adding persistent visual noise.

## Use When

- Use for concise, supporting context on hover/focus.
- Use to label icon-only controls when visible text is absent.

## Do Not Use When

- Do not use for long instructions or interactive content.
- Do not use as the only source of critical information.

## Standard Basis

Tooltip semantics are non-interactive contextual descriptions associated with a trigger element.

## Anatomy

- Trigger element
- Tooltip bubble
- Optional directional pointer

## Structure Contract

| Item | Classification | Contract |
|---|---|---|
| Trigger | Required | Focusable or hoverable owner element. |
| Tooltip content | Required | Short, concise text guidance. |
| Relationship | Required | Programmatic trigger-to-tooltip description link. |
| Placement | Optional | Position variant around trigger. |

## Implementation Naming Contract

### CSS Class Contract

- Public tooltip classes use the `uif-` prefix.

### Token Contract

- Public tooltip tokens use `--uif-tooltip-*`.

### Data Attribute Contract

Data attributes may mirror placement metadata.

### Native / ARIA Precedence

- Use tooltip role semantics and trigger description relationship.

### Agent Freedom Boundary

- Non-interactive tooltip semantics are not agent freedom.

## Required Semantics

- Trigger and tooltip relationship is explicit.
- Tooltip content is concise supplementary guidance.

## Behaviour

- Appears on trigger hover and keyboard focus.
- Dismisses on blur or pointer exit.
- Does not capture focus.

## Keyboard Interaction

- Tooltip itself has no focus.
- Trigger focus state controls tooltip visibility.

## Accessibility Rules

- Keep tooltip non-interactive.
- Do not rely on tooltip as only accessible name for controls that require direct labeling.
- Ensure tooltip text remains readable and contrast-compliant.

## Token Requirements

- Tooltip surface and text styling
- Placement offset
- Pointer/arrow styling

## Token Slot Matrix

| Part | Property | State / Variant | Required semantic token slot | Notes |
|---|---|---|---|---|
| Tooltip bubble | Background/text color | Default | Tooltip surface/text slots | Must preserve contrast. |
| Tooltip bubble | Spacing/radius | Default | Tooltip shape/spacing slots | Supports short content only. |
| Tooltip pointer | Color/size | Placement variants | Tooltip pointer slots | Matches bubble styling. |

## States

- Hidden
- Visible

## State Semantics

| State | Required semantics | User interaction | Notes |
|---|---|---|---|
| Hidden | No tooltip shown | Trigger can reveal | Required default. |
| Visible | Tooltip shown for current trigger | Dismiss on blur/exit | Required active state. |

## Variants

- `top`
- `bottom`
- `left`
- `right`

## Responsive / Density Behaviour

Tooltip placement and spacing adapt to viewport constraints while preserving readable short content.

## Component Dependencies

- `Tooltip`
- `Button`, `Link`, or other trigger-owning patterns

## Minimum Component API

| API | Classification | Default | Contract |
|---|---|---|---|
| `text` | Required | None | Tooltip content text. |
| `placement` | Optional | `top` | Preferred placement direction. |

## Agent Freedom

| Decision Area | Freedom Level | Allowed Choices | Requires Human Review |
|---|---|---|---|
| Interaction model | none | Keep tooltip non-interactive and trigger-owned. | Yes, for interactive popover behavior. |
| Placement strategy | guided | Placement variants with fallback logic. | No. |
| Content length | limited | Short guidance text only. | Yes, for long-form help content. |

## Implementation Contract

- Preserve trigger-owned tooltip behavior.
- Preserve non-interactive semantics.
- Preserve concise readable content.

## Test Requirements

- Verify hover/focus visibility.
- Verify blur/exit dismissal.
- Verify trigger relationship semantics.

## Negative Test Requirements

- Interactive controls inside tooltip fail.
- Tooltip used for critical long-form instructions fails.

## Documentation Requirements

Human-facing docs explain tooltip scope, content length, and popover boundary.

## Anti-Patterns

- Long instructional paragraphs in tooltip.
- Tooltip-only critical workflow information.

## Agent Output

Agents can derive contextual-help review checks and accessibility criteria from this pattern.

Review this pattern against `patterns/checklists/pattern-spec-review-checklist.md` before deriving implementation output.

## Open Questions

- Open question: Should collision-avoidance placement behavior be standardized in base tooltip guidance?

