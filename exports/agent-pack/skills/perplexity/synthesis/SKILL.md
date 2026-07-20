---
name: synthesis
description: Load when combining multiple findings into a coherent interpretation that preserves evidence, conflicts, and next steps.
metadata:
  canonical_title: Synthesis
  source_id: specification.capability.synthesis
  source_path: capabilities/synthesis.md
---

# Synthesis

## Question

What does it mean to synthesize multiple findings?

## Purpose

Synthesis combines multiple findings into a coherent interpretation that preserves evidence, conflicts, priorities, and recommended next steps.

## Inputs

- Findings from multiple reviews or knowledge sources
- Evidence and assumptions
- Conflicts or gaps
- Intended audience
- Decision or summary need

## Required Knowledge

- Design intelligence
- Precedence
- Relationship types
- Relevant domain documents for the findings being synthesized

## Reasoning Method

1. Group findings by theme rather than source order.
2. Separate evidence, assumptions, conflicts, and recommendations.
3. Apply precedence when findings disagree.
4. Identify the decisive issues.
5. Preserve nuance without concatenating every input.
6. Produce a coherent summary with follow-up actions.

## Outputs

- Synthesized summary
- Thematic findings
- Conflict resolution notes
- Prioritized next steps
- Open questions

## Quality Gates

- Synthesis does not hide conflicts.
- Higher-precedence knowledge is favored when sources disagree.
- The output is shorter and clearer than the combined inputs.
- Recommendations remain traceable to source findings.

## Related Documents

- `principle.foundation.design-intelligence`
- `governance.precedence`
- `reference.relationship-types`
- `workflow.operational.architecture-review`
