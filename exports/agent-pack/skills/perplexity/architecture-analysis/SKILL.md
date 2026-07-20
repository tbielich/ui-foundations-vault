---
name: architecture-analysis
description: Load when analyzing whether a proposed structure, boundary, or relationship fits the existing knowledge architecture.
metadata:
  canonical_title: Architecture Analysis
  source_id: specification.capability.architecture-analysis
  source_path: capabilities/architecture-analysis.md
---

# Architecture Analysis

## Question

What does it mean to analyze system architecture?

## Purpose

Architecture analysis evaluates whether a proposed structure, boundary, or relationship fits the existing knowledge structure.

## Inputs

- Architecture proposal or existing structure
- Affected domains
- Claimed purpose
- Dependencies and relationships
- Known risks, gaps, or conflicts

## Required Knowledge

- Vault architecture
- Precedence model
- UI Foundations token, semantic, theme, mode, component, and pattern knowledge
- Reference taxonomies

## Reasoning Method

1. Identify the architectural question.
2. Locate the relevant knowledge domain.
3. Map dependencies and relationships.
4. Check for overlap, contradiction, and hidden coupling.
5. Evaluate fit against precedence and existing architecture.
6. Record risks, assumptions, and recommended disposition.

## Outputs

- Architecture fit assessment
- Relationship map
- Conflict or duplication findings
- Risk summary
- Recommendation or follow-up questions

## Quality Gates

- Analysis uses existing architecture as the source of truth.
- Boundaries are explicit.
- Findings distinguish architecture from operation and implementation.

## Related Documents

- `docs.architecture`
- `governance.precedence`
- `specification.ui-foundations.token-architecture`
- `specification.ui-foundations.component-architecture`
- `workflow.operational.architecture-review`
