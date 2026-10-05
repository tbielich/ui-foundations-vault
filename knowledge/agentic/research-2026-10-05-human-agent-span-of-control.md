---
id: knowledge.agentic.research-2026-10-05-human-agent-span-of-control
title: Research Notes — Human–Agent Span of Control and Agentic Load
type: research
status: draft
owners:
  - ui-foundations
created: 2026-10-05
updated: 2026-10-05
authority: supporting
summary: Supporting research on human supervisory load, agent orchestration overhead, and capacity governance for agentic workflows.
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
---

# Research Notes — Human–Agent Span of Control and Agentic Load

## Purpose

Capture external evidence about the capacity required to supervise AI agents and agentic workflows.

The research was prompted by an organisational-design question: if AI protects human cognitive capacity by filtering, prioritising, drafting, or executing work, should organisations also explicitly allocate capacity for the work of orchestrating and maintaining that AI assistance?

These notes are supporting research only. They do not establish a UIF governance rule or a universal agent-per-person limit.

## Executive finding

AI assistance can create real productive capacity, but the evidence does not support treating all saved task time as automatically available organisational capacity.

AI changes the work system. Some execution and information-processing effort disappears, while new effort appears in:

- goal definition and context provision;
- output verification and correction;
- exception handling;
- permissions and integration management;
- workflow maintenance;
- incident and risk management.

The strongest candidate principle is:

> Do not govern AI capacity by agent count. Govern it by human supervisory load, risk exposure, and demonstrated performance.

A fixed limit such as “12 agents per person” is not empirically supported by the reviewed evidence. Complexity-weighted load plus risk gates is a more credible model.

## 1. Evidence summary

### 1.1 AI can reduce local task effort

The reviewed evidence supports meaningful productivity gains in bounded settings:

- Noy and Zhang reported about 40% lower task time and 18% higher quality for tested professional writing tasks.
- Brynjolfsson, Li, and Raymond reported a 14% average productivity increase in customer support, with larger gains for novice and lower-skilled workers.
- Dell’Acqua et al. found consultants completed 12.2% more tasks, 25.1% faster, with substantially higher assessed quality on tasks inside the AI capability frontier.
- A Microsoft Research field experiment found reduced email time for workers with integrated AI assistance.

These findings support the claim that AI can remove effort from specific activities.

They do not demonstrate that the same amount of time becomes durable net capacity across an entire role.

### 1.2 Cognitive load can move rather than disappear

AI assistance can remove search, drafting, or coordination work while adding supervisory work:

- deciding whether an output is trustworthy;
- reconstructing missing context;
- checking whether the correct objective was followed;
- detecting subtle errors;
- monitoring asynchronous processes;
- maintaining a mental model of delegated work.

Human-factors research on automation bias and supervisory control makes the same point: reliable automation does not eliminate monitoring demand and may create complacency or missed-event risk.

### 1.3 Goal-aware filtering is an emerging pattern, not yet a proven capacity model

Current products increasingly use goals, deadlines, dependencies, workload, and organisational context to surface what requires attention.

Asana is one example of this product direction.

However, the reviewed research could not verify the specific claim that Asana employees or product managers save approximately one to two working days per week through AI-based attention filtering.

Treat that claim as unverified unless the original case study, interview, or measurement source is located.

### 1.4 There is no validated universal human–agent span

The reviewed evidence does not establish a universal supervisory limit such as 7, 12, or 20 agents or workflows per person.

Research on multi-system supervisory control instead models capacity through factors such as:

- intervention frequency;
- task waiting time;
- time available before intervention is required;
- autonomy and neglect time;
- quality of system feedback;
- concurrent workload;
- cost of missing an event.

Organisational span-of-control research reaches a similar conclusion: supervision capacity depends on work complexity, standardisation, independence, responsibility, and time demand rather than a single headcount number.

For agentic systems, supervisory-control engineering is therefore a better analogy than simple line management.

## 2. Operating modes

UIF should distinguish different operating modes because their supervisory demands are not equivalent.

| Mode | Primary human role | Typical supervisory need |
| --- | --- | --- |
| Task automation | Define rules and handle exceptions | Low |
| AI assistance | Use and judge suggestions | Interaction-level |
| Autonomous agent | Delegate an objective and monitor execution | Medium to high |
| Agentic / multi-agent workflow | Govern process, dependencies, permissions, and delegated actions | High |

The important shift is from interaction effort to operational ownership.

As autonomy rises, human effort increasingly includes:

```text
interaction
+ verification
+ exceptions
+ maintenance
+ governance
```

## 3. Candidate Agentic Load model

### 3.1 Net capacity

Capacity should be measured as a system outcome rather than raw time saved:

```text
net capacity
= avoided work
- orchestration
- verification
- exception handling
- coordination
- maintenance
```

A workflow creates positive capacity only when the avoided work remains greater than its supervisory and governance overhead while quality and risk stay within tolerance.

### 3.2 Supervisory-load dimensions

Instead of counting agents, score the factors that create human supervision demand:

- autonomy and action scope;
- criticality of the outcome;
- exception or intervention frequency;
- review intensity;
- workflow-change frequency;
- cross-system and permission complexity;
- coupling with other workflows.

For initial UIF use, prefer a transparent additive or tiered model over a mathematically precise formula.

The goal is not false precision. The goal is to make invisible operational load visible and comparable.

### 3.3 Portfolio effects

Several independent low-risk workflows may be easier to supervise than one highly autonomous, high-impact workflow.

Load also increases when workflows:

- share data or permissions;
- depend on one another;
- produce concurrent exceptions;
- change frequently;
- require fast human intervention;
- operate asynchronously outside normal working hours.

The portfolio, not only the individual agent, is therefore the relevant governance object.

## 4. Candidate governance tiers

| Tier | Workflow profile | Candidate expectation |
| --- | --- | --- |
| 0 — Personal assistance | Suggestion only, reversible, low risk | Informal ownership and lightweight review |
| 1 — Bounded automation | Predefined actions in one system | Named owner, logs, periodic quality checks |
| 2 — Autonomous workflow | Chooses or sequences actions, potentially across systems | Explicit capacity allocation, documented controls, exception monitoring |
| 3 — High-impact autonomy | Sensitive data, external commitments, or material risk | Human approval gates, backup owner, incident process |
| 4 — Multi-agent operations | Coupled agents, broad permissions, or continuous operation | Portfolio governance, change management, dedicated operational ownership |

A fixed count may still be useful as a review trigger, but not as the primary capacity rule.

Example: “more than N autonomous workflows requires portfolio review” is defensible as an internal control. “Humans can safely manage N agents” is not supported by the evidence.

## 5. Candidate UIF interpretation

### Human

Agent orchestration is work.

If a person is responsible for meaningful agentic workflows, the associated context preparation, review, exceptions, maintenance, and governance should not remain invisible.

### Agent

An agent should expose enough state, evidence, exceptions, and provenance for a human owner to supervise it without reconstructing the entire execution manually.

Higher autonomy should increase the evidence and control requirements rather than reduce them.

### System

The system should separate:

- gross assistance benefit;
- supervisory load;
- net organisational capacity;
- risk exposure.

This creates a measurable operating model instead of assuming that every additional agent is a productivity multiplier.

## 6. UIF hypotheses

### H1 — Net capacity matters more than gross time saved

Agentic assistance is valuable when the complete human–agent system produces positive net capacity while preserving quality and control.

### H2 — Supervisory load matters more than agent count

The number of agents or workflows is a weak primary capacity metric.

Autonomy, risk, exceptions, review intensity, change, permissions, and coupling are stronger predictors of human supervisory demand.

### H3 — Agent orchestration should become explicit capacity

At higher autonomy and risk tiers, orchestrating and maintaining agentic assistance should be represented in workload and capacity planning.

### H4 — Fixed limits are governance triggers, not universal laws

A numerical limit may be useful to trigger review or escalation, but it should not be treated as an empirically valid human capacity constant.

## 7. Possible UIF follow-up

### ADR questions

- Should UIF define Agentic Load as a formal governance concept?
- Should autonomous workflows declare autonomy, criticality, review, exception, and permission characteristics in execution contracts?
- Should portfolio-level risk and supervisory load constrain how many concurrent autonomous workflows may be assigned to one human owner?
- Which tiers require mandatory human approval or backup ownership?
- Which metrics belong in UIF-INT verification evidence versus UIF-STO operational views?
- Should “net capacity created” become an evaluation criterion for agentic workflow maturity?

### Candidate spike — Human–Agent Capacity Pilot

Test the model with one to three real UIF workflows of different profiles.

Measure:

- direct time avoided;
- orchestration minutes;
- review time;
- intervention count;
- exception rate;
- rework;
- workflow-change frequency;
- incidents and near misses;
- response latency to exceptions;
- net capacity over several weeks.

Increase responsibility progressively rather than introducing many workflows at once.

The practical limit is reached when marginal capacity approaches zero or when review quality, response latency, mental-model accuracy, or risk controls begin to degrade.

## 8. Research provenance and source status

Research synthesis: Perplexity-assisted research, 2026-10-05.

Important evidence-quality note:

- productivity studies provide useful empirical evidence for bounded tasks and settings;
- human-factors and supervisory-control research provides stronger conceptual support for load-based supervision;
- vendor claims are supporting signals, not governance evidence;
- the specific Asana “one to two days per week” claim remains unverified.

Primary and supporting references from the research:

- Noy & Zhang, *Experimental Evidence on the Productivity Effects of Generative Artificial Intelligence*, Science, 2023: https://www.science.org/doi/10.1126/science.adh2586
- Brynjolfsson, Li & Raymond, *Generative AI at Work*, NBER: https://www.nber.org/system/files/working_papers/w31161/w31161.pdf
- Dell’Acqua et al., *Navigating the Jagged Technological Frontier*, Harvard Business School: https://www.hbs.edu/faculty/Pages/item.aspx?num=64700
- Microsoft Research, *Shifting Work Patterns with Generative AI*: https://www.microsoft.com/en-us/research/publication/shifting-work-patterns-with-generative-ai/
- Parasuraman & Manzey, review of automation bias and complacency: https://journals.sagepub.com/doi/10.1177/0018720810376055
- Asana, AI task management product description: https://asana.com/uses/ai-task-management
- Microsoft Work Trend Index 2025: https://www.microsoft.com/en-us/worklab/work-trend-index/2025-the-year-the-frontier-firm-is-born
- Multi-UAV supervisory-control research: https://link.springer.com/chapter/10.1007/978-3-540-72696-8_2
- McKinsey, span-of-control framework: https://www.mckinsey.com/capabilities/people-and-organization/our-insights/how-to-identify-the-right-spans-of-control-for-your-organization

## Research status

Supporting research only.

Before promotion into an ADR, specification, workflow, or governance rule:

1. verify the primary sources that materially support the proposed rule;
2. calibrate the load dimensions against real UIF workflows;
3. test whether measured supervisory effort predicts capacity better than workflow count;
4. define risk gates independently from workload scoring;
5. promote only the durable UIF decision, not the external source's implementation model.
