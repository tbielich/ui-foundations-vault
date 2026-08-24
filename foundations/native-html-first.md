---
id: principle.foundation.native-html-first
title: Native HTML First
type: principle
status: accepted
owners:
  - ui-foundations
created: 2026-08-24
updated: 2026-08-24
authority: source
summary: Prefer native HTML elements as the semantic foundation; custom elements enhance rather than replace them.
related:
  references:
    - principle.foundation.accessibility-principles
    - principle.foundation.design-principles
---

# Native HTML First

## Question

When should a component use a native HTML element versus a custom implementation?

## Purpose

Native HTML elements carry built-in semantics, keyboard behavior, form participation, and assistive technology support. They work without JavaScript, degrade gracefully, and benefit from ongoing browser improvements. Custom elements that replace natives instead of enhancing them lose these properties and must reimplement them — often incompletely.

## Principles

- Native foundation: when a standard HTML element exists for the intended purpose, use it as the structural basis of the component.
- Enhancement over replacement: custom elements should wrap, extend, or progressively enhance native elements — not substitute them with `<div>` and ARIA re-implementations.
- ARIA as a last resort: use ARIA attributes only when no native element provides the required semantics. Redundant ARIA on elements that already communicate their role is noise.
- JavaScript as enhancement: the component must communicate its core semantics and basic structure without JavaScript. Script adds behavior, not meaning.
- Form participation: components representing form controls should use or contain native form elements (`<input>`, `<select>`, `<meter>`, `<progress>`, `<textarea>`) so they participate in form submission, validation, and autofill natively.

## Decision Guidance

| Situation | Approach |
|-----------|----------|
| A native element exists with the right semantics | Use it directly; style with CSS; enhance with JS if needed |
| A native element exists but needs richer interaction | Wrap the native element inside a custom element; add behavior via JS |
| No native element matches the intended semantics | Build a custom element with appropriate ARIA roles and keyboard patterns |
| A native element has limited cross-browser styling | Use the native element for semantics; add a visual presentation layer that hides the native rendering (e.g. `appearance: none` or visually-hidden + visual proxy) |

## Examples

| Component | Native Element | Strategy |
|-----------|---------------|----------|
| Meter | `<meter>` | Use native `<meter>` for semantics; style with CSS or add a visual proxy |
| ProgressBar | `<progress>` | Use native `<progress>` for semantics and form integration |
| Checkbox | `<input type="checkbox">` | Wrap the native checkbox; style with adjacent elements |
| Select | `<select>` | Use native `<select>` for small option sets; custom dropdown only when grouping, search, or rich rendering is required |
| Dialog | `<dialog>` | Use native `<dialog>` for focus trapping, backdrop, and close behavior |
| Accordion | `<details>` / `<summary>` | Use native disclosure where behavior matches; custom when synchronized panels are needed |

## Anti-Patterns

- Replacing `<meter>` with `<div role="meter">` — loses form participation, native accessibility announcements, and graceful degradation.
- Replacing `<progress>` with animated `<div>` — loses determinate/indeterminate semantics and native AT support.
- Replacing `<button>` with `<div role="button" tabindex="0">` — loses implicit form submission, space/enter handling, and disabled state.
- Adding `role="checkbox"` to a `<div>` when `<input type="checkbox">` would suffice — creates maintenance burden for keyboard and state management that the browser handles for free.

## Tradeoffs

Native elements have limitations:
- Cross-browser styling inconsistency (especially `<meter>`, `<progress>`, `<select>`)
- Limited customization of internal structure
- Some behaviors cannot be overridden (e.g., native `<select>` dropdown rendering)

These limitations justify a visual proxy pattern — keep the native element for semantics (potentially visually hidden) and render a styled counterpart — rather than full replacement.

## Related

- `principle.foundation.accessibility-principles`
- `principle.foundation.design-principles`
