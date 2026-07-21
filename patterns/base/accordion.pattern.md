---
id: pattern.base.accordion
title: Accordion Pattern
type: pattern
status: draft
owners:
  - ui-foundations
created: 2026-07-21
updated: 2026-07-21
authority: derived
summary: Agent-readable base pattern contract for accordions.
related:
  derived_from:
    - /Users/Thomas.Bielich@tui.com/GitHub/uif/ui-foundations-runtime/site/patterns/accordion.md
  references:
    - specification.pattern.schema
---

# Accordion Pattern

## Metadata

- id: `pattern.base.accordion`
- type: base
- status: draft
- source: `/Users/Thomas.Bielich@tui.com/GitHub/uif/ui-foundations-runtime/site/patterns/accordion.md`
- related standards: Native HTML `details` and `summary`; WCAG focus visibility and content structure requirements
- related components: `Accordion`
- related tokens: `accordion`, spacing, border, color, focus

## Intent

Provide a progressive disclosure pattern that reveals or hides related content sections without navigating away.

## Problem

Interfaces need to reduce scan load while keeping content available and preserving clear section titles and keyboard access.

## Use When

- Use when users need to scan grouped headings and open only relevant sections.
- Use when content blocks are related but not all required at once.

## Do Not Use When

- Do not use for mutually exclusive panel switching; use tabs for that.
- Do not hide critical, always-required instructions in collapsed sections.

## Standard Basis

Native `details` and `summary` behavior is the base. Expanded state must remain programmatically determinable and focusable through native semantics.

## Anatomy

- Section container
- Summary trigger
- Expandable content region

## Structure Contract

| Item | Classification | Contract |
|---|---|---|
| Section wrapper | Required | Group each disclosure item in its own semantic container. |
| Summary trigger | Required | Use one concise title per section. |
| Content region | Required | The region contains content directly related to the summary. |
| Disabled item | Optional | Disabled items must be visibly unavailable and non-interactive. |

## Implementation Naming Contract

### CSS Class Contract

- Public accordion classes use the `uif-` prefix.
- State classes use `is-*` only when native attributes do not fully express the state.

### Token Contract

- Public accordion tokens use `--uif-accordion-*`.

### Data Attribute Contract

Data attributes may mirror state metadata, but must not replace semantic structure.

### Native / ARIA Precedence

- Prefer native `details` and `summary`.
- Use ARIA only when native behavior cannot represent a needed semantic.

### Agent Freedom Boundary

- Semantic disclosure structure, keyboard behavior, and token scoping are not agent freedom.

## Required Semantics

- Summary text communicates section purpose.
- Expanded and collapsed state is programmatically determinable.
- Focus indicator remains visible on keyboard navigation.

## Behaviour

- Users toggle sections with pointer or keyboard activation on the summary.
- Expanded sections reveal content inline without changing context.
- Disabled sections cannot be toggled.

## Keyboard Interaction

- `Tab`: moves focus between summaries and other focusable content.
- `Enter` / `Space`: toggles the focused summary.

## Accessibility Rules

- Use native disclosure semantics.
- Keep summary labels concise and meaningful.
- Do not rely on icon rotation alone to express state.

## Token Requirements

- Container border and background
- Summary text and icon color
- Focus indicator
- Spacing and divider tokens

## Token Slot Matrix

| Part | Property | State / Variant | Required semantic token slot | Notes |
|---|---|---|---|---|
| Summary trigger | Text / icon color | Default / hover / focus | Accordion summary text/icon slots | Must preserve contrast. |
| Item container | Border / background | Default / expanded / disabled | Accordion container slots | Expanded state must remain readable. |
| Summary trigger | Focus indicator | Focus-visible | Accordion focus slot | Meets non-text contrast. |

## States

- Collapsed
- Expanded
- Focus
- Disabled

## State Semantics

| State | Required semantics | User interaction | Notes |
|---|---|---|---|
| Collapsed | Content hidden | Summary can be activated | Required. |
| Expanded | Content visible | Summary can collapse section | Required. |
| Focus | Visible focus indicator | Keyboard navigation | Required. |
| Disabled | Non-interactive section | No toggle | Optional. |

## Variants

- Default
- Disabled item

## Responsive / Density Behaviour

Accordion sections stack vertically and preserve readable spacing across viewport sizes and density settings.

## Component Dependencies

- `Accordion`
- Icon primitive for disclosure indicator

## Minimum Component API

| API | Classification | Default | Contract |
|---|---|---|---|
| `title` | Required | None | Summary label text. |
| `open` | Optional | `false` | Controls expanded state. |
| `disabled` | Optional | `false` | Prevents toggle interactions. |

## Agent Freedom

| Decision Area | Freedom Level | Allowed Choices | Requires Human Review |
|---|---|---|---|
| Disclosure semantics | none | Preserve native disclosure behavior. | Yes, for non-native disclosure structures. |
| Visual style | guided | Use semantic token slots for all states. | No, unless adding new semantic states. |
| Disabled strategy | limited | Native or equivalent non-interactive behavior. | Yes, for non-standard disabled behavior. |

## Implementation Contract

- Preserve semantic disclosure behavior.
- Preserve keyboard and focus support.
- Keep expanded/collapsed state clearly perceivable.

## Test Requirements

- Verify collapsed/expanded toggling.
- Verify keyboard activation.
- Verify visible focus indicator.
- Verify disabled behavior when supported.

## Negative Test Requirements

- Summary that does not toggle fails.
- Hidden content with no semantic state relationship fails.
- Focus indicator removal fails.

## Documentation Requirements

Human-facing docs explain when to use accordion, how to label summaries, and how to avoid hiding critical content.

## Anti-Patterns

- Using accordion for tabbed switching.
- Vague summary labels such as "More".
- Hiding required, critical content by default.

## Agent Output

Agents can derive acceptance criteria, accessibility checks, and token audits from this pattern.

Review this pattern against `patterns/checklists/pattern-spec-review-checklist.md` before deriving implementation output.

## Open Questions

- Open question: Should multi-expand and single-expand behavior both be first-class at base-pattern level?

