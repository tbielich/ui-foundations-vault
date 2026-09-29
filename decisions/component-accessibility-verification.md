---
id: adr.component-accessibility-verification
title: "ADR: Component Accessibility Verification and Evidence Scoring"
type: adr
status: review
owners:
  - ui-foundations
created: 2026-09-29
updated: 2026-09-29
authority: source
summary: Proposes bounded automated component accessibility evidence and Design Checklist scoring while keeping real screenreader verification separate.
applies_to:
  - ui-foundations-runtime
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
    - governance.verification-review
  depends_on:
    - adr.bounded-browser-verification
  references:
    - principle.foundation.accessibility-principles
    - workflow.operational.accessibility-review
    - specification.capability.accessibility-evaluation
verification:
  status: unverified
review_cycle: on-change
---

# ADR: Component Accessibility Verification and Evidence Scoring

## Context

UIF Runtime has an accepted bounded browser-verification capability and a headless
Chromium Playwright path in `npm run ci:check`. The existing Design Checklists in
Component Docs are authored `data-done` items, not results derived from verification
evidence. Some accessibility claims therefore look complete without identifying
which component state, context, revision, or interaction was checked.

The Datepicker investigation also illustrates a verification risk: changing a
Playground control is not evidence that the actual component input, trigger, and
calendar interaction work. Tests must follow the user-facing component boundary.

The inspected Runtime accessibility page already requires manual screenreader and
keyboard checks before stable status. This proposal preserves that expectation.
Playwright ARIA snapshots expose accessible structure; axe-core detects certain
automatable problems. Neither proves actual VoiceOver, NVDA, or JAWS output.

This is private UIF ecosystem work, strictly separate from TUI UILib / the TUI
Design System. No UILib architecture, governance, assets, or ownership is imported.

## Decision

**Proposed for review; not implementation authority until accepted.** Adopt a
bounded component accessibility verification capability and an evidence-backed
score inside each participating component's existing **Design Checklist**.

### Evidence layers

| Layer | Required evidence | Limit |
| --- | --- | --- |
| Accessible structure | Small reviewed Playwright ARIA snapshots/assertions for roles, accessible names, relevant states and relationships | Browser-exposed semantics, not spoken output |
| Keyboard and focus | Real key presses, focus transitions and observable component state/value outcomes | Keyboard operability, not assistive-technology interoperability |
| Automated rules | Component-scoped axe-core analysis after the required states are reached | Only the recorded rules, context and states were evaluated |
| Real screenreader | Separate manual record naming screenreader/browser/OS, task, revision, tester, date and observations | Never inferred from automated evidence |

Runtime may extend its existing Playwright setup with `@axe-core/playwright` as a
development-only integration of axe-core. Before implementation, its local
`AGENTS.md` framework exception must explicitly reference this accepted ADR.
This permission does not create a general framework exception. The capability and
evidence semantics remain provider-neutral; executor-specific behavior stays in
adapters. Pure logic and score/report validation remain under `node --test`.

Tests must use the actual rendered component, scoped separately from docs chrome
and Playground configuration controls. Assert resulting component values, focus
and accessible states, not only CSS classes or echoed Playground controls. Initial
setup may use existing configuration surfaces, but must not simulate the action
under test. Snapshot baselines need semantic review; regenerating a baseline is
not a repair. Critical names and states must not be omitted by partial matching.

### Design Checklist score

The label is **Automated accessibility evidence**, not a WCAG compliance score or
a screenreader compatibility rating. Display the score with coverage, gate status,
revision, tested context, evidence link, and separate manual screenreader status.
Existing design/documentation checklist items are not counted as automated passes.

Runtime records a versioned, reviewed inventory of applicable criterion IDs for
each component and declared state/context. The inventory covers the three automated
layers above. It must be fixed before execution; neither raw axe rule counts nor
Playwright assertion counts define the denominator.

Each criterion has one result: `pass`, `fail`, `not-tested`, `blocked`, or
`not-applicable`. `not-applicable` requires a reviewed rationale and remains visible.
An applicable criterion passes only if all of its required scenarios have current
evidence. An incomplete axe result is `blocked` pending review, never a pass;
axe's inapplicable rules do not automatically make a whole criterion inapplicable.

- Let **A** be all applicable automated criteria, including failed, blocked and
  untested criteria; let **P** be those with current passing evidence.
- Score = `floor(100 × P / A)`, displayed alongside `P/A` and all result counts.
- If A is zero, display **Not assessed**, never 100%.
- Failed, missing, stale, skipped or blocked checks cannot increase P. Evidence for
  a different source revision or criterion/configuration version is stale; retain
  it only as labelled historical evidence, with the current criterion `not-tested`.
- No weighting, letter grades, cross-component league table, or aggregate system
  rating is introduced. Different coverage is not comparable.

Illustrative only: 3 pass, 1 fail, 1 not-tested, 1 blocked and 1 justified
not-applicable produce `3/6 = 50%`. This is not a measurement of any UIF component.

The automated gate is **PASS** only when every required applicable criterion has
current passing evidence and no unresolved finding remains in the declared scope.
A confirmed criterion failure or axe violation makes it **FAIL** regardless of
severity or score. With no confirmed failure, missing, incomplete, stale or
unexecutable required evidence makes it **BLOCKED**. Zero applicable criteria is
also BLOCKED. Report axe impact separately for prioritization, not discounting.
No silent exclusions, rule suppression, denominator reduction, or automatic
snapshot approval may turn a failure into a pass.

Show **Screenreader: not tested** unless separate manual evidence exists. A manual
failure remains visible and blocks a claim of overall accessibility readiness even
when the automated score is 100%. Automated PASS does not change lifecycle status,
remove the existing manual stable-status gate, or authorize claims of full WCAG
conformance. Uncovered states, brands, modes and browsers stay explicitly untested.

### Evidence and ownership

Persist machine-readable Runtime results with component/criterion IDs and version,
source commit, content/configuration identity when the worktree is dirty, timestamp,
run identity, browser/OS/tool versions, state and brand/mode scope, outcomes, findings,
N/A rationales and evidence references. Dirty local results cannot substantiate a
published clean revision. Derive the docs view and CI gate from the same validated
results; do not hand-maintain passing scores or hard-code positive badges.

Missing, malformed, stale or mismatched results must render an explicit unavailable
state. The build must not quietly reuse an unrelated successful run. CI preserves
raw findings and report artifacts on failure as well as success. Result production
and docs rendering must avoid a dependency cycle: build the test surface, execute
checks, then render the evidence-bearing docs against that same source revision.

Vault owns this decision and the scoring semantics. Runtime owns checks, criterion
inventories, results, CI and Component Docs projections. UIF-INT retains execution
contracts and intake semantics; UIF-STO may later consume results. No shared
execution semantics, service, MCP, AI scoring engine, or duplicated canonical
governance is introduced. This capability is **Automation**; AI may propose tests
or interpret findings, but cannot self-certify evidence or accept the ADR.

### Rollout and authorization

The first implementation issue is limited to **Button and Checkbox** in headless
Chromium, brand A / light mode, using their existing rendered docs examples. This
small slice exercises names, native states, keyboard behavior, axe results and docs
integration. It does not certify other components, variants or contexts. Datepicker
repair and coverage remain separate bounded work; this proposal does not select or
authorize that work.

The dependent Runtime issue starts blocked, without `agent:ready`. Before a human
may authorize it, the ADR must have completed review, have `status: accepted` in
Vault's default branch, and have an acceptance PR/commit recorded in the issue.
Merging a review document or merely adding a readiness label is insufficient.
Reconcile the issue with the accepted decision and confirm an executor supporting
code/browser work; the existing docs-only cloud task path is not sufficient.
Executor preflight must fail closed if any prerequisite is absent. No autonomous
acceptance, readiness promotion, implementation, or merge is authorized here.

## Rationale

Evidence should match the claim. Accessible structure, keyboard behavior, rules
and actual assistive-technology behavior answer different questions. A visible,
deterministic coverage score makes gaps inspectable without suggesting that passing
a subset of automated checks proves accessibility. Reusing the existing browser
path keeps the capability small and the ownership boundaries clear.

## Consequences

- **Human:** Component Docs expose tested scope and missing manual work beside the
  checklist. The score is understandable only with its denominator and limitations.
- **Agent:** Explicit criteria, evidence identity and gates prevent self-reported
  success or Playground-only checks from being mistaken for component evidence.
- **System:** Runtime adds a dev dependency and report/docs integration cost;
  bounded coverage and the existing runner limit maintenance overhead.
- Existing failures may block the pilot. Persist findings and obtain separate
  bounded repair authority; do not silently broaden this implementation issue.
- The numerical rubric and pilot scope are review choices. Accessibility foundation
  and capability documents referenced below are themselves in review and are
  supporting context, not silently promoted governance.

## Alternatives Considered

- **axe-only badge:** simpler, but omits interaction and accessible-state assertions.
- **ARIA snapshots only:** useful semantics evidence, but no complementary rule scan.
- **One combined automated/manual score:** obscures missing screenreader evidence.
- **Qualitative checklist only:** retained for design guidance, but insufficient for
  reproducible scoring requested for Component Docs.
- **Broad E2E, cross-browser or screenreader automation platform:** deferred; exceeds
  the bounded browser decision and needs its own capability decision and evidence.

## Verification

ADR review checks boundaries, denominator and unknown-state treatment, evidence
provenance, acceptance/readiness gates, and separation from manual screenreader work.
This document remains `review` and `verification.status: unverified`; document
validation does not establish an implemented or accessible component.

After acceptance, independent read-only Runtime verification must establish:

- Pilot tests use rendered components and assert intended semantic and interaction
  outcomes; known negative controls cause the corresponding checks/gates to fail.
- Score calculation and PASS/FAIL/BLOCKED behavior cover missing/stale evidence,
  zero denominators, N/A rationale, skipped checks and incomplete axe results.
- The Design Checklists show the same results as CI, scope and evidence links, and
  a separate screenreader status; an automated 100% never implies manual PASS.
- Runtime's required lint/unit/CI checks and bounded browser checks pass at the
  published implementation commit; failures are retained and surfaced honestly.
- No component repair, broad rollout, screenreader automation, visual regression,
  new browser matrix, Page Objects or unrelated framework is smuggled into the slice.

## Related

- [Dependent Runtime issue #309](https://github.com/tbielich/ui-foundations-runtime/issues/309) — blocked pending ADR acceptance and explicit human execution authorization.
- [Accepted bounded browser decision](bounded-browser-verification.md)
- [Lifecycle](../governance/lifecycle.md) and [verification review](../governance/verification-review.md)
- Runtime baseline inspected: `tbielich/ui-foundations-runtime` at
  `8c2c2ebd1a2f43270c34f87171a8200fbd38a410`; `AGENTS.md`, `package.json`,
  `playwright.config.js`, `.github/ISSUE_TEMPLATE/runtime-task.yml`,
  `.github/ISSUE_TEMPLATE/cloud-ready-task.yml`, `site/patterns/button.md`,
  `site/patterns/checkbox.md`, `site/components/date-picker.md`, and
  `site/foundations/accessibility.md`.
- [Playwright ARIA snapshots](https://playwright.dev/docs/aria-snapshots) and
  [accessibility testing](https://playwright.dev/docs/accessibility-testing):
  implementation evidence for the automated layers, not UIF governance authority.
- [axe-core result API](https://github.com/dequelabs/axe-core/blob/develop/doc/API.md):
  implementation reference for violations, passes, incomplete and inapplicable results.
