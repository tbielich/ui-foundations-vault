---
id: pattern.composition.date-picker
title: Date Picker Pattern
type: pattern
status: draft
owners:
  - ui-foundations
created: 2026-07-08
updated: 2026-07-09
authority: derived
summary: Agent-readable composition pattern contract for date pickers.
related:
  derived_from:
    - /Users/Thomas.Bielich@tui.com/GitHub/ui-foundations/docs/patterns/input.md
    - /Users/Thomas.Bielich@tui.com/GitHub/ui-foundations/site/components/date-picker.md
    - /Users/Thomas.Bielich@tui.com/GitHub/ui-foundations/site/patterns/calendar.md
  references:
    - specification.pattern.schema
    - pattern.base.input-text
    - pattern.base.button
---

# Date Picker Pattern

## Metadata

- id: `pattern.composition.date-picker`
- type: composition
- status: draft
- source: `/Users/Thomas.Bielich@tui.com/GitHub/ui-foundations/docs/patterns/input.md`; supporting pages `/Users/Thomas.Bielich@tui.com/GitHub/ui-foundations/site/components/date-picker.md` and `/Users/Thomas.Bielich@tui.com/GitHub/ui-foundations/site/patterns/calendar.md`
- related standards: Native HTML input and button; WAI-ARIA grid pattern where a custom calendar grid is used; WCAG labels, keyboard access, focus order, focus appearance, error identification, and contrast requirements
- related components: `Date Picker`, `Input`, `Calendar`, `Button`
- related tokens: `input`, `calendar`, `button`, focus, validation, surface, spacing

## Intent

Provide a composed date-entry and date-selection control that supports typed entry, visual calendar selection, keyboard operation, validation, and accessible state communication.

## Problem

Date entry often needs both precise typed input and visual calendar selection. A custom picker must coordinate input segments, trigger behavior, popup state, calendar grid focus, date selection, and validation without breaking base input or button contracts.

## Use When

- Use when a date field needs both typed entry and calendar selection.
- Use when single-date or range selection requires a consistent UI Foundations experience across brands and modes.
- Use when the native date input is insufficient for documented needs such as consistent styling, large day targets, custom range states, or cross-browser behavior.

## Do Not Use When

- Do not use when a simple native `input type="date"` satisfies the user need and platform consistency is acceptable.
- Do not use for arbitrary text or non-date values.
- Do not use when date constraints, format, or validation behavior are undefined.

## Standard Basis

The input segments inherit native text input behavior. The trigger inherits native button behavior. A custom calendar day grid uses `role="grid"` with roving tabindex and full-date accessible names. WCAG requires keyboard access, visible focus, perceivable error state, and sufficient contrast.

## Anatomy

- Form field with visible label.
- Grouped date input surface.
- Date segments for day, month, and year.
- Separators between segments.
- Calendar trigger button with calendar icon.
- Calendar popup or inline calendar.
- Calendar header with previous/next actions and month/year controls.
- Weekday row.
- Day cells with selectable, selected, today, disabled, outside-month, and range states.
- Optional helper or error text.

## Ownership Contract

| Concern | Owner | Notes |
|---|---|---|
| Text field value | Date Picker component | Synchronizes typed segments and selected calendar date. |
| Date parsing | Open question | Locale and format rules are not yet canonical. Agents must not invent parsing rules. |
| Date formatting | Open question | Locale and display format are not yet canonical. Agents must not invent formatting rules. |
| Popup open state | Date Picker component | Controlled by `open` when provided; otherwise owned internally through `defaultOpen`. |
| Focus management | Date Picker component | Owns focus transfer on open, close, selection, and Escape. |
| Calendar grid keyboard behaviour | Calendar dependency | Date Picker depends on Calendar grid contract; full Calendar pattern is not yet in this vault. |
| Date constraints | Product or consuming component until specified | `min`, `max`, and `disabledDates` are API inputs; business rules remain external. |
| Validation state | Date Picker API plus form-field composition | Exposes `invalid`, `descriptionId`, and `errorId`; message rendering is external unless component spec says otherwise. |
| Range selection | Out of scope | Range mode must not be implemented from this spec until a range model is defined. |

## Structure Contract

| Item | Classification | Contract |
|---|---|---|
| Label | Required | Visible label names the grouped date field. |
| Input or segmented date field | Required | Uses native input semantics for editable date parts or a native date input when chosen by component spec. |
| Trigger button | Required for popup variant | Native button with accessible name, `aria-expanded`, and `aria-controls`; `aria-haspopup` value is an open question. |
| Popup / dialog / popover container | Open question | Popup strategy is unresolved: dialog, popover, and inline calendar are valid candidates; agents must not choose without a component decision. |
| Inline calendar | Optional | Allowed only when the component spec selects inline rendering; still depends on Calendar semantics. |
| Calendar grid dependency | Required for custom calendar | Calendar owns grid structure, roving tabindex, day-cell semantics, and month navigation behavior. |
| Month navigation controls | Required for custom calendar | Native buttons or controls with accessible names. |
| Helper / error text | Optional; required relationship when visible error exists | Linked through `descriptionId` and `errorId`. |
| Range affordances | Out of scope | Do not derive range start, middle, end, preview, or clearing behavior until range model is defined. |
| Focus entry point | Required | Trigger activation or `Alt + Arrow Down` opens the calendar and moves focus according to component decision. |
| Focus return point | Required | Closing the popup returns focus to the trigger or invoking segment unless a component spec defines another return point. |
| Value ownership boundary | Required | Date Picker emits normalized value through API; product code owns business interpretation. |

## Implementation Naming Contract

### CSS Class Contract

- The public date picker component class must use the `uif-` prefix.
- Variants use chained classes.
- Authored states use `is-*` chained classes only when the state is not better represented by native attributes, ARIA, or pseudo-classes.
- Native states use pseudo-classes where possible.
- Do not use BEM modifier syntax, BEM element syntax, or unscoped public component classes.

### Token Contract

- Date picker token slots use `--uif-date-picker-*` or inherited dependent scopes such as `--uif-input-*`, `--uif-button-*`, and `--uif-calendar-*`.
- Experimental unresolved date picker tokens use `--uif-proof-*` or `--uif-assumption-*`.
- Do not use unscoped public tokens such as `--date-picker-*`, `--input-*`, or `--button-*`.

### Data Attribute Contract

| Attribute | Classification | Contract |
|---|---|---|
| `data-uif-component="date-picker"` | Optional | May identify the composed pattern for metadata, testing, or agent-readable inspection; it must not replace the public `.uif-*` date picker class. |
| `data-open="true"` | Optional mirror | May mirror popup state; `aria-expanded` remains required on the trigger when expansion is exposed. |
| `data-orientation="horizontal|vertical"` | Conditional | Use only if orientation affects layout or interaction. |

Data attributes are secondary metadata or state hooks. They must not replace public classes, tokens, focus management, popup semantics, calendar accessibility, trigger relationships, labels, invalid-state semantics, or dependent base-pattern contracts.

### Native / ARIA Precedence

- Use native input and button semantics from dependent base patterns.
- Use `aria-expanded` on the trigger when expansion is exposed.
- Use `aria-controls` when the trigger controls a popup element.
- Data attributes may mirror open or orientation state but must not be the only semantic source.

### Agent Freedom Boundary

- CSS naming, token scoping, native semantics, focus semantics, and accessibility semantics are not agent freedom.
- New date picker class names, token names, or data attributes must be marked as proposed or recorded in `Open Questions`.

## Required Semantics

- Associate the visible label with the date field and grouped input.
- Each segment must have a programmatic name such as day, month, and year.
- The calendar trigger must be a native button with `aria-expanded` and `aria-controls`.
- The calendar grid must expose grid semantics when custom day-grid keyboard navigation is used.
- Each day cell must expose a full-date accessible name.
- Disabled dates must be programmatically disabled or otherwise not selectable.
- Error text must be associated with the field when invalid.

## Behaviour

- Typing in segments updates the date value.
- Auto-advance after completing day or month segments: Optional; define in component spec before implementation.
- Separator handling for `/` or `.`: Optional; define in component spec before implementation.
- Backspace on an empty segment moving focus to the previous segment: Optional; define in component spec before implementation.
- The trigger opens or closes the calendar.
- Selecting a day fills the input value and closes the calendar for single-date selection.
- `Escape` closes the calendar without selecting.
- Outside click or focus movement dismissal: Optional for popup implementations; define in component spec.
- Focus transfer to calendar on trigger activation: Required for popup calendar unless component spec keeps focus in the field and documents the reason.
- Focus return on close: Required.
- Month change announcement: Required for custom calendar; exact live-region strategy belongs to Calendar dependency.
- Unavailable date semantics: Required; unavailable dates cannot be selected and must be programmatically indicated by the Calendar dependency.
- Invalid, out-of-range, incomplete, and disabled states must be communicated visually and programmatically.

## Keyboard Interaction

- Input segments inherit text-input editing behavior.
- `Tab`: moves through segments and then to the calendar trigger.
- `Alt + Arrow Down`: Optional; opens the calendar and moves focus to the grid when the component spec supports this shortcut.
- Calendar `ArrowLeft` / `ArrowRight`: moves focus one day backward or forward.
- Calendar `ArrowUp` / `ArrowDown`: moves focus one week backward or forward.
- Calendar `Home` / `End`: moves focus to the first or last day in the current week.
- Calendar `PageUp` / `PageDown`: moves focus to the previous or next month.
- Calendar `Enter` / `Space`: selects the focused date.
- `Escape`: closes the calendar without selecting.

## Accessibility Rules

- The composed field must be operable without a mouse.
- Focus movement between input, trigger, and calendar must be deterministic.
- The trigger must expose expanded/collapsed state.
- Day cells need full-date accessible names.
- Roving tabindex must keep one active day focus target in the calendar grid.
- Minimum day cell touch target must be 44 by 44 pixels when using the custom calendar.
- Error and constraint messages must be associated with the grouped field.
- Contrast must be validated for all calendar and input states across modes.

## Token Requirements

- Input container, text, border, focus, invalid, disabled, padding, and control slots.
- Button trigger and icon slots inherited from the input control/button pattern.
- Calendar container padding, border, radius, background, and gap slots.
- Calendar header and weekday typography/spacing slots.
- Calendar cell size, radius, text, background, hover, active, disabled, today, range, and focus slots.
- Popup surface, border, radius, shadow/elevation, spacing, and layering slots.
- Range preview slots are out of scope until range behavior is defined.

## Token Slot Matrix

| Part | Property | State / Variant | Required semantic token slot | Notes |
|---|---|---|---|---|
| Field container | Background / border / padding / radius | Default / focus / invalid / disabled | Date picker field slots inherited from input | Exact names can map to input slots. |
| Segment input | Text / placeholder / caret | Default / disabled / invalid | Date segment text and placeholder slots | Use input slots unless component spec defines segment-specific slots. |
| Trigger button | Size / icon color / focus | Default / hover / focus / disabled | Date picker trigger slots inherited from button/input control | Trigger uses native button semantics. |
| Popup surface | Background / border / radius / shadow / spacing | Open | Date picker popup surface slots | Exact token names unresolved. |
| Calendar grid | Gap / typography / surface | Default | Calendar grid slots | Owned by Calendar dependency. |
| Calendar cell | Size / radius / text / background | Default / hover / focus / selected / unavailable | Calendar cell slots by state | Minimum target remains required. |
| Selected date | Text / background / border | Selected | Calendar selected date slots | Owned by Calendar dependency. |
| Current date | Border / text emphasis | Today | Calendar current date slots | Owned by Calendar dependency. |
| Unavailable date | Text / background / cursor | Disabled / unavailable | Calendar unavailable date slots | Must not rely on color alone. |
| Focus ring | Outline / shadow / offset | Field, trigger, cell | Date picker focus slots inherited from dependencies | Must meet contrast. |
| Range preview | Background / border | Range preview | Out of scope | Do not generate until range model is defined. |

## States

- Closed
- Open
- Date selected
- Today
- Outside month
- Invalid
- Disabled
- Range start / middle / end: out of scope until range model is defined

## State Semantics

| State | Required semantics | User interaction | Notes |
|---|---|---|---|
| Closed | Trigger exposes collapsed state for popup variant | Field and trigger remain reachable | Required. |
| Open | Trigger exposes expanded state and controls calendar container | Calendar can be navigated or dismissed | Required for popup variant. Popup role is open question. |
| Date selected | Selected day is programmatically indicated by Calendar dependency; field value synchronized | Selecting a day updates value | Required for single-date mode. |
| Today | Current date is indicated without implying selection | Calendar navigation can move through today | Required when today is shown. |
| Outside month | Programmatic and visual distinction when shown | Selection allowed only if Calendar dependency permits | Optional display state. |
| Invalid | `aria-invalid="true"`; visible error linked when present | User can edit unless disabled/read-only | Required when invalid. |
| Disabled | Field and trigger disabled according to native semantics | Cannot open or edit | Required when disabled. |
| Range states | None in this spec | No range interaction derived | Out of scope. |

## Variants

- Single date
- Date range: out of scope until a range selection model is defined
- Container
- No container
- Native date input affordance where supported

Variants must preserve labeling, trigger state, focus behavior, calendar semantics, and validation relationships.

## Responsive / Density Behaviour

The input fills available inline space. Calendar day cells must keep usable target size. Open question: popup placement, overflow handling, and compact density behavior must be resolved before broad implementation.

## Component Dependencies

- Text input pattern
- Button pattern
- Calendar pattern or component; calendar-grid behavior remains dependency-owned until a Calendar vault spec exists
- Form field or label pattern
- Icon primitive for the calendar icon

## Minimum Component API

| API | Classification | Default | Contract |
|---|---|---|---|
| `value` | Optional controlled | None | Single-date controlled value; exact serialized format is open question. |
| `defaultValue` | Optional uncontrolled | None | Initial single-date value; exact serialized format is open question. |
| `mode` | Required | `single` | `single` supported; `range` out of scope. |
| `locale` | Required API input | Product or app default | Used for parsing/formatting once canonical rules are defined. |
| `dateFormat` | Required API input | Open question | Must be defined by component spec before implementation. |
| `min` | Optional | None | Constraint input; business meaning external. |
| `max` | Optional | None | Constraint input; business meaning external. |
| `disabledDates` | Optional | None | Constraint input; selection must be blocked. |
| `open` | Optional controlled | None | Controls popup open state. |
| `defaultOpen` | Optional uncontrolled | `false` | Initial popup open state. |
| `onChange` | Required callback | None | Emits selected single-date value; value shape is open question. |
| `onOpenChange` | Required for popup variant | None | Emits open state changes. |
| `onBlur` | Optional callback | None | Emits blur according to component framework conventions. |
| `invalid` | Required | `false` | Maps to invalid state and `aria-invalid`. |
| `descriptionId` | Optional | None | Links helper text. |
| `errorId` | Required when visible error exists | None | Links visible error text. |

## Agent Freedom

| Decision Area | Freedom Level | Allowed Choices | Requires Human Review |
|---|---|---|---|
| Dependent base semantics | none | Preserve Text Input and Button pattern contracts. | Yes, for any exception. |
| Calendar grid behavior | limited | Delegate grid structure, roving tabindex, day semantics, and month navigation to the Calendar dependency. | Yes, until a Calendar vault spec exists. |
| Popup strategy | none | Do not choose dialog, popover, or inline as canonical from this spec. | Yes, required before implementation. |
| Focus management | guided | Any deterministic approach that defines open focus entry, selection focus, Escape close, and close return. | Yes, if user flow differs from the contract. |
| Locale parsing and formatting | none | Do not invent parsing, formatting, or emitted value shape. | Yes, required before implementation. |
| Single-date value synchronization | guided | Any architecture that keeps typed field and selected day synchronized. | No, if API contract and accessibility relationships hold. |
| Range behavior | none | Range mode, range preview, and range value shape are out of scope. | Yes, required before enabling range. |
| Constraint handling | limited | Accept `min`, `max`, and `disabledDates` inputs; product/business interpretation remains external. | Yes, for new business rules. |
| Visual implementation | guided | Any framework/runtime approach using input, button, popup, and calendar token slots. | No, unless token slots or ownership are missing. |

## Implementation Contract

- Preserve base input and button contracts.
- Keep the date value synchronized between typed segments and calendar selection.
- Keep open/closed state reflected on the trigger.
- Keep focus behavior deterministic when opening, navigating, selecting, and dismissing.
- Use calendar grid semantics and roving focus for the custom calendar.
- Use semantic input, button, and calendar token slots.
- Do not add date parsing, formatting, or range rules to this vault unless sourced.
- Range mode is out of scope until a concrete range selection model is defined.
- Popup strategy is an open question; agents must not infer dialog versus popover versus inline as a requirement.
- Focus return on close is required.
- Unavailable dates cannot be selected.

## Test Requirements

- Verify label and segment accessible names.
- Verify trigger button exposes `aria-expanded` and controls the calendar.
- Verify keyboard flow across segments, trigger, and calendar.
- Verify calendar arrow, Home/End, PageUp/PageDown, Enter/Space, and Escape behavior.
- Verify selection updates input value and closes the picker for single-date selection.
- Verify disabled and invalid dates cannot be selected and are announced or associated.
- Verify focus visibility and contrast for input and calendar states.
- Verify responsive layouts keep usable day targets.
- Verify focus returns to the defined return point on close.
- Verify month changes are announced or otherwise perceivable according to Calendar dependency.

## Negative Test Requirements

- Popup trigger without accessible popup relationship fails.
- Open popup without accessible name fails.
- Date grid with multiple active tabindex targets fails.
- Unavailable date can be selected fails.
- Focus not returned on close fails.
- Invalid value without error relationship fails when visible error exists.
- Range mode implementation from this spec fails because range is out of scope.

## Documentation Requirements

Human-facing docs must explain composition, input segments, calendar trigger, keyboard interaction, single/range behavior, validation, accessibility, and token inheritance without copying this contract verbatim.

## Anti-Patterns

- Calendar popup without a programmatic trigger relationship.
- Calendar grid with no keyboard navigation.
- Day cells named only by visible number instead of full date.
- Typed input and calendar selection becoming unsynchronized.
- Closing or moving focus unexpectedly during text entry.
- Hardcoded calendar state colors outside semantic tokens.

## Agent Output

Agents can derive composition acceptance criteria, cross-part tests, accessibility review checks, token audits, and documentation deltas from this pattern. Agents must not add runtime implementation code to this vault.

Review this pattern against `patterns/checklists/pattern-spec-review-checklist.md` before deriving implementation output.

## Open Questions

- Open question: There is no dedicated `/docs/patterns/date-picker.md`; determine whether one belongs in the main repository or the component page remains the source.
- Open question: What date format, locale behavior, parsing rules, and emitted value shape are canonical?
- Open question: What exact min/max and disabled-date rules belong in the pattern versus product flows?
- Open question: Which popup strategy is canonical: dialog, popover, or inline calendar?
- Open question: What popup placement and collision behavior is expected on small screens?
- Open question: What is the exact `aria-haspopup` value for the trigger once popup strategy is selected?
- Resolved: Range mode is out of scope until a range selection model is defined.
