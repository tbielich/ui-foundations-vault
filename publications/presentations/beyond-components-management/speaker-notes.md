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

- **Opening question:** What changes when AI becomes part of the team?
- **Starting point:** Design systems already make visual decisions and components reusable.
- **Design knowledge:** Standards, decisions, specifications, patterns, constraints, ownership, and evidence.
- **Governance:** Defines who owns this knowledge and how it changes.
- **Goal:** Test the problem and assumptions—not approve a fixed solution or replace the current system.

<a id="slide-2-executive-summary"></a>

## Slide 2 — Three key ideas

- **Components remain important:** They do not contain every decision needed to use them well.
- **Important context lives elsewhere:** Accessibility, composition rules, reasons, exceptions, and lifecycle status.
- **AI needs clear context:** Automated processes may repeat a wrong assumption when guidance conflicts.
- **Knowledge platform:** A governed source of reusable knowledge, not another documentation website.
- **Discussion:** Treat all three ideas as questions to test.

<a id="slide-3-why-now"></a>

## Slide 3 — Why This Matters Now

- **More tools:** Product work now spans design, code, documentation, automation, and AI.
- **AI agent:** Software that completes tasks with some independence and needs reliable context.
- **Core challenge:** Find the governing source and distinguish rules from drafts, examples, and local exceptions.
- **Anthropic evidence:** More context is not always better; relevant and reliable context matters.
- **Figma evidence:** Code Connect maps design assets to production code and guidance.

<a id="slide-4-evolution"></a>

## Slide 4 — Design Systems Have Evolved

- **Guidelines:** Made preferred choices visible.
- **Components:** Made some choices reusable in products.
- **Knowledge:** Could make intent, constraints, relationships, and evidence reusable.
- **Important caveat:** This is a strategic lens, not a universal maturity model.
- **Question:** Can guidelines and components scale without reusable design knowledge?

<a id="slide-5-current-strengths"></a>

## Slide 5 — Today’s strengths

- **What works:** Consistency, less repeated implementation, and better collaboration.
- **GitHub Primer:** Shared components and design tokens can spread improvements across many products.
- **Design tokens:** Named data for design decisions.
- **No restart:** These strengths are the base for the discussion.
- **Test the assumption:** Does the current system already hold all important context?

<a id="slide-6-limits"></a>

## Slide 6 — Today’s challenges

- **Fragmentation:** Knowledge sits across design files, code, documentation, issues, and conversations.
- **Unclear rules:** Ownership, status, and relationships can be difficult to understand.
- **GitHub evidence:** An accessible component does not guarantee an accessible page; context still matters.
- **Adobe evidence:** Tokens contain only part of the information needed to build a component.
- **Architectural question:** Should the system manage knowledge with clear identity, ownership, status, and evidence?

<a id="slide-7-ai-context"></a>

## Slide 7 — AI changes how we build products

- **Narrow claim:** AI is a new consumer of guidance, not a replacement for designers or engineers.
- **AI needs:** The governing source, optional choices, prohibited choices, and clear output checks.
- **Prompt risk:** Copied instructions can become outdated across tools.
- **Bounded context:** A small set of relevant, governed sources for people and AI.
- **Priority:** Start with knowledge and governance; choose models and tools later.

<a id="slide-8-knowledge-chain"></a>

## Slide 8 — Components are not enough

- **Knowledge:** Records intent, standards, decisions, ownership, and evidence.
- **Specifications and patterns:** Turn knowledge into requirements and reusable decisions.
- **Components and products:** Apply those decisions in real customer and business contexts.
- **Clear boundary:** Knowledge does not replace research, product strategy, or local design judgment.
- **Key point:** Components remain important, but they are results of decisions.

<a id="slide-9-open-standards"></a>

## Slide 9 — The industry is moving

- **Different maturity levels:** These examples are not equivalent.
- **WCAG:** An established W3C standard that defines accessibility requirements.
- **DTCG:** A standardized format for exchanging design-token data.
- **Google DESIGN.md:** An emerging experiment, not an established standard.
- **Principle:** Use standards when they reduce repeated translation and dependence on one tool.

<a id="slide-10-ui-foundations"></a>

## Slide 10 — UI Foundations

- **Positioning:** UI Foundations is one possible reference implementation, not the only solution.
- **Reference implementation:** A working example used to test architectural ideas.
- **Separation:** Shared knowledge remains separate from tools and runtime assets, such as code and tokens.
- **Questions to test:** Can stable names, clear priority rules, and shared sources improve outcomes?
- **Architecture choice:** Other structures and terms could apply the same principles.

<a id="slide-11-open-source"></a>

## Slide 11 — Why open?

- **Implementation choice:** The main argument does not depend on open source.
- **Potential value:** Shared learning, independent review, and less dependence on one tool.
- **Vendor lock-in:** Changing tools becomes difficult or costly.
- **Privacy boundary:** Internal research, strategy, and customer data can remain private.
- **Real costs:** Contribution rules, compatibility, security ownership, and ongoing maintenance.

<a id="slide-12-tui-value"></a>

## Slide 12 — What could this mean for TUI?

- **Hypotheses, not promises:** Every benefit needs validation.
- **TUI context:** Many products, markets, channels, and technology stacks may create repeated work.
- **Potential value:** Reuse, AI support, clearer ownership, and more choice across tools.
- **Trade-off:** A knowledge platform also creates maintenance work.
- **Pilot measures:** Discovery time, repeated deviations, review findings, and correction cost.

<a id="slide-13-roadmap"></a>

## Slide 13 — Roadmap

- **Learn:** Define ownership, status, priority rules, and one small pilot.
- **Stay focused:** Do not move all documentation or select complex tools yet.
- **Validate:** Connect pilot knowledge to components, design assets, standards, and checks.
- **Scale:** Expand only what shows value for people and AI.
- **Decision rule:** Keep each stage reversible and use evidence to continue.

<a id="slide-14-discussion"></a>

## Slide 14 — Questions

- **Relevance:** Does this direction address an important TUI problem?
- **Alternatives:** Could stronger documentation or design operations solve it more simply?
- **Risk:** Standardization may remove useful local choice when boundaries are unclear.
- **Pilot:** Find a small test across design, engineering, accessibility, and product.
- **Measures first:** Agree on success measures before choosing tools.

<a id="slide-15-closing"></a>

## Slide 15 — Closing

- **Close on the progression:** Do not return to UI Foundations.
- **First generation:** Made interface choices visible and repeatable.
- **Second generation:** Placed more choices inside reusable components.
- **Next generation:** May make the knowledge behind those choices reusable.
- **Final question:** Is this direction relevant enough for a small, measurable pilot?
