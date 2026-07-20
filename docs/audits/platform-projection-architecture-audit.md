---
id: publication.platform-projection-architecture-audit
title: Platform Projection Architecture Audit
type: publication
status: review
owners:
  - ui-foundations
created: 2026-07-20
updated: 2026-07-20
authority: supporting
summary: Audits the smallest governance-aligned location for a Perplexity operating projection without changing canonical vault taxonomy.
consumers:
  - human
  - agent
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
  references:
    - agent-capability.vault-maintainer
    - docs.architecture
    - docs.cross-repo-knowledge-sync
    - export-pack.agent
    - registry.repos
    - registry.sync-contract
    - specification.document-structure
    - specification.vault-metadata
verification:
  status: partially-verified
assumptions:
  - No separate active release critical path artifact exists in the repository; this work proceeds only under explicit narrow authorization.
---

# Platform Projection Architecture Audit

## 1. Current repository model

The vault separates canonical knowledge from derived export content.

- Canonical source knowledge lives in governance, principles, decisions, specifications, workflows, prompts, agents, and related source directories.
- Registries and export packs sit at the architecture layer described as `Level 8: Registries and Export Packs` in `docs/architecture.md`.
- `exports/` already exists as the reviewed location for derived, consumer-facing guidance.
- `exports/agent-pack/` already carries derived agent-facing operating material without redefining canonical agent roles.
- `registry/repos.yml` and `registry/sync-contract.yml` already recognize `agent-pack` and `agent-guidance` as reviewed consumption surfaces.

This means the repository already has a derived export surface for consumer-facing operating guidance, and that surface is narrower and lower-risk than introducing a new canonical structure.

## 2. Problem definition

UI Foundations needs the smallest governance-aligned way to supply an external AI platform with platform-specific operating instructions, starting with Perplexity as a pilot.

The solution must preserve these boundaries:

- The vault remains the canonical source of truth.
- Perplexity is a downstream research and validation consumer.
- Perplexity does not become a canonical agent role, taxonomy entry, or governance authority.
- Vendor-specific operating instructions must remain derived and reversible.

## 3. Relevant governance constraints

The governing constraints from the reviewed repository sources are:

| Constraint | Source | Effect on this pilot |
| --- | --- | --- |
| Governance, principles, ADRs, and specifications outrank prompts and examples. | `governance/precedence.md` | The Perplexity artifact must be subordinate to canonical vault sources. |
| Stable and accepted source documents guide work; lower-precedence conflicts must return to review. | `governance/lifecycle.md` | The pilot must stay additive and avoid changing accepted or stable source meaning. |
| Tool-specific guidance belongs in prompts or derived export content, not canonical agent capability definitions. | `AGENTS.md`, `specifications/document-structure.md`, `specifications/vault-metadata.md` | The pilot should not change canonical agent roles or add tool-specific metadata. |
| Export packs are derived and must not override source documents. | `exports/README.md`, `exports/agent-pack/README.md`, `docs/cross-repo-knowledge-sync.md` | The pilot should live in an export surface and state its derived authority explicitly. |
| Registries and sync contracts describe reviewed consumption and should change only when artifact policy or repository consumption changes. | `registry/repos.yml`, `registry/sync-contract.yml`, `docs/reflection-loop.md` | Avoid registry or sync-contract edits unless the pilot changes pack policy or consumer contracts. |

## 4. Options considered

### Option A — Existing agent-pack projection

**Shape**

Place a Perplexity-specific projection inside the existing agent export surface, for example:

`exports/agent-pack/projections/perplexity-research.md`

**Assessment**

| Dimension | Evaluation |
| --- | --- |
| Architectural fit | Strong. Reuses the existing derived export area already intended for agent-facing operating guidance. |
| Canonical vs derived status | Clearly derived when marked `authority: derived` and kept inside `exports/agent-pack/`. |
| Duplication risk | Low if it references canonical vault sources and documents selection rules instead of copying source documents. |
| Scalability | Good. Additional consumer projections can become sibling files without changing canonical taxonomy. |
| Registry implications | None required for the pilot because `agent-pack` already exists and `agent-guidance` is already an allowed artifact. |
| Synchronization implications | None beyond the current reviewed-consumption model for `agent-pack`. |
| Migration cost | Low. One new derived file and small navigation updates only. |
| Advantages | Smallest additive change, easy to review, reversible, preserves current source/derived boundaries. |
| Disadvantages | `agent-pack` becomes a mixed surface containing both general agent guidance and consumer-specific projections, so README navigation must stay explicit. |

### Option B — Dedicated derived platform export

**Shape**

Create a new narrowly scoped export surface such as:

`exports/perplexity/`

**Assessment**

| Dimension | Evaluation |
| --- | --- |
| Architectural fit | Acceptable but weaker. It stays derived, yet duplicates the export-pack pattern for a single pilot. |
| Canonical vs derived status | Derived, but the new top-level export surface invites future pack semantics without a current need. |
| Duplication risk | Medium. It would likely need its own README, navigation, and eventually its own pack-level conventions. |
| Scalability | Mixed. It scales per platform, but encourages one directory per vendor before the shared shape is proven. |
| Registry implications | Likely deferred at first, but future consumers would quickly pressure `registry/repos.yml` and related contracts to recognize the new pack. |
| Synchronization implications | Ambiguous. The repository currently defines consumption around existing packs, not ad hoc platform-specific export roots. |
| Migration cost | Medium. More files now and more structural clean-up later if the pilot remains isolated. |
| Advantages | Clear visual separation by platform. |
| Disadvantages | Introduces a new export surface before proving the shared contract, increasing structural churn for little pilot value. |

### Option C — Canonical platform contract

**Shape**

Introduce a canonical platform or consumer contract outside the current agent taxonomy.

**Assessment**

| Dimension | Evaluation |
| --- | --- |
| Architectural fit | Weak for the pilot. This elevates a vendor-specific need into canonical repository structure. |
| Canonical vs derived status | Canonical, which conflicts with the stated requirement that vendor-specific operating instructions stay derived. |
| Duplication risk | High. It would duplicate or partially reclassify agent, prompt, export, or registry responsibilities. |
| Scalability | Potentially broad, but only through governance work that is not justified by a single consumer pilot. |
| Registry implications | High. New canonical contracts would likely require registry, schema, and sync-contract updates. |
| Synchronization implications | High. Downstream consumers would need explicit new contract semantics. |
| Migration cost | High. Existing structures, naming, and consumption rules would need review or migration. |
| Advantages | Could support a future generalized platform-contract model. |
| Disadvantages | Over-scoped, governance-affecting, and incompatible with the requirement for a minimal additive pilot. |

## 5. Recommended architecture

Recommend **Option A**: add the pilot as a derived projection under the existing agent pack:

`exports/agent-pack/projections/perplexity-research.md`

Why this is the best fit:

1. It reuses the repository's existing Level 8 export-pack layer instead of inventing a new canonical structure.
2. It keeps vendor-specific operating instructions derived, reviewable, and reversible.
3. It avoids changes to canonical agent roles, registry schemas, sync contracts, and lifecycle rules.
4. It creates a reusable pattern for future consumers without making Perplexity part of canonical taxonomy.

The pilot should remain a single derived document plus only the minimal navigation update needed to make the new projection discoverable.

## 6. Impact assessment

| Item | Assessment |
| --- | --- |
| Impact level | Low |
| Rationale | The recommended change is additive, derived, and confined to the existing export surface plus this audit report. |
| Canonical sources affected | None. Canonical governance, specifications, registries, and agent roles remain unchanged. |
| Public or machine-readable contracts affected | None. No registry, sync-contract, schema, or manifest changes are needed. |
| Backward-compatibility risk | Low. Existing pack consumers can ignore the new projection unless they opt into it. |
| Governance implications | None for Option A beyond normal review of a new derived document. |
| ADR or explicit approval required | No ADR required for Option A. Explicit execution authorization was required only because the work was outside the active release critical path. |

Because the recommended option does **not** change canonical taxonomy, governance, registry contracts, sync contracts, lifecycle rules, or public schemas, the pilot can continue to implementation.

## 7. Proposed pilot scope

The minimal pilot should include:

1. This audit report.
2. One derived Perplexity projection document under `exports/agent-pack/projections/`.
3. One minimal navigation update in `exports/agent-pack/README.md`.

The projection should define:

- Perplexity's purpose as an external research and validation consumer.
- Authority boundaries and escalation behavior.
- Source hierarchy rooted in canonical vault sources.
- Reasoning sequence and evaluation lenses.
- Output separation between facts, interpretation, and recommendation.
- Default output structure and confidence rules.
- Curated input selection rules instead of copying large parts of the vault.

## 8. Explicit non-goals

This pilot should **not**:

- Add Perplexity as a canonical agent role.
- Add a new top-level directory or taxonomy.
- Change `registry/repos.yml`, `registry/sync-contract.yml`, or any schema.
- Introduce generators, automation, or synchronization logic.
- Duplicate full vault documents into export content.
- Add projections for other platforms during this change.
- Redesign the agent pack or create a generalized platform contract.

## 9. Risks and unresolved questions

- The repository does not yet have a documented shared naming convention for consumer-specific projections beyond this pilot path.
- If multiple platforms need materially different setup artifacts later, `agent-pack` may need an index or manifest for projections.
- External platform limits such as context size, upload workflow, or citation behavior are not modeled canonically here and should remain local to the derived projection.
- Future consumer proliferation could justify a broader export-pack pattern, but this pilot does not provide enough evidence to promote that structure yet.

## 10. Files that would be added or modified during the pilot

**Add**

- `docs/audits/platform-projection-architecture-audit.md`
- `exports/agent-pack/projections/perplexity-research.md`

**Modify**

- `exports/agent-pack/README.md`

**Not changed**

- Canonical agent definitions
- Governance documents
- Registry files
- Sync contracts
- Advisory schemas
