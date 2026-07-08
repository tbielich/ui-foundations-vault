---
id: specification.github.issue-templates
title: GitHub Issue Templates
type: specification
status: review
owners:
  - ui-foundations
created: 2026-07-08
updated: 2026-07-08
authority: supporting
summary: Maps the canonical issue template model to GitHub Issue Forms for UI Foundations repositories.
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
  implements:
    - specification.issue-template-model
  references:
    - specification.classification-model
    - specification.github.classification-mapping
    - docs.architecture
---

# GitHub Issue Templates

## Purpose

This document defines how the canonical issue template model is represented as GitHub Issue Forms for UI Foundations repositories.

GitHub Issue Forms are an implementation detail. This mapping must preserve the canonical template semantics from `specification.issue-template-model` and the classification semantics from `specification.classification-model`.

## Scope

This mapping covers issue form expectations for:

- `ui-foundations-vault`
- `ui-foundations`
- `ui-foundations-intelligence`
- `ui-foundations-studio`

This document does not create `.github` files, GitHub form YAML, labels, projects, workflows, or automation. It defines the expected mapping only.

## Common Mapping Rules

All GitHub Issue Forms must preserve the canonical issue model.

### Required Fields

Every form must require:

- Purpose
- Scope
- Layer
- Domain
- Artifact
- Implementation
- Required references
- Acceptance criteria
- Validation expectations

### Classification Mapping

| Canonical Field | GitHub Representation | Requirement |
| --- | --- | --- |
| Layer | Project field `Layer` | Required. Must match the owning repository layer unless the issue is explicitly Integration work. |
| Domain | Body field and, when available, `domain:*` label | Required. The body field preserves explicit issue content. The label supports filtering where the domain exists in `specification.github.classification-mapping`. |
| Artifact | Issue body field and title pattern | Required. Identifies the concrete thing being changed. |
| Implementation | Issue body field | Required. Use `Not yet selected` when unknown. |

### Common Suggested Labels

Every form should suggest:

- One `domain:*` label that matches the selected Domain.
- A neutral workflow or type label if the repository already uses one.

Suggested labels are implementation aids. They do not replace body fields or Project fields. This mapping does not create new labels.

For Integration work, Integration domains remain explicit in the issue body and Project field expectations. Until Integration-specific `domain:*` labels are defined in `specification.github.classification-mapping`, forms should suggest the affected repository domain label as a supporting label rather than inventing a new label.

### Common Project Field Expectations

Every issue should be added to the ecosystem project when project tracking is used.

| Project Field | Expectation |
| --- | --- |
| Layer | Set to the owning layer. |
| Repository | Set to the repository where the issue is created. |
| Epic | Set when the work belongs to a larger initiative. |
| Priority | Set during triage. |
| Milestone | Set only when there is a concrete delivery target. |

### Common Body Sections

Every form should render these body sections:

- Purpose
- Scope
- Classification
- Required references
- Acceptance criteria
- Validation expectations

Optional body sections may render only when relevant:

- Context
- Non-goals
- Dependencies
- Risks
- Open questions
- Impact
- Handoff notes

## Repository Templates

### `ui-foundations-vault`

The vault owns Knowledge work.

#### Knowledge Work

| Field | Mapping |
| --- | --- |
| Template name | Knowledge work |
| Template description | Create, revise, review, or retire canonical UI Foundations knowledge. |
| Default title pattern | `[Knowledge] <artifact>: <short outcome>` |
| Suggested labels | `domain:foundation`, `domain:reference`, `domain:governance`, `domain:capability`, `domain:operational`, `domain:glossary`, `domain:architecture` |

Required fields:

- Purpose
- Knowledge change
- Scope
- Layer
- Domain
- Artifact
- Implementation
- Required references
- Acceptance criteria
- Validation expectations

Optional fields:

- Context
- Non-goals
- Related terminology
- Impact on other repositories
- Open questions
- Review notes

Body sections:

- Purpose
- Knowledge change
- Scope
- Classification
- Required references
- Acceptance criteria
- Validation expectations
- Optional context
- Optional review notes

Project field expectations:

| Project Field | Value |
| --- | --- |
| Layer | Knowledge |
| Repository | `ui-foundations-vault` |
| Epic | Set when the knowledge work belongs to a named initiative. |
| Priority | Set during triage. |
| Milestone | Set only for planned governance, specification, or release review targets. |

#### Integration Work

| Field | Mapping |
| --- | --- |
| Template name | Integration work |
| Template description | Define or revise vault-owned mappings, handoffs, or cross-repository coordination documents. |
| Default title pattern | `[Integration] <boundary>: <short outcome>` |
| Suggested labels | Use the closest `domain:*` Knowledge label when the artifact is a vault document; use neutral integration labels only if they already exist. |

Required fields:

- Purpose
- Integration boundary
- Scope
- Layer
- Domain
- Artifact
- Implementation
- Source system or layer
- Target system or layer
- Required references
- Acceptance criteria
- Validation expectations

Optional fields:

- Mapping rules
- Sync direction
- Conflict handling
- Data ownership
- Migration notes
- Operational risks
- Handoff notes

Body sections:

- Purpose
- Integration boundary
- Scope
- Classification
- Source and target
- Required references
- Acceptance criteria
- Validation expectations
- Optional mapping or handoff notes

Project field expectations:

| Project Field | Value |
| --- | --- |
| Layer | Integration |
| Repository | `ui-foundations-vault` |
| Epic | Set when the integration work belongs to a cross-system initiative. |
| Priority | Set during triage. |
| Milestone | Set only when tied to a planned mapping, migration, or handoff milestone. |

### `ui-foundations`

The runtime repository owns Runtime work.

#### Runtime Work

| Field | Mapping |
| --- | --- |
| Template name | Runtime work |
| Template description | Create, change, review, or retire UI Foundations runtime assets. |
| Default title pattern | `[Runtime] <artifact>: <short outcome>` |
| Suggested labels | `domain:component`, `domain:token`, `domain:pattern`, `domain:theme`, `domain:documentation`, `domain:build`, `domain:accessibility` |

Required fields:

- Purpose
- Runtime change
- Scope
- Layer
- Domain
- Artifact
- Implementation
- Required references
- Acceptance criteria
- Validation expectations

Optional fields:

- Context
- Non-goals
- Compatibility
- Accessibility considerations
- Migration notes
- Visual or behavioral evidence
- Release impact
- Handoff notes

Body sections:

- Purpose
- Runtime change
- Scope
- Classification
- Required references
- Acceptance criteria
- Validation expectations
- Optional compatibility and migration notes
- Optional visual, behavioral, or accessibility evidence

Project field expectations:

| Project Field | Value |
| --- | --- |
| Layer | Runtime |
| Repository | `ui-foundations` |
| Epic | Set when the runtime work belongs to a component, token, pattern, theme, or release initiative. |
| Priority | Set during triage. |
| Milestone | Set only when tied to a planned runtime release or delivery target. |

#### Integration Work

| Field | Mapping |
| --- | --- |
| Template name | Runtime integration work |
| Template description | Manage mappings, imports, exports, migrations, or handoffs that affect runtime assets. |
| Default title pattern | `[Integration] <runtime boundary>: <short outcome>` |
| Suggested labels | Use the affected Runtime `domain:*` label and any existing neutral integration label. |

Required fields:

- Purpose
- Integration boundary
- Scope
- Layer
- Domain
- Artifact
- Implementation
- Source system or layer
- Target system or layer
- Required references
- Acceptance criteria
- Validation expectations

Optional fields:

- Mapping rules
- Sync direction
- Conflict handling
- Data ownership
- Migration notes
- Rollback expectations
- Operational risks
- Handoff notes

Body sections:

- Purpose
- Integration boundary
- Scope
- Classification
- Source and target
- Required references
- Acceptance criteria
- Validation expectations
- Optional migration or rollback notes

Project field expectations:

| Project Field | Value |
| --- | --- |
| Layer | Integration |
| Repository | `ui-foundations` |
| Epic | Set when the work belongs to a cross-repository or external-system initiative. |
| Priority | Set during triage. |
| Milestone | Set only when tied to a migration, release, or external handoff target. |

### `ui-foundations-intelligence`

The intelligence repository owns Intelligence work.

#### Intelligence Work

| Field | Mapping |
| --- | --- |
| Template name | Intelligence work |
| Template description | Create, change, evaluate, or retire reasoning and execution behavior. |
| Default title pattern | `[Intelligence] <artifact>: <short outcome>` |
| Suggested labels | `domain:context`, `domain:contracts`, `domain:planner`, `domain:resolver`, `domain:verification`, `domain:synthesis`, `domain:routing`, `domain:adapter`, `domain:orchestration` |

Required fields:

- Purpose
- Intelligence behavior
- Scope
- Layer
- Domain
- Artifact
- Implementation
- Required references
- Acceptance criteria
- Validation expectations

Optional fields:

- Context inputs
- Expected outputs
- Failure modes
- Evaluation cases
- Safety considerations
- Handoff notes
- Open questions

Body sections:

- Purpose
- Intelligence behavior
- Scope
- Classification
- Required references
- Acceptance criteria
- Validation expectations
- Optional inputs, outputs, and evaluation cases
- Optional failure modes or safety considerations

Project field expectations:

| Project Field | Value |
| --- | --- |
| Layer | Intelligence |
| Repository | `ui-foundations-intelligence` |
| Epic | Set when the work belongs to a capability, contract, routing, or orchestration initiative. |
| Priority | Set during triage. |
| Milestone | Set only when tied to a planned intelligence delivery target. |

#### Integration Work

| Field | Mapping |
| --- | --- |
| Template name | Intelligence integration work |
| Template description | Manage adapters, contracts, mappings, or handoffs between intelligence and other systems. |
| Default title pattern | `[Integration] <intelligence boundary>: <short outcome>` |
| Suggested labels | Use the affected Intelligence `domain:*` label and any existing neutral integration label. |

Required fields:

- Purpose
- Integration boundary
- Scope
- Layer
- Domain
- Artifact
- Implementation
- Source system or layer
- Target system or layer
- Required references
- Acceptance criteria
- Validation expectations

Optional fields:

- Mapping rules
- Sync direction
- Conflict handling
- Data ownership
- Migration notes
- Failure modes
- Operational risks
- Handoff notes

Body sections:

- Purpose
- Integration boundary
- Scope
- Classification
- Source and target
- Required references
- Acceptance criteria
- Validation expectations
- Optional mapping, contract, or failure-mode notes

Project field expectations:

| Project Field | Value |
| --- | --- |
| Layer | Integration |
| Repository | `ui-foundations-intelligence` |
| Epic | Set when the work belongs to a cross-system intelligence initiative. |
| Priority | Set during triage. |
| Milestone | Set only when tied to a planned adapter, contract, or handoff target. |

### `ui-foundations-studio`

The studio repository owns Studio work.

#### Studio Work

| Field | Mapping |
| --- | --- |
| Template name | Studio work |
| Template description | Create, change, evaluate, or retire UI Foundations workspace surfaces. |
| Default title pattern | `[Studio] <artifact>: <short outcome>` |
| Suggested labels | `domain:dashboard`, `domain:workspace`, `domain:explorer`, `domain:review`, `domain:visualization` |

Required fields:

- Purpose
- Workspace change
- Scope
- Layer
- Domain
- Artifact
- Implementation
- Required references
- Acceptance criteria
- Validation expectations

Optional fields:

- User workflow
- Interaction states
- Data dependencies
- Accessibility considerations
- Visual evidence
- Empty or error states
- Handoff notes
- Open questions

Body sections:

- Purpose
- Workspace change
- Scope
- Classification
- Required references
- Acceptance criteria
- Validation expectations
- Optional workflow, state, and dependency notes
- Optional visual or accessibility evidence

Project field expectations:

| Project Field | Value |
| --- | --- |
| Layer | Studio |
| Repository | `ui-foundations-studio` |
| Epic | Set when the work belongs to a dashboard, workspace, explorer, review, or visualization initiative. |
| Priority | Set during triage. |
| Milestone | Set only when tied to a planned studio delivery target. |

#### Integration Work

| Field | Mapping |
| --- | --- |
| Template name | Studio integration work |
| Template description | Manage workspace mappings, imports, exports, handoffs, or cross-system data boundaries. |
| Default title pattern | `[Integration] <studio boundary>: <short outcome>` |
| Suggested labels | Use the affected Studio `domain:*` label and any existing neutral integration label. |

Required fields:

- Purpose
- Integration boundary
- Scope
- Layer
- Domain
- Artifact
- Implementation
- Source system or layer
- Target system or layer
- Required references
- Acceptance criteria
- Validation expectations

Optional fields:

- Mapping rules
- Sync direction
- Conflict handling
- Data ownership
- Migration notes
- Empty or error states
- Operational risks
- Handoff notes

Body sections:

- Purpose
- Integration boundary
- Scope
- Classification
- Source and target
- Required references
- Acceptance criteria
- Validation expectations
- Optional data, state, or handoff notes

Project field expectations:

| Project Field | Value |
| --- | --- |
| Layer | Integration |
| Repository | `ui-foundations-studio` |
| Epic | Set when the work belongs to a cross-system studio initiative. |
| Priority | Set during triage. |
| Milestone | Set only when tied to a planned workspace, data, or handoff target. |

## Validation

A GitHub Issue Form mapping is valid when:

- It implements `specification.issue-template-model` without redefining canonical issue semantics.
- It preserves required classification fields for Layer, Domain, Artifact, and Implementation.
- It uses `domain:*` labels consistently with `specification.github.classification-mapping`.
- It keeps Artifact and Implementation explicit in the issue body.
- It requires references or an explicit `No existing reference` statement.
- It requires acceptance criteria with outcome, evidence, and boundary check.
- It requires validation expectations before work begins.
- It distinguishes owning repository from cross-layer impact.
- It keeps GitHub YAML, `.github` files, workflow automation, and repository changes out of this vault mapping.
