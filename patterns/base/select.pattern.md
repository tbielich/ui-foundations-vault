---
id: pattern.base.select
title: Select Pattern
type: pattern
status: draft
owners:
  - ui-foundations
created: 2026-07-21
updated: 2026-07-21
authority: derived
summary: Agent-readable base pattern contract for select controls.
related:
  derived_from:
    - /Users/Thomas.Bielich@tui.com/GitHub/uif/ui-foundations-runtime/site/patterns/select.md
  references:
    - specification.pattern.schema
---

# Select Pattern

## Metadata

- id: `pattern.base.select`
- type: base
- status: draft
- source: `/Users/Thomas.Bielich@tui.com/GitHub/uif/ui-foundations-runtime/site/patterns/select.md`
- related standards: Native select semantics and keyboard navigation requirements
- related components: `Select`
- related tokens: `select`, option list, placeholder, focus, border

## Intent

Provide a compact control for choosing one option from a list.

## Problem

Interfaces need a scalable single-selection control for medium and large option sets.

## Use When

- Use when option counts are high and inline radio options would increase visual noise.

## Do Not Use When

- Do not use for very small option sets where radios provide better visibility.

## Standard Basis

Native select behavior is the base for option navigation, selection, and assistive technology compatibility.

## Anatomy

- Field container
- Selected value/placeholder text
- Disclosure indicator
- Option list context

## Structure Contract

| Item | Classification | Contract |
|---|---|---|
| Select field | Required | Single-choice selection control. |
| Label association | Required | Programmatic label is required. |
| Options | Required | Defined option list, optionally grouped. |
| Disabled state | Optional | Non-interactive select when unavailable. |

## Implementation Naming Contract

### CSS Class Contract

- Public select classes use the `uif-` prefix.

### Token Contract

- Public select tokens use `--uif-select-*`.

### Data Attribute Contract

Data attributes may mirror selected/invalid state metadata.

### Native / ARIA Precedence

- Prefer native select semantics.

### Agent Freedom Boundary

- Selection semantics and keyboard model are not agent freedom.

## Required Semantics

- Programmatic label is present.
- Selected value is programmatically determinable.

## Behaviour

- Opens option list through native interaction.
- Supports option keyboard navigation and type-ahead behavior.

## Keyboard Interaction

- `Tab`: focus traversal.
- `Enter` / `Space`: open list.
- Arrow keys: navigate options.
- `Home` / `End`: jump to boundary options.

## Accessibility Rules

- Use semantic select behavior.
- Keep placeholder distinct from label.
- Preserve focus visibility and readable options.

## Token Requirements

- Field border/background/text
- Placeholder and selected value styling
- Focus and disabled states

## Token Slot Matrix

| Part | Property | State / Variant | Required semantic token slot | Notes |
|---|---|---|---|---|
| Field container | Border/background | Default / hover / focus / disabled | Select container slots | Preserve contrast. |
| Value text | Text color | Placeholder / selected | Select value text slots | Placeholder remains hint only. |
| Field container | Focus indicator | Focus-visible | Select focus slot | Required for keyboard users. |

## States

- Default
- Hover
- Focus
- Disabled
- Value selected

## State Semantics

| State | Required semantics | User interaction | Notes |
|---|---|---|---|
| Default | No active focus | Can open list | Required. |
| Focus | Active keyboard focus | Can open/select | Required. |
| Disabled | Non-interactive | No selection change | Required when disabled. |
| Value selected | Current choice visible | Can change selection | Required after selection. |

## Variants

- Placeholder/no selection
- Selected value
- Option-grouped list

## Responsive / Density Behaviour

Select preserves field readability and hit area while scaling spacing and typography via tokens.

## Component Dependencies

- `Select`
- Label primitive

## Minimum Component API

| API | Classification | Default | Contract |
|---|---|---|---|
| `options` | Required | `[]` | Option list definition. |
| `value` | Optional | None | Selected option value. |
| `placeholder` | Optional | None | Hint text when no selection. |
| `disabled` | Optional | `false` | Non-interactive state. |

## Agent Freedom

| Decision Area | Freedom Level | Allowed Choices | Requires Human Review |
|---|---|---|---|
| Selection semantics | none | Preserve single-select model. | Yes, for multi-select behavior. |
| Option grouping | guided | Group options where useful. | No. |
| Visual behavior | guided | Tokenized state styling. | No. |

## Implementation Contract

- Preserve single-choice select semantics.
- Preserve labeling and keyboard behavior.
- Preserve state readability and focus clarity.

## Test Requirements

- Verify label association.
- Verify keyboard navigation.
- Verify disabled behavior.
- Verify placeholder vs selected value behavior.

## Negative Test Requirements

- Placeholder-only labeling fails.
- Select used for multi-select behavior without explicit model fails.

## Documentation Requirements

Human-facing docs explain select usage thresholds, labeling, and option grouping guidance.

## Anti-Patterns

- Select for tiny option sets where radios are clearer.
- Placeholder used as only label.

## Agent Output

Agents can derive form-control acceptance criteria and accessibility checks from this pattern.

Review this pattern against `patterns/checklists/pattern-spec-review-checklist.md` before deriving implementation output.

## Open Questions

- Open question: Should async-option loading behavior be standardized in base select or a composition pattern?

