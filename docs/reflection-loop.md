---
id: docs.reflection-loop
title: Reflection Loop
type: workflow
status: draft
owners:
  - ui-foundations
created: 2026-07-09
updated: 2026-07-09
authority: supporting
summary: Defines how insights from issues, PRs, experiments, and reviews become reusable vault knowledge.
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
  references:
    - knowledge.lessons.index
    - registry.sync-contract
---

# Reflection Loop

## Goal

After significant UI Foundations work, extract reusable knowledge so the ecosystem improves without scattering rules across repositories.

## When to Reflect

Run the reflection loop after:

- A major issue or PR.
- A release-impacting bug.
- A repeated review finding.
- A token, component, accessibility, or package boundary decision.
- An experiment closeout.
- A cross-repo sync request.

## Inputs

- Source repository.
- Issue, PR, experiment, or review link.
- Relevant local files or docs.
- Observed decision or problem.
- Any affected vault documents.

## Steps

1. Capture the concrete local fact.
2. Separate local implementation detail from reusable insight.
3. Write a lesson in `knowledge/lessons/` when the insight may apply beyond one repository.
4. Link the lesson to source evidence and affected areas.
5. Check whether similar lessons already exist.
6. If lessons recur, propose promotion into governance, specification, workflow, prompt, or export pack.
7. Update registries only when repository consumption or artifact policy changes.

## Outputs

- A documented lesson, or a note explaining why no reusable lesson was found.
- Promotion proposal when repeated evidence exists.
- Follow-up issue for the vault or affected runtime repository.

## Promotion Rules

Repeated lessons become stronger artifacts only after review:

- Governance when the lesson defines trust, review, ownership, lifecycle, or decision rights.
- Specification when the lesson defines expected behavior, structure, or constraints.
- Workflow when the lesson describes repeatable action.
- Prompt when the lesson helps agents operationalize existing knowledge.
- Export pack update when consuming repositories need reviewed reusable guidance.

## Constraints

- Do not change runtime implementation from the vault.
- Do not promote a single local workaround into governance without evidence.
- Do not treat prompts as authority over governance, principles, ADRs, or specifications.
- Do not automate cross-repo sync without the sync contract and manual review.

## Verification

A reflection outcome is ready when:

- The source and evidence are traceable.
- The generalized lesson is separate from implementation detail.
- Affected repositories or domains are named.
- The proposed promotion path, if any, is explicit.
- No protected local files are changed by vault work.
