---
id: map.pattern-to-standard
title: Pattern to Standard Map
type: specification
status: draft
owners:
  - ui-foundations
created: 2026-07-08
updated: 2026-07-08
authority: supporting
summary: Maps pilot vault patterns to native and accessibility standards.
---

# Pattern to Standard Map

| Pattern | Standard Basis | Required Native Element / Role | Notes |
|---|---|---|---|
| [Button](../base/button.pattern.md) | Native HTML button; WCAG focus, contrast, and use of color requirements | `<button>` for actions; `<a>` for navigation | `aria-pressed` toggle behavior is out of scope. Loading `aria-busy` placement remains an open question. |
| [Input](../base/input.pattern.md) | Native HTML input; WCAG label, error, focus, contrast, required indication, and use of color requirements | `<input>` with `<label>`, `aria-label`, or `aria-labelledby`; `aria-describedby` / `aria-invalid` for validation relationships | Placeholder must not be the only label. `readonly` and `disabled` remain distinct native states. |
| [Date Picker](../composition/date-picker.pattern.md) | Native input and button; WAI-ARIA grid for custom calendar; WCAG keyboard, focus, labels, errors, and contrast requirements | Native segment inputs or native date input, native trigger button, calendar `role="grid"` when custom grid is used | Popup role is unresolved: dialog, popover, and inline are open options. Range mode is out of scope until defined. |
