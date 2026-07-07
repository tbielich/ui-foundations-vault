---
id: principle.design-intelligence
title: Design Intelligence
type: principle
status: stable
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: source
summary: Defines design intelligence as explicit design knowledge humans and agents can apply.
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
---

# Design Intelligence

Design intelligence is the ability to make design decisions that are coherent, contextual, and useful across product, engineering, and agent workflows.

## Principle

UI Foundations should encode design knowledge in forms that humans can reason about and agents can apply without guessing.

## Implications

- Design rules should explain intent, not only mechanics.
- Tokens, components, and patterns should be grounded in product use cases.
- Specifications should expose constraints, tradeoffs, and examples.
- Agent prompts should encourage verification before generation.
- Visual quality should be treated as a system property, not a final polish step.

## Quality Bar

A design-intelligent artifact should answer:

- What problem does this solve?
- What decisions does this constrain?
- What should remain flexible?
- How can a reviewer tell whether it worked?
