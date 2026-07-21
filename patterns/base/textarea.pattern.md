---
id: pattern.base.textarea
title: Textarea Pattern
type: pattern
status: draft
owners:
  - ui-foundations
created: 2026-07-21
updated: 2026-07-21
authority: derived
summary: Agent-readable base pattern contract for textarea controls.
related:
  derived_from:
    - /Users/Thomas.Bielich@tui.com/GitHub/uif/ui-foundations-runtime/site/patterns/textarea.md
  references:
    - specification.pattern.schema
---

# Textarea Pattern

## Metadata

- id: `pattern.base.textarea`
- type: base
- status: draft
- source: `/Users/Thomas.Bielich@tui.com/GitHub/uif/ui-foundations-runtime/site/patterns/textarea.md`
- related standards: Native textarea semantics and labeling requirements
- related components: `TextArea`
- related tokens: `textarea`, border, placeholder, focus, spacing

## Intent

Provide multi-line text entry for longer-form user input.

## Problem

Interfaces need text input beyond single-line constraints while preserving native editing and accessibility semantics.

## Use When

- Use for comments, notes, and freeform long text.

## Do Not Use When

- Do not use for short structured input better served by single-line input.

## Standard Basis

Native `<textarea>` behavior is the baseline for multiline editing semantics.

## Anatomy

- Textarea field container
- Editable text region
- Optional placeholder hint

## Structure Contract

| Item | Classification | Contract |
|---|---|---|
| Native textarea | Required | Preserve multiline native editing behavior. |
| Label association | Required | Programmatic label required. |
| Disabled/read-only | Optional | Native availability/editability controls. |

## Implementation Naming Contract

### CSS Class Contract

- Public textarea classes use the `uif-` prefix.

### Token Contract

- Public textarea tokens use `--uif-textarea-*`.

### Data Attribute Contract

Data attributes may mirror state metadata only.

### Native / ARIA Precedence

- Use native textarea semantics and attributes.

### Agent Freedom Boundary

- Native editing semantics and label requirements are not agent freedom.

## Required Semantics

- Programmatic label association.
- Placeholder is hint only, not label.

## Behaviour

- Supports multiline editing and line breaks.
- Can allow vertical resize where intended.
- Disabled/read-only alter interaction behavior.

## Keyboard Interaction

- `Tab`: focus traversal.
- `Enter`: inserts new line.
- Native editing shortcuts are preserved.

## Accessibility Rules

- Use native textarea semantics.
- Ensure visible focus and sufficient contrast.
- Associate helper/error text where provided.

## Token Requirements

- Container border/background
- Text and placeholder color
- Focus and invalid states
- Spacing and radius

## Token Slot Matrix

| Part | Property | State / Variant | Required semantic token slot | Notes |
|---|---|---|---|---|
| Textarea container | Border/background | Default / hover / focus / disabled | Textarea container slots | Must preserve contrast. |
| Text content | Text/placeholder color | Default / disabled | Textarea text slots | Placeholder remains hint-only. |
| Textarea container | Focus indicator | Focus-visible | Textarea focus slot | Required keyboard cue. |

## States

- Default
- Hover
- Focus
- Disabled
- Read-only

## State Semantics

| State | Required semantics | User interaction | Notes |
|---|---|---|---|
| Default | Editable multiline input | Full editing | Required. |
| Focus | Focus indicator visible | Active editing | Required. |
| Disabled | Non-interactive | No editing/focus | Optional by context. |
| Read-only | Value readable but not editable | Focusable where native behavior allows | Optional. |

## Variants

- Default
- Disabled
- Read-only

## Responsive / Density Behaviour

Textarea scales width with container and preserves readable editing area at each density.

## Component Dependencies

- `TextArea`
- Label/form-field composition

## Minimum Component API

| API | Classification | Default | Contract |
|---|---|---|---|
| `value` | Optional | None | Controlled value. |
| `placeholder` | Optional | None | Hint text only. |
| `rows` | Optional | Component default | Initial visible row count. |
| `disabled` | Optional | `false` | Native disabled behavior. |
| `readonly` | Optional | `false` | Native read-only behavior. |

## Agent Freedom

| Decision Area | Freedom Level | Allowed Choices | Requires Human Review |
|---|---|---|---|
| Native semantics | none | Preserve textarea editing behavior. | Yes, for non-native replacements. |
| Resize behavior | limited | Controlled vertical resize policy. | No. |
| Visual expression | guided | Tokenized state styling. | No. |

## Implementation Contract

- Preserve multiline editing semantics.
- Preserve label and focus accessibility.
- Preserve disabled/read-only distinction.

## Test Requirements

- Verify multiline editing and keyboard behavior.
- Verify label association and placeholder guidance.
- Verify disabled/read-only behavior.

## Negative Test Requirements

- Placeholder-only labeling fails.
- Read-only treated as disabled fails.

## Documentation Requirements

Human-facing docs explain multiline use, labeling, and editing state differences.

## Anti-Patterns

- Textarea for short, structured one-line input.
- Removing native resize/focus affordances without replacement.

## Agent Output

Agents can derive form-control review checks and accessibility criteria from this pattern.

Review this pattern against `patterns/checklists/pattern-spec-review-checklist.md` before deriving implementation output.

## Open Questions

- Open question: Should autoresize behavior be standardized as base textarea guidance?

