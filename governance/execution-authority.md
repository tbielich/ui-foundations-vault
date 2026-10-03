---
id: governance.execution-authority
title: Execution Authority and Agent Provenance
type: governance
status: review
owners:
  - ui-foundations
created: 2026-10-03
updated: 2026-10-03
authority: source
summary: Defines durable separation between agent-produced repository changes, human review and final merge authority while keeping concrete provider and runtime identity configuration outside canonical governance.
applies_to:
  - ui-foundations
  - ui-foundations-vault
  - ui-foundations-intelligence
  - ui-foundations-studio
  - ui-foundations-connectors
related:
  references:
    - governance.precedence
    - governance.lifecycle
    - adr.capability-based-execution
    - specification.agent-execution-contract
---

# Execution Authority and Agent Provenance

## Purpose

UI Foundations must make it possible to distinguish work produced by an agent from work authored, reviewed or approved by a human.

The goal is durable provenance and independent human approval, not a dependency on a particular provider, hosting platform, account name or credential mechanism.

## Rules

### Agent-produced changes must remain attributable

Repository mutations and externally observable mutations performed through governed connections by an agent or agent-controlled execution path must carry durable evidence that identifies them as agent-produced.

Where the target system supports distinct actors, agent-produced commits, branches, pull requests, messages, records or equivalent mutations should use a dedicated non-human execution identity rather than a human contributor's identity.

An executor must not present agent-produced work as if it were authored by the human who requested, reviewed or approved it.

If a distinct platform actor cannot be used, the execution path must preserve equivalent explicit provenance in durable repository or execution evidence. Session memory alone is not sufficient provenance.

### Production and approval must remain separable

The producer of a change and the authority accepting that change are separate roles.

Agent execution may create or update bounded repository artifacts or perform bounded mutations through governed connections when authorized, but agent self-report, successful execution, verification success or ownership of the producing identity does not constitute human approval.

An agent must not approve its own produced change on behalf of the human approval role.

### Human approval is the final merge boundary

Unless another accepted governance decision explicitly establishes a narrower automatic-acceptance case, final merge of agent-produced repository changes requires an authorized human approval that is attributable independently from the producing agent identity.

Approval must apply to the reviewed revision. Material changes after approval require the applicable review or approval to be renewed.

### Identity configuration is implementation-owned

This governance defines identity separation and provenance semantics, not concrete runtime configuration.

Account names, email addresses, credentials, tokens, authentication methods, command-line configuration, provider settings and platform-specific actor mappings belong to the consuming repository, execution environment, connection layer, secret store, adapter or other implementation-owned configuration.

Connections that perform mutations in external systems must preserve the authorized execution identity and return sufficient actor, target and outcome evidence to the owning workflow. A connection transports or executes authority granted elsewhere; it must not silently substitute a human identity or create new authority.

Derived projections may instruct a specific executor how to satisfy this governance, but they must not redefine the rule or become its canonical source.

### Evidence must survive the session

Compliance must be reconstructable from durable repository state and execution evidence without relying on conversational memory.

When applicable, evidence should allow a reviewer to determine:

- which task or authorization caused the mutation;
- which execution identity produced the change;
- which revision or external target state was verified;
- which human identity reviewed or approved that revision or governed action when approval is required;
- whether the approved revision or action is the one being applied.

## Boundaries

This governance does not:

- mandate a particular repository host or provider;
- define a specific agent username, email address or credential;
- require every read-only agent action to use a separate platform account;
- grant agents permission to mutate repositories or external systems;
- replace bounded execution contracts, repository-local permissions or verification;
- authorize automatic merge or automatic approval.

Repository-local implementation may impose stricter controls.

## Human, Agent, and System Implications

- **Human:** agent-produced work is visibly distinguishable from human authorship, and review or approval remains an independently attributable action.
- **Agent:** executors may implement bounded work but cannot inherit the requester's identity or convert execution success into approval.
- **System:** identity mapping and credentials remain implementation-specific while provenance, role separation and approval semantics stay provider-neutral and durable.

## Verification

This governance is satisfied for a mutating agent workflow, including repository and governed connection mutations, when evidence demonstrates that:

1. the produced change is durably attributable to an agent execution identity or equivalent explicit provenance;
2. the producing identity is distinguishable from the human approval identity;
3. verification and approval remain separate from executor completion;
4. where human approval is required, it is bound to the revision or governed external action eligible for application;
5. concrete provider or credential configuration is not embedded in canonical governance;
6. the provenance and approval chain can be reconstructed without chat history.

## Related

- `decisions/capability-based-execution.md` defines provider-neutral execution and keeps human approval as the final merge boundary.
- `specifications/agent-execution-contract.md` defines task/executor correlation, lifecycle separation, authorization and revision-bound acceptance semantics.
