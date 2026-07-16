---
id: publication.presentation.beyond-components-management.speaker-notes
title: Beyond Components — Management Speaker Notes
type: publication
status: draft
owners:
  - ui-foundations
created: 2026-07-16
updated: 2026-07-16
authority: supporting
summary: Speaker notes for the fifteen-slide Beyond Components management presentation.
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
  depends_on:
    - publication.presentation.beyond-components-management.slides
  references:
    - index.publication.whitepaper.beyond-components
---

# Beyond Components — Management Speaker Notes

<a id="slide-1-title"></a>

## Slide 1 — Beyond Components

Open with the strategic question, not the implementation. Design systems have created leverage by standardizing visual decisions and reusable components. The next constraint is whether the knowledge behind those assets can travel reliably across teams, tools, and AI-assisted workflows.

The presentation is not an argument to replace the existing design system. It asks whether the system’s architectural boundary should expand. The proposed direction is to treat design knowledge—standards, decisions, specifications, patterns, ownership, and evidence—as a governed asset in its own right.

Set the expectation that this is a discussion about future direction. The desired outcome is leadership validation of the problem, the assumptions, and a sensible pilot—not approval of a predetermined platform.

<a id="slide-2-executive-summary"></a>

## Slide 2 — Executive Summary

Land three takeaways. First, reusable components remain essential, but many important decisions sit outside component code: accessibility context, composition rules, rationale, exceptions, and lifecycle state.

Second, AI makes fragmented knowledge more consequential. A person may stop and ask when guidance conflicts; an automated workflow may apply an incorrect assumption repeatedly.

Third, a knowledge platform is an architectural response, not a new documentation website. It makes authority, relationships, lifecycle, and evidence explicit so the same sources can support design, engineering, product, automation, and AI.

Invite the audience to test these propositions throughout the discussion. None should be accepted solely because they appear in the whitepaper or this presentation.

<a id="slide-3-why-now"></a>

## Slide 3 — Why This Matters Now

Explain that the environment around design systems has changed. Product delivery now spans design tools, code repositories, documentation systems, automation, and increasingly AI agents. Each additional consumer creates another translation boundary.

The issue is not simply information volume. It is whether consumers can identify the governing source, understand its scope, and distinguish an accepted rule from a draft, example, or local exception.

Anthropic’s context-engineering work makes the AI dimension concrete: more context is not automatically better; high-signal, relevant context matters. Figma Code Connect illustrates the broader industry movement toward explicit mappings between design assets, production code, and guidance.

The management implication is that knowledge architecture is becoming part of delivery architecture.

<a id="slide-4-evolution"></a>

## Slide 4 — Design Systems Have Evolved

Frame the evolution as cumulative. Guidelines made preferred choices visible. Component libraries then made part of those choices executable and reusable. Design tokens improved portability for selected design decisions.

The proposed next step does not invalidate those investments. It extends them by governing the intent, constraints, relationships, and evidence that components cannot contain alone.

Avoid presenting the three stages as a universal industry maturity model. Organizations evolve differently. The diagram is a strategic lens: each stage increases the unit of value that can be reused across the organization.

The key question is whether reusable implementation can continue to scale without reusable design knowledge.

<a id="slide-5-current-strengths"></a>

## Slide 5 — What Today’s Design Systems Solve Well

Establish credibility by acknowledging current strengths. Design systems reduce repeated implementation, create consistency, and give designers and engineers a shared language. Public systems such as GitHub Primer show how component and token investments can propagate improvements across a large product estate.

These capabilities are not the problem. They are the platform on which the next capability can be built.

The distinction matters politically and financially. This proposal is not a request to restart the design system. It is a request to protect and extend its value by making the knowledge around its assets more durable and reusable.

Pause here if the audience believes the current model already captures all relevant decision context. That assumption should be tested before continuing.

<a id="slide-6-limits"></a>

## Slide 6 — Where Today’s Architecture Reaches Its Limits

Describe the typical fragmentation pattern: visual guidance in a design tool, behavior in code, accessibility detail in annotations, rationale in issues, and exceptions in conversations. Each source may be valid, but authority and relationships are difficult to reconstruct.

GitHub’s accessibility work provides a useful example. An accessible component does not guarantee an accessible composed experience; instance-level semantics and page context remain necessary. Adobe Spectrum similarly states that tokens provide only part of the information required to represent or implement a component.

The architectural limit is therefore not poor documentation. It is that the system treats knowledge as supporting material rather than as a governed asset with identity, lifecycle, and evidence.

<a id="slide-7-ai-context"></a>

## Slide 7 — AI Changes the Operating Context

Avoid claims that AI replaces designers or engineers. The narrower claim is that AI introduces a new consumer that can act quickly across many artifacts.

Agents need to know which source governs, what is optional, what is prohibited, and how output must be verified. A long prompt copied into several tools is not a durable solution because it duplicates rules and can become stale.

The strategic requirement is bounded context: a small, relevant set of governed sources connected to validation. Humans benefit from the same clarity.

This is why AI readiness is primarily a knowledge and governance question. Model selection and orchestration are downstream implementation choices.

<a id="slide-8-knowledge-chain"></a>

## Slide 8 — Knowledge Becomes the Primary Asset

Use the chain to clarify roles. Knowledge captures intent, standards, decisions, ownership, and evidence. Specifications turn that knowledge into explicit requirements. Patterns make recurring decisions reusable. Components implement selected patterns. Products compose those components within real customer and business contexts.

“Primary asset” does not mean components become secondary in investment or importance. It means the knowledge layer governs why components exist, how they should be used, and what evidence supports them.

The leadership implication is that documentation, governance, and architecture are not overhead around the design system. They are part of the system’s reusable value.

<a id="slide-9-open-standards"></a>

## Slide 9 — Open Standards Create Shared Boundaries

Separate established standards from emerging initiatives. WCAG provides normative accessibility requirements. The Design Tokens Community Group provides a stable 2025.10 format for exchanging design-token data. These are concrete shared boundaries.

Google DESIGN.md is different: it is an alpha experiment combining machine-readable tokens with human-readable guidance. It is evidence of direction, not settled consensus. Similar caution applies to other emerging design-data initiatives.

The strategic point is not to adopt every new format. It is to preserve organizational knowledge independently of any one tool and to use standards where they genuinely reduce translation and coupling.

<a id="slide-10-ui-foundations"></a>

## Slide 10 — UI Foundations

Introduce UI Foundations only after the general architecture is understood. Position it as one reference implementation that separates canonical knowledge from runtime assets, execution concerns, and human-facing presentation.

The reference implementation exists to make assumptions testable. Can stable identifiers improve discovery? Can explicit precedence reduce conflicts? Can the same governed sources support both people and agents? Can implementation evidence feed back into shared knowledge through review?

Do not ask the audience to accept the current repository structure or terminology. Other architectures may preserve the same principles. The important question is whether the responsibility boundaries are useful.

<a id="slide-11-open-source"></a>

## Slide 11 — Why Open Source

Treat open source as an implementation strategy, not a requirement of the thesis. An open reference model exposes assumptions, schemas, validators, and decision history to independent review. It can also reduce dependence on a proprietary authoring or retrieval tool.

Openness does not require publishing internal research, product strategy, or customer data. Public foundations can coexist with private organizational knowledge and access controls.

The trade-off is stewardship. Open source requires contribution rules, compatibility commitments, security ownership, and sustained maintenance. Leadership should support openness only where independent validation, collaboration, or interoperability justifies that cost.

<a id="slide-12-tui-value"></a>

## Slide 12 — Why This Matters for TUI

Present the benefits as hypotheses to validate, not promised outcomes. TUI’s scale across products, markets, channels, and technology stacks creates repeated interpretation and coordination costs. Governed design knowledge could make more of that reasoning reusable.

The potential value is strategic flexibility: teams can change tools or delivery models while retaining canonical decisions and relationships. AI readiness improves because agents receive the same governed context as human teams. Governance becomes more visible because ownership and lifecycle are attached to artifacts.

The cost case must be measured. A knowledge platform also creates maintenance work. The pilot should test whether it reduces rework, discovery time, and duplicated decisions enough to justify that burden.

<a id="slide-13-roadmap"></a>

## Slide 13 — Roadmap

Emphasize sequencing. Near term means clarifying ownership, lifecycle, authority, and one bounded pilot. Avoid migrating the entire documentation estate or selecting elaborate tooling.

Medium term means connecting the pilot’s knowledge to components, design assets, standards, and assurance. This is where impact analysis and verification become testable.

Long term means scaling only what has demonstrated value across human and AI workflows. Richer search, graph projections, or context services may be appropriate later, but they should not precede stable sources and governance.

The roadmap is deliberately reversible. Each horizon should have evidence-based exit criteria.

<a id="slide-14-discussion"></a>

## Slide 14 — Discussion

Shift from presentation to decision. First, ask whether the direction addresses a strategically relevant problem or merely an internal documentation concern.

Second, invite challenges to the assumptions: Is a separate knowledge layer necessary? Could stronger documentation or DesignOps practices solve the problem more simply? What risks arise from standardizing design knowledge?

Third, identify a bounded pilot where design, engineering, accessibility, and product decisions intersect. Avoid choosing a pilot solely because it is easy.

Finally, agree on success measures before choosing tooling. Possible measures include time to find authoritative guidance, repeated deviations, review findings, and correction cost.

<a id="slide-15-closing"></a>

## Slide 15 — Closing

Close by returning to the progression rather than the implementation. The first generation made interface choices visible and repeatable. The second embedded more of those choices in reusable implementation. The proposed next generation makes the design knowledge behind those choices reusable and governable.

The statement is intentionally directional. It should be treated as a proposition to test, not an inevitability. The immediate leadership decision is whether the proposition is strategically relevant enough to justify a bounded, measurable pilot.

End on the slide. Do not add a product pitch or implementation request after the final statement.
