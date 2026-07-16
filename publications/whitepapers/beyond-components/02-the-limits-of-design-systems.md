---
id: publication.whitepaper.beyond-components.limits-of-design-systems
title: The Limits of Design Systems
type: publication
status: draft
owners:
  - ui-foundations
created: 2026-07-16
updated: 2026-07-16
authority: supporting
summary: Draft chapter on the limits of current design systems.
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
  references:
    - index.publication.whitepaper.beyond-components
---

# The Limits of Design Systems

## A component library is necessary but incomplete

Published engineering practice establishes both the value and the boundary of component reuse. Component libraries package repeatable structure, styling, and behavior behind a maintained interface. GitHub reported replacing dozens of bespoke table implementations with a shared Primer component, combining component expertise with participation from disabled users ([GitHub, 2024](references.md#ref-github-inclusive-components)). The component succeeds because it is embedded in research, guidance, collaboration, and product migration—not because reusable code alone contains every relevant decision.

A component can define a default role, keyboard behavior, states, and API. It cannot independently determine the correct heading hierarchy of a page, the accessible name needed in a particular business context, whether an action should navigate or mutate data, or which error message helps a user recover. GitHub's accessibility-annotation work states this directly: accessible components can still be composed into inaccessible designs, and visual component properties often omit contextual semantics ([GitHub, 2025](references.md#ref-github-annotations)). WCAG 2.2 likewise defines conformance for full pages, not isolated components, and notes that conformance cannot exclude part of a page ([W3C, 2024](references.md#ref-wcag22)).

The limit is therefore not a defect in components. It is a category boundary. Components encode reusable implementation; product experiences also depend on relationships, content, sequence, data, policy, and context.

## Documentation is often fragmented by tool and audience

Most organizations document design-system knowledge in several places for legitimate reasons. Designers need assets and usage guidance near their design work. Engineers need APIs, examples, package versions, and migration notes near code. Accessibility specialists need semantic and testing detail. Product teams need patterns connected to real workflows. Governance groups need ownership, lifecycle, and decision history.

Fragmentation becomes problematic when these surfaces silently compete as sources of truth. A design file may show a newer variant than the code package. A documentation site may retain a deprecated example. An issue may contain the rationale for an exception that never reached the specification. A chat discussion may be the only record of why an apparently reasonable API was rejected. Search can locate these fragments, but retrieval alone does not establish authority.

Figma's Code Connect addresses one part of this problem by linking design components to maintained production code and documentation ([Figma, 2024](references.md#ref-figma-code-connect)). The important architectural lesson is not that every organization should adopt a particular product. It is that explicit mappings are more reliable than resemblance. A node named “Button” and a component named `Button` are not necessarily equivalent unless the system records the relationship, supported properties, and ownership.

## Tokens carry values and intent, not complete behavior

Tokens are one of the strongest examples of design knowledge becoming structured data. The DTCG format establishes portable names, values, types, references, and extensions ([DTCG, 2025](references.md#ref-dtcg-format)). Semantic token systems add intent: an alias such as an accent background can remain stable while raw color changes by theme. Public systems from Fluent, Spectrum, Carbon, and Polaris show variations of this layered approach.

Yet tokens do not specify complete interface behavior. Spectrum explicitly describes its token system as one resource used alongside design and engineering documentation ([Adobe Spectrum, 2025](references.md#ref-spectrum-tokens)). A focus-ring color token does not state when focus must move, which element receives it, or how focus is restored after a dialog closes. A spacing token does not determine the correct information hierarchy. A motion token does not decide whether animation should be suppressed under user preferences. Those decisions belong to patterns, specifications, accessibility guidance, and product context.

This distinction matters for AI consumption. If an agent retrieves tokens without their semantic layer, it may reproduce values while violating intent. If it retrieves semantic names without component and pattern constraints, it may apply them in invalid contexts. Structured data is useful only when its scope is clear.

## Examples are persuasive but weak as contracts

Design systems commonly teach through examples because examples reduce abstraction. They are indispensable for onboarding and comprehension. They are also easy for both humans and AI to overgeneralize.

An example typically demonstrates one valid configuration. It may omit failure states, localization, responsive behavior, keyboard interaction, loading, permissions, empty data, or content extremes. When examples are copied without an accompanying contract, omitted conditions can be mistaken for unsupported conditions or, worse, can disappear from implementation altogether.

The WAI-ARIA Authoring Practices Guide provides a useful model for separating layers. It identifies WCAG and ARIA as normative standards while describing the APG itself as informative guidance; each pattern combines purpose, keyboard interaction, semantics, and illustrative examples ([W3C APG, 2026](references.md#ref-wai-apg)). That distinction prevents an example from silently acquiring the authority of a standard. Design systems benefit from the same clarity: examples should point to requirements and constraints rather than become the only place those requirements can be inferred.

## Governance is often external to the artifact

Many systems have contribution processes, review meetings, release notes, and owner groups. These are governance mechanisms, even when they are not named as such. The problem arises when governance state is not attached to the knowledge it governs. Consumers may not know whether a page is experimental, accepted, deprecated, or merely old.

Adobe Spectrum's principles emphasize versioning, open issues, and design checklists as ways to communicate status ([Adobe Spectrum, 2026](references.md#ref-spectrum-principles)). Carbon's contribution model separates enhancement work from phased new-component contributions ([IBM Carbon, 2026](references.md#ref-carbon-contributing)). These practices show that lifecycle and contribution are part of a design system's operating model.

For a knowledge platform, lifecycle should be explicit and queryable. Each governed artifact needs an owner, status, authority, dates, and relationships to the sources it implements or supports. This does not require a complex database. Lightweight metadata in version-controlled documents can be sufficient if the vocabulary is stable and validated.

## Search is not the same as knowledge architecture

Adding enterprise search or retrieval-augmented generation to fragmented documentation can improve discovery, but it does not resolve contradictions. A retrieval system may find both a deprecated guideline and its replacement. It may rank a polished example above a terse normative specification. It may return a local implementation note as though it applied across the organization.

The missing capability is a precedence model. Consumers need to know which sources are normative, which are supporting, which are derived, and how conflicts are handled. They also need stable identifiers so a relationship survives file moves and publication changes.

Current design systems have not failed; they have optimized for consistency, reuse, distribution, and collaboration. The emerging problem is that their design knowledge must now be consumed across more tools, repositories, and autonomous workflows. AI makes the cost of that unresolved ambiguity operational, which is the subject of the next chapter.
