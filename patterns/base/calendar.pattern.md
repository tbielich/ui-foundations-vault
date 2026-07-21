---
id: pattern.base.calendar
title: Calendar Pattern
type: pattern
status: draft
owners:
  - ui-foundations
created: 2026-07-21
updated: 2026-07-21
authority: derived
summary: Agent-readable base pattern contract for calendars.
related:
  derived_from:
    - /Users/Thomas.Bielich@tui.com/GitHub/uif/ui-foundations-runtime/site/patterns/calendar.md
  references:
    - specification.pattern.schema
---

# Calendar Pattern

## Metadata

- id: `pattern.base.calendar`
- type: base
- status: draft
- source: `/Users/Thomas.Bielich@tui.com/GitHub/uif/ui-foundations-runtime/site/patterns/calendar.md`
- related standards: WAI-ARIA grid interaction patterns; WCAG focus and target size requirements
- related components: `Calendar`
- related tokens: `calendar`, day-cell, range, focus, spacing, typography

## Intent

Provide an accessible, locale-aware calendar grid for selecting single dates or contiguous date ranges.

## Problem

Date selection needs predictable keyboard navigation, clear selected states, understandable temporal context, and locale-aware labeling.

## Use When

- Use when users select dates directly from a month grid.
- Use in booking, scheduling, and filter experiences requiring date precision.

## Do Not Use When

- Do not use calendar grid for freeform date text entry alone.
- Do not use for complex planning workflows that require timeline or planner semantics.

## Standard Basis

Calendar uses grid-based interaction semantics with roving focus and explicit date selection states.

## Anatomy

- Calendar container
- Header controls and current month/year label
- Weekday row
- Day-cell grid

## Structure Contract

| Item | Classification | Contract |
|---|---|---|
| Grid | Required | Day cells are organized in a semantic grid. |
| Day cell | Required | Each selectable date cell conveys full date meaning. |
| Month context | Required | Current month/year context is always visible. |
| Range state | Optional | Start, middle, and end semantics for range selection. |

## Implementation Naming Contract

### CSS Class Contract

- Public calendar classes use the `uif-` prefix.

### Token Contract

- Public calendar tokens use `--uif-calendar-*`.

### Data Attribute Contract

Data attributes may mirror date state but do not replace semantic selection state.

### Native / ARIA Precedence

- Prefer semantic button-in-grid patterns for day interaction.
- Expose full date labels for assistive technologies.

### Agent Freedom Boundary

- Grid semantics, keyboard model, and state semantics are not agent freedom.

## Required Semantics

- Day cells expose programmatic date meaning.
- Selected and disabled states are programmatically determinable.
- Focus movement is predictable and visible.
- Localized weekday/month naming and full-date announcements are consistent with the configured locale.

## Behaviour

- Arrow keys move focus by day/week increments.
- Activation selects date or range endpoint.
- Disabled dates remain non-selectable.
- Localized month and weekday presentation follows configured locale settings.

## Keyboard Interaction

- `Arrow` keys: move across dates.
- `Home` / `End`: move to week boundaries.
- `PageUp` / `PageDown`: move by month.
- `Enter` / `Space`: select focused date.

## Accessibility Rules

- Use grid semantics for day matrix.
- Provide full localized date labels for day cells.
- Keep target size and focus visibility accessible.

## Token Requirements

- Container surface and border
- Header, weekday, and day-cell typography/color
- Selection, range, disabled, hover, and focus tokens

## Token Slot Matrix

| Part | Property | State / Variant | Required semantic token slot | Notes |
|---|---|---|---|---|
| Day cell | Fill / text color | Default / selected / disabled | Calendar day-cell slots | Preserve contrast across states. |
| Day cell | Range visuals | Range start / middle / end | Calendar range slots | Must distinguish boundaries. |
| Day cell | Focus indicator | Focus-visible | Calendar focus slot | Required for keyboard navigation. |

## States

- Default
- Hover
- Focus
- Selected
- Range
- Outside month
- Disabled

## State Semantics

| State | Required semantics | User interaction | Notes |
|---|---|---|---|
| Default | Selectable date | Focus/select | Required. |
| Selected | Active selected date | Replace/update selection | Required. |
| Range | Start/middle/end range states | Extend range selection | Optional when range mode enabled. |
| Disabled | Non-selectable date | No selection | Required when constrained dates exist. |

## Variants

- Single date selection
- Date range selection
- Container and containerless presentation

## Responsive / Density Behaviour

Calendar preserves readable day-cell size, grid alignment, and focus treatment across viewport and density modes.

## Component Dependencies

- `Calendar`
- Button semantics for interactive day cells

## Minimum Component API

| API | Classification | Default | Contract |
|---|---|---|---|
| `selectedDate` | Optional | None | Single selected date. |
| `rangeStart` | Optional | None | Range start date. |
| `rangeEnd` | Optional | None | Range end date. |
| `locale` | Optional | App default | Locale used for localized labels and date text. |
| `disabled` | Optional | `false` | Disables interactive selection. |

## Agent Freedom

| Decision Area | Freedom Level | Allowed Choices | Requires Human Review |
|---|---|---|---|
| Grid semantics | none | Preserve date-grid accessibility semantics. | Yes, for non-grid alternatives. |
| Range modeling | limited | Support start/middle/end semantics when range exists. | Yes, for alternate range interaction models. |
| Visual implementation | guided | Use semantic calendar token slots. | No. |

## Implementation Contract

- Preserve keyboard date navigation.
- Preserve date meaning and state semantics.
- Preserve focus and contrast accessibility.

## Test Requirements

- Verify keyboard navigation model.
- Verify selected/range/disabled semantics.
- Verify full date accessibility labels.

## Negative Test Requirements

- Day cells without date labels fail.
- Non-visible focus state fails.
- Disabled dates that can be selected fail.

## Documentation Requirements

Human-facing docs explain keyboard navigation, range behavior, and constraints clearly.

## Anti-Patterns

- Encoding selection with color alone.
- Non-linear focus movement across the grid.

## Agent Output

Agents can derive acceptance criteria, accessibility checks, and test plans from this pattern.

Review this pattern against `patterns/checklists/pattern-spec-review-checklist.md` before deriving implementation output.

## Open Questions

- Open question: Should month/year control behavior be standardized at base pattern level or delegated to composition patterns?
