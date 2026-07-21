---
id: map.pattern-to-component
title: Pattern to Component Map
type: specification
status: draft
owners:
  - ui-foundations
created: 2026-07-08
updated: 2026-07-08
authority: supporting
summary: Maps pilot vault patterns to related UI Foundations components and source docs.
---

# Pattern to Component Map

| Pattern | Type | Related Component(s) | Dependency Role | Ownership Notes | Source Doc | Vault Spec | Status |
|---|---|---|---|---|---|---|---|
| [Button](../base/button.pattern.md) | Base | `Button` | Implementing component | Button owns native action semantics, loading suppression, icon-only naming, and visual states. ButtonGroup is out of scope until a composition pattern exists. | `/Users/Thomas.Bielich@tui.com/GitHub/ui-foundations/docs/patterns/button.md` | `patterns/base/button.pattern.md` | Draft pilot |
| [Input](../base/input.pattern.md) | Base | `Input`, form field | Implementing component plus field composition dependency | Input owns native value, state attributes, and relationships. Form field owns visible message rendering by default. | `/Users/Thomas.Bielich@tui.com/GitHub/ui-foundations/docs/patterns/input.md` | `patterns/base/input.pattern.md` | Draft pilot |
| [Calendar](../base/calendar.pattern.md) | Base | `Calendar` | Implementing component | Calendar defines date navigation, selection, range behavior, focus movement, disabled-date behavior, localization, and accessibility semantics. | `/Users/Thomas.Bielich@tui.com/GitHub/uif/ui-foundations-runtime/site/patterns/calendar.md` | `patterns/base/calendar.pattern.md` | Draft pilot |
| [Date Picker](../composition/date-picker.pattern.md) | Composition | `Date Picker`, `Input`, `Calendar`, `Button` | Implementing composition with dependent base patterns and Calendar dependency | Date Picker implements the Calendar pattern together with field, trigger, popover/dialog surface, parsing, formatting, and validation. | `/Users/Thomas.Bielich@tui.com/GitHub/ui-foundations/docs/patterns/input.md`; supporting `/Users/Thomas.Bielich@tui.com/GitHub/ui-foundations/site/components/date-picker.md` | `patterns/composition/date-picker.pattern.md` | Draft pilot |
