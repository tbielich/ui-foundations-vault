---
id: index.capabilities
title: Capabilities
type: index
status: review
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: supporting
summary: Entry point for executor-independent capability definitions.
related:
  references:
    - principle.foundation.design-intelligence
    - reference.terminology
    - workflow.operational.architecture-review
---

# Capabilities

## Question

What is the capability layer?

## Purpose

The capability layer defines what kinds of work can be performed with the vault knowledge.

A capability is independent of who or what executes it. It describes reusable work, required knowledge, reasoning method, expected outputs, and quality gates.

## Inputs

- A task or review need
- Relevant vault documents
- Available evidence
- Constraints and assumptions

## Required Knowledge

- Immutable foundations
- UI Foundations architecture knowledge
- Reference terms and taxonomies
- Operational playbooks

## Reasoning Method

1. Identify the capability needed.
2. Load the relevant source knowledge.
3. Apply the capability method without introducing new principles or architecture.
4. Produce outputs that can be reviewed independently.

## Outputs

- Capability-specific findings
- Recommendations or decisions where appropriate
- Evidence and assumptions
- Follow-up questions

## Quality Gates

- The capability remains independent of concrete executors and runtimes.
- The capability references existing vault knowledge.
- The capability does not introduce implementation or operational machinery.

## Related Documents

- `principle.foundation.design-intelligence`
- `reference.terminology`
- `workflow.operational.architecture-review`
