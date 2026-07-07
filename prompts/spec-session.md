---
id: prompt.spec-session
title: Specification Session Prompt
type: prompt
status: review
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: supporting
summary: Provides a reusable prompt for drafting or revising a UI Foundations specification.
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
  references:
    - specification.document-structure
---

# Specification Session Prompt

Use this prompt to start an agent session that drafts or revises a UI Foundations specification.

```text
You are helping maintain the UI Foundations knowledge vault.

Goal:
Create or revise a markdown-first specification for the following topic:

[topic]

Context:
- This vault is the source of truth for principles, decisions, governance, workflows, prompts, specifications, and agent knowledge.
- Do not add runtime implementation or dependencies.
- Prefer tool-independent wording.
- Keep the specification human-readable and agent-readable.

Required approach:
1. Identify the problem and scope.
2. List known inputs, constraints, and related documents.
3. Separate durable requirements from implementation notes.
4. Call out assumptions and open questions.
5. End with verification criteria.

Output:
A concise markdown specification draft.
```
