---
id: experiment.button-proof-of-use
title: Button Proof of Use
type: experiment
status: draft
owners:
  - ui-foundations
created: 2026-07-08
updated: 2026-07-13
authority: derived
summary: Small implementation draft derived from the agent-readable Button Pattern.
related:
  derived_from:
    - pattern.base.button
---

# Button Proof of Use

This experiment tests whether `patterns/base/button.pattern.md` gives enough agent-readable guidance to produce a minimal implementation draft. It is not a production component, package, or final token proposal.

The first proof used BEM-like modifier and element names. Those names were replaced because UI Foundations uses class name chains. This revision aligns the proof-of-use with the final explicit UIF naming contract: scoped `.uif-button` class chains, UIF-style part classes, and `--uif-proof-button-*` experimental token placeholders.

## Result

Accepted as a successful proof-of-use. This experiment shows the Button Pattern can guide a minimal implementation draft, but it is not production-ready.

Open before production:

- Loading semantics.
- `aria-busy` placement.
- Final token names.
- Variant class prefixing.

## Files

- `button.html`: static examples for default, disabled, icon-only, and loading buttons.
- `button.css`: minimal styles using scoped `--uif-proof-button-*` experimental token placeholders.
- `button.a11y-checklist.md`: proof-of-use accessibility review checklist.

## Derived Successfully

- Native `<button>` is the required element for actions.
- `type="button"` is the default unless submit or reset behavior is explicitly needed.
- Text buttons preserve accessible names through visible labels.
- Icon-only buttons require an explicit accessible name.
- Decorative icons and loading indicators are hidden with `aria-hidden="true"`.
- Disabled examples use the native `disabled` attribute.
- Focus-visible styling is required and represented through a token placeholder.
- Variants can be expressed without changing semantics.
- UIF class name chains can represent variants and authored states without changing native button semantics.
- The current pattern's `.uif-button` public component class and optional `data-uif-component="button"` metadata can be applied without replacing native semantics.

## Assumptions

- Placeholder CSS custom properties use the prefix `--uif-proof-button-*` so the experiment stays scoped while making the UIF naming contract explicit.
- System color fallbacks such as `ButtonFace`, `ButtonText`, and `AccentColor` are used only to keep the static draft inspectable without hardcoding brand colors.
- The loading example uses both `disabled` and `aria-busy="true"` to show repeated-activation suppression without JavaScript.
- The loading indicator is decorative because the visible label remains the accessible name.
- The icon glyphs are inline text placeholders for proof-of-use only; production usage would rely on an approved icon primitive.
- The loading example uses `.is-loading` and `data-loading="true"` as experimental state hooks because loading semantics remain open in the pattern.

## Unclear In The Pattern Spec

- Whether loading should apply native `disabled` or keep the button focusable while suppressing repeated activation.
- Whether `aria-busy` belongs on the button or on a surrounding async region.
- Exact public `--uif-button-*` token names for variant backgrounds, text, borders, focus ring, icon size, loading size, and motion.
- Canonical size scale and whether this pattern should define named sizes.
- Whether icon-only buttons should require visible tooltips in this system.

## Needs Human Review

- Loading-state semantics before production implementation.
- Final token mapping from pattern slots to approved UI Foundations tokens.
- Visual treatment for solid, outline, and ghost hierarchy.
- Hit target sizing against the system density model.
- Icon primitive integration and approved icon-only affordances.

## Pattern And Template Recommendation

Future pattern specs should include the canonical `Implementation Naming Contract` from `patterns/schemas/pattern.schema.md`. This experiment confirmed that UIF naming conventions must be explicit so agents follow the scoped class chains, part classes, token naming, documented data-attribute contracts, native semantics, and accessibility rules.

## Readiness To Scale

The Button Pattern is useful enough to derive a minimal implementation draft and an accessibility checklist. It is not fully ready to scale unattended across more base patterns until open questions are resolved for loading semantics, token naming, size scale, and any component-specific accessibility conventions.
