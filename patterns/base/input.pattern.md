---
id: pattern.base.input
title: Input Pattern
type: pattern
status: draft
owners:
  - ui-foundations
created: 2026-07-08
updated: 2026-07-21
authority: derived
summary: Agent-readable base pattern contract for single-line inputs.
related:
  derived_from:
    - /Users/Thomas.Bielich@tui.com/GitHub/uif/ui-foundations-runtime/docs/patterns/input.md
    - /Users/Thomas.Bielich@tui.com/GitHub/uif/ui-foundations-runtime/site/patterns/input.md
  references:
    - specification.pattern.schema
---

# Input Pattern

## Metadata

- id: `pattern.base.input`
- type: base
- status: draft
- source: `/Users/Thomas.Bielich@tui.com/GitHub/uif/ui-foundations-runtime/docs/patterns/input.md`; supporting canonical page `/Users/Thomas.Bielich@tui.com/GitHub/uif/ui-foundations-runtime/site/patterns/input.md`
- related standards: Native HTML `input`; WCAG labels, focus appearance, error identification, text contrast, non-text contrast, and use of color requirements
- related components: `Input`, form field
- related tokens: `input`, focus, validation, spacing, color, border, radius

## Intent

Provide a native single-line input control that users can label, focus, edit, validate, and understand across supported input variants.

## Problem

Forms need single-line entry controls that preserve native behavior, programmatic labels, validation semantics, and accessible error relationships while allowing UI Foundations theming.

## Principle

All supported input types inherit the same base interaction contract.

Differences between input types are constrained to value semantics, native validation behavior, native formatting expectations, and input-keyboard affordances.

Accessibility, focus behavior, state handling, labeling, helper-text relationships, and error relationships remain shared responsibilities across input types.

## Use When

- Use for freeform text and structured single-line text entry.
- Use a more specific native `type` when it matches the expected data, such as `email`, `password`, `number`, `tel`, `url`, `search`, `date`, or `time`.
- Use placeholder text only as a short format hint.

## Do Not Use When

- Do not use placeholder text as the only label.
- Do not use `type="text"` when a more specific native input type supports the data.
- Do not use this base pattern for multiline entry; use a textarea pattern when needed.

## Explicitly Out of Scope

- Date Picker composition
- Time Picker composition
- Calendar interaction surfaces outside native input behavior
- Popover or dialog container behavior
- Rich text editing
- Combobox behavior
- Select behavior

## Standard Basis

Native HTML `input` behavior is the base. Required: labels use `<label>`, `aria-label`, or `aria-labelledby`. Required: error state uses `aria-invalid` and associated error text with `aria-describedby` when visible error text exists.

## Anatomy

- Container: field area with border, background, padding, and focus styling.
- Input primitive: native single-line entry element with value or placeholder.
- Label: visible label or programmatic label.
- Optional trailing control: clear, increment/decrement, visibility toggle, or date picker affordance based on type.
- Optional helper or error text.

## Structure Contract

| Item | Classification | Contract |
|---|---|---|
| Native element | Required | Use native `<input>` for supported single-line text-like types. |
| Supported types | Required | `text`, `email`, `password`, `number`, `tel`, `url`, `search`, `date`, and `time` are supported input types. |
| Label relationship | Required | Use `<label for>`, `aria-label`, or `aria-labelledby`; placeholder-only labels are forbidden. |
| Description relationship | Optional | Link helper text with `aria-describedby` through `descriptionId`. |
| Error relationship | Required when visible error exists | Link visible error text with `aria-describedby` or `aria-errormessage` through `errorId`; use `aria-invalid="true"`. |
| Prefix / suffix / adornment | Optional | Decorative adornments are not part of the accessible name unless explicitly referenced. |
| Trailing controls | Conditional | Controls that perform actions use button semantics and accessible names. |
| DOM order | Required | Label precedes or programmatically names the input; helper/error text follows the input in reading order when rendered. |
| Forbidden structures | Required | Do not replace native input editing behavior with generic elements. |

## Implementation Naming Contract

### CSS Class Contract

- The public input component class must use the `uif-` prefix.
- Variants use chained classes.
- Authored states use `is-*` chained classes only when the state is not better represented by native attributes or pseudo-classes.
- Native states use pseudo-classes where possible.
- Do not use BEM modifier syntax, BEM element syntax, or unscoped public component classes.

### Token Contract

- Input token slots use `--uif-input-*` or a more specific approved `--uif-[component]-*` scope.
- Experimental unresolved input tokens use `--uif-proof-*` or `--uif-assumption-*`.
- Do not use unscoped public tokens such as `--input-*`.

### Data Attribute Contract

| Attribute | Classification | Contract |
|---|---|---|
| `data-uif-component="input"` | Optional | May identify the component for metadata, testing, or agent-readable inspection; it must not replace the public `.uif-*` input class. |
| `data-invalid="true"` | Optional mirror | May mirror visual or component invalid state, but it must not replace `aria-invalid="true"` when invalid state is exposed. |

Data attributes are secondary metadata or state hooks. They must not replace public classes, tokens, labels, descriptions, visible error text, `aria-describedby`, or `aria-errormessage` relationships.

### Native / ARIA Precedence

- Use native `disabled`, `required`, `readonly`, `type`, and `name` where applicable.
- Use `aria-invalid="true"` when invalid state is exposed.
- Use `aria-describedby` or `aria-errormessage` for visible helper or error relationships.
- Data attributes may mirror invalid state but must not be the only semantic source.

### Agent Freedom Boundary

- CSS naming, token scoping, native input semantics, and accessibility semantics are not agent freedom.
- New input class names, token names, or data attributes must be marked as proposed or recorded in `Open Questions`.

## Required Semantics

- Use a native `<input>` element for single-line text entry.
- Provide a programmatic label for every input.
- Associate helper and error text with `aria-describedby` when present.
- Use `aria-invalid="true"` when the value is invalid.
- Use native `disabled` for disabled fields.
- Keep placeholder text separate from the accessible label.

## Validation Ownership

The base input exposes validation state and accessibility relationships. Rendering validation messages belongs to a form-field or validation composition pattern unless a component spec explicitly assigns message rendering to the input.

| Concern | Owner | Notes |
|---|---|---|
| Native constraint validation | Browser / native input | Required attributes such as `required`, `type`, and pattern-like constraints participate in native validation when used. |
| `invalid` visual state | Input component API | Maps to `aria-invalid="true"` and invalid token slots. |
| Visible error message rendering | Form-field or validation composition | Input links to the message through `errorId`; it does not own message content by default. |
| Helper/description text rendering | Form-field or validation composition | Input links through `descriptionId`. |
| Required state | Input component API plus form-field documentation | Must be programmatically or textually understandable. |
| Disabled state | Native input | Uses native `disabled`. |
| Read-only state | Native input | Uses native `readonly`; not equivalent to disabled. |

## Behaviour

- Inputs expand to fill the available inline size of their container.
- Input types support native typing and single-line editing semantics, with type-specific native differences where applicable.
- Disabled inputs cannot be edited and are removed from the tab order by native behavior.
- Focus changes border color and adds a focus ring.
- Clear, number stepper, password visibility, and date picker controls are optional type-specific trailing controls.
- Error messages must identify the field, the problem, and the fix.

## Keyboard Interaction

- `Tab`: moves focus into or out of the input.
- Character keys: enter text at the cursor position.
- `Backspace`: deletes the character before the cursor.
- `Ctrl + A`: selects all text in the input.
- Native platform editing shortcuts remain available.

## Accessibility Rules

- Every input must have a programmatic label.
- Placeholder text is not an accessible label.
- Disabled inputs use native `disabled`.
- Error states must use `aria-invalid` and associated error text via `aria-describedby` when visible error text exists.
- Focus indicators meet at least 3:1 contrast.
- Color must not be the only way to communicate invalid or disabled states.

## Token Requirements

- Container background by state.
- Text color by state.
- Placeholder color.
- Border color and size by state.
- Focus ring or focus border slot.
- Invalid border and focus slots.
- Disabled container, border, and text slots.
- Padding, radius, height, gap, and trailing-control slots.
- Label, helper, and error text slots when those parts are present through a field composition.
- Read-only slots where visually distinct from default.

## Token Slot Matrix

| Part | Property | State / Variant | Required semantic token slot | Notes |
|---|---|---|---|---|
| Input container | Background | Default / hover / focus / disabled / read-only | Input container background slot by state | Exact token name must use the `--uif-input-*` scope when public. |
| Input container | Border color | Default / hover / active / focus / invalid / disabled | Input border color slot by state | Invalid must not rely on color alone. |
| Input container | Border width | Default / active | Input border size slot | Required for active recipe. |
| Input primitive | Text color | Default / hover / active / disabled | Input text color slot by state | Must preserve contrast. |
| Input primitive | Placeholder color | Default | Input placeholder text slot | Placeholder is hint only. |
| Input container | Focus indicator | Focus-visible | Input focus ring slot | Must meet non-text contrast. |
| Input container | Padding / height / radius / gap | All states | Input size and shape slots | Includes room for trailing controls. |
| Trailing control | Size / color / spacing | By control type | Input control slot | Control semantics come from button pattern when focusable. |
| Error text | Text color / spacing | Invalid | Field error text slot | Owned by field composition unless component spec says otherwise. |
| Helper text | Text color / spacing | Default | Field helper text slot | Owned by field composition unless component spec says otherwise. |

## States

- Default
- Hover
- Active
- Focus
- Disabled
- Read-only
- Invalid

## State Semantics

| State | Required semantics | User interaction | Notes |
|---|---|---|---|
| Default | Native input semantics | Typing and native editing available | Required. |
| Hover | No ARIA state | Pointer feedback only | Required visual state when pointer hover is available. |
| Active | Native active interaction | Pointer or keyboard interaction feedback | Required visual state. |
| Focus | Native focus plus visible indicator | Keyboard, pointer, or programmatic focus | Required. |
| Disabled | Native `disabled` | Not focusable or editable | Required when disabled. |
| Read-only | Native `readonly` | Focusable where native behavior allows; value not editable | Required when read-only. |
| Invalid | `aria-invalid="true"`; visible error linked when present | User can edit unless also disabled/read-only | Required when invalid. |

## Supported Input Types

| Variant | Difference from common model |
|---|---|
| `text` | Baseline freeform single-line entry. |
| `email` | Uses native email-oriented validation and virtual keyboard hints where supported. |
| `password` | Conceals entered characters; may compose with reveal control. |
| `number` | Uses native numeric entry semantics and platform-specific stepping affordances where available. |
| `tel` | Optimizes for telephone entry semantics and keyboard hints. |
| `url` | Uses URL-oriented validation and keyboard hints where supported. |
| `search` | Uses search-oriented semantics and may compose with clear/submit affordances. |
| `date` | Uses native date-entry semantics only; custom date-picker behavior is composition scope. |
| `time` | Uses native time-entry semantics only; custom time-picker behavior is composition scope. |

All input types preserve labeling, focus, validation, required/optional handling, disabled/read-only distinctions, and error relationships.

## Responsive / Density Behaviour

Inputs fill the available inline size. Placeholder and value text must remain readable in narrow containers. Trailing controls must not obscure typed value or focus indication.

## Component Dependencies

- `Input`
- Form field or label pattern
- Button pattern for trailing controls

## Related Patterns

- [Label Pattern](./label.pattern.md)
- [Form Pattern](./form.pattern.md)
- [Checkbox Pattern](./checkbox.pattern.md)
- [Radio Pattern](./radio.pattern.md)
- [Select Pattern](./select.pattern.md)
- [Calendar Pattern](./calendar.pattern.md)
- [Tooltip Pattern](./tooltip.pattern.md)

## Minimum Component API

| API | Classification | Default | Contract |
|---|---|---|---|
| `type` | Required | `text` | Supports the common input types defined in this pattern. |
| `name` | Optional | None | Passed to native input. |
| `value` | Optional controlled | None | Controlled value when provided. |
| `defaultValue` | Optional uncontrolled | None | Initial value for uncontrolled usage. |
| `placeholder` | Optional | None | Hint only; never the sole label. |
| `disabled` | Required | `false` | Maps to native `disabled`. |
| `readOnly` | Required | `false` | Maps to native `readonly`. |
| `required` | Required | `false` | Maps to native `required`; indication must be understandable. |
| `invalid` | Required | `false` | Maps to invalid state and `aria-invalid`. |
| `descriptionId` | Optional | None | Links helper text. |
| `errorId` | Required when visible error exists | None | Links visible error text. |
| `autocomplete` | Optional | None | Passed to native input when relevant. |
| `inputmode` | Optional | Native default | Passed to native input when relevant. |
| `onInput` | Optional event | None | Fires on native input. |
| `onChange` | Optional event | None | Fires on value change according to implementation framework conventions. |
| `onBlur` | Optional event | None | Fires on native blur. |

## Trailing Control Classification

| Control | Classification | Contract |
|---|---|---|
| Clear button | Supported in base input | Uses button semantics; accessible name required; clearing does not move focus unless a component spec defines otherwise. |
| Password reveal | Supported in base input for `password` | Uses button semantics; stateful accessible name required. |
| Search submit | Composition dependency | Belongs to search field or form composition. |
| Calendar trigger | Composition dependency | Belongs to date picker composition. |
| Validation icon | Optional decorative/status affordance | Must not be the only error communication. |
| Unit suffix | Optional adornment | Decorative unless referenced by label or description. |

## Agent Freedom

| Decision Area | Freedom Level | Allowed Choices | Requires Human Review |
|---|---|---|---|
| Native input semantics | none | Use native `<input>` and preserve native editing behavior. | Yes, for any non-input editable control. |
| Label relationship | none | Use `<label for>`, `aria-label`, or `aria-labelledby`; placeholder-only label is forbidden. | Yes, for any exception. |
| Message rendering ownership | limited | Link to external helper/error messages by default; render messages only if a component spec assigns ownership. | Yes, if input owns message rendering. |
| Validation state exposure | limited | Expose `invalid`, `required`, `disabled`, `readOnly`, `descriptionId`, and `errorId` relationships. | Yes, for alternate validation ownership. |
| Trailing controls | limited | Clear and password reveal are supported; search submit and calendar trigger are composition dependencies; validation icon and unit suffix follow declared rules. | Yes, for new controls. |
| API naming by framework | guided | Framework-specific event and prop names are allowed when they preserve the minimum API meaning. | No, unless semantics change. |
| Visual implementation | guided | Any structure using semantic input/field token slots and preserving focus, label, and message relationships. | No, unless token slots are missing. |
| Date/time variant boundary | open | Agents can preserve current documented variants but must not implement complex date picking from this base spec. | Yes, to change date/time ownership. |

## Implementation Contract

- Preserve the native input element and native editing behavior.
- Require a programmatic label.
- Use the most specific native input type available.
- Associate helper and error text programmatically.
- Preserve native disabled behavior.
- Use semantic input tokens for visual states.
- Keep trailing controls keyboard and screen-reader accessible when focusable.
- Expose validation state and relationships; do not own message rendering by default.
- Required indication must be programmatically or textually understandable.
- Clearing input must not unexpectedly move focus unless a component spec defines that behavior.
- Password reveal, when supported, must have a stateful accessible name.

## Test Requirements

- Verify native input element and expected `type`.
- Verify accessible name exists and does not rely only on placeholder text.
- Verify native keyboard editing behavior remains intact.
- Verify `disabled`, `read-only`, and `aria-invalid` behavior.
- Verify `aria-describedby` links helper and error text.
- Verify focus indicator and contrast requirements.
- Verify token use for states and no hardcoded state colors.
- Verify required state is understandable programmatically or textually.
- Verify clear control keeps focus behavior predictable.
- Verify password reveal accessible name changes or otherwise communicates state when supported.

## Negative Test Requirements

- Placeholder-only label fails.
- Invalid input without linked error text fails when visible error exists.
- Disabled input that remains focusable or editable outside native behavior fails.
- Read-only and disabled treated as identical fails.
- Trailing control without accessible name fails.
- Visible validation icon as the only error communication fails.

## Documentation Requirements

Human-facing docs must explain input types, labels, placeholder guidance, states, validation, keyboard interaction, accessibility, theming, and examples without copying this contract verbatim.

## Anti-Patterns

- Placeholder-only labels.
- Generic `type="text"` for known email, phone, URL, number, date, or time data.
- Unassociated error text.
- Removing native focus or editing behavior.
- Clear or visibility controls without accessible names.
- Hardcoded invalid or focus colors outside semantic tokens.

## Agent Output

Agents can derive component acceptance criteria, form review checks, validation test plans, token audits, and documentation deltas from this pattern. Agents must not add runtime implementation code to this vault.

Review this pattern against `patterns/checklists/pattern-spec-review-checklist.md` before deriving implementation output.

## Open Questions

- Resolved: Clear button and password reveal are supported in the base input; search submit and calendar trigger are composition dependencies.
- Resolved: Base input exposes invalid state and relationships; message rendering belongs to a form-field or validation composition unless a component spec says otherwise.
- Should search input have a separate base or composition pattern?
- Open question: Determine whether date and time remain input variants, or complex date picking always uses a composition pattern.
