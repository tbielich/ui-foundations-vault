---
id: pattern.base.form
title: Form Pattern
type: pattern
status: draft
owners:
  - ui-foundations
created: 2026-07-21
updated: 2026-07-21
authority: derived
summary: Agent-readable base pattern contract for forms.
related:
  derived_from:
    - /Users/Thomas.Bielich@tui.com/GitHub/uif/ui-foundations-runtime/site/patterns/form.md
  references:
    - specification.pattern.schema
---

# Form Pattern

## Metadata

- id: `pattern.base.form`
- type: base
- status: draft
- source: `/Users/Thomas.Bielich@tui.com/GitHub/uif/ui-foundations-runtime/site/patterns/form.md`
- related standards: Native form semantics; label and error association requirements
- related components: `Form`
- related tokens: `form`, field, helper text, group spacing, focus

## Intent

Provide a semantic structure for grouped fields, helper text, and actions.

## Problem

Complex input workflows need consistent grouping, labeling, and validation communication.

## Use When

- Use to collect multi-field user input.
- Use field groups for related sections and shared context.

## Do Not Use When

- Do not use as a generic layout wrapper when no form semantics are needed.

## Standard Basis

Native form, field grouping, and label association semantics are the baseline.

## Anatomy

- Form container
- Field groups
- Field rows
- Helper/error text
- Action region

## Structure Contract

| Item | Classification | Contract |
|---|---|---|
| Form container | Required | Semantic form root for field submission context. |
| Field labeling | Required | Every control must have programmatic labeling. |
| Group semantics | Optional | Related fields grouped with shared heading/legend semantics. |
| Error/helper text | Optional | Programmatically associated with relevant controls. |

## Implementation Naming Contract

### CSS Class Contract

- Public form classes use the `uif-` prefix.

### Token Contract

- Public form tokens use `--uif-form-*`.

### Data Attribute Contract

Data attributes may mirror layout variants and invalid state metadata.

### Native / ARIA Precedence

- Use native form and field semantics first.
- Use ARIA relationships for helper/error linking when needed.

### Agent Freedom Boundary

- Labeling, grouping, and error association semantics are not agent freedom.

## Required Semantics

- Inputs are labeled.
- Related groups have shared context labels.
- Validation messaging is associated with controls.

## Behaviour

- Form fields follow logical reading order.
- Actions are grouped and discoverable.
- Invalid fields communicate issue and remediation guidance.

## Keyboard Interaction

- Native field traversal with `Tab` / `Shift+Tab`.
- Native submit behavior as configured by composing context.

## Accessibility Rules

- Preserve label-control relationships.
- Preserve group semantics for related controls.
- Ensure error relationships are programmatically exposed.

## Token Requirements

- Container surface and spacing
- Field and group spacing
- Helper/error text styling
- Focus and invalid indicators

## Token Slot Matrix

| Part | Property | State / Variant | Required semantic token slot | Notes |
|---|---|---|---|---|
| Form container | Surface / border | Default / borderless | Form container slots | Must adapt by context. |
| Field helper text | Typography / color | Default / invalid | Form helper/error slots | Ensure readability. |
| Group spacing | Gap / padding | Density variants | Form group spacing slots | Preserve hierarchy. |

## States

- Default
- Invalid field present
- Borderless variant

## State Semantics

| State | Required semantics | User interaction | Notes |
|---|---|---|---|
| Default | Structured field grouping | Native form interaction | Required. |
| Invalid | Validation issue present | User can correct input | Optional by context. |
| Borderless | Embedded visual container mode | Same semantics as default | Optional variant. |

## Variants

- Default container
- Borderless
- Label positioning variants

## Responsive / Density Behaviour

Form layout adapts from stacked to wider arrangements while preserving readable labels and helper content.

## Component Dependencies

- `Form`
- `Input`, `Select`, `Checkbox`, `Radio`, `Switch`, `TextArea`
- `Button` for actions

## Minimum Component API

| API | Classification | Default | Contract |
|---|---|---|---|
| `borderless` | Optional | `false` | Embedded visual variant. |
| `labelPosition` | Optional | `top` | Field label layout preference. |
| `invalid` | Optional | `false` | Field invalid state communication. |
| `actionsAlign` | Optional | `end` | Action alignment behavior. |

## Agent Freedom

| Decision Area | Freedom Level | Allowed Choices | Requires Human Review |
|---|---|---|---|
| Form semantics | none | Preserve form and label semantics. | Yes, for non-semantic layout-only forms. |
| Layout variants | guided | Token-driven spacing and label positions. | No. |
| Validation ownership | limited | Link messages; do not invent hidden validation behavior. | Yes, for cross-field validation patterns. |

## Implementation Contract

- Preserve form and grouping semantics.
- Preserve label and validation relationships.
- Preserve predictable field/action flow.

## Test Requirements

- Verify label associations.
- Verify group semantics where used.
- Verify helper/error linkage and invalid signaling.

## Negative Test Requirements

- Field without programmatic label fails.
- Error text not linked to field fails.

## Documentation Requirements

Human-facing docs explain grouping, labeling, validation, and action arrangement boundaries.

## Anti-Patterns

- Using form containers for non-form content.
- Relying on placeholder text as labels.

## Agent Output

Agents can derive form review criteria and accessibility checks from this pattern.

Review this pattern against `patterns/checklists/pattern-spec-review-checklist.md` before deriving implementation output.

## Open Questions

- Open question: Should cross-field validation ownership be documented in base form or composition patterns?

