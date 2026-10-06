---
id: workflow.repository-sanity
title: Repository Sanity Workflow
type: workflow
status: review
owners:
  - ui-foundations
created: 2026-10-06
updated: 2026-10-06
authority: source
summary: Defines a conservative, evidence-driven workflow for repository hygiene that never risks active or recoverable work.
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
  depends_on:
    - governance.verification-review
---

# Repository Sanity Workflow

## Purpose

Maintain repository hygiene across the UIF ecosystem without risking active or recoverable work. The workflow detects stale, abandoned, or noteworthy repository state so it can be understood and, where provably safe, cleaned up — while leaving anything that requires human judgment or that cannot be reversed untouched.

## Principle

> Detect aggressively. Delete conservatively.

Inspection is the default. Mutation is explicit. The workflow is expected to run end to end as a read-only observation by default; cleanup only happens when it is explicitly requested and only against items that deterministic evidence proves are safe.

## Inputs

- One or more repositories in scope.
- Authoritative branch references for each repository (default and protected branches).
- Known active work signals (open changes, in-progress operations, external worktrees) where available.
- An explicit request when any mutation is intended; absence of that request means inspection only.

## Steps

The workflow is a single pipeline:

```text
DISCOVER
→ INSPECT
→ CLASSIFY
→ SAFE CLEAN
→ REVIEW
→ VERIFY
→ REPORT
```

1. **DISCOVER** — Identify the repositories in scope and the refs, worktrees, and work state relevant to each.
2. **INSPECT** — Gather state through non-destructive inspection only. Inspection must not mutate any repository.
3. **CLASSIFY** — Assign every discovered item exactly one classification (see taxonomy below) based on the evidence gathered.
4. **SAFE CLEAN** — Only when cleanup is explicitly requested, act on items classified `SAFE`, and only through the safe-action model. Items in any other class are never cleaned here.
5. **REVIEW** — Surface items that require human or reasoning-agent judgment. These are reported, never auto-acted upon.
6. **VERIFY** — After any mutation, re-inspect to confirm the outcome (see Verification).
7. **REPORT** — Emit the reporting contract: per-item findings and summary counts across all classifications.

## Classification taxonomy

Every item receives exactly one classification. The taxonomy separates what can be cleaned, what needs a decision, and what is merely diagnostic.

- **SAFE** — Deterministic evidence proves that an approved cleanup action is safe. Only `SAFE` items are eligible for automatic cleanup.
- **REVIEW** — Human or reasoning-agent judgment is required to decide what happens next. Examples: a stash, a branch whose commits are not proven contained in an authoritative branch, ambiguous abandoned work, or orphaned work state whose disposition cannot be established.
- **KEEP** — Active, relevant, protected, or unsafe to modify. Examples: the current branch, a default or protected branch, a branch associated with open review, a dirty repository, a repository with an active operation in progress, a branch used by another worktree, or known active work.
- **OBSERVE** — A noteworthy or potentially useful diagnostic state that currently requires no action. Example: dangling or unreachable commits discovered through non-destructive inspection when no evidence indicates corruption or any other actionable condition. `OBSERVE` items are reported but are never cleanup candidates.
- **BLOCKED** — Inspection could not reliably establish state, or required evidence is unavailable. State is reported as indeterminate rather than guessed.

`OBSERVE` exists so that diagnostic findings stay visible without adding review noise. `OBSERVE` items must remain visible in the report but subordinate to actionable `REVIEW` findings, and they must never be promoted into cleanup candidates.

## Safety invariants

These invariants hold regardless of executor or request:

1. Never delete uncommitted user work.
2. Never automatically delete commits that are not demonstrably contained in an authoritative branch.
3. Never force-delete an unmerged branch automatically.
4. Never automatically delete stashes.
5. Never use aggressive object pruning as routine sanity cleanup.
6. Never mutate a repository merely because it is dirty.
7. Branch age alone is never sufficient evidence for deletion.
8. Cleanup must be supported by deterministic evidence.

## Protected refs

Default, protected, current, and actively referenced branches cannot become automatic cleanup targets. Their protection is structural: no classification path leads such a branch into `SAFE`, so no cleanup action can select it.

## Worktree-aware protection

A branch used by another worktree must not be automatically deleted. A branch checked out elsewhere is treated as active and protected, independent of its merge or age status.

## Safe-action model

Automatic cleanup uses an explicit allowlist of safe actions rather than a general destructive command capability. Only actions on the allowlist, applied to items proven `SAFE`, may run. An action that is not on the allowlist is not available to the workflow, so the blast radius is bounded by construction rather than by caution. The canonical rule is independent of any particular executor's command syntax.

## Reporting contract

The report exposes, for each repository and item:

- repository
- item
- classification
- reason or evidence supporting the classification
- proposed or executed action, where applicable
- mutation result, where a mutation occurred
- summary counts per classification across all repositories

The report must make it easy to distinguish things that can safely be cleaned, things that require a decision, and things that are merely diagnostic observations. `OBSERVE` findings are shown but kept subordinate to `REVIEW` findings.

## Verification

Any mutation must be followed by re-inspection sufficient to prove that:

- the intended `SAFE` item was cleaned,
- protected and `REVIEW` items remain untouched, and
- repository health was not degraded.

When the workflow runs in its default read-only mode, verification confirms that no mutation occurred.

## Future evolution

A provider-neutral integration capability could be considered later only if another executor or consumer needs the same execution semantics. For now a single tool-specific projection is sufficient as the first consumer, and this workflow owns the durable, provider-neutral semantics.
