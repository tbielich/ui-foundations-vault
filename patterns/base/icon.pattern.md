---
id: pattern.base.icon
title: Icon Pattern
type: pattern
status: draft
owners:
  - ui-foundations
created: 2026-07-21
updated: 2026-07-21
authority: derived
summary: Agent-readable base pattern contract for icons.
related:
  derived_from:
    - /Users/Thomas.Bielich@tui.com/GitHub/uif/ui-foundations-runtime/site/patterns/icon.md
  references:
    - specification.pattern.schema
---

# Icon Pattern

## Metadata

- id: `pattern.base.icon`
- type: base
- status: draft
- source: `/Users/Thomas.Bielich@tui.com/GitHub/uif/ui-foundations-runtime/site/patterns/icon.md`
- related standards: Accessible name and decorative-image semantics
- related components: `Icon`
- related tokens: `icon`, color, size, spacing

## Intent

Provide reusable symbolic visuals that reinforce meaning and actions.

## Problem

Interfaces need consistent icon rendering, sizing, and accessibility behavior without relying on inconsistent ad hoc assets.

## Use When

- Use to reinforce nearby text labels.
- Use as visual affordance in controls with explicit accessible names.

## Do Not Use When

- Do not use standalone icons as the only meaning where text is required.
- Do not hardcode non-tokenized icon colors.

## Standard Basis

Icon semantics depend on context: decorative icons are hidden from assistive technology; meaningful icons require accessible naming via their interactive or labeled parent.

## Anatomy

- Icon glyph source
- Render container
- Optional contextual label relationship

## Structure Contract

| Item | Classification | Contract |
|---|---|---|
| Icon source | Required | Stable glyph reference. |
| Render container | Required | Inherits color and scales predictably. |
| Accessibility role | Required | Decorative vs meaningful treatment defined by context. |

## Implementation Naming Contract

### CSS Class Contract

- Public icon classes use the `uif-` prefix.

### Token Contract

- Public icon tokens use `--uif-icon-*`.

### Data Attribute Contract

Data attributes may provide metadata only.

### Native / ARIA Precedence

- Decorative icons should be hidden from assistive technology.
- Meaningful icons require accessible naming from contextual owner.

### Agent Freedom Boundary

- Decorative/meaningful accessibility boundary is not agent freedom.

## Required Semantics

- Icon meaning is explicit in context.
- Decorative icons are not redundantly announced.

## Behaviour

- Icons inherit current text color.
- Icons scale with container typography or explicit tokenized size.

## Keyboard Interaction

Icon primitive has no direct keyboard interaction.

## Accessibility Rules

- Decorative icons are hidden from assistive technology.
- Meaningful icon-only controls require explicit accessible names.

## Token Requirements

- Icon color
- Icon size
- Icon spacing/alignment

## Token Slot Matrix

| Part | Property | State / Variant | Required semantic token slot | Notes |
|---|---|---|---|---|
| Icon glyph | Color | Default / semantic contexts | Icon color slots | Use semantic color tokens only. |
| Icon glyph | Size | XS–XL contexts | Icon size slots | Preserve optical readability. |
| Icon container | Alignment / spacing | Inline and control contexts | Icon spacing slots | Maintain text alignment. |

## States

- Decorative
- Meaningful

## State Semantics

| State | Required semantics | User interaction | Notes |
|---|---|---|---|
| Decorative | Hidden from AT | None | Default in text-labeled contexts. |
| Meaningful | Named through context | Depends on parent control | Required for icon-only controls. |

## Variants

- Size variants
- Semantic color contexts

## Responsive / Density Behaviour

Icons preserve alignment and legibility across typography and density scales.

## Component Dependencies

- `Icon`
- Label and button/link patterns for meaningful usage contexts

## Minimum Component API

| API | Classification | Default | Contract |
|---|---|---|---|
| `name` / source | Required | None | Icon glyph source identity. |
| `decorative` | Optional | `true` | Accessibility visibility behavior. |
| `size` | Optional | Contextual default | Size mapping to token slots. |

## Agent Freedom

| Decision Area | Freedom Level | Allowed Choices | Requires Human Review |
|---|---|---|---|
| Accessibility semantics | none | Correct decorative/meaningful treatment. | Yes, for exceptions. |
| Rendering strategy | guided | Preserve tokenized color and size behavior. | No. |
| Icon source governance | limited | Use approved icon inventory only. | Yes, for new public icons. |

## Implementation Contract

- Preserve icon accessibility semantics.
- Preserve tokenized color/size behavior.
- Preserve alignment in composed controls.

## Test Requirements

- Verify decorative icon hiding.
- Verify meaningful icon naming through context.
- Verify tokenized size and color behavior.

## Negative Test Requirements

- Icon-only control with no accessible name fails.
- Hardcoded icon color outside semantic tokens fails.

## Documentation Requirements

Human-facing docs explain decorative vs meaningful usage and naming requirements.

## Anti-Patterns

- Meaningful icon with no accessible name.
- Icon-only communication for critical instructions.

## Agent Output

Agents can derive accessibility and token compliance checks from this pattern.

Review this pattern against `patterns/checklists/pattern-spec-review-checklist.md` before deriving implementation output.

## Open Questions

- Open question: Should icon density presets be standardized across all component contexts?

