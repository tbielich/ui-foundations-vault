---
id: lesson.icon-audit-45
title: Icon Set Audit (Issue 45)
type: lesson
status: draft
owners:
  - ui-foundations
created: 2026-10-31
updated: 2026-10-31
authority: derived
summary: Research audit of the runtime SVG icon set with a draft grammar, reference set, and benchmark concepts; counts quantitative-verified by the independent verifier, grammar and visual findings draft pending human review.
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
    - pattern.base.icon
    - governance.precedence
    - agent-capability.vault-maintainer
provenance:
  sources:
    - type: issue
      role: source
      repository: ui-foundations-vault
      number: 45
    - type: repository
      role: derived-from
      repository: ui-foundations-runtime
      path: src/assets/icons
    - type: repository
      role: supporting-source
      repository: ui-foundations-runtime
      path: docs/agentic/icon-creation.md
    - type: repository
      role: supporting-source
      repository: ui-foundations-runtime
      path: site/patterns/icon.md
verification:
  status: quantitative-verified
  evidence:
    - reproducibility.md
    - summary.json
  note: Independent verifier (Codex) regenerated and confirmed the counts, per-rule totals, and duplicate groups against the pinned source snapshot. Grammar classification and all visual/geometry findings remain draft, pending human governance and visual review. Kiro did not run the tool.
assumptions:
  - Quantitative counts, duplicate groups, and per-rule totals are quantitative-verified by the independent verifier against the pinned source snapshot; the grammar and every visual/geometry judgement remain draft pending human review.
  - The implementation and usage guides are conventions, not approved numeric governance.
---

# Icon Set Audit (Issue 45)

## Post-PR66 addendum: new primary design source

After PR66 the user supplied an **existing icon guideline they authored** in
Figma (UI Assets Library, file `Eprjc6hw7QyMvvD01eGgGy`, section node
`482:12945` "Icons"). This is a **primary, user-identified design source** that
was **not** in scope when this audit ran. Its existence **invalidates the claim
that this audit is a complete design-guideline comparison**: the audit compared
assets only to the runtime implementation/usage guides, so it is now a
**runtime-guide-only** comparison with design-guideline completeness **pending
reconciliation**.

The **quantitative checks are unchanged**: still **601** inventory icons and
**12621** finding rows (601 × 21), and they remain a **historical comparison
against the pinned runtime guides**. Nothing was re-evaluated against Figma.
Readiness is **blocked for any generation spike until reconciliation**. See
[figma-guideline-addendum.md](figma-guideline-addendum.md) for the verified
Figma observations, provenance, and the comparative rule table.

## Status of this document

This is a research artifact. It does **not** promote any implementation
convention to approved governance. All numeric expectations in the companion
`grammar.json` are marked `proposed`. The quantitative sections below have been
filled from the independent verifier's (Codex) run of the audit tool against the
pinned source snapshot and are **quantitative-verified**. The grammar
classification and every visual, geometry, naming, and RTL judgement remain
**draft** and await human governance and visual review. Kiro authored the
tooling and this report; Kiro did **not** run the tool, and the verified counts
come from Codex's run, not from Kiro.

## Sources and authority

| Source | Repository / path | Role | Authority for this audit |
|---|---|---|---|
| Issue 45 | ui-foundations-vault#45 | task source | Scope and constraints |
| Icon assets | ui-foundations-runtime `src/assets/icons/*.svg` | audited input | Observed values only |
| Implementation guide | ui-foundations-runtime `docs/agentic/icon-creation.md` (status: active) | convention | **Not** approved governance |
| Usage guide | ui-foundations-runtime `site/patterns/icon.md` | component usage scope | **Not** asset-level governance |
| Derived pattern draft | vault `patterns/base/icon.pattern.md` (status: draft, authority: derived) | derived draft | **Not** canonical |
| Precedence | vault `governance/precedence.md` | governance | Canonical conflict order |

Pinned provenance:

- Runtime snapshot: `ui-foundations-runtime@aa153b79668df7c3b655a96d9541171de1899580`
- Vault base: `995c580ce6f162fbf9baa2f5e4819da1aa3384d8`

**Input source ownership.** The runtime `scripts/generate-icon-list.mjs` reads
`src/assets/icons/*.svg`, and `build.mjs` Stage 1 invokes that script. That is
the evidence that `src/assets/icons` is the **owned input** directory. The
audit therefore points `--source` at that directory and treats any generated
copies elsewhere as out of scope.

**No external brand authority.** No external brand PDF was supplied. This audit
makes **no claim** of external authority or manual design provenance for any
numeric value. The Vault remains the canonical governance surface.

## Exclusions

- Generated/derived copies of icons (any build output directory) are excluded;
  only the owned input directory is audited.
- No rendering, rasterization, pixel comparison, or geometry solving is
  performed. Anything that depends on rendered output is reported as
  `requires-visual-review`.
- Kiro had no shell or GitHub authority; its writes were limited to `tools/`
  and `vault/research/icon-audit-45/`. Codex ran the independent checks and
  handles draft PR publication. No production icon changes, normalization,
  generation, new provider integration, or merge were performed.

## Counts (quantitative-verified)

The pinned source directory contains **601** SVG files (the `icon_count` the
tool reports for `src/assets/icons` at the pinned snapshot). The numbers below
are taken verbatim from the independent verifier's (Codex) regenerated
`summary.json`; Kiro did not run the tool. The **21** draft rules applied across
the **601** icons produce **12621** finding rows (601 × 21).

- Icons in scope: **601**
- Draft rules applied: **21**
- Finding rows total: **12621** (601 × 21)
- Row status totals (`(icon, rule)` pairs):
  - pass: **7786**
  - documented-exception: **1**
  - inconsistent: **602**
  - guideline-gap: **1202**
  - requires-visual-review: **3030**
- Affected-icon totals (distinct icons with at least one row of that status,
  **not** the same axis as row totals):
  - pass: **601**
  - documented-exception: **1**
  - inconsistent: **600**
  - guideline-gap: **601**
  - requires-visual-review: **601**
- Duplicate candidate groups (signatures, not rendered-visual equivalence):
  - exact-byte: **15**
  - structural (ordered): **16**
  - order-independent: **16**
  - semantic-overlap: **95**
- Stroke color vs the documented `#9747FF` (`impl-guide.stroke.color`):
  **1** pass / **600** inconsistent. Only `tui-extras.svg` uses `#9747FF` and
  passes; the remainder use `#333333` and are inconsistent with the
  implementation guide.
- Observed stroke-color distribution (NON-NORMATIVE statistic, not the pass
  criterion): `#333333` on **1204** path-level observations, `#9747FF` on
  **2**. This distribution is reported for context only and carries no
  normative force.

Row totals count `(icon, rule)` pairs; affected-icon totals count distinct
icons touched by a status. These two axes are reported separately and must not
be conflated (e.g. `inconsistent` is **602** rows but **600** distinct icons).
The only `documented-exception` is the one dual-state name `thumbs-up--down` on
the `--` semantics rule (**1** row, **1** icon); every other outcome is pass /
inconsistent / guideline-gap / requires-visual-review, and `0` documented
exceptions elsewhere is a valid result.

These counts are quantitative-verified. They do **not** verify the correctness
of the grammar classification or of any visual, geometry, naming, or RTL
judgement, all of which remain draft pending human review.

## Observed conventions and their source status

The audit keeps two axes separate (see `grammar.json`): each rule declares a
**field classification** (`class`: hard / heuristic / judgment) independent of
its **draft status**, and an **evaluation** mode (`automated` = decided
deterministically by the tool; `manual` = surfaced for human/visual decision,
never auto-passed). The classification is defined by **how the rule is decided**,
not by how common the observed convention is. Machine-checkability does not by
itself confer policy legitimacy: a rule being automatable says nothing about
whether the underlying convention is approved governance.

- **Hard** = the rule can be validated **deterministically**, regardless of how
  prevalent the convention is in the set. A near-universal convention is not
  what makes a rule hard, and a convention that is deterministically checkable
  is hard even if most assets violate it. Hard rules in this draft are the
  deterministic presence/value checks: canvas `24×24`, root `fill="none"`,
  effective `stroke-linecap="round"`/`stroke-linejoin="round"`, no explicit
  `stroke-width` on any element (incl. inherited widths), the `fill` attribute
  omitted on every path, `stroke="#9747FF"` compared to the guide's documented
  value, kebab-case name shape, no raster content, and the presence detection of
  unevaluated `<style>`/`<use>`/class references. These are still conventions,
  not approved governance.
- **Heuristic** = an **approximation** that compares against observed values
  within an **explicit numeric tolerance**. Every heuristic rule in this draft
  carries a concrete proposed numeric tolerance (e.g. a keyshape bounding-box
  absolute-error bound in SVG user units); there is no vague "small" or "~"
  allowance standing in for a tolerance. These tolerances are documented
  **proposals**, not executed checks; the tool surfaces them for review and does
  not assert them.
- **Judgment** = requires a **human** decision (rendered geometry, visual, or
  semantic). This covers safe area, optical correction, corner radii, path
  ordering, RTL, semantic naming, `--` semantics, mask/clip structure, the
  allowed-element inventory, transform presence interpretation, and render-time
  mask applicability. Where a rule has no numeric metric and no deterministic
  automated presence check, it is classified `judgment` and routed to human
  approval rather than being dressed up as machine-verified.

## Guideline gaps

1. **Stroke color contradiction (guide vs reality).** The implementation guide
   states explicitly that every `<path>` uses `stroke="#9747FF"`. That documented
   value is the audit's comparison criterion: `#9747FF` **passes**
   (`impl-guide.stroke.color`), and any other concrete color is **inconsistent**
   with the implementation guide. In the pinned snapshot only `tui-extras.svg`
   uses `#9747FF`; the rest use `#333333` and are therefore inconsistent with the
   guide. This is a convention conflict against the guide, not a production
   defect, because the guide is a convention and not approved governance. The
   observed color distribution (most assets `#333333`) is reported separately in
   `summary.json` as a **non-normative** statistic; it is never used as the pass
   criterion, and `#9747FF` is **not** described as a placeholder or authoring
   color (the guide does not call it that).
2. **Asset color vs render color (different scopes).** Assets hardcode a literal
   stroke color, while the usage guide says the consuming component applies the
   SVG as a CSS `mask-image` with `currentColor`. Whether that render-time
   technique neutralizes the asset's hardcoded color is a **different scope**
   (component usage), which this asset-level audit does not test. The audit
   therefore emits `requires-visual-review` on
   `usage-guide.color.mask-applicability` when an asset carries a hardcoded
   color, rather than inventing an approved exception to the asset-level color
   rule. There is **no** documented exception to the asset color rule, and `0`
   documented exceptions for color is a valid outcome.
3. **Path ordering self-contradiction.** The guide says "keyshape path first,
   then inner paths" and, in the same section, cites `shield-check.svg` as
   "checkmark path, then shield path". The assets are inconsistent
   (`checkmark-circled.svg` draws the circle first; `shield-check.svg` draws the
   checkmark first). Path ordering cannot be auto-verified and is never
   auto-passed.
4. **Circle keyshape encodings.** At least two different circle path encodings
   exist for "the same" keyshape, despite the guide saying to copy the circle
   verbatim from `plus-circled.svg`.
5. **Directional `--` overload.** The guide documents the double dash as a rare
   dual-state marker and names exactly one such icon (`thumbs-up--down`). In the
   snapshot it is also widely used for a single direction (`arrow--left`,
   `chevron--down`, `aircraft--right`, `hand-pointing--left`,
   `ellipsis--vertical`, the `-circled` directional variants, etc.). The audit
   separates **lexical** naming (`impl-guide.naming.kebab-case`, which judges the
   string shape) from **semantic** judgement
   (`impl-guide.naming.double-dash-semantics`). `thumbs-up--down` is the one
   documented dual-state name and is marked `documented-exception`; every other
   `--` name is `requires-visual-review` because the directional/other meaning of
   `--` is not documented. A `--` name is never auto-passed just because it is
   lexically valid.
6. **No asset-level accessibility or RTL semantics.** Accessibility is applied
   by the consuming component; assets carry no title/desc/aria, and RTL
   mirroring for directional icons is undocumented.
7. **Heavy/bold weight by geometry.** `-heavy`/`-bold`/`-ultrabold` weight comes
   from doubled outline geometry, not a stroke attribute. These filenames are
   **not** auto-exempted from any rule.
8. **Undocumented clip/mask/defs structure.** Two icons (`robot-smile.svg`,
   `sign-directions.svg`) wrap their content in `<g clip-path="url(#...)">` with
   a `<defs><clipPath><rect width="24" height="24" fill="white"/></clipPath>`
   clipping to the canvas bounds — an export artifact the guide does not
   document. The audit inventories these structures (including the two white
   `rect` clip bounds and the `white` fill as a hardcoded color) and emits
   `requires-visual-review` on `impl-guide.structure.mask-clip-defs`. Being
   vector-only is **not** treated as full structure validation; the clipping
   effect needs review.

## Unresolved visual decisions

The following cannot be decided statically and are flagged
`requires-visual-review`:

- Inner-symbol safe-area insets within keyshapes.
- Optical centering/correction (e.g. `star`, `heart`, `sun-tui`).
- Corner radii and internal spacing.
- Path ordering correctness per icon.
- Clip/mask/defs structural variants (`robot-smile`, `sign-directions`).
- Whether a `--` name is a dual-state icon or an overloaded directional use.
- Whether a hardcoded asset color is neutralized by the runtime CSS mask
  (different scope, not tested here).
- Whether structural, order-independent, and semantic-overlap duplicate
  **candidate signatures** are true duplicates. These are candidates only; the
  tool does not assert rendered-visual equivalence.

## Prioritized recommendations

1. **Resolve the stroke-color contradiction** between the implementation guide
   (`#9747FF`) and the asset reality (`#333333`) before any grammar rule about
   color is promoted. This is the highest-impact inconsistency.
2. **Decide the canonical path-ordering rule** (or explicitly declare it
   unconstrained) so the guide stops contradicting itself.
3. **Disambiguate the `--` convention** (dual-state vs directional).
4. **Decide asset-level accessibility/RTL posture** (confirm it stays at the
   component layer, or add asset metadata).
5. **Only after human ratification**, promote selected `proposed` tolerances in
   `grammar.json` to governed values. Until then they remain proposals.

## Reference set and benchmark concepts

- `reference-set.json` curates existing icons spanning the structural categories
  (simple, complex, rounded, angular, diagonal, enclosed, open, overlays,
  directional, optical-correction-review). Optical-correction entries are review
  candidates, not verified corrections.
- `benchmark-concepts.json` proposes plausibly-missing **distinct** concepts
  checked for name absence and semantic overlap against the **601**-file pinned
  inventory. Filename-absence remains valid **only** against the pinned runtime
  inventory; Figma concept presence is **pending comparison**. The Figma Icon Set
  (node `5051:11598`) contains a **Fullscreen** (`5051:12335`) and an **Undo
  Clock** (`5051:13421`) component, so the `fullscreen` and `clock-history`
  candidates are **not established as missing** against Figma (no automatic name
  mapping or visual equivalence inferred). The remaining selected concepts stay
  **proposed, not approved missing**. See
  [figma-guideline-addendum.md](figma-guideline-addendum.md). Every proposed name was confirmed absent; every icon cited under
  `semantic_overlap` was confirmed to exist, so name absence does not prove the
  concept is visually absent. Each selected candidate therefore carries
  `review_required: true` for human semantic/visual confirmation before
  creation. Highly-redundant concepts that are almost certainly already
  satisfied (`link-external` vs `target-blank`/`share-box`, `qr-code` vs
  `scan-code`, `verified` vs `badge-check`) are held out of the selected set in
  `conditional_reserve` and are not proposed for creation unless a human
  confirms the redundancy is false. No SVGs are generated.

## Readiness

- Tooling: authored, stdlib-only, with fixture tests, and revised to address the
  independent-review defects (color authority, inherited stroke-width, literal
  vs effective fill, CSS/style/namespace handling, `--` semantics, stable
  repository-relative paths, mask/clip structure row, rule class vs status). Kiro
  did **not** run the tool and makes no claim of having executed it. The
  independent verifier (Codex) ran the tool and its fixture tests against the
  pinned snapshot; the counts in this report come from that run.
- Evidence JSON (`inventory.json`, `findings.json`, `summary.json`): regenerated
  by the verifier from the revised tool against the pinned snapshot and
  **quantitative-verified**. The counts, per-rule totals, and duplicate groups
  in this report are taken verbatim from that `summary.json`. The JSON is not
  hand-edited.
- Governance drafts (`grammar.json`, `reference-set.json`,
  `benchmark-concepts.json`): `draft` status, awaiting human review. Rule
  classifications, proposed numeric tolerances, reference-set curation, and
  benchmark-concept selections are **not** verified by the count run and remain
  draft.
- This report: quantitative sections are filled and **quantitative-verified**;
  the grammar classification and all visual/geometry/naming/RTL findings remain
  **draft** pending human review. Prose grammar and copy have not had a human
  visual review pass.

- Figma design source (post-PR66): a user-authored Figma icon guideline (file
  `Eprjc6hw7QyMvvD01eGgGy`, node `482:12945`) was supplied after this audit ran.
  It is recorded with provenance in
  [figma-guideline-addendum.md](figma-guideline-addendum.md) and in the
  `grammar.json` `design_guideline_rules`. The existing runtime-guide rules are
  now scoped **runtime-guide-only** and **provisional**; reconciliation with the
  Figma source is pending. No immutable Figma version ID was obtained and no Git
  SHA is used to version the Figma file.

Not ready for promotion to governance. Blocked for any generation spike until
the Figma reconciliation is done.

## Next bounded step

The next step is **human** governance and visual review — not another tool run.
A reviewer should evaluate the implementation/usage guide against the audited
assets and decide:

- the stroke-color contradiction (`#9747FF` guide vs `#333333` assets);
- the canonical path-ordering rule (or that it is unconstrained);
- the `--` naming convention (dual-state vs directional);
- asset-level accessibility and RTL posture;
- geometry-dependent items (safe area, optical correction, corner radii,
  mask/clip structure) flagged `requires-visual-review`;
- which `proposed` numeric tolerances in `grammar.json`, if any, to ratify.

No generator spike and no icon creation should start until those decisions are
made. There is **no** further rerun of the audit tool planned as a next step;
the counts are already verified and `reproducibility.md` records the exact,
self-contained command if a re-run is ever needed. Everything in this artifact
remains **draft** until a human ratifies it.

## Independent execution receipt

[verification.json](verification.json) records the ACP sessions, returned defects,
source commit and blob hashes, independent checks, and remaining review limits.
The initial ACP turn was blocked; the repair and final documentation turns
completed. Quantitative verification does not approve the draft grammar.
