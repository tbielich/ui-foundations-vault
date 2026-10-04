---
id: governance.natural-writing
title: Natural Writing Contract
type: governance
status: review
owners:
  - ui-foundations
created: 2026-10-04
updated: 2026-10-04
authority: source
summary: Defines global writing invariants and style heuristics for human- and agent-authored UIF text.
---

# Natural Writing Contract

## Purpose

UIF text should sound appropriate to its author, audience, medium, and task. Humans and agents must prefer concrete information over formulaic completeness, rhetorical polish, or generic assistant language.

This contract applies to generated and edited prose across UIF, including documentation, research, ADRs, specifications, issues, pull requests, reviews, interface copy, and agent outputs. Content-specific rules may add constraints but must not weaken the hard rules below.

## Hard Rules

### Truth and attribution

- Never invent sources, authors, publications, URLs, studies, identifiers, quotations, statistics, institutions, evidence, or personal experience.
- Do not use vague authority claims such as "experts say", "studies show", or "critics argue" without attributable evidence.
- Separate observed facts from interpretation.
- Do not assign significance, impact, recognition, or strategic importance without evidence.
- State uncertainty in terms of the missing fact or evidence. Do not hide uncertainty behind generic model disclaimers.

### Voice

- Do not use assistant filler or conversational boilerplate unless the requested medium requires it.
- Do not simulate humanity through invented memories, feelings, biography, mistakes, or deliberate typos.
- Preserve the author's existing voice when editing. Do not normalize every text into one professional register.
- Match the medium. Interface copy, an ADR, a PR, research notes, and a personal message must not share one default structure or tone.

### Substance

- Prefer concrete actions, observations, constraints, examples, and consequences over abstract claims.
- Prefer direct verbs to unnecessary nominalizations.
- Do not add generic benefits, risks, challenges, conclusions, or future outlooks merely to make a text appear complete.
- A conclusion must add a decision, consequence, synthesis, or next action. It must not repeat the preceding text.

## Style Heuristics

These are diagnostic signals, not banned syntax. Use them when the content requires them; revise them when they exist only because they are familiar generation patterns.

### Structure

- Structure follows content. Do not generate a default sequence such as introduction, benefits, challenges, future, and conclusion.
- Use headings only when they improve navigation.
- Use lists for genuinely enumerable content, not to fragment ordinary prose.
- Do not force ideas into groups of three.
- Paragraph and sentence lengths may vary naturally.
- Use emphasis sparingly and only when it improves scanning.
- Prefer normal punctuation to repeated em dashes.

### Language

Avoid habitual use of:

- inflated significance language such as "pivotal", "crucial", "landmark", or equivalent claims without evidence;
- promotional adjectives where factual description is sufficient;
- editorial meta-language such as "it is important to note";
- assistant phrases such as "of course", "great question", "let's dive in", or "I hope this helps";
- mechanical transitions such as repeated "furthermore", "additionally", or "moreover";
- automatic summaries such as "in conclusion" when no new synthesis follows;
- formulaic contrasts such as "not only X, but also Y" when no real contrast exists;
- decorative "from X to Y" ranges;
- repetitive participial constructions or sentence templates.

No individual phrase is prohibited when it is the clearest wording for the context. Repetition and formulaic use are the failure condition.

## Content-Type Inheritance

This governance document is the baseline for all prose-producing capabilities and workflows.

A content-type specification may add rules for its context:

- UX writing: brevity, action orientation, accessibility, user state, canonical terminology.
- Documentation: scannability, technical precision, reproducibility.
- ADRs: decision clarity, evidence, alternatives, consequences.
- Research: provenance, uncertainty, distinction between evidence and hypothesis.
- GitHub communication: actionable context, concise rationale, explicit status and next action.

Lower-precedence documents must reference this contract rather than copy it.

## Agent Application

Before returning or committing prose, an agent should check for:

- `unsupported-authority`
- `unsupported-significance`
- `invented-evidence`
- `assistant-boilerplate`
- `generic-transition`
- `redundant-summary`
- `formulaic-tricolon`
- `formulaic-contrast`
- `promotional-language`
- `unnecessary-heading`
- `unnecessary-list`
- `repetitive-sentence-pattern`
- `unnecessary-em-dash`
- `generic-future-section`
- `voice-normalization`

A detected signal is a review trigger, not an automatic rewrite. The agent must first determine whether the pattern serves the content.

## Review Rule

For every sentence, prefer this progression:

**claim or action -> concrete information -> necessary context**

Avoid this progression:

**claim -> rhetorical amplification -> abstract significance -> repeated summary**

The final question is not "does this sound human?" It is:

**Would this wording make sense for this author, audience, medium, and task if no generative system were involved?**
