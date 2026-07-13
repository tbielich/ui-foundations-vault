---
id: experiment.button-proof-of-use.a11y-checklist
title: Button Proof of Use Accessibility Checklist
type: checklist
status: draft
owners:
  - ui-foundations
created: 2026-07-08
updated: 2026-07-13
authority: derived
summary: Accessibility checks derived from the Button Pattern proof-of-use draft.
related:
  derived_from:
    - pattern.base.button
---

# Button Proof of Use Accessibility Checklist

## Accessible Name Checks

- [ ] Every text button exposes its visible label as the accessible name.
- [ ] Icon-only buttons provide an explicit accessible name with `aria-label` or an equivalent tested mechanism.
- [ ] Decorative icons use `aria-hidden="true"`.
- [ ] Loading indicators do not replace or obscure the accessible name.
- [ ] Button labels are concise, sentence case, and action-oriented.

## Keyboard Checks

- [ ] `Tab` moves focus to enabled buttons.
- [ ] `Shift + Tab` moves focus to the previous focusable element.
- [ ] `Enter` activates enabled buttons.
- [ ] `Space` activates enabled buttons.
- [ ] No generic element with `role="button"` is used where native `<button>` is available.

## Focus-Visible Checks

- [ ] Keyboard focus creates a visible `:focus-visible` indicator.
- [ ] The focus indicator is not removed by reset styles.
- [ ] The focus indicator has sufficient contrast against the surrounding background.
- [ ] The focus indicator remains visible for solid, outline, ghost, and icon-only variants.

## Disabled Checks

- [ ] Disabled buttons use the native `disabled` attribute.
- [ ] Disabled buttons are not focusable through sequential keyboard navigation.
- [ ] Disabled buttons are not activatable by pointer, `Enter`, or `Space`.
- [ ] Disabled visual treatment does not rely on color alone.

## Loading-State Checks

- [ ] The loading button preserves its accessible name.
- [ ] The loading indicator is decorative unless it communicates additional status.
- [ ] Repeated activation is suppressed while loading.
- [ ] The chosen loading semantics are documented because disabled mapping is an open pattern question.
- [ ] Use of `aria-busy` is reviewed because placement is an open pattern question.

## Icon-Only Checks

- [ ] Icon-only buttons contain one icon plus an explicit accessible name.
- [ ] Icon-only buttons meet the same minimum target size as other buttons.
- [ ] Icon-only buttons do not rely on tooltip text as the only accessible name unless tested.
- [ ] The icon is hidden from assistive technology when the accessible name comes from `aria-label`.

## Anti-Pattern Checks

- [ ] No links are styled as action buttons.
- [ ] No action buttons are implemented with `div`, `span`, or another generic element.
- [ ] No focus indicator is removed.
- [ ] No brand colors or raw color values are hardcoded.
- [ ] No final token names are invented where the pattern only defines token slots.
- [ ] No BEM-style modifier or element classes are used instead of UIF class name chains.
- [ ] Public button classes use the scoped `.uif-button` contract, not unscoped component classes.
- [ ] Experimental token placeholders use the `--uif-proof-button-*` scope or another documented `--uif-proof-*` / `--uif-assumption-*` UIF experiment scope.
- [ ] No ButtonGroup behavior is derived from this base button proof.
