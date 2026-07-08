---
id: specification.classification-model
title: Classification Model
type: specification
status: review
owners:
  - ui-foundations
created: 2026-07-08
updated: 2026-07-08
authority: source
summary: Defines the canonical classification model used across the UI Foundations ecosystem.
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
  references:
    - docs.architecture
    - reference.terminology
    - reference.document-types
---

# Classification Model

## Purpose

The classification model defines a shared way to describe work, knowledge, and artifacts across the UI Foundations ecosystem.

Consistent classification is required so humans can understand ownership and scope, AI agents can retrieve and reason over context, automation can route and summarize work predictably, and governance can verify whether artifacts belong to the correct layer and domain.

The model describes concepts, not tool configuration. Project management tools may implement the model through labels, tags, components, fields, or other mechanisms, but those mechanisms do not define the model.

## Classification Hierarchy

Classification follows a four-level hierarchy:

1. Layer
2. Domain
3. Artifact
4. Implementation

### Layer

A layer is the highest-level architectural responsibility in the ecosystem.

Layers describe where a concern belongs. They are stable across repositories, planning tools, automation, and agent workflows.

### Domain

A domain is a stable area of responsibility within a layer.

Domains help classify work more precisely without depending on repository names, folder paths, or tool-specific categories. Each repository may define the domains it owns, but those domains should remain consistent with the ecosystem layer model.

### Artifact

An artifact is the concrete thing being classified.

Artifacts may be documents, decisions, specifications, reviews, tasks, issues, components, patterns, tokens, releases, research outputs, or other produced assets. Artifact classification should describe the nature of the object, not the tool that stores it.

### Implementation

An implementation is the tool-specific representation of the classification model.

Implementations may use labels, tags, fields, components, projects, boards, filters, or views. They are not canonical. They must preserve the meaning of the layer, domain, and artifact classifications rather than redefine them.

## Architectural Layers

The canonical architectural layers are:

- Knowledge
- Intelligence
- Runtime
- Studio
- Integration

### Knowledge

Knowledge owns canonical meaning.

This layer includes foundations, principles, reference material, governance, specifications, capabilities, operational guidance, glossary entries, and architecture knowledge. The vault is the canonical source for this layer.

### Intelligence

Intelligence owns reasoning and execution logic.

This layer includes context assembly, planning, resolving, verification, synthesis, routing, adapters, contracts, and orchestration concepts. It applies vault knowledge without redefining it.

### Runtime

Runtime owns executable and consumable UI Foundations assets.

This layer includes tokens, components, patterns, themes, documentation outputs, build concerns, and accessibility implementation concerns. It implements knowledge and architecture decisions without becoming the source of canonical governance.

### Studio

Studio owns the human-facing workspace for the ecosystem.

This layer includes dashboards, workspaces, explorers, review surfaces, and visualizations that help humans and agents inspect, navigate, and apply ecosystem knowledge.

### Integration

Integration owns ecosystem boundaries and external connections.

This layer includes cross-repository coordination, external standards alignment, synchronization, handoffs, import and export mappings, and connections to third-party systems.

## Domains

Domains subdivide a layer into stable responsibility areas. The following examples are canonical domain families, not exhaustive implementation inventories.

### Knowledge Domains

- Foundation
- Reference
- Governance
- Capability
- Operational
- Glossary
- Architecture

### Runtime Domains

- Component
- Token
- Pattern
- Theme
- Documentation
- Build
- Accessibility

### Intelligence Domains

- Context
- Contracts
- Planner
- Resolver
- Verification
- Synthesis
- Routing
- Adapter
- Orchestration

### Studio Domains

- Dashboard
- Workspace
- Explorer
- Review
- Visualization

### Integration Domains

Integration domains are defined when an ecosystem boundary needs stable classification.

Examples include external standards, repository coordination, synchronization, migration, and tool mapping. Integration domains should describe the boundary being managed, not the tool used to manage it.

## Naming Rules

Canonical names should be semantic, stable, and tool-independent.

- Layer names use Pascal Case.
- Domain names use clear nouns that describe responsibility.
- Artifact names describe the thing being classified, not where it is stored.
- Names should avoid vendor, tool, repository, or file-format assumptions unless those assumptions are the subject being classified.
- Tool-specific namespaces, prefixes, separators, casing, and display names are implementation details.
- Implementation names may adapt canonical names to local tool constraints, but they must preserve the underlying meaning.

Examples of canonical layer names:

- Knowledge
- Runtime
- Intelligence
- Studio
- Integration

## Color Semantics

Color is a semantic aid for visual classification. It must not be the only source of meaning.

Hue identifies the architectural layer:

- Knowledge: green
- Runtime: blue
- Intelligence: purple
- Studio: orange
- Integration: gray

Brightness identifies importance inside the layer:

- Light: reference, metadata, and supporting information
- Medium: primary domains and core concepts
- Dark: infrastructure, architecture, governance, and execution core

This specification defines color meaning only. Exact color values, palettes, accessibility adjustments, and tool-specific color mappings belong in implementation-specific documents.

## Implementation Mapping

Tools may map the classification model differently.

Examples of possible implementations include:

- GitHub Labels
- Jira Components
- Linear Labels
- Azure DevOps Tags
- Project fields
- Board filters
- Documentation indexes
- Automation routing rules

These mappings are implementation details. A mapping is conforming when it preserves the canonical meaning of layer, domain, artifact, and implementation classifications.

## Governance

Classification concepts are canonical.

Implementations may evolve as tools, workflows, and repositories change. The canonical model remains owned by the vault.

Tool-specific implementations must conform to this specification rather than redefining classification concepts locally. When a tool mapping needs a new layer or domain, the classification model should be reviewed before the mapping is treated as canonical.

Changes to canonical layers affect the whole ecosystem and require governance review. Changes to domains should be reviewed by the owning layer or repository and checked for consistency with this specification.

## Validation

A classification model or implementation mapping is valid when:

- It preserves the hierarchy of layer, domain, artifact, and implementation.
- It does not make a tool-specific representation normative.
- It does not require a specific project management tool.
- It does not depend on hardcoded label syntax.
- It does not store exact color values in the canonical model.
- It uses repository-independent terminology where possible.
- It aligns with canonical terminology in `reference.terminology`.
- It respects vault governance and lifecycle rules.
- It does not cross repository boundaries by assigning ownership to the wrong layer.

## Review

### Human Maintainability

The model is intentionally small. Humans should be able to classify work by first identifying the architectural layer, then the domain, then the artifact. Tool-specific details should be handled in implementation mappings, not in this specification.

### AI Consumption

The hierarchy gives agents a predictable reasoning path for discovery, filtering, routing, and conflict detection. Agents should treat layer and domain as semantic context, not as labels that override governance, specifications, or repository boundaries.

### Governance Consistency

The model keeps canonical meaning in the vault and allows tool mappings to change independently. This protects governance from being defined by whichever planning tool is currently in use.

### Future Portability

The model can be implemented by labels, tags, fields, components, indexes, or future MCP servers because it defines classification semantics rather than storage mechanics.
