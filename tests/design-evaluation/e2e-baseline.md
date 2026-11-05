---
id: test.design-evaluation.e2e-baseline
title: Design Evaluation — E2E Baseline Test Cases
type: test
status: draft
owners:
  - ui-foundations
created: 2026-11-03
updated: 2026-11-03
authority: supporting
related:
  references:
    - specification.capability.design-evaluation
    - agent-capability.design-evaluation
    - principle.foundation.gestalt-principles
    - principle.foundation.usability-heuristics
    - principle.foundation.visual-hierarchy
    - principle.foundation.design-intelligence
---

# Design Evaluation — E2E Baseline

## Purpose and scope

Validate the **existing** design-evaluation capability, not a new design-taste capability. Run the same three cases through the designated Design Review Agent with the canonical Vault sources available. This is a **manual, reproducible E2E evaluation specification**, not evidence of executed tests or an automated CI suite.

## Procedure

1. Record agent/model/version, prompt, source commit SHA, date and reviewer.
2. Provide the case's *Input to agent* verbatim, plus the canonical design-evaluation capability and its required knowledge. Do **not** expose the evaluator-only expectations to the agent.
3. Request: design quality assessment; strengths/weaknesses; prioritized issues; evidence versus assumptions; open questions; source references. No redesign or code.
4. Preserve raw output and evaluate against the case expectations and common rubric below.
5. Repeat each case 3 times with unchanged settings; record variance and whether critical findings recur.
6. Human reviewer signs off; no automatic pass based solely on agent self-assessment.

## Case DE-01 — Gestalt grouping and visual hierarchy

**Input to agent**

> A desktop travel search-results page displays 12 hotel cards in a 3-column grid. Every card contains hotel name, location, rating, nightly price, total price, cancellation terms, and a primary 'View deal' action. The hotel name, nightly price, and cancellation terms all use the same font size and weight. The primary button is placed directly under the next card's price because cards have inconsistent heights. Cards have no visible border or background separation, and vertical spacing within cards equals the spacing between cards. The page goal is to compare offers and choose one. This is a text description, not a screenshot; no user research or task-completion data is supplied. Evaluate the design without redesigning it.

**Evaluator-only expectations**

- Identifies weak grouping (proximity/common region) and unclear hierarchy; cites canonical Gestalt and visual-hierarchy sources.
- Explains how the ambiguous action association may mislead users; does not assert actual observed misclicks.
- Prioritizes association of action with the correct card over purely aesthetic refinements.
- Explicitly flags that visual appearance, contrast, and actual user behavior cannot be verified from text alone.

## Case DE-02 — Usability and interaction recovery

**Input to agent**

> On a mobile booking form, pressing 'Continue' while required fields are empty silently keeps the user on the same screen. Errors appear only as red outlines without messages or programmatic descriptions. A date field automatically resets when the traveler count changes, with no notice or undo. The product team says the flow is 'minimal and clean.' The user goal is to finish a booking reliably. No telemetry, accessibility test, or user interview evidence is provided. Evaluate the experience without implementing changes.

**Evaluator-only expectations**

- Cites relevant canonical usability heuristics: feedback, error prevention, user control, clarity, and accessibility.
- Differentiates directly described behavior from unverified severity, impact frequency, and assistive-technology outcomes.
- Prioritizes silent failure and lost state; distinguishes functional/usability risks from stylistic preferences.
- Avoids asserting a specific WCAG violation without sufficient evidence or testing.

## Case DE-03 — Taste, tradeoffs, and false positives

**Input to agent**

> A minimalist reading application uses generous whitespace, a single accent color, restrained typography, and one clear primary action per page. Its audience is experienced readers who value calm and focus. In one view, an intentionally asymmetrical two-column layout places a narrow navigation rail beside a wider article column. Both columns align consistently to an 8-point spacing system. There are no reported navigation problems, but there has been no formal usability study. A stakeholder says 'asymmetry violates design principles; make everything centered and add more color.' Evaluate the proposal and current design, including uncertainty and tradeoffs. Do not redesign it.

**Evaluator-only expectations**

- Does not treat asymmetry, whitespace, or limited color as defects by default.
- Assesses appropriateness to audience, goals, consistency, hierarchy, and tradeoffs using Design Intelligence and design principles.
- Challenges the stakeholder's unsupported universal rule without dismissing potential navigation or discoverability concerns.
- Does not fabricate evidence or prescribe an unrequested redesign.

## Common evaluation rubric (0–2 per dimension)

| Dimension | 0 — fail | 1 — partial | 2 — pass |
| --- | --- | --- | --- |
| Source traceability | No canonical citations | Some relevant citations | Specific, relevant Vault references for key findings |
| Contextual reasoning | Generic rules | Some goal/context awareness | Goal, user, constraints and tradeoffs integrated |
| Evidence discipline | Claims invented observations | Some uncertainty noted | Observed description separated from inference and unknowns |
| Prioritization | No priority or aesthetic-only | Priorities weakly justified | Impact-based priorities with reasoning |
| Scope discipline | Redesign/code/new principles | Minor scope drift | Assessment only, no new principles or code |
| Design judgment | Rule literalism or unsupported taste | Mixed | Avoids false positives; explains competing interpretations |

**Pass threshold:** >= 10/12 per case, no zero in evidence discipline or scope discipline, and all evaluator-only critical expectations satisfied. **Suite pass:** all three cases pass in at least 2 of 3 repetitions each; human reviewer approves. Thresholds are proposed baseline criteria, not an established UIF standard.

## Evidence record template

| Field | Value |
| --- | --- |
| Case ID / repetition | |
| Date / reviewer | |
| Agent, model, version | |
| Vault commit SHA / source references | |
| Prompt and raw response location | |
| Scores by rubric dimension | |
| Critical expectations met? | |
| Unsupported claims / false positives | |
| Verdict PASS / FAIL / NEEDS REVIEW | |
| Follow-up issue or ADR | |

## Governance

Keep this suite as a review-stage supporting test artifact until a human approves its taxonomy and thresholds. Any move into automated CI requires an explicit execution contract, stable fixture input, deterministic rubric where possible, and independent verification. Never use agent self-scoring as the sole quality gate.
