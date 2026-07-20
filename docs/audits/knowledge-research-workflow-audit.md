---
id: publication.knowledge-research-workflow-audit
title: Knowledge Research Workflow Audit
type: publication
status: review
owners:
  - ui-foundations
created: 2026-07-20
updated: 2026-07-20
authority: supporting
summary: Audits the current vault support for reusable research workflows, capabilities, roles, registry relationships, and export projections.
consumers:
  - human
  - agent
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
    - governance.verification-review
  references:
    - docs.architecture
    - index.capabilities
    - index.operational
    - index.workflows
    - index.agents
    - registry.index
    - exports.index
verification:
  status: partially-verified
assumptions:
  - The repository's current canonical role model is limited to generic vault-maintainer guidance because no additional role documents exist under `agents/`.
---

# Knowledge Research Workflow Audit

## 1. Executive assessment

The vault already preserves the core boundary between canonical knowledge and derived export content, but the target stack is only partially implemented.

Current state against the intended model:

```text
Vault
  -> roles
  -> capabilities
  -> operational workflows
  -> registry
  -> export projections
```

| Layer | Current state | Assessment |
| --- | --- | --- |
| Vault | Strong source boundary across governance, specifications, workflows, and exports | Preserved |
| Roles | Only generic vault-maintainer guidance in `AGENTS.md`; no explicit role documents in `agents/` | Missing abstraction |
| Capabilities | Present in `capabilities/` as executor-independent source specifications | Present |
| Operational workflows | Present, but split across `operational/`, `workflows/`, and one derived export workflow | Partially coherent |
| Registry | Present and already models reviewed consumption boundaries | Present |
| Export projections | Present through export packs, including one vendor-specific Perplexity projection | Present |

The architecture is directionally correct, but research work is not yet modeled as a clean composition of **role -> capability -> workflow -> projection**. The main gap is not export packaging. The main gap is the missing role composition and a small set of atomic reusable capabilities in the knowledge layer, while source discovery remains workflow-owned.

## 2. Canonical boundary check

The repository mostly respects the canonical-versus-derived boundary requested for downstream AI ecosystems.

### Canonical knowledge already modeled

- Governance and precedence in `governance/`
- Specifications, including capability definitions, in `specifications/` and `capabilities/`
- Repeatable workflows in `operational/`, `workflows/`, and `docs/reflection-loop.md`
- Agent operating guidance in `AGENTS.md`
- Pattern and reference knowledge in `patterns/`

### Derived knowledge already modeled

- Reviewed consumption contracts in `registry/`
- Consumer-facing export packs in `exports/`
- Vendor-specific projection in `exports/agent-pack/projections/perplexity-research.md`

### Boundary result

The repository does **not** currently reverse source and projection responsibilities. The larger issue is that some derived research guidance is compensating for missing canonical role and capability composition.

## 3. Inventory of reusable workflows

### 3.1 Canonical operational workflows

| Document | Primary purpose | Reusable research value | Notes |
| --- | --- | --- | --- |
| `operational/architecture-review.md` | Evaluate fit, overlap, coupling, and boundary placement | High | Closest current workflow to knowledge-layer research and architecture assessment |
| `operational/accessibility-review.md` | Review accessibility barriers and user impact | Medium | Strong domain workflow, not a general research workflow |
| `operational/component-review.md` | Review component responsibility, state, and composition | Medium | Overlaps with `workflows/component-review.md` |
| `operational/release-review.md` | Review release coherence, metadata, and evidence | High | Useful as a verification and audit workflow |
| `operational/spec-session.md` | Create or revise a specification from governed sources | High | Strong source-grounded drafting workflow |
| `operational/token-audit.md` | Audit token meaning, layer placement, and reuse | Medium | Strong domain workflow, not general research |

### 3.2 Additional canonical workflows outside `operational/`

| Document | Primary purpose | Reusable research value | Notes |
| --- | --- | --- | --- |
| `workflows/component-review.md` | Component proposal review | Medium | Duplicates the same problem space already covered by `operational/component-review.md` |
| `workflows/design-knowledge-pilot.md` | Bounded pilot comparing governed knowledge against current-source discovery | High | Most relevant current workflow for knowledge research, but intentionally scoped as a pilot |
| `docs/reflection-loop.md` | Promote reusable findings back into the vault | High | Important follow-through workflow after research and review |

### 3.3 Derived workflow surfaces

| Document | Primary purpose | Why it is derived |
| --- | --- | --- |
| `exports/agent-pack/review-rules.md` | Agent review stance for consuming repositories | Consuming-repository guidance, not canonical workflow authority |
| `exports/agent-pack/projections/perplexity-research.md` | Perplexity-specific research and validation operating guidance | Vendor-specific projection by design |

### 3.4 Workflow assessment

The vault already has enough workflow material to support research-adjacent work, but it is scattered across three shapes:

1. `operational/` playbooks
2. `workflows/` broader workflows and pilots
3. derived export workflows and projections

That split is understandable, but it weakens discoverability and makes it harder to say which workflow is the canonical starting point for cross-vendor knowledge research.

## 4. Inventory of capabilities

All current canonical capabilities live in `capabilities/` and are modeled as source specifications rather than executor-specific instructions.

| Capability | Main purpose | Research relevance | Notes |
| --- | --- | --- | --- |
| `accessibility-evaluation` | Identify accessibility barriers and impact | Medium | Domain-specific |
| `architecture-analysis` | Evaluate structure, boundaries, and relationships | High | Core research building block |
| `design-evaluation` | Evaluate design quality | Medium | Domain-specific |
| `design-reasoning` | Make tradeoffs explicit | High | Useful in research synthesis |
| `pattern-selection` | Choose the correct reusable pattern | Medium | Decision support, not general research |
| `specification-generation` | Turn governed knowledge into structured specification output | High | Essential downstream drafting capability |
| `synthesis` | Combine findings into a coherent interpretation | High | Core research building block |
| `ux-writing` | Improve interface language | Low | Specialized editing capability |
| `verification` | Check whether claims are supported by evidence | High | Core research building block |

### Capability assessment

The capability layer is strong at:

- analysis
- verification
- synthesis
- governed drafting

The capability layer is weak at:

- evidence framing
- cross-source comparison before verification
- confidence assessment

Those missing pieces are exactly the ones downstream research consumers need before they can apply verification and synthesis well. By contrast, source discovery, source selection, and escalation fit better as workflow steps than as a broad reusable capability.

## 5. Inventory of roles

### 5.1 Canonical role surfaces

| Document | Current role signal | Assessment |
| --- | --- | --- |
| `AGENTS.md` (`agent-capability.vault-maintainer`) | Generic vault-maintainer guidance | Useful repository-wide guardrail, but not a role catalog |
| `agents/README.md` | Declares agent roles and capabilities as a category | Empty index with no actual role documents |

### 5.2 Derived role-like guidance

| Document | Current role signal | Assessment |
| --- | --- | --- |
| `exports/agent-pack/assistant-behavior-rules.md` | Cross-repo assistant behavior | Derived behavior rules, not a canonical role |
| `exports/agent-pack/agents-additions.md` | Suggested `AGENTS.md` text for consumers | Derived adoption guidance, not a canonical role |
| `exports/agent-pack/projections/perplexity-research.md` | External research consumer stance | Projection, explicitly not a canonical role |

### 5.3 Role assessment

The canonical implementation cannot be determined from the available governing sources.

Specifically, the repository does not yet define whether research should be composed through:

- one broad canonical research role
- several narrower roles such as researcher, verifier, and synthesizer
- no role taxonomy at all beyond repository-level agent guidance

What **is** clear from the available sources is that the current role layer is under-modeled relative to the intended architecture.

## 6. Duplication and taxonomy drift

### 6.1 Confirmed duplication

| Area | Evidence | Effect |
| --- | --- | --- |
| Component review workflow | `operational/component-review.md` and `workflows/component-review.md` cover the same review problem with overlapping steps and outputs | Two starting points for the same activity |
| Specification session | `operational/spec-session.md` and `prompts/spec-session.md` express the same session flow at different levels | Acceptable prompt-to-workflow pairing, but linkage is implicit rather than explicit composition |
| Agent behavior guidance | `AGENTS.md`, `exports/agent-pack/assistant-behavior-rules.md`, and `exports/agent-pack/agents-additions.md` repeat overlapping boundary rules | Reuse is present, but source-versus-derived ownership is easy to blur |

### 6.2 Taxonomy drift

| Area | Drift | Risk |
| --- | --- | --- |
| Workflow placement | `operational/` and `workflows/` both contain `type: workflow` artifacts | Harder retrieval and unclear starting point |
| Capability typing | Capability documents are executor-independent but typed as `specification` rather than `agent-capability` | Reasonable, but the role-capability distinction is not obvious to consumers |
| Agent layer | `agents/` is declared but effectively empty, while role-like guidance lives in root and exports | Missing canonical composition point |

## 7. Missing abstractions

### 7.1 Missing atomic capabilities for research composition

There is no minimal source capability set for the work that happens **between** workflow-owned source discovery and the existing `verification` and `synthesis` capabilities.

Before admitting any new capability, the concept should be checked against existing abstractions in this order:

1. workflow
2. pattern
3. specification
4. principle
5. governance rule
6. role responsibility

If the concept is already represented by one of those abstractions, the existing abstraction should be reused.

Only after that admission check should a new capability be created, and only when the concept represents a reusable, executor-independent reasoning ability.

The smallest missing atomic capabilities are:

- **evidence framing**: normalize gathered evidence into explicit claims, assumptions, and supporting sources
- **cross-source comparison**: compare aligned sources, identify agreement and contradiction, and isolate decision-relevant differences
- **confidence assessment**: express confidence based on source quality, evidence coverage, and unresolved conflicts

These are small enough to be reused across multiple roles and consumers without creating a broad research capability.

Source discovery, source selection, and governance escalation should remain inside operational workflows where topic scope and review context are already defined.

### 7.2 Missing canonical research role

There is no explicit role that composes:

- evidence framing
- cross-source comparison
- confidence assessment
- verification
- synthesis
- release or architecture review workflows
- reflection-loop handoff

This makes vendor projections carry more behavioral responsibility than they should.

### 7.3 Missing explicit workflow composition for research

The repository has the pieces for research work, but not a clear compositional path such as:

1. discover and select sources within the operational workflow
2. frame evidence into claims and assumptions
3. compare sources and isolate conflicts
4. verify source support
5. synthesize findings
6. assess confidence
7. recommend next action
8. route reusable insight into the reflection loop

### 7.4 Missing projection relationship model

The Perplexity projection references canonical sources correctly, but there is no explicit canonical research role, no minimal atomic capability set, and no workflow-owned research composition for future projections to anchor on. That limits reuse for ChatGPT Projects, Claude Projects, Gemini Gems, Open WebUI, Studio, and future A2A runtimes.

## 8. Projection-only logic

The following logic belongs only in projections or export packs and should remain derived:

| Surface | Projection-only logic | Keep derived because |
| --- | --- | --- |
| `exports/agent-pack/projections/perplexity-research.md` | Perplexity-specific constraints, handoff format, confidence labeling convention, curated upload strategy | Vendor runtime behavior must not become canonical |
| `exports/agent-pack/agents-additions.md` | Copy-ready `AGENTS.md` additions for consuming repositories | Repository adoption text is packaging, not canonical source knowledge |
| `exports/agent-pack/review-rules.md` | Cross-repo review stance for consuming repositories | Consumption guidance depends on downstream context |
| `exports/governance-pack/*` | Reviewed governance packaging for other repositories | Export packaging must remain subordinate to source governance |
| `exports/runtime-pack/*` | Runtime-facing expectations for implementation repositories | Runtime packaging is derived from canonical knowledge |

### Projection risk

The current Perplexity projection is correctly placed, but it now contains some of the clearest research-operating guidance in the repository. That is a signal that generic reasoning behavior should move back toward canonical roles, atomic capabilities, and workflows so projections can shrink to platform-specific constraints and references.

## 9. Smallest safe additive pilot

## Selected architecture

Preserve the requested model and strengthen the missing middle:

```text
Vault
  -> canonical research role
  -> atomic reusable capabilities
  -> workflow-owned source discovery and escalation
  -> existing operational workflows
  -> existing registry and export packs
  -> vendor-specific projections
```

## Recommended pilot scope

The smallest safe additive pilot is:

1. **Add the smallest missing atomic capabilities** for evidence framing, cross-source comparison, and confidence assessment.
2. **Apply a capability admission check first** so no new capability is added when the concept is already better represented as a workflow, pattern, specification, principle, governance rule, or role responsibility.
3. **Add one canonical research role** in `agents/` that composes those atomic capabilities with existing `verification`, `synthesis`, and relevant operational workflows.
4. **Keep source discovery and escalation inside operational workflows** by wiring source selection, conflict handling, and reflection-loop handoff into the most relevant current workflows.
5. **Thin projections instead of expanding them** so vendor-specific documents reference canonical workflows and capabilities rather than embedding generic reasoning behavior.
6. **Keep registry and export changes minimal** by reusing the existing `agent-pack` and current sync-contract structure.

## Why this is the smallest safe option

- It fixes the missing middle with narrowly scoped reusable parts instead of introducing a broad research capability.
- It requires a reuse-first admission check before any new capability is introduced.
- It reuses existing capabilities and workflows rather than replacing them.
- It avoids new top-level taxonomy such as `skills/`, `playbooks/`, or `adapters/`.
- It keeps source discovery and escalation in the workflows that already define context and review scope.
- It keeps vendor-specific behavior in projections where it already belongs, while making those projections thinner.
- It creates a reusable anchor for all downstream consumers, not only Perplexity.

## Candidate workflow extensions for the approved stage

If approved, the lowest-risk workflow changes are:

| Workflow | Safe extension |
| --- | --- |
| `operational/architecture-review.md` | Add source-selection, evidence-framing, and cross-source comparison steps for architecture questions |
| `operational/spec-session.md` | Add governed source discovery and evidence-framing before drafting |
| `operational/release-review.md` | Add explicit comparison, confidence, and escalation handling for release claims |
| `docs/reflection-loop.md` | Add a clearer handoff from role-composed research outputs into lessons or promotion proposals |

## Candidate projection follow-through for the approved stage

After the canonical research layer exists, projections such as Perplexity should become thinner and refer back to:

- the canonical research role
- the atomic capability set
- the existing verification and synthesis capabilities
- the existing operational workflows

Projections should then keep only platform-specific constraints, formatting expectations, and consumer handoff notes.

That keeps projections vendor-shaped but no longer vendor-defining.

## 10. Impact, risks, and deferred work

| Item | Assessment |
| --- | --- |
| Impact level | Low to medium |
| Reason | Additive knowledge modeling only; no runtime, dependency, or automation changes |
| Registry change required now | No |
| Export-pack change required now | No |
| Main risk | Over-fragmenting capability definitions or creating a research role that overlaps too much with generic vault-maintainer guidance |
| Main deferred decision | How small the atomic capability set can remain while still supporting multiple consumers |

### Remaining risks

- The current sources do not clearly define a canonical role taxonomy.
- `operational/` versus `workflows/` remains ambiguous even after a research pilot unless addressed deliberately.
- Capability documents are source specifications today; changing their typing or placement would need careful review.
- If projections are not actively reduced after the canonical workflow references exist, reasoning behavior may continue to drift outward into derived documents.

### Deferred work

- Unify or clearly differentiate `operational/component-review.md` and `workflows/component-review.md`.
- Decide whether `operational/` remains a distinct domain or folds into `workflows/` over time.
- Decide whether capability artifacts should continue as `type: specification` or gain a more explicit canonical capability marker.
- Add additional downstream projections only after the canonical research layer is in place.

## 11. Approval gate

This Stage 1 audit recommends a **single additive pilot** focused on canonical research composition.

It does **not** recommend:

- new top-level taxonomy
- registry contract redesign
- sync automation
- vendor-specific canonical artifacts
- runtime or documentation repository changes from this audit alone

No implementation is included in this stage. Wait for approval before changing canonical roles, capabilities, workflows, registries, or projections.
