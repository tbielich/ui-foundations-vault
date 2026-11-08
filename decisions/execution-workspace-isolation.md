---
id: adr.execution-workspace-isolation
title: Execution Workspace Isolation
type: adr
status: review
owners:
  - ui-foundations
created: 2026-11-08
updated: 2026-11-08
authority: source
summary: Proposes provider-neutral workspace allocation and Git worktree isolation for concurrent UIF-INT executions.
applies_to:
  - ui-foundations-intelligence
related:
  references:
    - adr.capability-based-execution
    - governance.precedence
    - governance.lifecycle
provenance:
  sources:
    - type: issue
      role: source
      repository: ui-foundations-vault
      number: 75
    - type: issue
      role: supporting-source
      repository: ui-foundations-intelligence
      number: 126
---

# ADR: Execution Workspace Isolation

- Status: Review (candidate; not authoritative until accepted)
- Date: 2026-11-08
- Owners: UI Foundations

## Context

UIF-INT has a provider-neutral `AgentTask.workspace` field and `ExecutionTrace`, deterministic before/after workspace change detection, supervised checkpoints with a single-run lock, and controller-owned validation evidence stored outside worker-writable workspaces. These facilities do not, by themselves, allocate, reserve, recover, or release Git worktrees across concurrent runs.

The GitHub issue dispatcher currently requires an existing `--workspace` directory for execution. The repository-sanity skill detects linked worktrees and dirty state, but is read-only diagnostics rather than workspace orchestration. A documented live-edit probe explicitly excludes staging isolation and merge.

This proposal is based on a targeted read-only repository inspection at UIF-INT commit `d14ee2f382c4e295cdfda7571963ac08b80c3452`. It does not establish complete absence of every alternative workspace manager; the implementation discovery must confirm this.

## Decision (proposed)

UIF-INT owns allocation, identity, reservation, recovery, and release of execution workspaces independently of executor provider. Executors receive the selected directory through the existing task contract and do not independently choose or clean up task workspaces.

Use a managed Git worktree by preference when independent repository tasks execute concurrently or may conflict. Allow a pre-existing clean workspace for bounded serial tasks. Require stronger environment isolation only when task capabilities or risk justify a clone/container. Worktrees are **not** security sandboxes.

Preserve the existing executor, trace, supervision, and validation contracts wherever possible. A small orchestration-side allocator should reuse them rather than create a second execution workflow.

A workspace allocation record should persist at least: repository identity, task/contract ID, baseline commit SHA, branch/ref, canonical worktree path, allocation owner, lifecycle state, resulting commit SHA (when available), and cleanup/verification references. The exact schema and storage location remain implementation decisions subject to tests.

### Proposed lifecycle

1. **Preflight:** verify repository identity, baseline SHA, cleanliness and absence of conflicting branch/path reservation.
2. **Allocate:** atomically reserve task ownership and create or assign an appropriate worktree; persist the allocation before dispatch.
3. **Execute:** pass the assigned path through `AgentTask.workspace`; preserve existing bounded permissions and change evidence.
4. **Verify:** independently evaluate the exact resulting commit SHA and declared validation evidence; do not equate executor completion with acceptance. When verification needs a separate checkout, provision it as read-only.
5. **Retain or release:** preserve interrupted, failed, dirty or disputed workspaces until recovery/review policy authorizes cleanup; never discard uncommitted work silently.
6. **Recover:** reconcile persisted allocation state against Git worktree metadata and process state; fail closed on ambiguous ownership.

### Invariants

- One active allocation owner per branch/worktree; collisions fail closed.
- No automatic merge or branch deletion as a consequence of executor success.
- Validation evidence remains outside the worker-writable workspace.
- Verification does not create new implementation scope.
- Workspace and Git checkout isolation do not isolate credentials, processes, ports, shared services or build caches.
- Cloud and local executors follow the same contract semantics.

## Consequences

**Benefits:** concurrent agents do not overwrite the same checkout; task provenance and reproducibility improve; verification can be pinned to immutable source state.

**Costs:** lifecycle bookkeeping, cross-process locks, stale reservations, disk use, and recovery/retention policies. A worktree cannot provide hostile-code containment. Shared environment resources require separate controls.

## Alternatives Considered

- **Single shared checkout:** simplest for sequential work; unsafe as a general concurrent default.
- **Managed Git worktree:** lightweight and shares Git objects; preferred for parallel repository work, but requires robust ownership and recovery.
- **Independent clone or container:** stronger separation of Git state or runtime environment at greater setup/storage cost; use when justified by risk/capabilities.
- **Executor-managed worktrees:** rejected because provider-specific ownership would fragment UIF-INT execution semantics and evidence.

## Verification

Before acceptance or implementation:
- Audit repository-local staging, supervised execution, validation and repository-sanity tests for overlap.
- Test fixture repositories for parallel allocations, branch already checked out, dirty/untracked files, stale locks, interrupted workers, orphaned metadata, and safe cleanup.
- Confirm pinned-SHA verifier behavior and evidence isolation across executor types.
- Demonstrate serial execution still works without mandatory worktree creation.
- Review governance conflicts and ensure durable policy stays in UIF-VLT, implementation and tests in UIF-INT.

## Follow-up

- UIF-INT issue #126: complete overlap audit, derive minimal allocator story, and implement only after bounded approval.
- UIF-VLT issue #75: review and accept/revise this ADR.
