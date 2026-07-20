---
id: pattern.base.table
title: Table Pattern
type: pattern
status: draft
owners:
  - ui-foundations
created: 2026-07-20
updated: 2026-07-20
authority: derived
summary: Agent-readable base pattern contract for the data table component.
related:
  derived_from:
    - site/patterns/table.md
    - site/patterns/table-playground.md
  references:
    - specification.pattern.schema
    - issue #52
---

# Table Pattern

## Metadata

- id: `pattern.base.table`
- type: base
- status: draft
- source: `site/patterns/table.md`
- related components: `Table`
- related tokens: `--uif-table-*`, spacing, color, typography, border
- integration surfaces: CSS pattern, Nunjucks macro, Playground, Docs page, Code Connect, Component tokens

## Summary

Data table for displaying structured information. Progressively enhanced with JavaScript for interactive features. The base HTML table with `.uif-table` class provides all visual styling; `enhanceTable()` adds sort, selection, and column resize behaviours.

## Scope (from issue #52)

- Sortable columns — click or keyboard-activate `th[aria-sort]` to cycle none → ascending → descending
- Row selection — `data-selection="single"` or `data-selection="multi"` on the table element
- Resizable columns — `data-resizable` attribute on `th` elements
- Sticky header — `thead th` sticks via `position: sticky`
- Empty state — `.uif-table-empty` class
- Loading state — `.uif-table--loading` class (reduces opacity, disables pointer events on tbody)

## HTML Contract

### Wrapper

```html
<div class="uif-table-wrapper">
  <table class="uif-table">...</table>
</div>
```

### Density modifiers (on `<table>`)

| Class | Description |
|---|---|
| `uif-table--compact` | Tight padding |
| `uif-table--comfortable` | Default comfortable padding |
| `uif-table--spacious` | Extra spacious padding |

### Behaviour attributes

| Attribute | Element | Description |
|---|---|---|
| `data-selection="single"` | `<table>` | Enables single row selection |
| `data-selection="multi"` | `<table>` | Enables multi row selection |
| `aria-sort="none\|ascending\|descending"` | `<th>` | Marks header as sortable |
| `data-resizable` | `<th>` | Enables column resize handle |

### State classes (JS-managed)

| Class / Attribute | Element | Description |
|---|---|---|
| `aria-selected="true"` | `<tr>` | Row is selected |
| `uif-table--loading` | `<table>` | Loading state |

## JavaScript API

```js
import { enhanceTable, observeTable } from "ui-foundations/ui/components/table.js";

enhanceTable();          // enhance all .uif-table on page
enhanceTable(container); // enhance within container
observeTable();          // watch for dynamically added tables
```

Auto-enhances on `DOMContentLoaded` when loaded as a `<script type="module">`. Disable auto-enhance with `window.__TABLE_NO_AUTO = true`.

## Token Mapping

| Token | Semantic Token | Usage |
|---|---|---|
| `--uif-table-background` | `--color-fill-surface` | Table background |
| `--uif-table-text-color` | `--color-text-default` | Body text |
| `--uif-table-border-color` | `--color-border-subtle` | Row separators |
| `--uif-table-border-size` | `--brand-size-border-default` | Border thickness |
| `--uif-table-padding-block` | `--brand-size-spacing-component` | Cell vertical padding |
| `--uif-table-padding-inline` | `--brand-size-spacing-comfortable` | Cell horizontal padding |
| `--uif-table-header-font-family` | `--typography-label-font-family` | Header text |
| `--uif-table-header-font-size` | `--typography-label-font-size` | Header text size |
| `--uif-table-header-font-weight` | `--typography-label-font-weight` | Header text weight |
| `--uif-table-row-background-hover` | `--color-fill-subtle` | Row hover state |
| `--uif-table-row-background-selected` | `--color-fill-subtle` | Selected row fill |
| `--uif-table-row-text-color-selected` | `--color-text-brand` | Selected row text |
| `--uif-table-focus-color` | `--color-focus` | Keyboard focus ring |

## Accessibility

- Table must have a `<caption>` or the wrapping element must have `aria-label` / `aria-labelledby` for screen readers.
- Sortable `<th>` elements use `aria-sort` to communicate sort state.
- Selected rows use `aria-selected="true"` on `<tr>`.
- Keyboard: `Enter`/`Space` on sortable headers cycles sort; `Enter`/`Space` on selectable rows toggles selection.
- Focus ring applied via `box-shadow` inset to avoid layout impact.

## Integration Surfaces

| Surface | Status | Path |
|---|---|---|
| CSS pattern | ✅ | `src/ui/patterns/table.css` |
| JS component | ✅ | `src/ui/components/table.js` |
| Nunjucks macro | ✅ | `site/_includes/macros/ui.njk` — `table`, `tableHead`, `tableBody`, `th`, `tr`, `td` |
| Docs page | ✅ | `site/patterns/table.md` |
| Playground | ✅ | `site/patterns/table-playground.md` |
| Code Connect | ⚠️ | `schemas/web-table.figma.ts` — awaiting Figma node-id |
| Component tokens | ✅ | `dist/tokens/css/patterns-ui.tokens.css`, `dist/tokens/tokens.yaml` |
