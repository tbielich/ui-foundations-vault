---
id: adr.transport-neutral-capabilities
title: Transport-neutral Capabilities and Consumer Boundaries
type: adr
status: review
owners:
  - ui-foundations
created: 2026-09-19
updated: 2026-09-19
authority: source
summary: Defines transport-neutral UIF capabilities, separates CLI and MCP projections from execution semantics, and keeps published runtime packages as the primary product-consumer boundary.
applies_to:
  - ui-foundations-intelligence
  - ui-foundations
  - ui-foundations-vault
related:
  references:
    - governance.precedence
    - governance.lifecycle
    - knowledge.agentic.research-2026-09-18
---

# ADR: Transport-neutral Capabilities and Consumer Boundaries

## Context

UIF serves two materially different consumers.

Product consumers build UIF-based digital products from the published runtime implementation. Their normal integration boundary is UIF-RUN and its consumable packages, tokens, styles, types, components, and assets.

Agent consumers need structured access to UIF knowledge and capabilities during design, implementation, verification, and maintenance. UIF-INT already owns provider-neutral execution semantics such as reasoning, orchestration, bounded execution contracts, routing, verification, evidence, and trace/state.

Supporting research suggests that CLI, MCP, Skills, and future protocols should not become owners of the underlying knowledge or execution semantics. A transport can be useful for a particular consumer without becoming an architectural boundary.

The architectural question is therefore not whether UIF should choose CLI or MCP. It is where capability semantics live, how they are projected to different consumers, and whether agent-facing infrastructure becomes a requirement for ordinary runtime consumers.

## Decision

UIF capabilities are transport-neutral.

Capability semantics and typed contracts must not depend on CLI, MCP, a specific agent protocol, or a specific executor. Agent-facing transports expose shared capabilities through thin adapters or projections.

UIF-INT remains responsible for execution semantics, including bounded contracts, orchestration, routing, verification, evidence, and trace/state. Transport adapters do not redefine those semantics.

CLI and MCP may expose the same underlying capability handlers:

```text
                    shared capability
                           │
                 typed contract/handler
                           │
             ┌─────────────┴─────────────┐
             ↓                           ↓
         CLI adapter                 MCP adapter
             │                           │
      shell / JSON                MCP tool protocol
```

Additional transports may be introduced without changing the shared capability contract when their requirements can be expressed as projections of the same semantics.

UIF-RUN remains the primary consumption boundary for teams building UIF-based digital products. Runtime consumers must not be required to operate UIF-INT, MCP, or other agent infrastructure in order to use published UIF runtime assets.

Agent tooling is a development-time capability and may be distributed separately, including through a CLI package, MCP service, or future adapter.

This ADR does not require implementation of a CLI or MCP adapter. It defines the boundary those implementations must preserve.

## Rationale

Transport neutrality preserves provider neutrality and prevents protocol-specific behavior from leaking into shared execution semantics.

A shared capability layer allows multiple adapters to reuse retrieval, resolution, validation, and other deterministic behavior rather than implementing parallel semantics.

Keeping UIF-RUN as the product-consumer boundary preserves a simple adoption model: a team can consume UIF through standard published packages without understanding or operating the private knowledge and orchestration architecture that produces and maintains those assets.

This separates runtime consumption from agentic development-time assistance while allowing both to benefit from the same governed UIF ecosystem.

## Consequences

- CLI and MCP are projections/adapters rather than architectural owners.
- Shared capability contracts must be usable independently of any one transport.
- Transport-specific argument parsing, protocol metadata, serialization, session behavior, and discovery remain in adapters.
- Retrieval, resolution, validation, and other reusable semantics should converge into shared capability handlers rather than be duplicated across transports.
- UIF-INT continues to own provider-neutral execution semantics.
- UIF-RUN remains independently consumable through published packages.
- Agent tooling may be optional development-time tooling and must not become a runtime dependency for product consumers.
- Existing MCP or hub code should be evaluated for accidental coupling before new transports are added.
- A CLI can be introduced incrementally without replacing MCP.
- Supporting research informs this decision but does not make external implementation details normative for UIF.

## Alternatives Considered

### MCP as the primary capability architecture

Rejected because it couples shared capability semantics to one agent protocol and makes future transports depend on an MCP-shaped boundary.

MCP remains a valid projection where native tool discovery and structured agent integration are useful.

### CLI as the primary capability architecture

Rejected because shell invocation, process lifecycle, stdout serialization, and command discovery are transport concerns rather than shared capability semantics.

CLI remains a valid projection for coding agents, CI, scripts, and humans with terminal access.

### Separate CLI and MCP implementations

Rejected because independent implementations would duplicate retrieval and resolution logic, increase semantic drift, and make verification of equivalent behavior harder.

### Expose UIF-INT directly to product consumers

Rejected because ordinary runtime consumption should not require orchestration, agent protocols, execution contracts, or private knowledge infrastructure.

## Verification

Before this ADR moves beyond review:

1. identify a small set of existing or candidate read-only capabilities suitable for both CLI and MCP;
2. implement or prototype at least one shared typed handler with thin CLI and MCP projections;
3. demonstrate equivalent semantic output from both projections for the same inputs;
4. verify that no shared capability contract depends on MCP-specific or CLI-specific concepts;
5. confirm that a UIF-RUN consumer can install and use published runtime assets without UIF-INT, CLI, or MCP;
6. record comparative evidence such as tool calls, latency, context/token use, and failure behavior where practical.

If the spike demonstrates that important capability semantics cannot remain transport-neutral without material complexity, this ADR returns to review rather than forcing the implementation to conform.

## Related

- Research: `knowledge/agentic/research-2026-09-18-agent-ready-foundations.md`
- Runtime implementation: `ui-foundations`
- Intelligence implementation: `ui-foundations-intelligence`
