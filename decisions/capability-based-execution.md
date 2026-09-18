---
id: adr.capability-based-execution
title: Capability-Based Provider-Neutral Execution
type: adr
status: review
owners:
  - ui-foundations
created: 2026-09-18
updated: 2026-09-18
authority: source
summary: Defines capability-based provider-neutral executor routing for UIF Intelligence, with cloud execution as a first-class path and local execution selected only when required.
applies_to:
  - ui-foundations-intelligence
related:
  references:
    - governance.precedence
    - governance.lifecycle
---

# ADR: Capability-Based Provider-Neutral Execution

## Context

UIF Intelligence already defines provider-neutral agent tasks, capability-aware executor registration, bounded execution, independent verification, and Cline integration. The execution architecture must not make Cline, ChatGPT, Codex, or another provider the architectural center.

Repository work should also be executable without requiring a developer workstation to be online when all required capabilities are available in a cloud execution environment.

## Decision

UIF-INT owns eligibility, governance resolution, bounded task construction, capability routing, execution correlation, and verification orchestration. Executors implement bounded tasks; they do not own workflow doctrine, governance, or scope expansion.

Execution routing is capability-based and provider-neutral:

- executable tasks declare required capabilities;
- executors declare supported capabilities;
- UIF-INT deterministically selects a compatible executor;
- no compatible executor means execution fails closed or remains unassigned;
- provider-specific transport details remain behind executor adapters.

Cloud execution is a first-class route for repository work. Local executors such as Cline are selected when a task requires machine-bound capabilities such as local services, Ollama, hardware, or local MCP access.

GitHub is the control plane for eligible UIF-RUN work and observable repository execution state: issues, branches, pull requests, checks, and evidence.

ChatGPT may participate as an intelligence or execution surface, but no ChatGPT session is itself the durable UIF-INT architecture.

## Consequences

- Existing Cline Hub, WebSocket, session, and tool-policy work remains useful as a local executor adapter.
- Cline is not the default executor by architectural definition.
- Execution contracts must not encode provider preference unless a capability is intrinsically provider-bound and separately governed.
- Normal cloud-capable repository work can proceed while the developer workstation is offline.
- Local-only work waits for or routes to a compatible local executor.
- Verification remains independent of executor prose and self-assessment.
- Human approval remains the final merge and governance-exception boundary unless another accepted decision changes that rule.
- Executor adapters may evolve without changing bounded task semantics.

## Alternatives Considered

- Make Cline the primary execution architecture: rejected because local transport and workstation availability would become system-level constraints.
- Make ChatGPT the permanent UIF-INT runtime: rejected because a product session/provider must not own the durable architecture.
- Require all work to run in the cloud: rejected because some capabilities are inherently local.
- Let each executor interpret issues and governance independently: rejected because eligibility, scope, and verification would diverge across providers.

## Verification

This decision is satisfied when:

- the same bounded task can be routed to different compatible executors without changing task semantics;
- capability routing is deterministic and fails closed when requirements cannot be met;
- provider-specific transport details do not enter the core task contract;
- cloud-capable repository work can reach a verified pull request without the developer workstation being online;
- local-only requirements cannot be silently routed to an incompatible cloud executor.

## Related

- UIF-INT #14: provider-neutral Capability Provider architecture
- UIF-INT #45: bounded execution contracts from approved UIF-RUN issues
- UIF-INT #64: capability-based execution and cloud-first executor routing
- UIF-VLT #34: canonicalization tracking issue
