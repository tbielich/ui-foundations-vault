---
id: pattern.base.dialog
title: Dialog Pattern
type: pattern
status: draft
owners:
  - ui-foundations
created: 2026-09-18
updated: 2026-09-18
authority: derived
summary: Agent-readable base contract for modal dialogs that require focused user interaction.
---

# Dialog Pattern

## Metadata

- id: `pattern.base.dialog`
- type: base
- status: draft
- implementation evidence: RUN issue #33 and preserved draft PR #278
- related standards: native HTML `<dialog>`, modal dialog semantics, keyboard and focus-management requirements
- related component: current Runtime draft uses `Modal`

## Intent

Provide a focused interaction surface for decisions or tasks that temporarily require the user's attention while preventing interaction with the rest of the page.

## Problem

Interfaces sometimes need a bounded interaction that must be completed, confirmed, cancelled, or explicitly dismissed before the user returns to the underlying page. Recreating modal semantics with generic containers introduces avoidable focus, inertness, keyboard, and accessibility risk.

## Use When

- Use for a short, focused decision or task that must temporarily interrupt the current page context.
- Use for confirmation when an action has meaningful consequences.
- Use an urgent alert-style dialog only when immediate acknowledgement or action is required.

## Do Not Use When

- Do not use a dialog for passive status messaging; use inline feedback or notification patterns.
- Do not use it for contextual supplementary content that does not block the page; use a popover or inline disclosure.
- Do not place long, navigation-heavy, or page-like experiences inside a dialog when a dedicated page is more appropriate.
- Do not use generic `div`-based modal behavior when native `<dialog>` can satisfy the requirement.

## Standard Basis

The preferred semantic baseline is native `<dialog>` shown modally with `showModal()`.

Native modal behavior should be used for top-layer placement, background inertness, focus containment, and the Escape-driven `cancel` event rather than reimplemented as parallel JavaScript behavior.

Implementation evidence from RUN draft PR #278 is informative only; this pattern governs any reintegration after review.

## Anatomy

- Dialog surface
- Heading
- Optional description
- Content/body
- Primary action
- Optional secondary/cancel action
- Optional close control
- Native backdrop

## Structure Contract

| Item | Classification | Contract |
|---|---|---|
| Native dialog | Required | Use a `<dialog>` element for the modal surface. |
| Heading | Required | Provide an accessible name, normally through a visible heading. |
| Description | Optional | Associate supporting text when it materially helps users understand the decision or task. |
| Primary action | Required for decision dialogs | Performs the principal confirm/acknowledge action. |
| Cancel action | Conditional | Present when cancellation is allowed and useful. |
| Close control | Conditional | Present only when the dialog is dismissible. |
| Backdrop | Required for modal presentation | Use the native dialog backdrop; do not create a competing overlay interaction model. |

## Implementation Naming Contract

### CSS Class Contract

- Public dialog classes use the `uif-` prefix.
- The current Runtime draft uses the `uif-modal*` class family.
- Existing public Runtime naming must not be renamed as part of reintegration unless a separate reviewed naming decision explicitly approves that migration.
- Use class chains rather than BEM element or modifier syntax.

### Token Contract

- Public component token slots use the current Runtime component namespace, `--uif-modal-*`, until a separate naming decision changes it.
- Reuse semantic/core tokens for generic spacing, typography, borders, targets, and layout where component-specific slots do not add semantic value.
- New component-specific tokens require an authoritative token source; agents must not invent Figma variable identities.
- Runtime-only dynamic custom properties, if needed, must be explicitly classified as code-only extension points.

### Data Attribute Contract

- Native attributes and element state take precedence over UIF-specific data attributes.
- `open` is native state on the rendered `<dialog>`.
- Data attributes may identify action intent such as confirm, cancel, or dismiss for event delegation.
- Data attributes must not replace accessible names, native `open` state, or ARIA relationships.

### Native / ARIA Precedence

- Prefer native `<dialog>` plus `showModal()` for modal presentation.
- Use a visible heading associated as the accessible name, for example through `aria-labelledby`.
- Use `aria-describedby` only when a concise description improves understanding.
- Do not add redundant `aria-modal` when native modal-dialog behavior already provides the semantics unless testing demonstrates a concrete compatibility need.
- Do not recreate focus trapping or page inertness with a second JavaScript system when native modal behavior is active.
- Urgent alert-dialog semantics are a separate semantic choice and must not be inferred only from visual styling.

### Agent Freedom Boundary

Agents must not change:
- native dialog semantics,
- whether a non-dismissible dialog can be escaped,
- accessible naming relationships,
- confirm/cancel/dismiss event meaning,
- public naming,
- size/density architecture.

Agents may derive:
- internal implementation structure,
- event delegation mechanics,
- tokenized visual expression,
- documentation examples,
provided the governed semantics remain intact.

## Required Semantics

- Modal presentation uses `showModal()`, not only the boolean `open` attribute.
- The dialog has a programmatically determinable accessible name.
- Background page content is not interactive while the modal dialog is open.
- A dismissible dialog provides at least one clear dismissal path.
- A non-dismissible dialog must not expose a close control or backdrop/Escape dismissal behavior.
- Confirm, cancel, and dismiss are distinguishable consumer outcomes.
- Closing the dialog must leave focus in a predictable and usable location.

## Behaviour

### Open

- Consumer intent to open the component results in native modal presentation through `showModal()`.
- Repeated open synchronization must not throw when the dialog is already open.

### Confirm

- The primary action emits or returns a distinct confirm outcome.
- Whether confirm closes the dialog is part of the component contract and must be consistent across surfaces.

### Cancel

- A cancel action emits or returns a distinct cancel outcome.
- Cancellation closes a dismissible dialog.

### Dismiss

For a dismissible dialog, supported dismissal mechanisms may include:
- close control,
- Escape / native `cancel` event,
- backdrop interaction.

All enabled dismissal paths must converge on the same close-state contract.

For a non-dismissible dialog:
- prevent the native `cancel` event from closing the dialog,
- omit the close control,
- do not close on backdrop interaction.

### Backdrop Interaction

Backdrop-click dismissal is optional behavior, not an inherent native `<dialog>` guarantee. If supported, hit testing must distinguish clicks outside the dialog box from clicks inside the dialog content.

### Focus

- Rely on native modal behavior for initial focus containment and background inertness.
- The implementation must verify where initial focus lands for the supported content structures.
- On close, focus should return to the invoking control when that control still exists and is focusable; otherwise use a documented fallback.
- Do not maintain a competing manual focus-trap loop unless a verified platform gap requires it.

## Keyboard Interaction

- `Tab` / `Shift+Tab`: move among focusable controls within the active modal context.
- `Escape`: requests cancellation through the native `cancel` event.
- In dismissible mode, Escape may close after the component processes the cancel outcome.
- In non-dismissible mode, Escape must not close the dialog.
- `Enter` behavior follows the focused native control; do not globally synthesize confirm without an explicit form/action contract.

## Accessibility Rules

- Every dialog has an accessible name.
- Visible heading and programmatic name should refer to the same user-facing concept.
- Descriptions are concise and associated only when useful.
- Focus indicators remain visible for all interactive controls.
- Destructive or irreversible actions are identified through content and action labeling, not color alone.
- The component must not contain another modal interaction that produces ambiguous focus ownership.
- Reduced-motion and zoom/reflow requirements apply to any dialog transition or constrained layout.

## Token Requirements

Expected token concerns include:
- dialog surface background,
- dialog border/radius where component-specific semantics exist,
- backdrop appearance,
- text and action states through existing semantic/component tokens,
- spacing through semantic size tokens,
- focus styling through established focus tokens.

Size values that only represent general layout widths should prefer existing container/size semantics unless a reviewed component token is justified.

## Token Slot Matrix

| Part | Property | State / Variant | Required semantic token slot | Notes |
|---|---|---|---|---|
| Surface | Background | Default | Modal surface slot | Component-specific if required across brands/modes. |
| Surface | Radius | Default | Modal radius slot | Component-specific if design requires it. |
| Backdrop | Background | Open | Modal backdrop slot | Must preserve sufficient separation without encoding semantics by opacity alone. |
| Actions | Spacing | Default | Semantic spacing | Prefer existing semantic size tokens. |
| Focus | Indicator | Focus-visible | Existing focus semantics | Required on interactive controls. |

## States

- Closed
- Open
- Confirming/actionable
- Dismissible
- Non-dismissible

Transient application states such as loading or error are composition concerns unless separately specified.

## Variants

### Confirmation

Used when the user must confirm or cancel a decision.

### Alert-style

Used only for urgent content that requires immediate acknowledgement or action.

The exact ARIA role for an alert-style variant remains an open semantic review question; visual `alert` styling alone must not change the role.

## Responsive / Density Behaviour

Dialogs must remain usable at high zoom and narrow viewports without clipping essential controls.

General density is not a dialog-specific concern. Component-level `s/m/l` sizing is not yet governed by this draft and must not be treated as implementation-ready until reconciled with the ecosystem density/responsive strategy.

## Component Dependencies

- Button / action controls
- Icon, when a close control uses an icon
- Existing semantic typography, spacing, focus, and container tokens

## Minimum Component API

| API | Classification | Default | Contract |
|---|---|---|---|
| `open` | Required state | `false` | Synchronizes consumer state with native modal open/close behavior. |
| `dismissible` | Optional | `true` | Enables close/Escape/backdrop dismissal paths when supported. |
| `title` or equivalent named slot | Required | None | Supplies the visible and programmatic dialog name. |
| `description` or equivalent slot | Optional | None | Supplies supporting text and description relationship. |
| confirm action | Conditional | None | Required for decision dialogs. |
| cancel action | Conditional | None | Required when cancellation is part of the task. |
| `variant` | Optional | `confirmation` | May distinguish confirmation from reviewed alert-style semantics. |

A `size` API is intentionally not part of the minimum API in this draft.

## Consumer Event Contract

The implementation should expose distinguishable outcomes for:
- confirm,
- cancel,
- close/dismiss.

Event names and payload shape are implementation API decisions that require consistency across Web Component documentation, tests, and generated examples. They should not expose internal DOM details.

## Agent Freedom

| Decision Area | Freedom Level | Allowed Choices | Requires Human Review |
|---|---|---|---|
| Native modal primitive | none | `<dialog>` + `showModal()` | Yes, for an alternate modal primitive. |
| Accessible naming | none | Heading/name relationship | Yes, for alternate semantics. |
| Dismissal internals | limited | Event delegation, backdrop hit testing | Yes, for changing enabled dismissal mechanisms. |
| Visual expression | guided | Tokenized surface/spacing/states | No, within token contract. |
| Public Modal/Dialog naming | none | Preserve current Runtime naming pending decision | Yes. |
| S/M/L size API | none | Do not introduce from this draft | Yes. |

## Implementation Contract

A RUN reintegration derived from this pattern must:
- start from the preserved implementation only as evidence,
- use native `<dialog>` modal behavior,
- avoid a parallel legacy overlay implementation unless explicitly justified as compatibility scope,
- preserve clear confirm/cancel/dismiss outcomes,
- enforce dismissible/non-dismissible behavior consistently,
- validate accessible name/description relationships,
- validate close-state and focus-return behavior,
- keep size/density work outside the bounded slice until separately governed.

## Test Requirements

Verify at minimum:
- modal opens via `showModal()`,
- accessible name relationship exists,
- optional description relationship exists when description is rendered,
- confirm outcome is distinguishable,
- cancel outcome is distinguishable,
- dismiss outcome is distinguishable,
- dismissible Escape path closes,
- non-dismissible Escape path calls `preventDefault()` and remains open,
- close control exists only when dismissible,
- backdrop dismissal, if supported, does not fire for clicks inside the dialog box,
- background inertness/focus behavior is provided by native modal mode,
- focus return is verified or explicitly documented,
- public classes and tokens follow the naming contract.

## Negative Test Requirements

The implementation fails review if:
- modal state is represented only by a styled generic container,
- a manual overlay/focus-trap system competes with active native dialog behavior without a documented compatibility requirement,
- a dialog has no accessible name,
- non-dismissible mode can close through Escape, close control, or backdrop click,
- confirm, cancel, and dismiss collapse into an indistinguishable outcome,
- agent-generated Figma token identities are introduced,
- component-level size variants are added before the size/density decision is governed.

## Documentation Requirements

Human-facing docs explain:
- when to use a dialog versus inline feedback, popover, or page navigation,
- confirmation versus urgent alert-style usage,
- dismissible versus non-dismissible behavior,
- keyboard behavior,
- consumer events/outcomes,
- accessible naming and description requirements,
- any supported size behavior only after that API is governed.

## Anti-Patterns

- Generic `div role="dialog"` implementation when native `<dialog>` is available and sufficient.
- Multiple independent focus traps.
- Close icon with no accessible name.
- Backdrop click closing a non-dismissible dialog.
- Destructive action identified only by color.
- Large page-like flows forced into modal layout.
- Treating `open` styling as equivalent to `showModal()`.

## Agent Output

After this pattern is reviewed, an agent may derive a bounded RUN execution contract that selectively ports the preserved Modal draft rather than merging the 22-component branch wholesale.

## Review Questions

The following remain intentionally unresolved and must not be silently implemented:

1. Should the canonical ecosystem term be `Dialog` while retaining `Modal` only as the current Runtime public API, or should `Modal` remain canonical?
2. Should the urgent variant use native dialog semantics or explicitly opt into `alertdialog` semantics?
3. Is backdrop-click dismissal part of the default dismissible contract or an opt-in behavior?
4. What is the exact focus-return guarantee when the invoking control is removed or disabled while the dialog is open?
5. Should confirm automatically close in all variants, or can consumers keep the dialog open for validation/asynchronous work?
6. Should S/M/L exist as a component API at all, or be replaced by container/responsive/density rules?

Review this pattern against `patterns/checklists/pattern-spec-review-checklist.md` before deriving implementation output.
