---
id: pattern.base.label
title: Label Pattern
type: pattern
status: draft
owners:
  - ui-foundations
created: 2026-07-21
updated: 2026-07-21
authority: derived
summary: Agent-readable base pattern contract for labels.
related:
  derived_from:
    - /Users/Thomas.Bielich@tui.com/GitHub/uif/ui-foundations-runtime/site/patterns/label.md
  references:
    - specification.pattern.schema
---

# Label Pattern

## Metadata

- id: `pattern.base.label`
- type: base
- status: draft
- source: `/Users/Thomas.Bielich@tui.com/GitHub/uif/ui-foundations-runtime/site/patterns/label.md`
- related standards: Native form-label association requirements
- related components: `Label`
- related tokens: `label`, typography, color, icon spacing

## Intent

Provide consistent textual naming for controls, fields, and compact icon+text content.

## Problem

Interfaces need stable labeling that supports readability, scanability, and explicit semantic association with controls.

## Use When

- Use field labels for form controls.
- Use compact label-content primitives for non-form text+icon combinations.

## Do Not Use When

- Do not use presentational label content as a substitute for semantic field labels.

## Standard Basis

Field labels rely on native label semantics and explicit association with form controls.

## Anatomy

- Label text
- Optional start/end icon slots
- Optional required indicator in field-label contexts

## Structure Contract

| Item | Classification | Contract |
|---|---|---|
| Label text | Required | Concise text that names the target content/control. |
| Semantic association | Required for fields | Programmatic relationship with target control. |
| Optional icons | Optional | Decorative unless explicitly named by context. |

## Implementation Naming Contract

### CSS Class Contract

- Public label classes use the `uif-` prefix.

### Token Contract

- Public label tokens use `--uif-label-*`.

### Data Attribute Contract

Data attributes may mirror metadata but must not replace label semantics.

### Native / ARIA Precedence

- Use native label semantics for form fields.
- Use presentational structures for non-field label content.

### Agent Freedom Boundary

- Field-label semantic association is not agent freedom.

## Required Semantics

- Field labels identify control purpose.
- Label content remains concise and meaningful.

## Behaviour

- Field-label activation focuses associated input.
- Label-content adapts with icon and text spacing tokens.

## Keyboard Interaction

Labels are non-interactive primitives; field-label click/focus behavior is delegated to native semantics.

## Accessibility Rules

- Every form control has a programmatic label.
- Decorative icons in labels are hidden from assistive technology.

## Token Requirements

- Label text typography and color
- Icon gap and alignment
- Required-indicator emphasis

## Token Slot Matrix

| Part | Property | State / Variant | Required semantic token slot | Notes |
|---|---|---|---|---|
| Label text | Typography / color | Default / disabled contexts | Label text slots | Must preserve readability. |
| Icon slot | Size / spacing | Start / end icon | Label icon slots | Decorative by default. |
| Required indicator | Color / spacing | Required field label | Label required-indicator slots | Must not be only required signal. |

## States

- Default
- Required field-label context
- Disabled field context

## State Semantics

| State | Required semantics | User interaction | Notes |
|---|---|---|---|
| Default | Control/content naming | None | Required. |
| Required | Field requirement signaled | None | Optional by field context. |
| Disabled context | Associated with disabled control | None | Optional by field context. |

## Variants

- Field label
- Label content with icons
- Icon-only label content (context-named)

## Responsive / Density Behaviour

Label typography and spacing scale by tokenized density and size contexts.

## Component Dependencies

- `Label`
- `Icon` primitive when icon slots are used

## Minimum Component API

| API | Classification | Default | Contract |
|---|---|---|---|
| `text` | Required | None | Label content text. |
| `htmlFor` | Required for field label | None | Control association target. |
| `required` | Optional | `false` | Required-field marker. |
| `startIcon` / `endIcon` | Optional | None | Decorative icon slots. |

## Agent Freedom

| Decision Area | Freedom Level | Allowed Choices | Requires Human Review |
|---|---|---|---|
| Field association | none | Preserve semantic association. | Yes, for non-standard label ownership. |
| Icon usage | limited | Decorative icon slots by context. | No. |
| Typography/spacing | guided | Use semantic label tokens. | No. |

## Implementation Contract

- Preserve field-label semantics.
- Preserve concise readable text.
- Preserve icon accessibility behavior.

## Test Requirements

- Verify field label association.
- Verify icon decorative treatment.
- Verify required indicator behavior.

## Negative Test Requirements

- Unassociated field label fails.
- Icon-only label content without contextual accessible name fails.

## Documentation Requirements

Human-facing docs explain field label vs label-content roles and required-marker guidance.

## Anti-Patterns

- Placeholder-only labeling.
- Using presentational label content as semantic field label.

## Agent Output

Agents can derive form-label review checks and accessibility criteria from this pattern.

Review this pattern against `patterns/checklists/pattern-spec-review-checklist.md` before deriving implementation output.

## Open Questions

- Open question: Should required-indicator verbalization conventions be centralized in label or form patterns?

