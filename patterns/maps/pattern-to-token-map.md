---
id: map.pattern-to-token
title: Pattern to Token Map
type: specification
status: draft
owners:
  - ui-foundations
created: 2026-07-08
updated: 2026-07-08
authority: supporting
summary: Maps pilot vault patterns to required semantic token slots.
---

# Pattern to Token Map

| Pattern | Token Area | Required Semantic Token Slots | Notes |
|---|---|---|---|
| [Button](../base/button.pattern.md) | `button`, focus, icon, loading | Root background/text/border by variant and state; hover/active overlay; focus indicator; disabled state slots; padding, minimum size, radius; icon size/gap/color; loading indicator size/color/motion | ButtonGroup token slots are out of scope until a composition pattern exists. |
| [Text Input](../base/input-text.pattern.md) | `input`, focus, validation, field text, trailing control | Container background/border by state; text and placeholder color; focus indicator; invalid slots; disabled and read-only slots; padding, height, radius, gap; trailing control size/color/spacing; helper/error text slots when composed with field | Message rendering slots are field-composition owned by default. |
| [Date Picker](../composition/date-picker.pattern.md) | `input`, `button`, `calendar`, popup surface, focus, validation | Field slots inherited from input; trigger slots inherited from button/input control; popup surface background/border/radius/shadow/spacing; calendar grid and cell slots; selected/current/unavailable date slots; focus slots | Range preview slots are out of scope. Popup exact token names remain unresolved. |
