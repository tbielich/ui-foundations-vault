---
id: publication.whitepaper.beyond-components.abstract
title: Abstract
type: publication
status: draft
owners:
  - ui-foundations
created: 2026-07-16
updated: 2026-07-16
authority: supporting
summary: Abstract for the Beyond Components whitepaper.
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
  references:
    - index.publication.whitepaper.beyond-components
---

# Abstract

Design systems now cover much more than visual consistency. They bring together components, tokens, patterns, documentation, and the ways teams work with them. Reusable implementation reduces repeated work, semantic tokens separate intent from raw values, and shared interaction patterns help teams stay consistent. Yet most design systems still distribute their meaning across design files, component code, websites, issue trackers, conversations, and the tacit knowledge of specialists. Their assets are reusable, but the reasoning that governs those assets is often difficult to retrieve, compare, validate, or apply outside the tool in which it was recorded.

AI exposes this gap. An AI agent can generate interface code quickly, but generation quality depends on the context made available to it: canonical component identities, intended semantics, accessibility obligations, architectural constraints, decision history, and verification criteria. A component library answers only part of that need. GitHub's account of accessibility annotations, for example, shows that an accessible component does not guarantee an accessible composed experience; instance-specific semantics and page context remain necessary ([GitHub, 2025](references.md#ref-github-annotations)). Anthropic similarly frames effective agent behavior as a context-engineering problem in which relevant, high-signal information must be selected from a larger body of possible context ([Anthropic, 2025](references.md#ref-anthropic-context)).

This paper argues that design systems should make their underlying decisions reusable alongside their components. This requires design systems to operate as knowledge platforms: governed systems that connect standards, principles, decisions, specifications, reusable assets, workflows, evidence, and implementation mappings. The proposal does not replace component libraries, design tools, or documentation sites. It adds a durable knowledge layer that makes relationships and authority explicit for human and machine consumers.

The paper separates four kinds of claims. Industry observations describe visible practices and emerging tool directions. Established standards include sources such as WCAG 2.2 and the Design Tokens Community Group's 2025.10 format report. Architectural principles are reasoned recommendations about separation of concerns, provenance, lifecycle, and validation. UI Foundations proposals are specific, testable interpretations of those principles, not claims of industry consensus.

UI Foundations is used as a reference implementation of the proposed model. It illustrates how canonical knowledge, execution, runtime assets, and human-facing workspaces can remain distinct while sharing identifiers and governance. The paper does not claim that this is the only valid architecture or that every organization requires the same repository structure. The claim is more specific: teams introducing AI into design and engineering need governed design knowledge they can retrieve and test. Adding assets or extending prompts will not resolve missing authority and context.
