---
id: pattern.base.link
title: Link Pattern
type: pattern
status: draft
owners:
  - ui-foundations
created: 2026-07-21
updated: 2026-07-21
authority: derived
summary: Agent-readable base pattern contract for links.
related:
  derived_from:
    - /Users/Thomas.Bielich@tui.com/GitHub/uif/ui-foundations-runtime/site/patterns/link.md
  references:
    - specification.pattern.schema
---

# Link Pattern

## Metadata

- id: `pattern.base.link`
- type: base
- status: draft
- source: `/Users/Thomas.Bielich@tui.com/GitHub/uif/ui-foundations-runtime/site/patterns/link.md`
- related standards: Native HTML anchor semantics; WCAG link purpose requirements
- related components: `Link`
- related tokens: `link`, text, underline, focus, visited

## Intent

Provide semantic inline navigation to destinations and resources.

## Problem

Interfaces need clear navigation affordances that remain distinct from action controls.

## Use When

- Use for navigation to a page, section, file, or external resource.
- Use descriptive text that explains destination.

## Do Not Use When

- Do not use links for in-place actions; use buttons for actions.

## Standard Basis

Native anchor semantics (`<a>`) are the baseline for navigation behavior and keyboard support.

## Anatomy

- Link text
- Optional decorative start/end icons
- Optional visited state presentation

## Structure Contract

| Item | Classification | Contract |
|---|---|---|
| Anchor semantics | Required | Navigation uses native anchor behavior. |
| Destination | Required unless disabled | Destination must be explicit for active links. |
| Link text | Required | Text must communicate destination purpose. |
| Disabled treatment | Optional | Disabled links remove navigation affordance. |

## Implementation Naming Contract

### CSS Class Contract

- Public link classes use the `uif-` prefix.

### Token Contract

- Public link tokens use `--uif-link-*`.

### Data Attribute Contract

Data attributes may mirror state metadata only.

### Native / ARIA Precedence

- Use native anchor for active navigation.
- Disabled treatment must prevent navigation and focus when intended.

### Agent Freedom Boundary

- Link-vs-button semantic boundary is not agent freedom.

## Required Semantics

- Link text remains meaningful in isolation.
- Focus and visited states remain perceivable.

## Behaviour

- Enter key activates link navigation.
- Visited style can indicate prior navigation.
- Disabled link variant is non-navigable and non-focusable.

## Keyboard Interaction

- `Tab`: focus link.
- `Enter`: activate destination.

## Accessibility Rules

- Use meaningful link text.
- Keep non-color cues (such as underline) for discoverability.
- Preserve visible focus state.

## Token Requirements

- Default/hover/active/visited/disabled text styling
- Underline behavior
- Focus indicator

## Token Slot Matrix

| Part | Property | State / Variant | Required semantic token slot | Notes |
|---|---|---|---|---|
| Link text | Color | Default / hover / active / visited / disabled | Link state color slots | Maintain contrast and state distinction. |
| Link text | Decoration | Default / hover | Link decoration slots | Avoid color-only differentiation. |
| Link | Focus indicator | Focus-visible | Link focus slot | Required for keyboard navigation. |

## States

- Default
- Hover
- Active
- Visited
- Focus
- Disabled

## State Semantics

| State | Required semantics | User interaction | Notes |
|---|---|---|---|
| Default | Navigable destination | Activate with Enter/click | Required. |
| Visited | Previously visited destination | Same as default | Optional by browser behavior. |
| Disabled | Not navigable | No activation | Optional variant. |

## Variants

- Inline text link
- Link with start/end icon
- Disabled link

## Responsive / Density Behaviour

Links inherit surrounding typography and maintain legible interaction styling across density and mode contexts.

## Component Dependencies

- `Link`
- `Icon` primitive for optional icon slots

## Minimum Component API

| API | Classification | Default | Contract |
|---|---|---|---|
| `href` | Required unless disabled | None | Navigation destination. |
| `disabled` | Optional | `false` | Non-navigable state treatment. |
| `startIcon` / `endIcon` | Optional | None | Decorative icon slots. |

## Agent Freedom

| Decision Area | Freedom Level | Allowed Choices | Requires Human Review |
|---|---|---|---|
| Semantic role | none | Use link for navigation only. | Yes, for non-navigation link usage. |
| Disabled behavior | limited | Non-navigable, non-focusable disabled variant. | No. |
| Visual state expression | guided | Tokenized state styling with non-color cues. | No. |

## Implementation Contract

- Preserve native navigation semantics.
- Preserve meaningful text and focus behavior.
- Preserve distinction from button actions.

## Test Requirements

- Verify keyboard activation.
- Verify disabled non-navigation behavior.
- Verify visited/focus state styling.

## Negative Test Requirements

- Link used for non-navigation action fails.
- Generic text like "click here" without context fails.

## Documentation Requirements

Human-facing docs explain link purpose, text standards, and link-vs-button boundaries.

## Anti-Patterns

- Action links for non-navigation behavior.
- Ambiguous destination wording.

## Agent Output

Agents can derive navigation/accessibility review checks from this pattern.

Review this pattern against `patterns/checklists/pattern-spec-review-checklist.md` before deriving implementation output.

## Open Questions

- Open question: Should external-link disclosure conventions be standardized in base link or content guidelines?

