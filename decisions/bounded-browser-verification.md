---
id: adr.bounded-browser-verification
title: Bounded Browser Verification
type: adr
status: accepted
owners:
  - ui-foundations
created: 2026-09-29
updated: 2026-09-29
authority: source
summary: Defines when UIF Runtime requires real-browser verification and keeps that capability bounded alongside the existing lightweight test stack.
applies_to:
  - ui-foundations-runtime
related:
  references:
    - governance.precedence
    - governance.lifecycle
---

# ADR: Bounded Browser Verification

## Context

UIF Runtime currently validates logic, generated output, naming, documentation drift,
and other static contracts with a lightweight Node-based test stack. Its repository
rules also state that agents must not introduce new frameworks.

A Datepicker regression exposed a different failure class: browser interaction can
fail even when pure state logic and static contracts are correct. A user click must
travel through the real browser DOM, event model, rendered controls, and resulting
state before the behavior is proven.

Simulated DOM environments can test parts of that path, but they do not establish
evidence for browser-dependent behavior such as native event semantics, focus,
hit-testing, overlays, or CSS-dependent interaction.

The repository therefore needs a deliberately bounded way to verify interaction in
a real browser without turning the existing test strategy into a broad E2E platform.

## Decision

UIF Runtime adopts a bounded real-browser verification capability alongside its
existing lightweight test stack.

The following boundaries apply:

- `node --test` remains the default for pure logic, data, contract, and source-level
  verification.
- Pure logic should be extracted and tested without a browser whenever practical.
- Real-browser verification is used only when acceptance depends on browser DOM,
  event, focus, native-control, hit-testing, or rendered interaction semantics.
- UIF Runtime may use Playwright as the initial implementation of this capability.
  Playwright is an implementation choice of the Runtime repository, not a shared
  ecosystem execution semantic.
- Browser tests must remain small and regression-oriented. They should prove critical
  behavior that cannot be established by the lighter test layers.
- The first implementation slice is the Datepicker interaction regression that
  motivated this decision.

This decision does not establish:

- a general product E2E test platform;
- visual-regression infrastructure;
- a cross-browser test matrix;
- Page Object architecture;
- a shared fixture framework;
- broad browser coverage for behavior already proven by lighter tests.

The existing UIF Runtime rule that forbids introducing new frameworks must not be
silently bypassed. Before the browser-verification implementation is accepted, the
Runtime repository must explicitly narrow or qualify that local rule so that this
governed verification capability is permitted while the default prohibition remains
in force for unrelated framework additions.

## Rationale

The test layer should match the failure mode.

Using only pure logic tests would leave the DOM-to-state wiring unverified. Adding a
simulated DOM dependency would create another test layer while still leaving real
browser behavior outside the evidence boundary.

A narrowly scoped real-browser layer closes the demonstrated gap directly while
preserving the existing fast tests as the primary validation mechanism.

Keeping Playwright local to UIF Runtime also preserves ecosystem-level tool
independence: the durable decision is the need for bounded real-browser evidence,
not permanent coupling to one vendor or runner.

## Consequences

- UIF Runtime gains a second, explicitly bounded verification layer for browser-only
  interaction behavior.
- The default test path remains lightweight; browser tests are not the default answer
  for logic that can be proven without a browser.
- The Runtime repository must update its local agent rule before implementation can
  be considered compliant.
- CI must be able to execute the bounded browser checks headlessly and include their
  result in the repository's required validation path.
- Browser installation and execution add CI cost and maintenance overhead, which is
  accepted only for tests that require real-browser evidence.
- Visual regression and broader E2E architecture require separate evidence and a
  separate decision if they become necessary.

## Alternatives Considered

- **Simulated DOM with happy-dom or jsdom:** rejected as the primary solution because
  it verifies DOM-like behavior but not the full browser interaction boundary that
  produced the regression.
- **Pure logic extraction only:** retained as a complementary technique, but rejected
  as sufficient coverage because it does not verify DOM event wiring.
- **Full Playwright E2E platform:** rejected because it introduces more architecture,
  cost, and conventions than the demonstrated problem requires.
- **No new browser verification layer:** rejected because the Datepicker regression
  demonstrates a browser-dependent failure class that the existing suite cannot
  establish.

## Verification

This decision is satisfied when:

- UIF Runtime keeps pure logic and static contracts under the existing lightweight
  test path;
- the Runtime local agent rule explicitly permits the governed bounded
  browser-verification capability;
- the Datepicker regression is reproduced as a headless real-browser test that
  clicks an actual calendar day and verifies the resulting day/month/year state and
  selected DOM state;
- the browser check runs in CI and is included in the required Runtime validation
  path;
- no visual-regression system, cross-browser matrix, Page Objects, shared fixture
  framework, or unrelated E2E architecture is introduced by the initial slice.

## Related

- Runtime implementation issue: https://github.com/tbielich/ui-foundations-runtime/issues/307
