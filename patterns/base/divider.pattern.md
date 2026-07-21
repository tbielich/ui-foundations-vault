---
id: pattern.base.divider
title: Divider Pattern
type: pattern
status: draft
owners:
  - ui-foundations
created: 2026-07-21
updated: 2026-07-21
authority: derived
summary: Agent-readable base pattern contract for dividers.
related:
  derived_from:
    - /Users/Thomas.Bielich@tui.com/GitHub/uif/ui-foundations-runtime/site/patterns/divider.md
  references:
    - specification.pattern.schema
---

# Divider Pattern

## Metadata

- id: `pattern.base.divider`
- type: base
- status: draft
- source: `/Users/Thomas.Bielich@tui.com/GitHub/uif/ui-foundations-runtime/site/patterns/divider.md`
- related standards: Native separator semantics
- related components: `Divider`
- related tokens: `divider`, border, spacing, orientation

## Intent

Provide a visual and semantic separator between related content sections.

## Problem

Layouts need a lightweight boundary signal that improves scannability without adding interaction overhead.

## Use When

- Use to separate adjacent content groups.
- Use vertical or horizontal orientation based on layout flow.

## Do Not Use When

- Do not use as decorative framing.
- Do not use as a substitute for spacing strategy.

## Standard Basis

Native separator semantics are the baseline for meaningful content boundaries.

## Anatomy

- Separator rule
- Orientation context

## Structure Contract

| Item | Classification | Contract |
|---|---|---|
| Separator element | Required | Semantic separator when content boundary is meaningful. |
| Orientation | Optional | Horizontal by default; vertical when layout requires it. |
| Variant | Optional | Visual emphasis variants through tokens. |

## Implementation Naming Contract

### CSS Class Contract

- Public divider classes use the `uif-` prefix.

### Token Contract

- Public divider tokens use `--uif-divider-*`.

### Data Attribute Contract

Data attributes may mirror orientation metadata only.

### Native / ARIA Precedence

Use separator semantics; for decorative-only usage, remove from accessibility tree.

### Agent Freedom Boundary

Divider remains non-interactive and structural.

## Required Semantics

- Separator purpose is clear from context.
- Orientation is exposed when vertical.

## Behaviour

- Divider does not receive focus.
- Divider scales with container dimensions and tokenized thickness.

## Keyboard Interaction

No keyboard interaction for base divider.

## Accessibility Rules

- Use semantic separator when dividing meaningful sections.
- Decorative separators should not create noise in accessibility output.

## Token Requirements

- Rule color and thickness
- Orientation sizing
- Variant emphasis

## Token Slot Matrix

| Part | Property | State / Variant | Required semantic token slot | Notes |
|---|---|---|---|---|
| Rule | Color | Default / subtle | Divider color slots | Preserve contrast where required. |
| Rule | Thickness | All variants | Divider size slots | Tokenized thickness only. |
| Rule | Length behavior | Horizontal / vertical | Divider orientation slots | Fit layout context. |

## States

- Default
- Subtle variant

## State Semantics

| State | Required semantics | User interaction | Notes |
|---|---|---|---|
| Default | Visible separation | None | Required. |
| Subtle | Lower emphasis separation | None | Optional. |

## Variants

- `default`
- `subtle`
- `horizontal`
- `vertical`

## Responsive / Density Behaviour

Divider preserves separator clarity across density modes through tokenized spacing and thickness.

## Component Dependencies

- `Divider`

## Minimum Component API

| API | Classification | Default | Contract |
|---|---|---|---|
| `orientation` | Optional | `horizontal` | Layout direction. |
| `variant` | Optional | `default` | Emphasis level. |

## Agent Freedom

| Decision Area | Freedom Level | Allowed Choices | Requires Human Review |
|---|---|---|---|
| Interaction model | none | Keep divider non-interactive. | Yes, for interactive separator proposals. |
| Orientation expression | guided | Horizontal or vertical semantics. | No. |
| Decorative usage | limited | Presentation-only only when truly decorative. | Yes. |

## Implementation Contract

- Preserve separator meaning where needed.
- Preserve non-interactive behavior.
- Preserve orientation clarity.

## Test Requirements

- Verify horizontal and vertical behavior.
- Verify semantic or decorative accessibility treatment.
- Verify tokenized variants.

## Negative Test Requirements

- Using divider as clickable affordance fails.
- Decorative divider announced as meaningful separator fails.

## Documentation Requirements

Human-facing docs explain separation intent and orientation guidance.

## Anti-Patterns

- Decorative overuse.
- Replacing spacing-only problems with separators.

## Agent Output

Agents can derive layout review checks and token audits from this pattern.

Review this pattern against `patterns/checklists/pattern-spec-review-checklist.md` before deriving implementation output.

## Open Questions

- Open question: Should inset divider variants belong to base divider or to composition layouts?

