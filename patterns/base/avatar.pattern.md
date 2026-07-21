---
id: pattern.base.avatar
title: Avatar Pattern
type: pattern
status: draft
owners:
  - ui-foundations
created: 2026-07-21
updated: 2026-07-21
authority: derived
summary: Agent-readable base pattern contract for avatars.
related:
  derived_from:
    - /Users/Thomas.Bielich@tui.com/GitHub/uif/ui-foundations-runtime/site/patterns/avatar.md
  references:
    - specification.pattern.schema
---

# Avatar Pattern

## Metadata

- id: `pattern.base.avatar`
- type: base
- status: draft
- source: `/Users/Thomas.Bielich@tui.com/GitHub/uif/ui-foundations-runtime/site/patterns/avatar.md`
- related standards: Accessible name requirements for meaningful imagery
- related components: `Avatar`
- related tokens: `avatar`, size, shape, text, background, border

## Intent

Provide a compact identity marker for a person, account, or entity.

## Problem

Interfaces need a consistent visual identity cue that works with image and fallback content while preserving accessible naming.

## Use When

- Use to represent users or entities in lists, headers, and metadata rows.
- Use initials fallback when no image is available.

## Do Not Use When

- Do not use avatar as an action control by itself.
- Do not use avatar as the only identity context when a label is required.

## Standard Basis

Avatars represent identity content, not an interactive control by default. Image alternatives must provide meaningful accessible naming.

## Anatomy

- Avatar container
- Optional image
- Initials fallback

## Structure Contract

| Item | Classification | Contract |
|---|---|---|
| Container | Required | A stable circular or approved shape tokenized container. |
| Image | Optional | Render when image source is available. |
| Initials fallback | Optional | Render when image is missing or fails. |
| Accessible name | Required | Provide an accessible name for meaningful identity contexts. |

## Implementation Naming Contract

### CSS Class Contract

- Public avatar classes use the `uif-` prefix.

### Token Contract

- Public avatar tokens use `--uif-avatar-*`.

### Data Attribute Contract

Data attributes may expose metadata but must not replace semantics.

### Native / ARIA Precedence

- Use native image semantics for image content.
- Use role and label semantics only when needed for non-image fallback rendering.

### Agent Freedom Boundary

- Identity semantics and accessible naming are not agent freedom.

## Required Semantics

- Avatar conveys identity context.
- Accessible naming is preserved for meaningful content.
- Fallback content remains understandable.

## Behaviour

- Image renders when available.
- Initials fallback renders when image is unavailable.
- Sizes scale by tokenized size variants.

## Keyboard Interaction

Avatar is non-interactive unless composed inside an interactive parent.

## Accessibility Rules

- Provide meaningful alternative text or accessible labeling in context.
- Do not announce decorative fallback characters redundantly.

## Token Requirements

- Container size and radius
- Background and text color
- Border and ring tokens
- Image fit and fallback typography tokens

## Token Slot Matrix

| Part | Property | State / Variant | Required semantic token slot | Notes |
|---|---|---|---|---|
| Container | Size / shape | XS–XL | Avatar size and radius slots | Must preserve intended identity hierarchy. |
| Fallback text | Color / typography | Default | Avatar fallback text slots | Keep contrast legible. |
| Container | Border / background | Default / themed | Avatar surface slots | Must adapt across modes. |

## States

- Image
- Initials fallback
- Themed

## State Semantics

| State | Required semantics | User interaction | Notes |
|---|---|---|---|
| Image | Identity image shown | None | Optional state. |
| Initials fallback | Fallback identity shown | None | Required fallback path. |
| Themed | Tokenized brand/mode adaptation | None | Required in supported themes. |

## Variants

- `xs`
- `sm`
- `md`
- `lg`
- `xl`

## Responsive / Density Behaviour

Avatar scales through size tokens and preserves legibility at all supported sizes.

## Component Dependencies

- `Avatar`

## Minimum Component API

| API | Classification | Default | Contract |
|---|---|---|---|
| `src` | Optional | None | Image source. |
| `alt` | Required for image | None | Accessible image text. |
| `initials` | Optional | None | Fallback initials content. |
| `size` | Optional | `md` | Size variant token mapping. |

## Agent Freedom

| Decision Area | Freedom Level | Allowed Choices | Requires Human Review |
|---|---|---|---|
| Identity semantics | none | Preserve accessible identity labeling. | Yes, for alternate naming strategies. |
| Fallback strategy | limited | Initials fallback for missing images. | Yes, for non-initials fallback content. |
| Size scale | guided | Use documented size variants. | No. |

## Implementation Contract

- Preserve identity meaning.
- Preserve image fallback behavior.
- Preserve size consistency and contrast.

## Test Requirements

- Verify image and fallback rendering.
- Verify accessible name for meaningful avatars.
- Verify size variants.

## Negative Test Requirements

- Image-only avatar with missing accessible name fails.
- Missing fallback behavior fails.

## Documentation Requirements

Human-facing docs explain identity usage, fallback rules, and sizing guidance.

## Anti-Patterns

- Using avatar as the only control label.
- Relying on color alone for identity distinction.

## Agent Output

Agents can derive acceptance criteria and token audits from this pattern.

Review this pattern against `patterns/checklists/pattern-spec-review-checklist.md` before deriving implementation output.

## Open Questions

- Open question: Should status-presence badges be part of base avatar or a composition pattern?

