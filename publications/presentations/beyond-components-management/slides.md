---
id: publication.presentation.beyond-components-management.slides
title: Beyond Components — Management Slides
type: publication
status: draft
owners:
  - ui-foundations
created: 2026-07-16
updated: 2026-07-16
authority: supporting
summary: Fifteen-slide management narrative derived from the Beyond Components whitepaper.
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
  depends_on:
    - index.publication.whitepaper.beyond-components
  references:
    - index.publication.presentation.beyond-components-management
---

<!-- slide: 1 -->

# 1. Beyond Components

> Design systems must evolve from reusable interface assets into governed sources of design knowledge.

**Subtitle:** Why Design Systems Must Become Knowledge Platforms for Humans and AI

**Suggested visual:** [From components to governed knowledge](assets/diagrams/01-title.mmd)

**Speaker notes:** [Slide 1](speaker-notes.md#slide-1-title)

---

<!-- slide: 2 -->

## 2. Executive Summary

> The strategic opportunity is to make design knowledge reusable, governable, and accessible across human and machine workflows.

- Components remain essential, but they do not contain the full decision context.
- AI increases the operational cost of fragmented or implicit guidance.
- A knowledge platform creates scale through authority, relationships, and evidence.

**Suggested visual:** [Three executive takeaways](assets/diagrams/02-executive-summary.mmd)

**Speaker notes:** [Slide 2](speaker-notes.md#slide-2-executive-summary)

---

<!-- slide: 3 -->

## 3. Why This Matters Now

> Design knowledge must travel across more consumers, tools, and delivery paths than the current architecture was designed to support.

- AI introduces autonomous and semi-autonomous consumers.
- Automation turns local rules into repeatable organizational behavior.
- Multi-tool ecosystems increase translation, drift, and ownership risk.

**Evidence:** [Anthropic context engineering](../../whitepapers/beyond-components/references.md#ref-anthropic-context) · [Figma Code Connect](../../whitepapers/beyond-components/references.md#ref-figma-code-connect)

**Suggested visual:** [New consumers and ecosystem pressure](assets/diagrams/03-why-now.mmd)

**Speaker notes:** [Slide 3](speaker-notes.md#slide-3-why-now)

---

<!-- slide: 4 -->

## 4. Design Systems Have Evolved

> Each generation standardized a larger unit of design value.

- Design guidelines made preferred decisions visible.
- Component libraries made implementation reusable.
- Knowledge platforms make design intent and constraints reusable.

**Suggested visual:** [Design-system evolution](assets/diagrams/04-evolution.mmd)

**Speaker notes:** [Slide 4](speaker-notes.md#slide-4-evolution)

---

<!-- slide: 5 -->

## 5. What Today’s Design Systems Solve Well

> The current model creates real leverage and should be extended, not replaced.

- Consistency across products and journeys
- Reuse of tested interface implementation
- Collaboration through shared language and assets

**Evidence:** [GitHub Primer evolution](../../whitepapers/beyond-components/references.md#ref-github-accessibility-journey) · [Nielsen Norman Group](../../whitepapers/beyond-components/references.md#ref-nng-consistency)

**Suggested visual:** [Current design-system value](assets/diagrams/05-current-strengths.mmd)

**Speaker notes:** [Slide 5](speaker-notes.md#slide-5-current-strengths)

---

<!-- slide: 6 -->

## 6. Where Today’s Architecture Reaches Its Limits

> Reusable assets scale faster than the knowledge required to apply them correctly.

- Knowledge is fragmented across files, code, documentation, and conversations.
- Governance is often implicit or detached from the artifact.
- Tool-specific representations create dependency and drift.
- Machine consumers cannot reliably infer authority or context.

**Evidence:** [GitHub accessibility annotations](../../whitepapers/beyond-components/references.md#ref-github-annotations) · [Adobe Spectrum tokens](../../whitepapers/beyond-components/references.md#ref-spectrum-tokens)

**Suggested visual:** [Fragmentation and decision loss](assets/diagrams/06-limits.mmd)

**Speaker notes:** [Slide 6](speaker-notes.md#slide-6-limits)

---

<!-- slide: 7 -->

## 7. AI Changes the Operating Context

> Humans are no longer the only consumers of design-system guidance.

- AI requires bounded, structured, and authoritative context.
- Longer prompts cannot compensate for contradictory knowledge.
- Validation and provenance become part of design-system quality.

**Evidence:** [Anthropic effective agents](../../whitepapers/beyond-components/references.md#ref-anthropic-agents) · [GitHub agent instructions](../../whitepapers/beyond-components/references.md#ref-github-agents-md)

**Suggested visual:** [Human, software, and AI consumers](assets/diagrams/07-ai-context.mmd)

**Speaker notes:** [Slide 7](speaker-notes.md#slide-7-ai-context)

---

<!-- slide: 8 -->

## 8. Knowledge Becomes the Primary Asset

> Components operationalize design knowledge; they are not the outer boundary of what the system must govern.

- Knowledge establishes intent and authority.
- Specifications define expected behavior and constraints.
- Patterns make recurring decisions reusable.
- Components implement those decisions in products.

**Suggested visual:** [Knowledge-to-product chain](assets/diagrams/08-knowledge-chain.mmd)

**Speaker notes:** [Slide 8](speaker-notes.md#slide-8-knowledge-chain)

---

<!-- slide: 9 -->

## 9. Open Standards Create Shared Boundaries

> Standards improve portability when their authority and maturity remain explicit.

- DTCG standardizes the exchange of design-token data.
- W3C standards anchor accessible behavior and semantics.
- Google DESIGN.md signals emerging experimentation beyond tokens—not settled consensus.

**Evidence:** [DTCG 2025.10](../../whitepapers/beyond-components/references.md#ref-dtcg-format) · [WCAG 2.2](../../whitepapers/beyond-components/references.md#ref-wcag22) · [Google DESIGN.md](../../whitepapers/beyond-components/references.md#ref-google-design-md)

**Suggested visual:** [Standards and organizational knowledge](assets/diagrams/09-open-standards.mmd)

**Speaker notes:** [Slide 9](speaker-notes.md#slide-9-open-standards)

---

<!-- slide: 10 -->

## 10. UI Foundations

> UI Foundations is a reference implementation of the architectural principles introduced in this presentation.

- Canonical knowledge remains separate from implementation and presentation tools.
- Human and machine consumers use the same governed sources.
- Evidence can improve shared knowledge through review.
- Other architectures can implement the same principles.

**Suggested visual:** [UI Foundations responsibility model](assets/diagrams/10-ui-foundations.mmd)

**Speaker notes:** [Slide 10](speaker-notes.md#slide-10-ui-foundations)

---

<!-- slide: 11 -->

## 11. Why Open Source

> Openness makes architectural assumptions inspectable and reduces strategic coupling.

- Transparent governance and evolution
- Independent validation and contribution
- Portable formats and replaceable tools
- Shared foundational work without exposing private product knowledge

**Suggested visual:** [Open reference model](assets/diagrams/11-open-source.mmd)

**Speaker notes:** [Slide 11](speaker-notes.md#slide-11-open-source)

---

<!-- slide: 12 -->

## 12. Why This Matters for TUI

> Governed design knowledge can increase strategic flexibility across products, markets, and delivery models.

- Reusable knowledge across teams and journeys
- Stronger AI readiness and verification
- Explicit governance and decision ownership
- Greater scalability with less repeated interpretation
- Lower long-term switching and coordination cost

**Suggested visual:** [Strategic value for TUI](assets/diagrams/12-tui-value.mmd)

**Speaker notes:** [Slide 12](speaker-notes.md#slide-12-tui-value)

---

<!-- slide: 13 -->

## 13. Roadmap

> The architecture should earn its expansion through evidence.

- **Near term:** establish ownership, lifecycle, authority, and a bounded pilot.
- **Medium term:** connect knowledge to assets, standards, and assurance.
- **Long term:** scale governed retrieval across human and AI workflows.

**Suggested visual:** [Three-horizon roadmap](assets/diagrams/13-roadmap.mmd)

**Speaker notes:** [Slide 13](speaker-notes.md#slide-13-roadmap)

---

<!-- slide: 14 -->

## 14. Discussion

> Leadership validation should precede platform expansion.

- Is this direction strategically relevant?
- Which assumptions need challenging?
- Where should we pilot this?
- What would success look like?

**Suggested visual:** [Leadership decision frame](assets/diagrams/14-discussion.mmd)

**Speaker notes:** [Slide 14](speaker-notes.md#slide-14-discussion)

---

<!-- slide: 15 -->

## 15. Closing

**Suggested visual:** [Three generations of design systems](assets/diagrams/15-closing.mmd)

**Speaker notes:** [Slide 15](speaker-notes.md#slide-15-closing)

> The first generation of design systems standardized interfaces.
>
> The second standardized implementation.
>
> The next generation will standardize design knowledge.
