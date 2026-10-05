---
id: knowledge.accessibility.preference-adaptation
title: User Preference Adaptation Is Not a Theme Matrix
type: knowledge
status: draft
owners:
  - ui-foundations
created: 2026-09-30
updated: 2026-09-30
authority: supporting
summary: Research finding that visual modes, user-preference adaptations, and platform color overrides should remain distinct and composable.
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
---

# User Preference Adaptation Is Not a Theme Matrix

## Finding

Modern web standards do not treat every accessibility preference as a visual theme. They expose independent signals that authors can respond to through CSS media queries, semantic value resolution, system colors, and component behavior.

For UIF, the useful distinction is:

- **Appearance modes** define a coherent visual language, currently light and dark.
- **Preference adaptations** selectively modify semantics or behavior, for example contrast, reduced motion, reduced transparency, and defensive handling of color inversion.
- **Platform adaptations** represent browser or operating-system rendering behavior that UIF should cooperate with rather than replace, especially forced colors.

This distinction avoids materializing combinations such as `dark-high-contrast-reduced-motion`.

## Evidence

CSS Media Queries Level 5 defines independent preference and rendering features including:

- `prefers-color-scheme`
- `prefers-contrast`
- `forced-colors`
- `prefers-reduced-motion`
- `prefers-reduced-transparency`
- `inverted-colors`

The research also found materially different responsibilities:

- `prefers-color-scheme` is a strong fit for an authored appearance mode.
- `prefers-contrast` requests a contrast preference and can drive selective semantic adaptation; it is not equivalent to forced colors.
- `forced-colors: active` indicates user-agent enforcement of a user-selected palette and should normally be supported through system colors and component-specific rules rather than a proprietary UIF high-contrast theme.
- `prefers-reduced-motion` changes component behavior rather than visual theme identity.
- `prefers-reduced-transparency` is suitable for progressive enhancement where supported.
- `inverted-colors` is best treated defensively rather than as a primary UIF mode.

The reviewed design-system examples reinforce the distinction: Primer separates authored high-contrast themes from forced colors, while Fluent documents forced-colors support through CSS system colors. Material demonstrates authored contrast contexts without making them equivalent to platform forced-color rendering.

## Architecture hypothesis

Retain the established UIF layering:

```text
Core → Appearance → Semantics → Patterns
```

Do not insert preference or platform adaptations as additional mandatory layers and do not encode every condition into token identity.

Instead, investigate **Conditional Preference Adaptation**:

```text
                  Conditions
                ┌──────────────┐
                │ contrast     │
                │ motion       │
                │ transparency │
                │ forcedColors │
                └──────┬───────┘
                       ↓

Core → Appearance → Semantics → Patterns
```

The working hypothesis is:

> Token identity stays stable. Context changes resolution or component behavior.

For example, a component should continue to consume semantic contracts such as:

```text
color.border.default
color.focus.ring
color.content.muted
motion.duration.interactive
```

rather than consume condition-specific identities such as a complete `dark-high-contrast-reduced-motion` theme.

This is a hypothesis, not an accepted architecture decision.

## Implications to test

A bounded spike should test whether independent conditions can compose without creating a token or theme matrix.

Suggested representative scope:

- Button
- Dialog

Conditions:

- light / dark
- `prefers-contrast: more`
- `prefers-reduced-motion: reduce`
- `forced-colors: active`

The spike should determine whether stable semantic token identities plus conditional resolution and component behavior are sufficient across the combinations.

## Risks and open questions

- `prefers-contrast` support and OS mapping are less uniform than color scheme or reduced motion.
- Reduced-transparency support remains uneven and should not become a critical accessibility dependency.
- Forced colors can require component-specific handling for borders, focus, selection, SVGs, native controls, and state representation; global token remapping alone may be insufficient.
- A product-authored high-contrast palette may still be useful, but it must remain distinct from forced colors.
- Preference-specific token namespaces could recreate the same combinatorial matrix at the token level.
- Product overrides versus system preferences need an explicit precedence contract before implementation.

## Candidate ADR question

> How should UIF represent and resolve orthogonal user-preference and platform adaptations without expanding its appearance-mode or token matrix?

Candidate approaches for later evaluation:

1. **Theme matrix** — explicit combined themes; simple but combinatorial.
2. **Additional token layers** — dedicated preference/platform layers; structured but risks hierarchy and duplication.
3. **Conditional resolution** — stable semantic identities with orthogonal conditions; currently the hypothesis to test.

## Research-to-decision state

```text
Research ✓ → Hypothesis ✓ → ADR → Spike → Evidence → Decision
```

No architecture decision is established by this finding.

## Primary references

- W3C Media Queries Level 5: https://www.w3.org/TR/mediaqueries-5/
- W3C WCAG 2.2: https://www.w3.org/TR/WCAG22/
- CSS Color Adjustment Module Level 1: https://drafts.csswg.org/css-color-adjust/
- CSS Color Module Level 4: https://drafts.csswg.org/css-color/
- MDN `prefers-contrast`: https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/At-rules/@media/prefers-contrast
- MDN `forced-colors`: https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/At-rules/@media/forced-colors
- MDN `prefers-reduced-motion`: https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/At-rules/@media/prefers-reduced-motion
- MDN `prefers-reduced-transparency`: https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/At-rules/@media/prefers-reduced-transparency
- MDN `inverted-colors`: https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/At-rules/@media/inverted-colors
- Fluent UI Windows High Contrast: https://learn.microsoft.com/en-us/fluent-ui/web-components/design-system/high-contrast
- Primer color considerations: https://primer.style/accessibility/design-guidance/color-considerations/
- Primer motion and animation: https://primer.style/accessibility/design-guidance/motion-and-animation/
- Material 3 color system: https://m3.material.io/styles/color/system/overview
