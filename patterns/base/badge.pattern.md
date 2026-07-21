---
id: pattern.base.badge
title: Badge Pattern
type: pattern
status: draft
owners:
  - ui-foundations
created: 2026-07-21
updated: 2026-07-21
authority: derived
summary: Agent-readable base pattern contract for badges.
related:
  derived_from:
    - /Users/Thomas.Bielich@tui.com/GitHub/uif/ui-foundations-runtime/site/patterns/badge.md
  references:
    - specification.pattern.schema
---

# Badge Pattern

## Metadata

- id: `pattern.base.badge`
- type: base
- status: draft
- source: `/Users/Thomas.Bielich@tui.com/GitHub/uif/ui-foundations-runtime/site/patterns/badge.md`
- related standards: WCAG use-of-color requirements for status communication
- related components: `Badge`
- related tokens: `badge`, status color, typography, spacing, radius

## Intent

Provide a compact non-interactive label for status, metadata, or counts.

## Problem

Interfaces need short semantic markers that do not introduce additional interaction burden.

## Use When

- Use for concise status and category signals.
- Use for short counts and tags that support surrounding content.

## Do Not Use When

- Do not use badges as buttons or links by default.
- Do not use long sentences in badge content.

## Standard Basis

Badge is presentational status text and must remain readable without depending only on color.

## Anatomy

- Badge container
- Badge text
- Optional decorative icon

## Structure Contract

| Item | Classification | Contract |
|---|---|---|
| Container | Required | Non-interactive label container. |
| Text | Required | Concise text or numeric content. |
| Optional icon | Optional | Decorative icon only unless explicitly named by composition. |

## Implementation Naming Contract

### CSS Class Contract

- Public badge classes use the `uif-` prefix.

### Token Contract

- Public badge tokens use `--uif-badge-*`.

### Data Attribute Contract

Data attributes may mirror status type but do not replace semantics.

### Native / ARIA Precedence

Use plain text semantics unless a composition requires additional announcements.

### Agent Freedom Boundary

Badge remains non-interactive at base level.

## Required Semantics

- Badge content remains concise and meaningful.
- Variant meaning is not encoded by color alone.

## Behaviour

- Badge adapts to tokenized variants and modes.
- Badge does not receive focus in base usage.

## Keyboard Interaction

No direct keyboard interaction for base badge.

## Accessibility Rules

- Keep semantic meaning in text content.
- Hide decorative icons from assistive technology.

## Token Requirements

- Background and text color by variant
- Padding and radius
- Typography and icon spacing

## Token Slot Matrix

| Part | Property | State / Variant | Required semantic token slot | Notes |
|---|---|---|---|---|
| Badge container | Background | Default / brand / success / danger | Badge background variant slots | Maintain contrast. |
| Badge text | Text color | By variant | Badge text slots | Must remain readable. |
| Badge container | Radius / spacing | All variants | Badge shape/spacing slots | Keeps compact form. |

## States

- Default
- Themed variant

## State Semantics

| State | Required semantics | User interaction | Notes |
|---|---|---|---|
| Default | Neutral metadata label | None | Required. |
| Variant | Semantic status label | None | Optional by context. |

## Variants

- `default`
- `brand`
- `success`
- `danger`

## Responsive / Density Behaviour

Badge keeps compact height and scales spacing and type via tokens for dense and regular contexts.

## Component Dependencies

- `Badge`
- Icon primitive when icon is used

## Minimum Component API

| API | Classification | Default | Contract |
|---|---|---|---|
| `text` | Required | None | Badge label content. |
| `variant` | Optional | `default` | Semantic visual variant. |
| `size` | Optional | `md` | Size variant when supported. |
| `startIcon` | Optional | None | Decorative leading icon. |

## Agent Freedom

| Decision Area | Freedom Level | Allowed Choices | Requires Human Review |
|---|---|---|---|
| Interaction model | none | Keep base badge non-interactive. | Yes, for clickable badge proposals. |
| Variant mapping | guided | Use semantic variant tokens. | No. |
| Content length | limited | Short text or numbers only. | Yes, for long-form badge content. |

## Implementation Contract

- Preserve non-interactive behavior.
- Preserve readable concise text.
- Preserve semantic variant meaning.

## Test Requirements

- Verify variants map through tokens.
- Verify icons are decorative by default.
- Verify badge is not focusable in base usage.

## Negative Test Requirements

- Clickable badge without explicit composition semantics fails.
- Variant meaning conveyed by color only fails.

## Documentation Requirements

Human-facing docs explain variant meaning, content limits, and when to use alternatives.

## Anti-Patterns

- Long badge text.
- Using badge as primary action control.

## Agent Output

Agents can derive review checks and token audits from this pattern.

Review this pattern against `patterns/checklists/pattern-spec-review-checklist.md` before deriving implementation output.

## Open Questions

- Open question: Should notification-dot badges be documented as badge variant or separate primitive?

