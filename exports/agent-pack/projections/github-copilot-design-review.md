---
id: export-pack.agent.projection.github-copilot-design-review
title: GitHub Copilot Design Review Projection
type: export-pack
status: draft
owners:
  - ui-foundations
created: 2026-07-20
updated: 2026-07-20
authority: derived
summary: Derived GitHub Copilot projection of the design-review-agent role. References canonical source documents; does not introduce new domain rules.
related:
  governed_by:
    - governance.precedence
    - registry.sync-contract
  references:
    - agent-capability.role.design-review-agent
    - agent-capability.design-evaluation
    - agent-capability.verification
    - workflow.component-review
    - workflow.operational.component-review
---

# GitHub Copilot — Design Review Agent Projection

## Source Documents

This projection is derived from:

- `agents/roles/design-review-agent.md` (`agent-capability.role.design-review-agent`)
- `agents/capabilities/design-evaluation.md` (`agent-capability.design-evaluation`)
- `agents/capabilities/verification.md` (`agent-capability.verification`)
- `workflows/component-review.md`
- `operational/component-review.md`

Source version reference: see `registry/agents.yml` version 0.1

## Target Ecosystem

GitHub Copilot (AGENTS.md or Copilot instructions file in a consuming repository)

## Projection Rules

- This projection is derived. The source documents in the vault take precedence.
- Manual editing is permitted in consuming repositories, provided local changes do not claim vault authority.
- Changes to source documents must be reviewed before updating this projection.
- Changes flow back to the vault through the reflection loop and lesson process.

## Suggested Instructions Text

Use the following as a starting point for a consuming repository's AGENTS.md or Copilot instructions.

---

### Design Review

When reviewing a component proposal or design change:

1. Identify the user need and context.
2. Evaluate using design principles, Gestalt principles, usability heuristics, and visual hierarchy.
3. Check whether existing components or patterns already cover the need.
4. Separate confirmed issues from assumptions.
5. Rank findings by impact on understanding and use.

Outputs must include:

- Review recommendation: accept, revise, defer, or reject.
- Key rationale with cited source knowledge.
- Explicit assumptions and open questions.

Do not redesign the artifact unless the review scope explicitly requests it.  
Do not introduce new principles; reference existing vault knowledge.  
Follow vault precedence when findings conflict with prompts or examples.

---

## Consumption Rules

- Consume through `registry/sync-contract.yml`.
- Keep local repository constraints authoritative for implementation decisions.
- Do not treat this projection as a source document.
- Record reusable insights as vault lessons through the reflection loop.
