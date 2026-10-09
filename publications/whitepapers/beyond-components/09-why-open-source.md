---
id: publication.whitepaper.beyond-components.why-open-source
title: Why Open Source
type: publication
status: draft
owners:
  - ui-foundations
created: 2026-07-16
updated: 2026-07-16
authority: supporting
summary: Draft chapter on the role of open source in the proposed model.
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
  references:
    - index.publication.whitepaper.beyond-components
---

# Why Open Source

## Open source as an inspection and collaboration model

Open source is one possible **implementation strategy** for this model. It can strengthen a reference architecture by making formats, assumptions, and implementation choices inspectable. Organizations can evaluate the model without adopting a proprietary service, while standards mappings and validators can be reviewed independently.

The proposal does not require design systems to be public. Brand assets, product strategy, user research, and internal constraints may require restricted access. The relevant distinction is between an open reference model and an organization's private knowledge. A public framework can define document structures, relationship semantics, validation methods, and adapters while private repositories supply local content.

## Benefits

### Portability

Open formats and reference implementations reduce the cost of moving between tools. DTCG's vendor-neutral format targets token interoperability directly ([DTCG, 2025](references.md#ref-dtcg-format)). Google DESIGN.md and Adobe's draft Design Data Specification can be inspected as files and schemas, making their assumptions visible even while the formats evolve ([Google, 2026](references.md#ref-google-design-md); [Adobe, 2026](references.md#ref-adobe-design-data)).

### Shared verification

Public validators, schemas, and fixtures allow multiple implementations to test the same contract. Accessibility specialists can inspect semantics. Tool vendors can identify ambiguous requirements. Consumers can reproduce failures rather than depend on a private interpretation.

### Transparent evolution

Issues, proposals, version history, and release notes make change visible. The DTCG publishes reports at explicit maturity levels and develops work through public contribution channels ([DTCG, 2026](references.md#ref-dtcg-reports)). Carbon and Spectrum expose public documentation and contribution paths, while GitHub's Primer work documents practical accessibility lessons. This transparency does not guarantee consensus or quality, but it makes scrutiny possible.

### Avoiding duplicated foundational work

Shared formats, schemas, and validators can reduce the amount of foundational work each team has to rebuild. Teams can then spend more effort on domain-specific requirements and product work.

## Risks and limits

Open-source maintenance is not free. A public project needs triage, security response, release discipline, documentation, and contributor expectations. External contributions may expand scope faster than maintainers can review. A reference architecture can also be mistaken for a mandatory implementation.

A small shared core of schemas, conventions, validation, and examples limits that maintenance burden. Organization-specific governance remains local. Extensions should be explicit and should not fragment the shared core without evidence.

## Open source is not the same as a standard

An open-source implementation demonstrates feasibility and exposes trade-offs. A standard establishes shared expectations across independent implementations. Governance should therefore state compatibility precisely: using DTCG concepts, exporting a compatible file, and claiming conformance are different assertions.

A private organization can apply the same responsibility boundaries without publishing its implementation. Openness makes a reference model easier to inspect and challenge; it is not a condition for using it.
