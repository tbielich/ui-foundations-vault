---
id: export-pack.governance.changelog
title: Governance Pack Changelog
type: export-pack
status: draft
owners:
  - ui-foundations
created: 2026-07-09
updated: 2026-07-09
authority: derived
summary: Version history for the UI Foundations Governance Pack.
related:
  references:
    - export-pack.governance.manifest
    - registry.governance-packs
---

# Governance Pack Changelog

## 0.8.0 - UIF Public API Namespace

Status: review

### Added

- Added the canonical `uif` alias for public Nunjucks macro invocations.
- Added the canonical `uif-` prefix for public autonomous Custom Element tag
  names.
- Added the source ADR defining the scope and unresolved adjacent surfaces.

### Changed

- Expanded the machine-readable naming contract and schema for the two newly
  governed public API surfaces.
- Moved the governance pack to review for consuming-repository evaluation.

### Boundaries

- Does not rename macro module paths, named exports, JavaScript identifiers,
  module filenames, or package subpaths.
- Does not define compatibility aliases, dual registration, deprecation
  periods, or migration sequencing.

### Validation

- The local validator checks the canonical macro alias, invocation pattern, and
  Custom Element tag prefix.

## 0.7.0 - Machine-readable Naming Contract

Status: draft

### Added

- Added `contracts/naming-contract.json` as the portable machine-readable naming contract for runtime consumption.
- Added schema expectations for the naming contract artifact.
- Added documentation clarifying that markdown may explain naming rules while runtime consumes the JSON contract.

### Changed

- Updated the Governance Pack manifest and registry metadata to include the naming contract artifact.

### Validation

- Added local validation for the naming contract prefixes, pattern ID prefixes, source metadata, version metadata, and non-normative example labels.

## 0.6.0 - Agent-readable Pattern Governance

Status: draft

### Added

- Added canonical Implementation Naming Contract for implementation-deriving pattern specs.
- Added CSS Class Contract, Token Contract, Data Attribute Contract, Native / ARIA Precedence, and Agent Freedom Boundary.
- Added Data Attribute Contract guidance for pattern specs.
- Added Button, Input Text, and Date Picker pilot spec alignment.
- Added Button Proof-of-Use validation for UIF-prefixed class chains and scoped token assumptions.

### Changed

- Normalized pattern templates around the canonical naming contract.
- Updated proof-of-use guidance to reference the schema instead of duplicating local rules.
- Clarified that CSS naming, token scoping, native semantics, and accessibility semantics are not agent freedom.

### Validation

- Confirmed `.uif-*` remains the public class convention.
- Confirmed `--uif-*` remains the token convention.
- Confirmed data attributes remain secondary metadata/state hooks.
- Confirmed no runtime components or package configuration were changed.

### Open Questions

- Button loading semantics and `aria-busy` placement.
- Date Picker popup strategy and `aria-haspopup` details.
- Final public token mapping from proof assumptions to approved token names.

## 0.1.0

Status: draft

Initial publishable Governance Pack structure.

Includes:

- Naming rules.
- Token governance.
- Component governance.
- Accessibility baseline.
- Pack manifest.
- Registry entry.
- Review and consumption boundaries.

No runtime files, dependencies, CI workflows, deployment configuration, or automatic synchronization are included.
