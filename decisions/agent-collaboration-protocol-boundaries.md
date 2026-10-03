---
id: adr.agent-collaboration-protocol-boundaries
title: Agent Collaboration and Protocol Boundaries
type: adr
status: accepted
owners:
  - ui-foundations
created: 2026-10-02
updated: 2026-10-03
authority: source
summary: Defines orchestration-first collaboration for UIF agents, protocol-neutral work and event contracts, MCP as the capability boundary, and A2A only for independent remote agent service boundaries.
applies_to:
  - ui-foundations-intelligence
  - ui-foundations-runtime
  - ui-foundations-studio
  - ui-foundations-connectors
related:
  references:
    - governance.precedence
    - governance.lifecycle
    - adr.capability-based-execution
---

# ADR: Agent Collaboration and Protocol Boundaries

## Context

UI Foundations increasingly uses multiple agent and automation surfaces for planning, implementation, verification, repository work, research, and governed execution.

The architectural risk is to model those participants as a peer-to-peer multi-agent conversation network. Free-form inter-agent conversation creates weak ownership, context drift, duplicated work, unclear termination, difficult replayability, and provider coupling. It also makes evidence, authority, and approval boundaries harder to inspect.

UIF already has a stronger foundation:

- governance and eligibility are resolved before bounded execution;
- execution is capability-based and provider-neutral;
- GitHub provides durable repository artifacts and observable execution state;
- verification is independent from executor self-assessment;
- high-impact actions remain behind human approval;
- executor-specific transport stays behind adapters.

The remaining decision is how agents, automations, tools, and future remote agent services collaborate without turning the architecture into an unrestricted agent mesh.

Current protocol families solve different problems:

- native orchestration coordinates participants inside one controlled workflow;
- MCP exposes tools, resources, prompts, repositories, and other capabilities;
- A2A provides a task and lifecycle boundary between independently deployed agent services.

UIF therefore needs a collaboration model that is protocol-neutral at the contract level and introduces distributed-agent protocols only where a real service boundary exists.

## Decision

UIF uses an **orchestration-first collaboration model**.

A workflow has one orchestration owner responsible for task decomposition, ordering, delegation, correlation, verification orchestration, approval gates, and final workflow state. The concrete provider or product fulfilling that role is replaceable and must not be encoded as the architecture.

Specialist agents, executors, reviewers, automations, and tools receive bounded work rather than unrestricted conversational context.

### Collaboration contracts

UIF will define protocol-neutral structured contracts for work, events, artifacts, evidence, decisions, authority, and approval.

The contracts must be transport-independent so the same semantics can be carried through local orchestration, CLI adapters, GitHub artifacts, workflow stores, MCP-backed capabilities, queues, APIs, or a future A2A transport.

Free text may supplement structured fields, but it must not be the only representation of execution-relevant state.

At minimum, governed work must make the following explicit where applicable:

- workflow and task identity;
- sender or actor identity;
- objective and bounded inputs;
- constraints and acceptance criteria;
- allowed and forbidden actions;
- delegated authority and approval requirements;
- produced artifacts and evidence;
- blockers, failures, retries, and terminal state;
- decision and review outcomes;
- correlation and provenance.

### Event semantics

State transitions should be represented through explicit event types rather than inferred from conversation.

The initial event vocabulary should support at least:

- `task.requested`
- `task.accepted`
- `task.rejected`
- `task.blocked`
- `task.progressed`
- `task.completed`
- `task.failed`
- `task.cancelled`
- `artifact.created`
- `artifact.updated`
- `review.requested`
- `review.completed`
- `decision.proposed`
- `decision.accepted`
- `approval.required`
- `approval.granted`
- `approval.denied`

The vocabulary may evolve through specification work without changing this decision, provided ownership, authority, traceability, and explicit terminal states remain preserved.

### Protocol boundaries

UIF applies the following default hierarchy:

1. **Native orchestration** for participants in the same controlled workflow, repository, or runtime.
2. **MCP** for access to tools, repositories, files, services, prompts, and other controlled capabilities.
3. **A2A** only when the collaborator is an independently deployed agent service with its own lifecycle, state, security boundary, ownership boundary, capability-discovery need, or long-running asynchronous task model.
4. **MCP + A2A** when an independent remote agent also requires standardized access to tools or context.

A2A must not be introduced merely because two components use language models or are described as agents.

### Orchestrator role

The architecture defines an **orchestrator role**, not a permanent orchestrator vendor.

Codex may currently fulfill that role in a given workflow, but UIF specifications, contracts, schemas, and governance must not require Codex specifically. Other compatible orchestrators may assume the role if they satisfy the same contracts and authority rules.

### Direct agent-to-agent communication

Direct lateral communication between specialist agents is not the default.

It is justified only when a bounded subworkflow has a clear owner and at least one of the following is true:

- participants are independently deployed services;
- the interaction crosses a meaningful runtime, team, vendor, or organization boundary;
- the work is long-running or asynchronous;
- the workflow intentionally models negotiation or peer coordination;
- the channel is typed, observable, bounded, and has explicit termination rules.

Otherwise, participants exchange durable tasks, artifacts, events, and results through the orchestrated workflow.

### Durable state and evidence

Chats and model sessions are not authoritative workflow state.

Durable workflow state belongs in governed stores and artifacts such as GitHub, the authoritative workflow store, or other explicitly accepted state infrastructure.

UIF Studio should therefore visualize the **workflow evidence graph** rather than act primarily as an agent-chat transcript viewer.

Studio should be able to reconstruct relationships among:

- workflows;
- tasks;
- actors and agents;
- artifacts;
- evidence;
- reviews;
- decisions;
- approval events;
- failures and retries;
- protocol and control boundaries.

## Consequences

- UIF gains a stable collaboration model without committing to an agent protocol prematurely.
- Codex, Kiro, Cline, GitHub Copilot, future agents, and non-agent automations can participate through the same bounded semantics.
- Provider-specific behavior stays behind adapters or capability declarations.
- GitHub and the workflow store remain durable coordination surfaces rather than conversational memory.
- Agent behavior becomes easier to replay, inspect, verify, and audit.
- Human approval boundaries can be represented explicitly and consistently.
- Studio gains a clearer product role as an observability, evidence, and approval surface.
- A2A adoption can be deferred until an actual independent-service boundary appears.
- Introducing A2A later should require transport mapping rather than redesigning the core work model.
- Structured contracts add schema and lifecycle discipline that must be versioned and maintained.
- Native orchestration remains preferred for simple fixed flows because protocol machinery has operational cost.

## Alternatives Considered

- **Unrestricted peer-to-peer agent conversation:** rejected as the default because ownership, authority, termination, reproducibility, and evidence become difficult to govern.
- **A2A for all agent communication:** rejected because same-workflow and same-repository collaboration does not justify distributed-service discovery, identity, retry, versioning, and observability overhead.
- **MCP as the universal agent collaboration protocol:** rejected because MCP is primarily a capability and context boundary, not a complete independent-agent task lifecycle model.
- **Provider-specific orchestration contracts:** rejected because they would couple UIF workflow semantics to current tools and vendors.
- **GitHub issues and pull requests without a shared structured contract:** rejected as insufficient because repository artifacts alone do not define portable task, authority, event, approval, and evidence semantics.

## Verification

This decision is satisfied when:

- a bounded UIF task can be executed by different compatible participants without changing its core semantics;
- workflow and task ownership are explicit;
- execution-relevant state transitions are represented by structured events or equivalent typed state;
- authority and approval requirements are machine-readable;
- artifacts and evidence can be traced to producers, tasks, and source revisions;
- local or same-workflow collaboration does not require A2A;
- MCP integrations remain capability boundaries rather than hidden workflow owners;
- a future independent remote agent can be connected through A2A by mapping the existing UIF contract to A2A task, message, part, artifact, and lifecycle concepts;
- UIF Studio can reconstruct workflow state from durable evidence without depending on chat history.

## Follow-up

This ADR should be implemented through lower-precedence specifications and experiments rather than by embedding protocol details here.

Expected follow-up work:

1. Define a minimal UIF Work Contract.
2. Define the canonical event vocabulary and lifecycle mapping.
3. Define artifact and evidence references, including revision and content identity.
4. Define authority and approval schema semantics.
5. Define Studio's workflow evidence graph projection.
6. Add an A2A mapping only when a concrete independent remote-agent boundary exists.
