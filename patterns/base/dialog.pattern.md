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
summary: Agent-readable base contract for native HTML dialogs that require focused user interaction.
---

# Dialog Pattern

## Metadata

- id: `pattern.base.dialog`
- type: base
- status: draft
- implementation evidence: RUN issue #33 and preserved draft PR #278
- related standards: native HTML `<dialog>`, modal dialog semantics, keyboard and focus-management requirements
- canonical ecosystem term: `Dialog`
- compatibility note: the preserved Runtime draft still uses `Modal` naming and is migration evidence, not naming authority

## Intent

Provide a focused interaction surface for decisions or tasks that temporarily require the user's attention while preventing interaction with the rest of the page.

## Problem

Interfaces sometimes need a bounded interaction that must be completed, confirmed, cancelled, or explicitly dismissed before the user returns to the underlying page. Recreating modal semantics with generic containers introduces avoidable focus, inertness, keyboard, and accessibility risk.

## Use When

- Use for a short, focused decision or task that must temporarily interrupt the current page context.
- Use for confirmation when an action has meaningful consequences.
- Compose existing feedback components such as Alert inside a Dialog when additional status or warning content is needed; Alert is not a separate Dialog variant.

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

- `Dialog` is the canonical UIF term because UIF follows native platform terminology when an appropriate HTML primitive exists.
- New public dialog classes use the `uif-dialog*` family.
- The preserved Runtime draft's `uif-modal*` classes are compatibility/migration surface only and must not define new canonical naming.
- Migration of existing Runtime consumers from `Modal` to `Dialog` must be explicit and backward-compatible rather than silently breaking the public API.
- Use class chains rather than BEM element or modifier syntax.

### Token Contract

- New canonical component token slots use `--uif-dialog-*`.
- Existing `--uif-modal-*` tokens in preserved Runtime evidence are compatibility/migration surface and must not be extended as the canonical namespace.
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
- Do not introduce a separate alert-dialog variant by default. Warning or error content is composed from the existing Alert component inside the Dialog while the Dialog retains its native structure and interaction model.

### Agent Freedom Boundary

Agents must not change:
- native dialog semantics,
- whether a non-dismissible dialog can be escaped,
- accessible naming relationships,
- confirm/cancel/dismiss event meaning,
- canonical Dialog naming,
- size/density/layout architecture.

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
- A dismissible dialog provides clear dismissal through its explicit close control and the native Escape/cancel path.
- A non-dismissible dialog must not expose a close control and must prevent Escape/cancel from closing it.
- Clicking the backdrop does not dismiss the Dialog by default.
- Confirm, cancel, and dismiss are distinguishable consumer outcomes.
- Browser history/back navigation is not owned by the Dialog component; the embedding application decides whether navigation closes or replaces an open Dialog.
- When the original invoker still exists and is focusable, focus should return to it on close. If it no longer exists or cannot receive focus, choosing the next focus target is consumer responsibility.

## Behaviour

### Open

- Consumer intent to open the component results in native modal presentation through `showModal()`.
- Repeated open synchronization must not throw when the dialog is already open.

### Confirm

- The primary action emits or returns a distinct confirm outcome.
- Confirm does not automatically close the Dialog.
- The consumer decides whether confirm closes the Dialog, advances a multi-step flow, performs validation, waits for asynchronous work, or renders another view inside the same Dialog.

### Cancel

- A cancel action emits or returns a distinct cancel outcome.
- Cancellation closes a dismissible dialog.

### Dismiss

For a dismissible dialog, the component supports:
- an explicit close control,
- Escape through the native `cancel` event.

Both paths converge on the same close/dismiss outcome.

For a non-dismissible dialog:
- prevent the native `cancel` event from closing the dialog,
- omit the close control.

### Backdrop Interaction

Backdrop-click dismissal is not part of the Dialog contract. UIF does not add this behavior on top of the native element. This keeps dismissal semantics simple and allows the same Dialog foundation to support compositions such as drawers or bottom sheets without coupling them to outside-click behavior.

### Focus

- Rely on native modal behavior for initial focus containment and background inertness.
- The implementation must verify where initial focus lands for the supported content structures.
- On close, focus should return to the invoking control when that control still exists and is focusable.
- If the invoker no longer exists or cannot receive focus, the embedding consumer owns the fallback focus decision because UIF cannot know the surrounding application DOM or workflow context.
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

## Variants and Composition

Dialog does not define separate confirmation or alert structural variants. The semantic structure and interaction model remain the same.

Confirmation is expressed through the Dialog's content and actions.

Warnings, errors, or urgent status messaging are composed from the existing Alert component inside the Dialog rather than creating an `alertdialog` variant or duplicating Alert semantics in Dialog.

## Responsive / Density Behaviour

Dialogs must remain usable at high zoom and narrow viewports without clipping essential controls.

General density and width are not Dialog-specific variants. Dialog does not define an `s/m/l` size API. Width and responsive behavior are governed by layout/container semantics, container queries, and the broader density/responsive strategy rather than by component-owned size variants.

## Component Dependencies

- Button / action controls
- Icon, when a close control uses an icon
- Existing semantic typography, spacing, focus, and container tokens

## Minimum Component API

| API | Classification | Default | Contract |
|---|---|---|---|
| `open` | Required state | `false` | Synchronizes consumer state with native modal open/close behavior. |
| `dismissible` | Optional | `true` | Enables the explicit close control and native Escape/cancel dismissal path. |
| `title` or equivalent named slot | Required | None | Supplies the visible and programmatic dialog name. |
| `description` or equivalent slot | Optional | None | Supplies supporting text and description relationship. |
| confirm action | Conditional | None | Emits a confirm outcome; the consumer decides whether the Dialog closes or the flow continues. |
| cancel action | Conditional | None | Required when cancellation is part of the task. |

Dialog intentionally has no `variant` API for Alert semantics and no component-owned `size` API.

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
| Public naming | none | Canonical term and new API use Dialog; Modal is compatibility/migration surface only | Yes, for migration mechanics. |
| Size API | none | No Dialog-owned S/M/L; use governed layout/container/responsive mechanisms | Yes, for a future component-specific size API. |

## Implementation Contract

A RUN reintegration derived from this pattern must:
- start from the preserved implementation only as evidence,
- use native `<dialog>` modal behavior,
- avoid a parallel legacy overlay implementation unless explicitly justified as compatibility scope,
- preserve clear confirm/cancel/dismiss outcomes,
- never force confirm to close the Dialog,
- enforce dismissible/non-dismissible behavior consistently,
- do not add backdrop-click dismissal,
- validate accessible name/description relationships,
- return focus to the invoker when possible and leave fallback focus selection to the consumer when it is not,
- keep Dialog width out of component-owned size variants and use governed layout/container/responsive mechanisms.

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
- backdrop clicks do not dismiss the Dialog,
- confirm does not force close,
- background inertness/focus behavior is provided by native modal mode,
- focus returns to the invoker when possible and consumer-owned fallback is documented,
- new public classes and tokens use the Dialog naming contract.

## Negative Test Requirements

The implementation fails review if:
- modal state is represented only by a styled generic container,
- a manual overlay/focus-trap system competes with active native dialog behavior without a documented compatibility requirement,
- a dialog has no accessible name,
- non-dismissible mode can close through Escape or a close control,
- backdrop click is added as implicit dismissal behavior,
- confirm is hard-wired to close the Dialog,
- confirm, cancel, and dismiss collapse into an indistinguishable outcome,
- agent-generated Figma token identities are introduced,
- component-level S/M/L variants are introduced instead of governed layout/container/responsive behavior.

## Documentation Requirements

Human-facing docs explain:
- when to use a dialog versus inline feedback, popover, or page navigation,
- composition of Alert or other components inside Dialog,
- dismissible versus non-dismissible behavior,
- the absence of backdrop-click dismissal,
- keyboard behavior,
- consumer-controlled confirm flows,
- consumer events/outcomes,
- accessible naming and description requirements,
- width/responsive behavior through layout and container mechanisms rather than Dialog-owned sizes.

## Anti-Patterns

- Generic `div role="dialog"` implementation when native `<dialog>` is available and sufficient.
- Multiple independent focus traps.
- Close icon with no accessible name.
- Adding backdrop-click dismissal as hidden component behavior.
- Hard-wiring confirm to close when the consumer may need validation, async work, or a multi-step flow.
- Duplicating Alert semantics as a Dialog variant instead of composing the Alert component.
- Destructive action identified only by color.
- Large page-like flows forced into modal layout.
- Treating `open` styling as equivalent to `showModal()`.

## Agent Output

After this pattern is reviewed, an agent may derive a bounded RUN execution contract that selectively ports the preserved Modal draft rather than merging the 22-component branch wholesale.

## Review Decisions — 2026-09-18

The implementation questions raised during the initial draft are resolved:

1. **Canonical term:** Dialog. UIF follows native platform terminology when a suitable HTML primitive exists. Modal is compatibility/migration terminology only.
2. **Alert semantics:** no Alert/Dialog variant. Compose the existing Alert component inside Dialog when needed.
3. **Backdrop dismissal:** not part of the component contract; UIF adds no outside-click dismissal.
4. **Focus fallback:** return focus to the invoker when possible; if the invoker is gone or unfocusable, fallback focus is consumer responsibility.
5. **Confirm behavior:** confirm emits an outcome but does not force close. Consumers may validate, run async work, or advance multi-step content inside the same Dialog.
6. **Sizing:** no Dialog-owned S/M/L API. Width and responsive behavior belong to layout/container semantics, container queries, and broader density/responsive rules.
7. **Browser history:** Back/navigation behavior belongs to the embedding application, not the Dialog component.

Review this pattern against `patterns/checklists/pattern-spec-review-checklist.md` before deriving implementation output.
