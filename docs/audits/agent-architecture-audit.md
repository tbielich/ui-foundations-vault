---
id: publication.audit.agent-architecture
title: Agent Architecture Audit
type: publication
status: review
owners:
  - ui-foundations
created: 2026-07-20
updated: 2026-07-20
authority: supporting
summary: Audits current agent-related vault architecture and recommends a minimal additive target state for multi-ecosystem support.
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
  references:
    - specification.document-structure
    - specification.vault-metadata
    - docs.architecture
    - docs.cross-repo-knowledge-sync
    - docs.reflection-loop
    - docs.governance-pack-publishing
    - index.agents
---

# Agent Architecture Audit

## 1. Purpose

Audit the current vault architecture for agent-related knowledge and decide whether a minimal additive extension can improve clarity and multi-ecosystem projection without changing governance, taxonomy, precedence, lifecycle, metadata semantics, or cross-repository authority.

## 2. Scope

Reviewed:

- Governance, lifecycle, precedence, metadata, and document-structure sources
- `agents/`, `capabilities/`, `operational/`, `workflows/`, `patterns/`, `prompts/`
- `registry/`, `exports/`, `schemas/`, `docs/`, and relevant ADR/reference files

Excluded:

- Runtime implementation changes outside vault knowledge scope

## 3. Current Architecture

The repository already implements a governed, markdown-first model where authoritative meaning flows from governance and specifications into workflows/patterns/prompts, then into registry/export artifacts.

Agent knowledge is currently distributed across:

- `AGENTS.md` and `agents/` (explicit agent guidance entry points)
- `capabilities/` (executor-independent capability corpus, currently typed as `specification`)
- `operational/` and `workflows/` (repeatable review methods)
- `prompts/` and `exports/agent-pack/` (operational and derived guidance)

## 4. Existing Canonical Sources

Primary authoritative sources for this audit:

- `governance/precedence.md`
- `governance/lifecycle.md`
- `specifications/document-structure.md`
- `specifications/vault-metadata.md`
- `docs/architecture.md`
- `docs/cross-repo-knowledge-sync.md`

These establish:

- precedence order
- lifecycle and authority semantics
- allowed taxonomy values
- canonical-vs-derived boundaries

## 5. Existing Agent-Related Content

### Current intended purpose of `agents/`

`agents/` is currently an index-only entry point for tool-independent roles/capabilities guidance.

### Existing document types for agent knowledge

- `agent-capability` (defined in metadata/specification)
- `workflow` (repeatable review methods)
- `pattern` (reusable approaches)
- `prompt` (session operationalization)
- `registry` and `export-pack` (machine-readable and derived projection paths)

### Existing role/capability distinction

The vault defines capability structure clearly, but role modeling is implicit and not yet first-class in `agents/`.

### Existing execution descriptions

Execution behavior is described mainly through:

- `workflow.component-review`
- `workflow.operational.*`
- `workflow.design-knowledge-pilot`
- prompt and export-pack guidance

## 6. Current Content Classification

| Current document | Current location | Actual function | Current document type | Recommended treatment | Canonical or derived | Reason |
| --- | --- | --- | --- | --- | --- | --- |
| `AGENTS.md` | root | Global tool-independent agent operating boundary | `agent-capability` | Keep as canonical operating guidance | Canonical | Already aligned with governance and vault boundary |
| `agents/README.md` | `agents/` | Navigation to agent area | `index` | Expand as architecture map and contribution guide | Derived/supporting | Should orient, not define new governance |
| `capabilities/*.md` | `capabilities/` | Capability definitions (design, accessibility, verification, etc.) | `specification` | Keep for compatibility; introduce agent-scoped capability profiles in `agents/capabilities/` for pilot | Canonical today + transitional derived | Existing references likely depend on current IDs/types |
| `operational/*.md` | `operational/` | Repeatable review procedures | `workflow` | Keep as workflows; reference from roles/capabilities | Canonical/supporting | Already matches repeatable activity shape |
| `workflows/component-review.md` | `workflows/` | Core review process | `workflow` | Keep and reference | Canonical | Correct type and role |
| `prompts/spec-session.md` | `prompts/` | Session instruction starter | `prompt` | Keep and reference | Derived/supporting | Prompt is operational, not governing |
| `exports/agent-pack/*` | `exports/agent-pack/` | Derived cross-repo agent guidance | mixed (`export-pack`, `prompt`, `workflow`, `agent-capability`) | Keep derived; add explicit projection example linking source docs | Derived | Correct projection layer; needs clearer source traceability |
| `registry/*.yml` | `registry/` | Machine-readable contracts and consumption model | `registry` | Extend with agent relationship registry | Canonical for declarations | Existing pattern supports new declarations |

## 7. Gaps

1. Role profiles are not explicit in canonical navigation.
2. Capability corpus exists but is split across `capabilities/` and agent-oriented usage context.
3. No dedicated machine-readable role-to-capability relationship registry.
4. Multi-ecosystem projection rules exist conceptually, but agent-focused projection traceability is incomplete.

## 8. Duplication and Ambiguity Risks

1. Duplicate capability semantics across `capabilities/`, operational workflows, and export pack snippets.
2. Ambiguity between "capability definition" vs "workflow procedure".
3. Potential confusion if tool-specific projection text is interpreted as canonical.
4. Risk of introducing parallel taxonomy (`skills/`, `playbooks/`, `adapters/`) where current model is sufficient.

## 9. Multi-Ecosystem Requirements

### Canonical information that must stay in vault source docs

- Role purpose and boundaries
- Capability intent, inputs, outputs, and verification expectations
- Authority and precedence relationships
- Cross-document references

### Information that should remain tool-specific and derived

- Ecosystem-specific prompt wrappers
- vendor file locations and config fragments
- runtime-specific naming and orchestration instructions

### Projection location model

- Canonical definitions: vault documents (`agents/`, `workflows/`, `patterns/`, `prompts/`, `registry/`)
- Derived projections: `exports/` and consuming repositories

### ui-foundations-intelligence consumption

Use registry + export-pack references as a stable pull interface; keep execution logic and orchestration local to intelligence runtime.

### Codex/Open WebUI/Goose/Kiro/Copilot/MCP delivery

Consume derived projection artifacts that declare canonical source IDs and do not introduce new domain rules.

### Adapter decision

A new adapter document type is not required now. Existing registry + export-pack mechanisms are sufficient for pilot scope.

## 10. Options

### Option A: Existing taxonomy only

Use existing document types and directories; improve role/capability clarity with references and navigation.

**Human:** High clarity, low churn, low migration overhead.  
**Agent:** Deterministic enough if references are explicit.  
**System:** Minimal validation impact; easiest compatibility.

### Option B: Agent roles plus existing capability model

Add role and capability profiles under `agents/` while preserving current taxonomy and leaving existing capability specs intact for compatibility.

**Human:** Better findability in one place; manageable transition cost.  
**Agent:** Improves retrieval and relationship resolution.  
**System:** Additive registry/export updates only; no taxonomy/lifecycle change required.

### Option C: New canonical `skills/` type

Introduce a new top-level canonical type.

**Human:** Higher complexity and likely overlap.  
**Agent:** More classification branches and ambiguity risk.  
**System:** Requires governance/spec/metadata/lifecycle/schema/contract changes.

Not selected for pilot.

## 11. Impact Assessment

Impact level: **Low to Medium (additive)**  
Rationale: Adds audit + agent navigation/modeling artifacts; does not alter precedence, lifecycle, or taxonomy values.  
Canonical sources affected: `agents/README.md` (supporting), new agent profile docs (supporting), new registry declaration (draft source).  
Public contracts affected: None breaking; additive declarations only.  
Governance affected: No governance rule change.  
Schemas affected: None required for pilot.  
Cross-repository consumers affected: Only additive optional projection path.  
Migration risk: Low; existing capability/spec documents remain intact.  
Reversibility: High; new files can be removed without contract break.  
Approval required: Not required for additive pilot scope.

## 12. Recommendation

Select **Option B (additive form)**:

- Keep existing taxonomy and governance as-is.
- Add explicit role/capability pilot under `agents/`.
- Add registry declaration for role-capability-projection relationships.
- Add one derived ecosystem projection example.

Do **not** introduce `skills/` as a canonical type.

## 13. Proposed Minimal Target State

1. Expanded `agents/README.md` with clear boundaries, lifecycle, and canonical/derived model.
2. Two role profiles:
   - design-review-agent
   - accessibility-review-agent
3. Three capability profiles:
   - design-evaluation
   - accessibility-evaluation
   - verification
4. One machine-readable registry declaration for agent relationships and projection targets.
5. One derived projection example for a single ecosystem.

## 14. Proposed Migration Mapping

| Existing concept | Current source | Pilot mapping |
| --- | --- | --- |
| Design evaluation capability | `specification.capability.design-evaluation` | `agent-capability.design-evaluation` profile under `agents/capabilities/` |
| Accessibility evaluation capability | `specification.capability.accessibility-evaluation` | `agent-capability.accessibility-evaluation` profile under `agents/capabilities/` |
| Verification capability | `specification.capability.verification` | `agent-capability.verification` profile under `agents/capabilities/` |
| Review execution method | `workflow.operational.*`, `workflow.component-review` | Referenced by role profiles; not duplicated |
| Agent projection | `exports/agent-pack/*` | Add source-traceable ecosystem projection example |

## 15. Deferred Work

1. Full capability corpus migration strategy for `capabilities/` directory.
2. Optional schema for new agent registry declaration.
3. Additional ecosystem projections beyond pilot example.
4. Optional ADR if future standardization of role document semantics is required.

## 16. Approval Gate

Audit conclusion: implementation is **additive** and does **not** require governance/taxonomy/precedence/lifecycle/public-contract changes for pilot scope.

Proceed with minimal implementation.
