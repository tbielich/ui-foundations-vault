---
id: lesson.agentic-repository-scan
title: Agentic Repository Knowledge Scan
type: lesson
status: review
owners:
  - ui-foundations
created: 2026-09-13
updated: 2026-09-13
authority: supporting
summary: Extracts reusable agentic architecture lessons from UI Foundations experiments and identifies evidence-backed promotion candidates.
tags:
  - agentic
  - intelligence
  - orchestration
consumers:
  - human
  - agent
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
    - governance.verification-review
  supports:
    - principle.selective-activation
  references:
    - docs.reflection-loop
---

# Agentic Repository Knowledge Scan

## Purpose

This scan separates durable, tool-independent knowledge from local implementation details across the UI Foundations agentic repositories.

It is a review artifact, not a direct runtime recommendation. Findings remain lessons until review confirms that they should be promoted into principles, governance, specifications, workflows, patterns, or agent capabilities.

## Scope

Repositories reviewed:

- [design-ai-orchestrator](https://github.com/tbielich/design-ai-orchestrator)
- [agent-gateway-poc](https://github.com/tbielich/agent-gateway-poc)
- [a2a-ollama](https://github.com/tbielich/a2a-ollama)
- [agentic-second-brain](https://github.com/tbielich/agentic-second-brain)
- [ui-foundations-intelligence](https://github.com/tbielich/ui-foundations-intelligence)

The scan considered architecture documents, runtime contracts, context assembly, capability discovery, executor adapters, approval handling, workflow state, structured outputs, traces, and durable memory boundaries.

## Evaluation Method

A finding is considered a promotion candidate when it is:

- supported by direct repository evidence;
- repeated across more than one implementation or planning source;
- independent of a specific model, provider, agent, protocol, or framework;
- relevant to UI Foundations beyond the source repository;
- not already fully represented by a higher-precedence Vault source.

A single local workaround remains a lesson or research hypothesis.

## Findings

### 1. Explicit Uncertainty over Fabrication

**Local facts**

- `design-ai-orchestrator` requires missing design-system information to surface as a `GAP` rather than invented data.
- `ui-foundations-intelligence` defines missing-knowledge outcomes as warning, clarification, blocked execution, or a surfaced Vault issue. It explicitly rejects silent improvisation.

**Generalized lesson**

When required authoritative knowledge is absent, an agentic system should represent the absence explicitly and choose a governed failure mode. Plausible completion is not a substitute for source knowledge.

**Human perspective**

Reviewers can distinguish a real design-system decision from an agent assumption and can route the missing information to the correct owner.

**Agent perspective**

Executors receive an explicit state such as `gap`, `blocked`, or `clarification_required` instead of being rewarded for completing an unsupported answer.

**System perspective**

Missing knowledge becomes observable data that can be traced, measured, and resolved. It must remain distinct from retrieval failure, unsupported capability, and model failure.

**Evidence**

- [design-ai-orchestrator README](https://github.com/tbielich/design-ai-orchestrator/blob/main/README.md)
- [UI Foundations Intelligence context loading](https://github.com/tbielich/ui-foundations-intelligence/blob/main/docs/context-loading.md)
- [UI Foundations Intelligence contracts](https://github.com/tbielich/ui-foundations-intelligence/blob/main/docs/contracts.md)

**Promotion candidate**

Draft principle: **Explicit Uncertainty over Fabrication**.

A later specification should define machine-readable gap categories only after a real consumer requires them.

### 2. Contracts Bound Probabilistic Work

**Local facts**

- `design-ai-orchestrator` validates inputs before model calls and validates every model result against a strict output schema.
- `agent-gateway-poc` maps a common task/result envelope to a provider-specific Cline protocol.
- `ui-foundations-intelligence` defines separate request, workflow, capability, context, executor result, trace, verification, and synthesis contracts.

**Generalized lesson**

Probabilistic reasoning should operate inside deterministic boundaries. Inputs, outputs, lifecycle states, provenance, and verification obligations must be explicit contracts rather than prompt conventions.

**Human perspective**

Contracts make handovers reviewable and clarify which output can be trusted, retried, or rejected.

**Agent perspective**

An executor can reason freely inside the task while still returning an output that downstream systems can validate.

**System perspective**

Schema validation localizes failure at boundaries and prevents provider-native response formats from becoming ecosystem contracts.

**Evidence**

- [design-ai-orchestrator architecture](https://github.com/tbielich/design-ai-orchestrator/blob/main/docs/architecture.md)
- [design-ai-orchestrator base agent](https://github.com/tbielich/design-ai-orchestrator/blob/main/src/agents/base-agent.ts)
- [design-ai-orchestrator handover schema](https://github.com/tbielich/design-ai-orchestrator/blob/main/src/schemas/handover-output.schema.ts)
- [Agent Gateway](https://github.com/tbielich/agent-gateway-poc/blob/main/src/gateway.js)
- [UI Foundations Intelligence contracts](https://github.com/tbielich/ui-foundations-intelligence/blob/main/docs/contracts.md)

**Promotion candidate**

Specification candidate: **Agent Execution Contract**, covering task, result, trace, source references, constraints, and adapter mapping. Verification and synthesis must remain separate contracts.

### 3. Capability Is Durable; Executor Is Replaceable

**Local facts**

- `a2a-ollama` demonstrates capability discovery through Agent Cards and exposes tool capabilities through a protocol bridge.
- `agent-gateway-poc` selects adapters by requested capabilities.
- `ui-foundations-intelligence` deliberately moves capability identity and requirements into Vault knowledge while treating agents, models, and providers as runtime choices.

**Generalized lesson**

The durable abstraction is what work can be performed and under which requirements. The executor is an interchangeable runtime binding selected after capability resolution.

**Human perspective**

Teams can describe needed work without choosing Cline, Codex, Kiro, Ollama, or another implementation in advance.

**Agent perspective**

Executors advertise or are mapped to eligible capabilities, but they do not own the canonical definition of those capabilities.

**System perspective**

Capability resolution can evaluate required inputs, knowledge, output contracts, quality gates, privacy, cost, and availability before binding an executor and model.

**Evidence**

- [A2A Agent Card](https://github.com/tbielich/a2a-ollama/blob/feat/mcp-stdio-context/a2a/core/agent_card.py)
- [Agent Gateway selection](https://github.com/tbielich/agent-gateway-poc/blob/main/src/gateway.js)
- [UI Foundations Intelligence capability resolution](https://github.com/tbielich/ui-foundations-intelligence/blob/main/docs/capability-resolution.md)
- [Migration from a2a-ollama](https://github.com/tbielich/ui-foundations-intelligence/blob/main/docs/migration-from-a2a-ollama.md)

**Promotion candidate**

Capability specification candidate defining identity, purpose, required inputs, required knowledge, reasoning method, output contract, and quality gates without executor or model ownership.

### 4. Execution Authority Is External to the Executor

**Local facts**

- `agent-gateway-poc` disables tools by default, defaults approval to deny, and answers approval requests through gateway policy.
- `ui-foundations-intelligence` places allowed actions, forbidden actions, paths, validation requirements, timeouts, approvals, and cancellation requests in task constraints and execution traces.

**Generalized lesson**

An executor may request an action, but it must not grant itself authority. Scope and approval policy belong to the orchestration and governance boundary and should be traceable independently of model reasoning.

**Human perspective**

People retain meaningful control over repository scope, tool access, risky operations, and acceptance.

**Agent perspective**

The executor can explain what it needs and why, but a separate policy boundary decides whether the action is permitted.

**System perspective**

Default-deny, bounded scope, explicit approvals, and recorded decisions provide enforceable and auditable execution control.

**Evidence**

- [Agent Gateway Cline adapter](https://github.com/tbielich/agent-gateway-poc/blob/main/src/adapters/cline.js)
- [Agent Gateway README](https://github.com/tbielich/agent-gateway-poc/blob/main/README.md)
- [UI Foundations Intelligence contracts](https://github.com/tbielich/ui-foundations-intelligence/blob/main/docs/contracts.md)
- [UI Foundations agentic workflow](https://github.com/tbielich/ui-foundations-intelligence/blob/main/docs/agentic-workflow.md)

**Promotion candidate**

Governance candidate: **Execution Authority**, defining who may authorize actions, required defaults, scope constraints, trace requirements, and the separation between execution completion and acceptance.

### 5. Context Must Be Minimal, Sufficient, and Traceable

**Local facts**

- `design-ai-orchestrator` gives each specialist only selected inputs and selected prior outputs. Its validator receives the combined result and authoritative implementation context.
- `ui-foundations-intelligence` defines context packages with sources, fragments, constraints, freshness, applicability, and omissions.
- The existing Selective Activation principle already establishes intent- and capability-driven context assembly.

**Generalized lesson**

Context optimization has three simultaneous requirements: minimize irrelevant material, preserve all mandatory constraints, and record why each source was included or omitted.

**Human perspective**

A reviewer can understand which sources shaped an answer and whether critical guidance was absent.

**Agent perspective**

Focused context reduces interference, while explicit omissions and source identifiers support escalation and verification.

**System perspective**

Context assembly becomes a reproducible product of capability resolution rather than an unbounded prompt-building step.

**Evidence**

- [design-ai-orchestrator context builder](https://github.com/tbielich/design-ai-orchestrator/blob/main/src/context/build-agent-context.ts)
- [UI Foundations Intelligence context loading](https://github.com/tbielich/ui-foundations-intelligence/blob/main/docs/context-loading.md)
- [Selective Activation over Full Loading](../../principles/selective-activation.md)

**Promotion candidate**

No new principle is required. Extend future context-package specifications with inclusion reasons, omissions, authority, precedence, freshness, and sufficiency verification.

### 6. Execution Output Is Not Acceptance

**Local facts**

- `design-ai-orchestrator` runs a validator after specialist outputs and retains validation as a separate artifact.
- `agent-gateway-poc` returns executor results and event/approval metadata without claiming governance acceptance.
- `ui-foundations-intelligence` separates `AgentResult`, `ExecutionTrace`, `VerificationResult`, `SynthesisResult`, review states, and merge states.

**Generalized lesson**

A completed executor run only proves that an executor returned. Acceptance requires separate verification against authoritative knowledge, constraints, and evidence.

**Human perspective**

Review state cannot be confused with model confidence or technical completion.

**Agent perspective**

A producer does not self-certify its result; a verifier applies independent quality gates.

**System perspective**

Completion, verification, acceptance, and merge remain separate state transitions with distinct evidence.

**Evidence**

- [design-ai-orchestrator workflow](https://github.com/tbielich/design-ai-orchestrator/blob/main/src/orchestrator/run-workflow.ts)
- [Agent Gateway Cline adapter](https://github.com/tbielich/agent-gateway-poc/blob/main/src/adapters/cline.js)
- [UI Foundations Intelligence contracts](https://github.com/tbielich/ui-foundations-intelligence/blob/main/docs/contracts.md)
- [UI Foundations agentic workflow](https://github.com/tbielich/ui-foundations-intelligence/blob/main/docs/agentic-workflow.md)

**Promotion candidate**

Specification candidate: define lifecycle semantics across queued, running, completed, awaiting review, accepted, rejected, blocked, failed, canceled, and merged without collapsing executor and governance states.

### 7. Preserve Structured Artifacts and Traces

**Local facts**

- `design-ai-orchestrator` writes separate JSON artifacts and a merged handover rather than keeping only final prose.
- `agent-gateway-poc` records events, approval decisions, usage metadata, provider/model selection, and session identifiers.
- `ui-foundations-intelligence` treats execution trace, verification, and synthesis as first-class contracts.

**Generalized lesson**

Final prose is a projection, not the complete record. Agentic work should preserve structured intermediate artifacts, provenance, changes, decisions, and traces required for review and evaluation.

**Human perspective**

Reviewers can inspect evidence and intermediate reasoning products without reconstructing them from a summary.

**Agent perspective**

Downstream agents consume bounded structured artifacts instead of scraping another agent's prose.

**System perspective**

Structured records enable replay, comparison, debugging, metrics, and Studio visualization while provider-native raw output stays behind adapters.

**Promotion candidate**

Pattern candidate: **Inspectable Agent Handover**.

### 8. Stabilize Domain Contracts Before Protocol Bridges

**Local facts**

- `a2a-ollama` explores A2A communication, MCP tool access, capability exposure, multiple transports, streaming, and webhooks in one prototype.
- `ui-foundations-intelligence` identifies bidirectional A2A/MCP bridging before domain stability as unnecessary complexity and recommends provider-neutral contracts first.

**Generalized lesson**

Protocols should implement stable domain boundaries, not define them. Combining discovery, transport, tools, context, orchestration, and inference before the domain model stabilizes creates coupling that later migration must unwind.

**Human perspective**

Architecture decisions can be reviewed in domain language before tool and protocol choices narrow the design space.

**Agent perspective**

Agents interact through stable requests, capabilities, results, and traces rather than assuming a particular transport.

**System perspective**

A2A, MCP, CLI hubs, APIs, and future protocols become adapters at explicit boundaries.

**Evidence**

- [a2a-ollama README](https://github.com/tbielich/a2a-ollama/blob/feat/mcp-stdio-context/README.md)
- [Migration from a2a-ollama](https://github.com/tbielich/ui-foundations-intelligence/blob/main/docs/migration-from-a2a-ollama.md)

**Promotion candidate**

Architecture decision candidate: protocol adapters may be added only after their domain contract exists and the adapter does not become the source of capability, governance, or knowledge semantics.

### 9. Durable Memory Complements but Does Not Replace Active Context

**Local facts**

- `agentic-second-brain` separates durable decisions, preferences, project notes, resources, archive, and explicit agent memory.
- Its operating guidance states that durable memory does not replace reading the active codebase and separates user preferences from project constraints.

**Generalized lesson**

Durable memory should preserve confirmed facts, dated decisions, preferences, and handoff context. Current repository state and task-scoped context remain separate sources that must be read at execution time.

**Evidence**

- [Logic Memory Center](https://github.com/tbielich/agentic-second-brain/blob/main/README.md)
- [Agent Operating Context](https://github.com/tbielich/agentic-second-brain/blob/main/90-agent-memory/Agent%20Operating%20Context.md)
- [Decision Log](https://github.com/tbielich/agentic-second-brain/blob/main/90-agent-memory/Decision%20Log.md)

**Promotion candidate**

Keep as a lesson until UIF has a concrete durable-memory consumer. Do not add personal-memory semantics to the Vault or Intelligence contracts prematurely.

## Candidate Priority

| Priority | Candidate | Target type | Evidence strength | Reason |
|---|---|---|---|---|
| 1 | Explicit Uncertainty over Fabrication | Principle | High | Repeated and directly prevents unsupported design-system decisions. |
| 2 | Agent Execution Contract | Specification | High | Already converges across Gateway and Intelligence contracts. |
| 3 | Execution Authority | Governance | High | Necessary before broader autonomous tool execution. |
| 4 | Capability Definition | Specification | High | Central to executor- and model-independent Intelligence. |
| 5 | Execution and Acceptance Lifecycle | Specification | High | Prevents state ambiguity across Issues, executors, review, and merge. |
| 6 | Inspectable Agent Handover | Pattern | Medium | Repeated across artifacts and traces but needs a concrete consumer contract. |
| 7 | Protocols Follow Domain Contracts | ADR | Medium | Strong migration lesson; exact decision scope still needs review. |
| 8 | Durable Memory Boundary | Lesson | Low | Useful but supported by one small experiment and no current UIF consumer. |

## Risks and Blind Spots

- Most repositories are prototypes or planning scaffolds; implementation maturity is uneven.
- `design-ai-orchestrator` uses fixed specialist identities and static retrieval queries, so it demonstrates boundaries but not dynamic capability resolution.
- `agent-gateway-poc` currently has one executor adapter; interchangeability is architectural intent with limited comparative evidence.
- `a2a-ollama` is valuable as experiment evidence, not as a target architecture.
- `agentic-second-brain` provides a clean boundary concept but does not validate retrieval, freshness, contradiction handling, or privacy governance.
- The scan does not prove performance, quality, or cost improvements. Those require evaluation fixtures and traces.
- Existing Intelligence planning documents may contain knowledge that belongs in the Vault; promotion must preserve repository ownership and avoid copying implementation detail.

## Recommended Next Slice

Create one small review PR per promotion candidate, in this order:

1. Draft **Explicit Uncertainty over Fabrication** as a principle.
2. Reconcile the existing Intelligence `AgentTask`, `AgentResult`, and `ExecutionTrace` shapes into a Vault-owned Agent Execution Contract proposal.
3. Draft **Execution Authority** governance only after identifying human approval roles and bounded automatic approval cases.
4. Define the Capability document specification and validate it with one real UIF workflow.
5. Add evaluation fixtures for missing knowledge, unsupported capability, denied approval, invalid output, and failed verification.

Do not promote all candidates in one change. Each promotion should cite this lesson, state its evidence and assumptions, and pass verification review independently.
