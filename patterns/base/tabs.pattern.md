---
id: pattern.base.tabs
title: Tabs Pattern
type: pattern
status: draft
owners:
  - ui-foundations
created: 2026-07-21
updated: 2026-07-21
authority: derived
summary: Agent-readable base pattern contract for tabs.
related:
  derived_from:
    - /Users/Thomas.Bielich@tui.com/GitHub/uif/ui-foundations-runtime/site/patterns/tabs.md
  references:
    - specification.pattern.schema
---

# Tabs Pattern

## Metadata

- id: `pattern.base.tabs`
- type: base
- status: draft
- source: `/Users/Thomas.Bielich@tui.com/GitHub/uif/ui-foundations-runtime/site/patterns/tabs.md`
- related standards: ARIA tablist pattern and keyboard navigation requirements
- related components: `Tabs`
- related tokens: `tabs`, tab, indicator, panel, focus

## Intent

Provide structured switching between related content panels within the same context.

## Problem

Interfaces need efficient intra-page section switching without navigation or content duplication.

## Use When

- Use when related content sets share one page context and only one panel is active.

## Do Not Use When

- Do not use for progressive disclosure of independent sections; use accordion.

## Standard Basis

Tabs follow tablist semantics with tab, tabpanel, selected state, and roving focus behavior.

## Anatomy

- Tab list
- Tab triggers
- Active indicator
- Tab panel

## Structure Contract

| Item | Classification | Contract |
|---|---|---|
| Tab list | Required | Container with tab semantics and orientation context. |
| Tab triggers | Required | Each tab controls a panel. |
| Tab panel | Required | Exactly one active panel per selected tab in single-select mode. |
| Disabled tab | Optional | Non-selectable tab option. |

## Implementation Naming Contract

### CSS Class Contract

- Public tabs classes use the `uif-` prefix.

### Token Contract

- Public tabs tokens use `--uif-tabs-*`.

### Data Attribute Contract

Data attributes may mirror selected index metadata.

### Native / ARIA Precedence

- Use tablist/tab/tabpanel semantics and explicit tab-panel relationships.

### Agent Freedom Boundary

- Tab-panel relationship semantics and keyboard model are not agent freedom.

## Required Semantics

- Selected tab is programmatically determinable.
- Each tab is associated with one panel.
- Orientation and keyboard model are coherent.

## Behaviour

- Selecting a tab activates associated panel.
- Focus and selection follow roving-tab model.
- Disabled tabs are skipped by selection behavior.

## Keyboard Interaction

- `Tab`: enter/leave tablist.
- Arrow keys: move focus between tabs by orientation.
- `Home` / `End`: jump to first/last tab.
- `Enter` / `Space`: activate focused tab.

## Accessibility Rules

- Preserve explicit tab-to-panel mapping.
- Keep selected state and focus visible.
- Ensure panel content updates are understandable.

## Token Requirements

- Tab text and background states
- Active indicator
- Focus indicator
- Panel spacing and typography context

## Token Slot Matrix

| Part | Property | State / Variant | Required semantic token slot | Notes |
|---|---|---|---|---|
| Tab trigger | Text/background | Default / hover / selected / disabled | Tabs trigger slots | Selected state must be clear. |
| Active indicator | Color/size | Selected | Tabs indicator slots | Primary selected affordance. |
| Tab trigger | Focus indicator | Focus-visible | Tabs focus slot | Required keyboard affordance. |

## States

- Default
- Hover
- Selected
- Focus
- Disabled

## State Semantics

| State | Required semantics | User interaction | Notes |
|---|---|---|---|
| Default | Inactive tab | Can be selected | Required. |
| Selected | Active tab and panel | Can be replaced by another tab | Required. |
| Focus | Focused tab | Keyboard navigation | Required. |
| Disabled | Unavailable tab | No selection | Optional. |

## Variants

- Horizontal
- Vertical
- Disabled tabs

## Responsive / Density Behaviour

Tab labels remain readable and navigable across breakpoints; orientation can adapt where documented.

## Component Dependencies

- `Tabs`

## Minimum Component API

| API | Classification | Default | Contract |
|---|---|---|---|
| `orientation` | Optional | `horizontal` | Tablist direction. |
| `selected` | Required | None | Selected tab identity. |
| `disabled` | Optional | `false` | Per-tab disabled behavior. |

## Agent Freedom

| Decision Area | Freedom Level | Allowed Choices | Requires Human Review |
|---|---|---|---|
| Tab semantics | none | Preserve tablist model and relationships. | Yes, for alternate navigation models. |
| Activation model | limited | Explicit activate-on-interaction behavior. | Yes, for automatic activation changes. |
| Visual expression | guided | Tokenized trigger/indicator states. | No. |

## Implementation Contract

- Preserve tab-panel semantics and mappings.
- Preserve keyboard interaction model.
- Preserve selected/focus state clarity.

## Test Requirements

- Verify tab-to-panel relationships.
- Verify keyboard navigation and activation.
- Verify selected/focus/disabled states.

## Negative Test Requirements

- Tab with no associated panel fails.
- Multiple selected tabs in single-select mode fails.

## Documentation Requirements

Human-facing docs explain tabs-vs-accordion boundary and keyboard behavior.

## Anti-Patterns

- Tabs controlling unrelated content contexts.
- Ambiguous tab labels.

## Agent Output

Agents can derive navigation and accessibility checks from this pattern.

Review this pattern against `patterns/checklists/pattern-spec-review-checklist.md` before deriving implementation output.

## Open Questions

- Open question: Should automatic activation on focus be standardized or composition-specific?

