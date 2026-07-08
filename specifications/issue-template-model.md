---
id: specification.issue-template-model
title: Issue Template Model
type: specification
status: review
owners:
  - ui-foundations
created: 2026-07-08
updated: 2026-07-08
authority: source
summary: Defines the canonical tool-independent issue template model for UI Foundations work.
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
  references:
    - docs.architecture
    - specification.classification-model
    - specification.document-structure
    - specification.vault-metadata
    - specification.github.issue-templates
---

# Issue Template Model

## Purpose

This specification defines the canonical issue template model for the UI Foundations ecosystem.

Issue templates provide a consistent way to describe intended work before it is planned, routed, implemented, or reviewed. The model is tool-independent. Project management systems, source hosting platforms, studios, agent runtimes, or other tools may implement these templates, but those implementations do not define the canonical model.

## Scope

This specification defines template models for:

- Knowledge work
- Runtime work
- Intelligence work
- Studio work
- Integration work

## Non-Goals

This specification does not define:

- GitHub issue templates.
- YAML frontmatter for issue forms.
- Labels, project fields, boards, views, or project configuration.
- Repository automation, routing logic, or workflow execution.
- Tool-specific field types, validation syntax, or form controls.
- Repository implementation files.

Tool-specific mappings may use this model as their source, but they do not make their local fields, labels, titles, or form structure canonical.

## Repository Boundaries

Issue templates must preserve ecosystem ownership boundaries:

- Vault owns knowledge.
- Intelligence owns reasoning and execution.
- Runtime owns implementation assets.
- Studio owns workspace.
- Integration owns cross-system adapters.

An issue may describe impact across multiple layers, but it must identify one owning layer. Cross-layer effects belong in references, impact notes, or integration work rather than changing ownership semantics.

## Classification Requirements

Every issue template model must require the existing classification hierarchy:

| Field | Requirement |
| --- | --- |
| Layer | Required. Identifies the architectural layer that owns the work. |
| Domain | Required. Identifies the stable responsibility area within the layer. |
| Artifact | Required. Identifies the concrete thing being created, changed, reviewed, or investigated. |
| Implementation | Required. Identifies the tool-specific or repository-specific representation, when known. Use `Not yet selected` when implementation has not been chosen. |

Classification fields must use canonical meanings from `specification.classification-model`. Tool-specific labels, project fields, statuses, and boards may represent the classification fields but must not replace their canonical meaning.

## Relationship to Classification Model

This specification depends on `specification.classification-model`.

The classification model defines the canonical meaning of Layer, Domain, Artifact, and Implementation. This issue template model defines how those classification concepts must appear in issue-shaped work intake.

The relationship is:

| Classification Concept | Issue Template Use |
| --- | --- |
| Layer | Identifies the architectural owner of the work. |
| Domain | Identifies the stable responsibility area inside the owning layer. |
| Artifact | Identifies the concrete thing being proposed, changed, reviewed, or delivered. |
| Implementation | Identifies the tool-specific or repository-specific representation when known. |

Issue templates must not introduce new meanings for classification fields. If an issue cannot be classified with the existing model, the classification model should be reviewed before the new classification is treated as canonical.

## Implementation Evidence

`specification.github.issue-templates` is implementation evidence for this model.

The GitHub mapping shows how the canonical issue model can be represented in GitHub Issue Forms for current UI Foundations repositories. It is supporting evidence only. It must not override this specification, redefine canonical template sections, or make GitHub-specific labels, project fields, title patterns, or form controls normative.

## Universal Template Structure

Every conforming issue template must include these sections:

- Purpose
- Scope
- Classification
- Required references
- Acceptance criteria
- Validation expectations

Every conforming issue template may include these sections when useful:

- Context
- Non-goals
- Dependencies
- Risks
- Open questions
- Impact
- Handoff notes

Sections should be brief enough for humans to complete reliably and structured enough for agents to extract intent, ownership, evidence, and validation needs.

## Reference Requirements

Every issue must include references that make the work traceable.

Required references should identify:

- The canonical source or governing document when the issue changes knowledge, policy, requirements, or architecture.
- The affected artifact when the issue changes an existing artifact.
- The related decision, specification, workflow, prompt, component, token, pattern, workspace, adapter, or external system when applicable.

When no prior reference exists, the issue must state `No existing reference` and explain why the issue is introducing a new artifact or concern.

References should use stable document identifiers, repository paths, artifact names, or external system names. They should not depend on a single project management tool.

## Acceptance Criteria Structure

Acceptance criteria must describe observable completion, not implementation preference.

Every acceptance criteria section must include:

- Outcome: the required end state.
- Evidence: the document, artifact, review result, test result, screenshot, trace, or other proof that demonstrates the outcome.
- Boundary check: confirmation that the work remains in the owning layer or explicitly describes cross-layer impact.

Acceptance criteria may include:

- Review requirements.
- Compatibility requirements.
- Accessibility requirements.
- Migration requirements.
- Documentation requirements.
- Handoff requirements.

Acceptance criteria must avoid tool-specific status names, automation commands, or assumptions about a single implementation platform.

## Validation Expectations

Every issue template must define validation expectations before work begins.

Validation expectations must state:

- What must be checked.
- Who or what can check it.
- What evidence is required.
- Which repository or layer boundary must be preserved.

Validation may be manual, agent-assisted, or a combination. The template model defines the validation need, not the execution mechanism.

## Template Models

### Knowledge Work

#### Purpose

Knowledge work creates, revises, clarifies, reviews, or retires canonical ecosystem knowledge.

Knowledge work belongs to the Knowledge layer and is owned by the vault. It may describe expected impact on other repositories, but it must not implement runtime assets, intelligence logic, studio workspace behavior, integration adapters, automation, or generated output.

#### Required Sections

- Purpose
- Knowledge change
- Scope
- Classification
- Required references
- Acceptance criteria
- Validation expectations

#### Optional Sections

- Context
- Non-goals
- Related terminology
- Impact on other repositories
- Open questions
- Review notes

#### Required Classification Fields

| Field | Expected Value |
| --- | --- |
| Layer | Knowledge |
| Domain | Foundation, Reference, Governance, Capability, Operational, Glossary, Architecture, or another governed Knowledge domain |
| Artifact | Principle, decision, specification, workflow, prompt, glossary term, agent capability, index, reference, or other knowledge artifact |
| Implementation | Vault document, document identifier, repository path, or `Not yet selected` |

#### Required References

Knowledge work must reference:

- Governing vault documents when the work changes policy, lifecycle, precedence, or structure.
- Existing knowledge artifacts being changed.
- Related specifications, decisions, workflows, prompts, capabilities, or glossary terms.

If the work introduces a new canonical concept, the issue must explain why no existing knowledge artifact covers it.

#### Acceptance Criteria Structure

Acceptance criteria for knowledge work must confirm:

- The intended canonical meaning is clear.
- The document or artifact follows vault structure and metadata expectations.
- References point only to existing artifacts or explicitly identify new artifacts.
- The change does not add runtime implementation, automation, dependencies, or local orchestration logic.
- Cross-repository impact is described without modifying another repository.

#### Validation Expectations

Knowledge work is valid when:

- The issue identifies the owning vault artifact.
- The work conforms to vault governance and precedence.
- The classification fields align with the Knowledge layer.
- The proposed artifact is human-readable and agent-readable.
- Review can determine whether the change belongs in the vault.

### Runtime Work

#### Purpose

Runtime work creates, changes, reviews, or retires executable and consumable UI Foundations implementation assets.

Runtime work belongs to the Runtime layer. It may depend on vault specifications and decisions, but it must not redefine canonical knowledge locally.

#### Required Sections

- Purpose
- Runtime change
- Scope
- Classification
- Required references
- Acceptance criteria
- Validation expectations

#### Optional Sections

- Context
- Non-goals
- Compatibility
- Accessibility considerations
- Migration notes
- Visual or behavioral evidence
- Release impact

#### Required Classification Fields

| Field | Expected Value |
| --- | --- |
| Layer | Runtime |
| Domain | Component, Token, Pattern, Theme, Documentation, Build, Accessibility, or another governed Runtime domain |
| Artifact | Component, token, pattern, theme, package, documentation output, build asset, accessibility behavior, or other runtime artifact |
| Implementation | Runtime repository path, package, component name, token path, build target, documentation surface, or `Not yet selected` |

#### Required References

Runtime work must reference:

- The governing vault specification, principle, decision, or workflow when one exists.
- The runtime artifact being changed or introduced.
- Related components, tokens, patterns, themes, documentation, build outputs, or accessibility requirements.

If no governing knowledge exists, the issue must identify whether knowledge work is needed before or alongside runtime work.

#### Acceptance Criteria Structure

Acceptance criteria for runtime work must confirm:

- The runtime artifact behaves as intended.
- The implementation follows governing vault knowledge.
- The change preserves compatibility expectations or documents migration requirements.
- Required visual, behavioral, accessibility, build, or documentation evidence is available.
- The work does not create new canonical governance or specification meaning outside the vault.

#### Validation Expectations

Runtime work is valid when:

- The issue identifies the runtime artifact and owning Runtime domain.
- Validation can check the artifact through appropriate review, tests, examples, documentation, or accessibility evidence.
- Any deviation from existing vault knowledge is raised as separate knowledge work.
- Repository boundaries are preserved.

### Intelligence Work

#### Purpose

Intelligence work creates, changes, evaluates, or retires reasoning and execution behavior used by agents, planners, resolvers, verifiers, synthesizers, routers, adapters, or orchestration systems.

Intelligence work belongs to the Intelligence layer. It applies vault knowledge to reasoning and execution behavior without redefining canonical knowledge.

#### Required Sections

- Purpose
- Intelligence behavior
- Scope
- Classification
- Required references
- Acceptance criteria
- Validation expectations

#### Optional Sections

- Context inputs
- Expected outputs
- Failure modes
- Evaluation cases
- Safety considerations
- Handoff notes
- Open questions

#### Required Classification Fields

| Field | Expected Value |
| --- | --- |
| Layer | Intelligence |
| Domain | Context, Contracts, Planner, Resolver, Verification, Synthesis, Routing, Adapter, Orchestration, or another governed Intelligence domain |
| Artifact | Capability, contract, plan, resolver rule, verification check, synthesis behavior, route, adapter behavior, orchestration behavior, or other intelligence artifact |
| Implementation | Intelligence repository path, capability name, contract name, evaluation target, execution surface, or `Not yet selected` |

#### Required References

Intelligence work must reference:

- Vault knowledge that supplies the meaning, rule, capability, or constraint being applied.
- The intelligence artifact, contract, behavior, or execution path being changed.
- Evaluation inputs, expected outputs, or precedent examples when they exist.

If the work requires a new canonical rule, the issue must identify required knowledge work rather than embedding the rule only in intelligence behavior.

#### Acceptance Criteria Structure

Acceptance criteria for intelligence work must confirm:

- The intended reasoning or execution behavior is observable.
- Inputs, outputs, and boundaries are clear enough to evaluate.
- The behavior applies canonical vault knowledge without redefining it.
- Failure modes or unsupported cases are documented when relevant.
- Evidence from review, traces, evaluations, fixtures, or execution results is available.

#### Validation Expectations

Intelligence work is valid when:

- The issue identifies what reasoning or execution behavior changes.
- The classification fields align with the Intelligence layer.
- Validation can compare actual behavior against expected behavior.
- Any knowledge gap is routed to Knowledge work.
- The work does not modify runtime assets, studio workspace behavior, or cross-system adapters except through explicit handoff or integration work.

### Studio Work

#### Purpose

Studio work creates, changes, evaluates, or retires the human-facing workspace used to inspect, navigate, review, or apply UI Foundations ecosystem knowledge and artifacts.

Studio work belongs to the Studio layer. It may display or operate on knowledge, runtime assets, intelligence outputs, or integration data, but it does not own their canonical meaning.

#### Required Sections

- Purpose
- Workspace change
- Scope
- Classification
- Required references
- Acceptance criteria
- Validation expectations

#### Optional Sections

- User workflow
- Interaction states
- Data dependencies
- Accessibility considerations
- Visual evidence
- Empty or error states
- Handoff notes

#### Required Classification Fields

| Field | Expected Value |
| --- | --- |
| Layer | Studio |
| Domain | Dashboard, Workspace, Explorer, Review, Visualization, or another governed Studio domain |
| Artifact | Screen, view, dashboard, workspace, explorer, review surface, visualization, interaction flow, or other studio artifact |
| Implementation | Studio repository path, route, screen, component surface, design node, workspace area, or `Not yet selected` |

#### Required References

Studio work must reference:

- The knowledge, runtime artifact, intelligence behavior, or integration source represented by the workspace.
- The workspace surface, view, route, or interaction being changed.
- Applicable accessibility, usability, or review expectations when they exist.

If the work exposes a concept not yet defined in the vault, the issue must identify the knowledge gap.

#### Acceptance Criteria Structure

Acceptance criteria for studio work must confirm:

- The workspace supports the intended user or agent workflow.
- Displayed concepts preserve the canonical meaning of their source layer.
- Required states, interactions, and evidence are defined.
- Accessibility and usability expectations are checkable.
- The work does not move ownership of knowledge, runtime assets, intelligence behavior, or integration adapters into Studio.

#### Validation Expectations

Studio work is valid when:

- The issue identifies the workspace artifact and owning Studio domain.
- Validation can inspect the relevant surface, state, or workflow.
- Source-layer references are traceable.
- Visual or interaction evidence can demonstrate completion when applicable.
- Cross-layer dependencies are represented as references or handoffs.

### Integration Work

#### Purpose

Integration work creates, changes, evaluates, or retires cross-system adapters, synchronization behavior, mappings, migrations, imports, exports, or handoff contracts.

Integration work belongs to the Integration layer. It manages boundaries between systems without making either side the canonical source for the other.

#### Required Sections

- Purpose
- Integration boundary
- Scope
- Classification
- Required references
- Acceptance criteria
- Validation expectations

#### Optional Sections

- Source system
- Target system
- Mapping rules
- Sync direction
- Conflict handling
- Data ownership
- Migration notes
- Rollback expectations
- Operational risks

#### Required Classification Fields

| Field | Expected Value |
| --- | --- |
| Layer | Integration |
| Domain | External standards, repository coordination, synchronization, migration, tool mapping, handoff, or another governed Integration domain |
| Artifact | Adapter, mapping, sync rule, import, export, migration, bridge, handoff contract, or other integration artifact |
| Implementation | Adapter name, integration surface, repository path, external system, mapping document, contract name, or `Not yet selected` |

#### Required References

Integration work must reference:

- The source and target systems or layers involved.
- The canonical source of meaning for each side of the boundary.
- Existing mappings, contracts, schemas, specifications, or handoff documents when they exist.

If the integration introduces a new boundary, the issue must explain why the boundary is needed and which layer owns each side.

#### Acceptance Criteria Structure

Acceptance criteria for integration work must confirm:

- The source and target boundary is explicit.
- Ownership of canonical meaning is preserved.
- Mapping or handoff rules are documented.
- Conflict, failure, or mismatch behavior is defined when relevant.
- Evidence demonstrates that data, meaning, or artifacts move across the boundary as intended.

#### Validation Expectations

Integration work is valid when:

- The issue identifies both sides of the integration boundary.
- Validation can confirm that the adapter or mapping preserves canonical meaning.
- Sync, import, export, migration, or handoff behavior is testable or reviewable.
- The work does not redefine source-layer governance.
- Repository and system boundaries remain explicit.

## Governance

This specification is the source of truth for issue template semantics in the UI Foundations ecosystem.

Implementations may translate these models into issue forms, project fields, labels, templates, prompts, or other tool-specific representations. Those implementations must preserve the required sections, classification fields, reference expectations, acceptance criteria structure, and validation expectations defined here.

When a tool-specific implementation needs fields that are not defined here, those fields are implementation details unless they change the canonical meaning of the issue model. Changes to canonical template models require review in the vault.

## Validation

An issue template implementation is valid when:

- It preserves the distinction between Knowledge, Runtime, Intelligence, Studio, and Integration work.
- It requires Layer, Domain, Artifact, and Implementation classification.
- It requires traceable references or an explicit statement that no existing reference exists.
- It requires acceptance criteria with outcome, evidence, and boundary check.
- It requires validation expectations before work begins.
- It keeps tool-specific configuration out of the canonical model.
- It does not add automation requirements to this specification.
- It respects repository and layer ownership boundaries.
- It conforms to `specification.classification-model`.
