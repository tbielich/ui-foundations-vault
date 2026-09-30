---
id: adr.token-model-and-figma-projection
title: Token Model and Figma Projection
type: adr
status: accepted
owners:
  - ui-foundations
created: 2026-09-30
updated: 2026-09-30
authority: source
summary: Separates appearance axes from semantic roles and defines a deterministic, compatible Figma projection.
applies_to:
  - ui-foundations
related:
  references:
    - governance.precedence
    - governance.lifecycle
---

# ADR: Token Model and Figma Projection

## Context

The private UIF branch `3G6kkLVF0AKQO2BeCpixiN` currently projects brand
decisions as `Semantics (Brands)`, scheme decisions as `Appearance (Modes)`,
and fluid scale as `Typography (Fluid)`. Patterns bypass reusable semantics.
Runtime's Foundation-001 and DESIGN.md describe the old collection labels;
the old corner ADR additionally describes semantic projections absent in Figma.
Those conflicts are explicit migration inputs, not evidence that a role layer
already exists. UIF is separate from UILib and the official TUI Design System.

The current owner instruction authorizes this bounded implementation experiment.
The owner approved this ADR on 2026-09-30. It is accepted Vault governance.
Implementation beyond the bounded slice and a governance-pack release remain
separate work. Existing consumed packs are not silently rewritten.

## Decision

Use `Core → Appearance {Brand, Scheme, Scale} → Semantics → Patterns`.
Arrows describe increasing abstraction; aliases point toward dependencies.

- **Core** owns literal primitives, including qualified private Brand A/B/C
  source palettes. Palette qualification identifies provenance, not UI meaning.
- **Appearance / Brand** owns the full visual identity: palette, typography,
  shape and, where specified, spacing, sizing and other visual properties.
  Shape is one example of Brand responsibility, not its boundary.
- **Appearance / Scheme** selects light/dark realizations. It may depend on
  Brand or Core. Brand and Scheme are orthogonal contextual axes, not one mode.
- **Appearance / Scale** projects scalar and fluid typography/layout values.
  Min/Max are interpolation endpoints, not light/dark modes. It may depend on
  Core or Brand; typography and layout endpoints may be brand-specific.
- **Semantics** owns reusable purpose and matched interaction-state roles.
  It aliases Appearance; it does not select brands or schemes.
- **Patterns** expose family/variant/part/property/state slots and consume
  Semantics. Pattern-to-pattern dependencies are replaced by shared roles.

Figma projects these responsibilities as `Core (Primitives)`,
`Appearance (Brand)`, `Appearance (Scheme)`, `Appearance (Scale)`,
`Semantics (Roles)` and `Patterns (UI)`. `Interaction (States)` remains an
explicitly excluded prototype helper collection, not a foundation layer.

### Independent axes, dependent values

Brand, Scheme and Scale are independently selected contextual axes, not
independent sets of visual values. A surface can depend on Brand × Scheme;
responsive typography or layout can depend on Brand × Scale, and a value may
depend on all three where its contract requires it. Appearance resolves that
context while Semantics and Patterns retain stable purpose and slot names.
Do not duplicate every value by brand when the brands intentionally share it.

### Preserve brand identity during accessibility repairs

Contrast compliance and brand identity are independent acceptance gates. A
contrast repair must preserve each brand's intended hue, inversion and visual
role. Do not replace distinct brand action borders or foregrounds with one
shared neutral value merely because that value passes a contrast threshold.
Use existing brand palette primitives and scoped Brand × Scheme projections;
shared neutral values are allowed only where the contract intentionally shares
them. Preserve the distinction between filled Action Surface, paired Content,
Action Foreground and action Border.

Verify every affected Brand × Scheme × State combination for both contrast and
its expected brand-specific realization. Include assertions that distinguish
brands, not only generic contrast thresholds. A repair passes only when both
gates pass. Changes to shared semantic aliases require checking all consuming
patterns before merge.

The 30 September 2026 dark Outline repair demonstrated this failure: aliasing
all brands to a neutral Strong Dark border made all outlines white. The
correction keeps Brand A white and restores Brand B purple and Brand C blue
through a dedicated Brand-owned dark action-border projection.


The current bounded Scale projection contains shared literal Min/Max endpoints
and Core bridges. It does not yet implement brand-specific endpoint selection.
This is a recorded projection limitation, not a rule that Scale must be
brand-neutral. Adding such selection requires a separately bounded contract
and parity verification; this clarification changes no existing token values.

### Naming and projection

Use slash-delimited segments in Figma and dot-delimited logical paths.
New semantic color roles use `Color/<purpose>/<role>/<state>` (or
`Color/<role>/<state>` for the default canvas pair). Pattern state is last:
`<family>/<variant?>/<part?>/<property>/<state?>`. Preserve `Active` as the
existing runtime name for the pressed interaction; do not add competing state
vocabularies. Size variants and property axes are not interaction states.

Names contain no free-form whitespace. Existing IDs and explicit WEB syntax
are stable projection keys. Each rename has an ID-based before/after mapping;
existing CSS names and export paths may be retained through explicit adapter
metadata. New public role properties use `--uif-semantic-*`; new appearance
bridge properties use `--uif-appearance-*`. This bounded migration does not
perform the separate breaking namespace migration of legacy primitives.
Do not derive aliases by guessing a name when an ID is available.

### Surface, Content and Foreground

Surface is a filled region; Content is text or icon placed on that Surface.
Declare Surface↔Content pairs with matching purpose and state, including
Default, Hover, Active and Focus for action controls. Values may be identical
across states; their contracts are independently addressable and verified.
Disabled pairs remain explicit but are excluded from the normal-text contrast
gate. Pair checks cover every Brand × Scheme combination, composite alpha over
a declared background, and report the actual ratio (4.5:1 for normal text,
3:1 for large text or required non-text boundaries where applicable).

Foreground is an independently rendered action/status mark or text on a
surrounding surface; it is not interchangeable with Content on a filled action.
Its accessibility evaluation must declare that surrounding surface. A structural
pair cannot by itself certify rendered accessibility or focus visibility.

### Brand-owned shape

Brand owns shape choices; Semantics gives them reusable purposes. Project the
existing Button, Card, Modal, Input, Container and Tooltip corner choices as
Control, Panel, Dialog, Field, Container and Floating shape roles respectively.
Keep all existing brand values; do not collapse different values because two
roles currently look similar. Existing CSS corner names remain compatibility
projection syntax, not the new semantic vocabulary.

### Scoped variables

Set scopes from actual use: Surface uses frame/shape fills, Content uses
text/shape fills, Foreground uses text/shape/stroke, borders use stroke color,
shape uses corner radius, typography uses its font/line-height scope, spacing
uses gap or dimensions. Low-level shared palettes may use ALL_FILLS and
STROKE_COLOR. Unclassified/prototype helpers keep an explicit recorded scope
exception; never guess a restrictive scope that invalidates a current binding.

## Bounded Migration

1. Persist a pre-change variable snapshot and an ID-based migration manifest.
2. Rename existing appearance collections, preserving collection/mode IDs.
3. Add semantic roles and necessary appearance bridges; retain original
   variables and values. Route all existing pattern aliases through roles.
4. Normalize display names while retaining established WEB syntax/export paths.
5. In UIF-RUN, reconcile only affected IDs, aliases, scopes and new projections.
   Keep compatibility filenames/package exports and documented code-only
   projections. Replace the conflicting code-only Liquid scale with the actual
   Figma Scale endpoints and retain its former values as execution evidence.
   Do not overwrite unrelated primitive values from a broad sync.
6. Verify alias closure, cycles, allowed layer edges, ID/name/CSS uniqueness,
   unchanged resolved values, projection parity, contrast pairs, and required
   Runtime checks. Persist separate structural and accessibility outcomes.

Existing literal pattern behavior (`inherit`, `underline`) and literal numeric
slots remain a recorded legacy exception in this first safe slice. Converting
those, moving immutable Figma collection membership, deleting compatibility
variables, repairing unrelated palettes, component geometry, releases and
publishing library changes are outside this execution. No UILib brand values,
architecture, repositories or terminology are imported.

## Consequences

- Humans see responsibilities matching the architecture; compatibility labels
  survive only in traceable adapters.
- Agents can check scope and parity by ID without reconstructing chat history.
- The system gains an explicit semantic dependency boundary with more aliases;
  generation must preserve dynamic brand/scheme references and alpha values.
- Existing code-only token projections remain visible exceptions. This slice
  does not claim complete library synchronization or full accessibility.
- This accepted ADR can guide work; publication in a consumed governance pack
  remains a separate release. Runtime retains the original bounded execution
  authorization as historical evidence.

## Alternatives Considered

- Rename collections only: smallest but leaves semantic and state-pair gaps.
- Rebuild every variable and public CSS name: cleaner at once, but breaks IDs,
  bindings and consumers and expands the task into a release migration.
- Add a role layer with stable IDs and compatibility projections: selected;
  supplies the missing contract while preserving current visual values.

## Verification

The migration manifest enumerates source branch, collection projection,
before/after variable IDs, alias edges, compatibility export paths and exceptions.
Re-read Figma after writes independently. Verify every affected exported ID,
all state pairs and all six Brand × Scheme combinations against that read.
Run Runtime's `npm run lint`, `npm run test:unit` and `npm run ci:check`.
Report failures and pre-existing drift separately; a passing structural gate
must never be represented as an accessibility certification.
