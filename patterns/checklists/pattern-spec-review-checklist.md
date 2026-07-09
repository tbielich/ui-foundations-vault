---
id: checklist.pattern-spec-review
title: Pattern Spec Review Checklist
type: checklist
status: draft
owners:
  - ui-foundations
created: 2026-07-09
updated: 2026-07-09
authority: supporting
summary: Lightweight review checklist for agent-readable pattern specifications before implementation derivation.
related:
  references:
    - specification.pattern.schema
---

# Pattern Spec Review Checklist

Use this checklist before creating, approving, or deriving implementation guidance from an agent-readable pattern spec.

## Required Sections

- [ ] Includes `Implementation Naming Contract`.
- [ ] Includes `CSS Class Contract`.
- [ ] Includes `Token Contract`.
- [ ] Includes `Data Attribute Contract`.
- [ ] Includes `Native / ARIA Precedence`.
- [ ] Includes `Agent Freedom Boundary`.

## Naming

- [ ] Public classes use `.uif-*`.
- [ ] Class chains are used instead of BEM.
- [ ] No BEM modifier syntax is used, such as `.uif-button--solid`.
- [ ] No BEM element syntax is used, such as `.uif-button__icon`.
- [ ] No unscoped public component classes are introduced.

## Tokens

- [ ] Public CSS custom properties use `--uif-*`.
- [ ] Component token slots use `--uif-[component]-*`.
- [ ] Experimental tokens use `--uif-proof-*` or `--uif-assumption-*`.
- [ ] No unscoped public component tokens are introduced.

## Data Attributes

- [ ] Data attributes are secondary metadata/state hooks.
- [ ] Data attributes do not replace public classes.
- [ ] Data attributes do not replace token conventions.
- [ ] Data attributes do not replace native semantics.
- [ ] Data attributes do not replace ARIA.
- [ ] UIF-specific data attributes are documented by the pattern.

## Accessibility / Semantics

- [ ] Native attributes are preferred where available.
- [ ] ARIA is used for accessibility semantics.
- [ ] Data attributes may mirror state but are not the only semantic source.
- [ ] Open questions are not implemented as requirements.
- [ ] Required, optional, out-of-scope, and open-question behaviour is clearly classified.

## Agent Review

- [ ] CSS naming is not treated as agent freedom.
- [ ] Token scoping is not treated as agent freedom.
- [ ] Native semantics are not treated as agent freedom.
- [ ] Accessibility semantics are not treated as agent freedom.
- [ ] Proposed naming or data attributes are explicitly marked as proposed or open question.

## Implementation Readiness

- [ ] The spec provides enough information to derive HTML structure.
- [ ] The spec provides enough information to derive CSS/token usage.
- [ ] The spec provides enough information to derive a minimum component API.
- [ ] The spec provides enough information to derive accessibility tests.
- [ ] The spec provides enough information to derive negative anti-pattern tests.
- [ ] Missing implementation decisions are captured as open questions.
