---
id: lesson.icon-audit-45.figma-guideline-addendum
title: Figma Icon Guideline Addendum (Issue 45)
type: lesson
status: draft
owners:
  - ui-foundations
created: 2026-10-31
updated: 2026-10-31
authority: derived
summary: User-identified Figma icon guideline (UI Assets Library, node 482:12945 'Icons') supplied after PR66. Records the external design source with provenance, compares it to the existing runtime-guide-based audit rules, and marks the audit's design-guideline completeness as invalidated pending reconciliation. No re-evaluation of the 601 inventory against Figma is claimed.
consumers:
  - human
  - agent
  - codex
  - kiro
applies_to:
  - ui-foundations
  - ui-foundations-runtime
related:
  references:
    - lesson.icon-audit-45
    - pattern.base.icon
    - governance.precedence
provenance:
  sources:
    - type: issue
      role: source
      repository: ui-foundations-vault
      number: 45
    - type: design-source
      role: user-identified-design-guideline
      tool: figma
      access: official-figma-mcp-read-only
      file: Eprjc6hw7QyMvvD01eGgGy
      section_node: "482:12945"
      section_name: Icons
      url: https://www.figma.com/design/Eprjc6hw7QyMvvD01eGgGy/UI-Assets-Library?node-id=482-12945
      accessed: 2026-10-31
      capture_sha256: 5be17544d471e06ff72b01db786a130ff33b9e6999cc14be00fbcc9b700869e7
      version_id: null
      note: >-
        No immutable Figma version ID or commit SHA was obtained via MCP. The
        content snapshot text and capture SHA are supplied by Codex. Git commit
        SHAs do NOT version this Figma file; none is invented here.
verification:
  status: draft
  evidence:
    - verification.json
  note: >-
    Figma source observations were fetched and verified by Codex against the
    source text plus a full screenshot (official Figma MCP, read-only, session
    cb67a792-4a02-4ef3-858d-30efbc79f94d). The existing quantitative audit
    counts are unchanged and were NOT re-evaluated against this Figma source.
assumptions:
  - The Vault remains the canonical governance surface; this external Figma design source is referenced with provenance, not promoted to governance.
  - The user authored this guideline for icons, so it is a user-identified design guideline previously missing from the audit, not a random filename candidate.
  - Membership/mapping of the 601 runtime icons to this Figma library, and the applicable Figma revision, are unresolved.
---

# Figma Icon Guideline Addendum (Issue 45)

## Why this addendum exists

The original Issue 45 audit compared the runtime SVG asset set against two
**implementation/usage guides** in `ui-foundations-runtime`
(`docs/agentic/icon-creation.md`, `site/patterns/icon.md`). After PR66 the user
supplied an **existing icon guideline they authored** in Figma:

- Figma file `Eprjc6hw7QyMvvD01eGgGy` (UI Assets Library)
- Section node `482:12945`, name **Icons**
- URL: https://www.figma.com/design/Eprjc6hw7QyMvvD01eGgGy/UI-Assets-Library?node-id=482-12945

This is a **user-identified design guideline** that was previously missing from
the audit inputs. Its existence means the original audit was **not** a complete
design-guideline comparison. This addendum records the source with provenance,
states precisely what was and was not observed, and compares it to the existing
runtime-guide rules **without** silently converting units, resolving colors, or
re-running the tool.

## Source status and authority

- **Canonical governance** remains the Vault. This Figma file is an **external
  design source**, referenced with provenance, not promoted to governance.
- The user authored this guideline, so it is a **design guideline**, not a
  speculative filename candidate.
- The runtime implementation/usage guides remain **conventions**, now
  **scoped** as runtime-guide-only and marked **provisional** against this
  newly surfaced design source.
- **Membership and mapping are unresolved.** The approved production mapping of
  all **601** runtime icons is **not** conflated with this Figma library.
  Whether the 601 assets are members of, or derived from, this library, and
  which Figma revision applies, is **unresolved**.

## Provenance and immutability

- **Accessed:** 2026-10-31 via the official Figma MCP, **read-only**, by Codex
  (session `cb67a792-4a02-4ef3-858d-30efbc79f94d`).
- **File / node IDs:** file `Eprjc6hw7QyMvvD01eGgGy`, section node `482:12945`.
- **Content snapshot text and capture SHA:** supplied by Codex. The capture
  SHA (`5be17544d471e06ff72b01db786a130ff33b9e6999cc14be00fbcc9b700869e7`) is
  the hash of the full-section screenshot retrieved by Codex via the official
  Figma MCP on 2026-10-31; it versions the **observed capture**, not the Figma
  revision, so `version_id` stays `null`.
- The source text snapshot recorded in this addendum and the screenshot capture
  hash record **access evidence** only; membership of the 601 runtime icons in
  this library and an immutable Figma revision remain **unresolved**.
- **No immutable version obtained.** MCP did not return an immutable Figma
  version ID. No `versionID`, no `commitSHA`, and **no Git SHA** is invented to
  stand in for a Figma version. Git commit SHAs do **not** version this Figma
  file. The Figma file is unchanged by this work.

## Exact source observations (verified by Codex: text + full screenshot)

All observations below are the **verified source text** read from the Figma
section, not inferences. Measured example-layer bounds are **observations**, not
automatically normative rules.

### Anatomy legend (node `4991:335`)

Exact text:

- `width` 24px
- `height` 24px
- `radius` `--corner-rounded-1`
- `fill` transparent / deep blue
- `stroke` `--stroke-color-primary`
- `stroke-width` 2pt
- `stroke-linecap` round
- `stroke-linejoin` round

### Notes legend (node `5009:1076`)

- Content covers **sorting and naming**.
- Size scale: XSmall **16**, Small **20**, Medium **24**, Large **32**, XLarge
  **36**, XXLarge **40**, XXXLarge **44**.

### Keyshape frames (24x24)

- `482:12955` circle
- `482:13005` square
- `482:13008` rect-portrait
- `482:13010` rect-landscape

### Adjacent example shapes in metadata (OBSERVED bounds, NOT keyshape rules)

- `482:13032` ellipse 22x22
- `482:13033` rect 20x20
- `482:13034` portrait 16x22
- `482:13035` landscape 22x16

These measured example-layer bounds are **observations only**. They are **not**
automatically normative keyshape bounding rules and are **not** asserted to be
equivalent to the actual keyshape frames above. Determining the real keyshape
bounds requires inspecting the actual frames or exports; **no automatic
normalization** is performed.

### Post-it: "Naming for Coloring" (screenshot node `320:13734`)

Exact text read directly from the screenshot:

- All strokes must be named `stroke`.
- All shapes that need fill should be named `fill`, similar to SVG style
  attributes.

This is a **Figma layer naming** convention. It is **NOT** an SVG filename
naming rule and **NOT** a statement about XML attribute presence in exported
SVGs. The structured-context fetch for this post-it was intercepted by a
CodeConnect suggestion; the text was therefore read directly from the
screenshot.

### Icon Set frame (node `5051:11598`)

The section includes a large Icon Set frame with existing components. Metadata
and screenshot confirm at least:

- Fullscreen `5051:12335`
- Link External `5051:12508`
- Undo Clock `5051:13421`
- Thumbnails `5051:13327`

No automatic name mapping or visual equivalence to runtime assets is inferred
from these.

## Comparative rule table: Figma anatomy vs existing runtime-guide rules

Each row compares a **verified Figma observation** to the existing audit's
runtime-guide rule. "Conflict" means the two sources state different things and
a human must reconcile them. No silent conversion or color resolution is done.

| Attribute | Figma (verified) | Runtime-guide audit rule | Status | Reconciliation needed |
|---|---|---|---|---|
| Canvas size | 24px × 24px | `24×24` canvas / `0 0 24 24` viewBox | **Agrees** | None on nominal size |
| Stroke width | `2pt` | default `1` (no explicit `stroke-width`) | **Conflict** | Clarify unit/export scaling; do **not** silently treat `2pt` as `2px` or `8/3px` |
| Fill | transparent / deep blue | root `fill="none"`; no fill attribute on any path | **Conflict** | Reconcile "deep blue" fill vs stroke-only / no-path-fill |
| Stroke color | token `--stroke-color-primary` | guide `#9747FF`; observed `#333333` | **Conflict (unresolved)** | No token value fetched; **no resolved color**, so **no** false "600 violations" against Figma |
| Corner radius | token `--corner-rounded-1` | proposed corner-radius checks (manual) | **Unresolved** | Token name known; **no resolved numeric value** |
| Size scale | 16/20/24/32/36/40/44 | not previously documented | **Newly documented** | Documents a size scale, **not** all asset canvas sizes |
| Linecap | round | `stroke-linecap="round"` | **Agrees** | None |
| Linejoin | round | `stroke-linejoin="round"` | **Agrees** | None |
| Layer naming | strokes `stroke`, fills `fill` | filename kebab-case / semantics | **Separate scope** | Figma **layer** naming ≠ SVG **filename** naming |
| Keyshape bounds | frames `482:12955/13005/13008/13010`; example bounds observed | proposed keyshape bbox tolerances (manual) | **Different / unresolved** | Inspect actual frames/export; **no automatic normalization** |

### Notes on specific conflicts

- **Stroke width `2pt` vs default `1`.** These do not reconcile by inspection.
  `2pt` is a literal Figma value; whether it maps to an SVG `stroke-width` of
  `2`, or scales under export, is **unknown**. This addendum records the literal
  `2pt` and the **unresolved** conversion. It does **not** convert `2pt` to
  `2px` or `8/3px`.
- **Fill transparent / deep blue vs no-path-fill.** The Figma anatomy lists a
  fill of "transparent / deep blue", while the asset rule is stroke-only with no
  fill attribute on any path. This is a genuine conflict for human review.
- **Stroke color token vs observed colors.** The Figma stroke is the token
  `--stroke-color-primary`. **No token value was fetched**, so there is **no
  resolved color**. The audit's `#9747FF` (guide) and `#333333` (observed) are
  **not** compared against a Figma color, and the original 600 "inconsistent"
  color rows are **not** restated as violations against Figma.
- **Corner radius token.** `--corner-rounded-1` is a known token **name** with
  **no resolved numeric value** fetched; no numeric comparison is made.

## Impact on the existing audit claims

- The audit's **quantitative** results are **unchanged**: still **601**
  inventory icons, still **12621** finding rows (601 × 21). Those remain a
  **historical comparison against the pinned runtime guides**. Nothing here
  claims the 601 were re-evaluated against Figma.
- What **is** invalidated: the implicit claim that the audit was a **complete
  design-guideline comparison**. A primary, user-authored design source
  (Figma) existed and was not in scope. The audit is now a **runtime-guide-only**
  comparison, and its design-guideline completeness is **pending reconciliation**.
- **Benchmark "missing concept" claims** need reassessment against the Figma
  Icon Set, not only against runtime filenames:
  - **Fullscreen** (`5051:12335`) and **history / clock** (Undo Clock
    `5051:13421`) are **present in the Figma set** and are therefore **not
    established as missing** if those candidates were selected. No automatic
    name mapping or visual equivalence is inferred.
  - Filename-absence results remain valid **only** against the pinned runtime
    inventory. Figma concept presence is **pending comparison**.
  - The remaining proposed concepts stay **proposed, not approved missing**.

## Readiness

- **Blocked** for any generation spike until this reconciliation is done.
- Existing test results are **unaffected**; no script or reproducibility rewrite
  is needed.
- This addendum is **draft** and does not change the PR readiness or review
  state.

## Next bounded step

Human reconciliation of the conflicts in the comparative table, specifically:

- the `2pt` vs default-`1` stroke-width unit/export question;
- the "deep blue" fill vs no-path-fill conflict;
- resolving the `--stroke-color-primary` and `--corner-rounded-1` token values
  before any color/radius comparison against Figma;
- the membership/mapping of the 601 runtime icons to this Figma library and the
  applicable Figma revision;
- reassessing benchmark "missing" claims (notably Fullscreen and history/clock)
  against the Figma Icon Set.

No icon generation and no name/visual-equivalence mapping should start until
those decisions are made.
