---
id: specification.github.classification-mapping
title: GitHub Classification Mapping
type: specification
status: review
owners:
  - ui-foundations
created: 2026-07-08
updated: 2026-07-08
authority: supporting
summary: Maps the canonical classification model to GitHub Projects and GitHub Labels.
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
  implements:
    - specification.classification-model
  references:
    - docs.architecture
---

# GitHub Classification Mapping

## Purpose

This document defines how the canonical UI Foundations classification model is represented in GitHub Projects and GitHub Labels.

GitHub is one implementation of the classification model. This document must not redefine canonical classification concepts. The canonical model remains `specification.classification-model`.

## Mapping Overview

| Canonical Concept | GitHub Mapping | Notes |
| --- | --- | --- |
| Layer | GitHub Project field | Classifies the architectural layer of the work. |
| Domain | GitHub label namespace `domain:*` | Classifies the stable responsibility area inside a layer. |
| Artifact | Issue title and body structure | Describes the concrete thing being proposed, changed, reviewed, or delivered. |
| Implementation | Repository-specific labels, project fields, and views | Represents local GitHub configuration without changing canonical meaning. |

## Project Fields

Recommended GitHub Project fields:

| Field | Purpose | Recommended Values |
| --- | --- | --- |
| Layer | Architectural layer classification. | Knowledge, Intelligence, Runtime, Studio, Integration |
| Epic | Larger outcome or initiative grouping. | Free text or single-select values managed by the project. |
| Priority | Relative importance of the work. | Low, Medium, High, Critical |
| Milestone | Release, phase, or delivery target. | Repository or project milestone values. |
| Repository | Owning repository. | `ui-foundations-vault`, `ui-foundations`, `ui-foundations-intelligence`, `ui-foundations-studio` |

## Color Mapping

GitHub label colors implement the canonical color semantics.

| Layer | Hue | Light | Medium | Dark |
| --- | --- | --- | --- | --- |
| Knowledge | Green | `#DFF6DD` | `#2EA043` | `#0E4429` |
| Runtime | Blue | `#DDEBFF` | `#0969DA` | `#033D8B` |
| Intelligence | Purple | `#EDE7F6` | `#8250DF` | `#512A97` |
| Studio | Orange | `#FFF1D6` | `#FB8C00` | `#A64D00` |
| Integration | Gray | `#F0F0F0` | `#8C959F` | `#57606A` |

Shade categories follow the canonical model:

- Light: reference, metadata, and supporting information.
- Medium: primary domains and core concepts.
- Dark: infrastructure, architecture, governance, and execution core.

## Repository Domain Labels

Domain labels use the `domain:*` namespace in GitHub.

Each label maps to exactly one architectural layer and one shade category.

### `ui-foundations-vault`

| Label | Description | Layer | Shade | Color |
| --- | --- | --- | --- | --- |
| `domain:foundation` | Immutable design knowledge and principles. | Knowledge | Medium | `#2EA043` |
| `domain:reference` | Canonical lookup knowledge and terminology. | Knowledge | Light | `#DFF6DD` |
| `domain:governance` | Rules for trust, lifecycle, and precedence. | Knowledge | Dark | `#0E4429` |
| `domain:capability` | Tool-independent capability definitions. | Knowledge | Medium | `#2EA043` |
| `domain:operational` | Repeatable playbooks for applying knowledge. | Knowledge | Medium | `#2EA043` |
| `domain:glossary` | Ecosystem vocabulary entry points. | Knowledge | Light | `#DFF6DD` |
| `domain:architecture` | Knowledge structure and ecosystem boundaries. | Knowledge | Dark | `#0E4429` |

### `ui-foundations`

| Label | Description | Layer | Shade | Color |
| --- | --- | --- | --- | --- |
| `domain:component` | Reusable UI component concepts and assets. | Runtime | Medium | `#0969DA` |
| `domain:token` | Token concepts, lifecycle, and governance. | Runtime | Medium | `#0969DA` |
| `domain:pattern` | Reusable interface pattern concepts and assets. | Runtime | Medium | `#0969DA` |
| `domain:theme` | Brand and contextual theme concerns. | Runtime | Medium | `#0969DA` |
| `domain:documentation` | Runtime-facing documentation and examples. | Runtime | Light | `#DDEBFF` |
| `domain:build` | Build, packaging, and delivery concerns. | Runtime | Dark | `#033D8B` |
| `domain:accessibility` | Runtime accessibility behavior and quality. | Runtime | Dark | `#033D8B` |

### `ui-foundations-intelligence`

| Label | Description | Layer | Shade | Color |
| --- | --- | --- | --- | --- |
| `domain:context` | Context assembly and retrieval concerns. | Intelligence | Light | `#EDE7F6` |
| `domain:contracts` | Interfaces between reasoning units. | Intelligence | Dark | `#512A97` |
| `domain:planner` | Planning and task decomposition logic. | Intelligence | Dark | `#512A97` |
| `domain:resolver` | Conflict resolution and decision support. | Intelligence | Dark | `#512A97` |
| `domain:verification` | Evidence checks and claim validation. | Intelligence | Dark | `#512A97` |
| `domain:synthesis` | Combining findings into coherent output. | Intelligence | Medium | `#8250DF` |
| `domain:routing` | Selecting paths, handlers, or capabilities. | Intelligence | Dark | `#512A97` |
| `domain:adapter` | Boundary adapters for external systems. | Intelligence | Dark | `#512A97` |
| `domain:orchestration` | Coordinating multi-step or multi-agent work. | Intelligence | Dark | `#512A97` |

### `ui-foundations-studio`

| Label | Description | Layer | Shade | Color |
| --- | --- | --- | --- | --- |
| `domain:dashboard` | Overview surfaces for ecosystem status. | Studio | Medium | `#FB8C00` |
| `domain:workspace` | Interactive workspaces for users and agents. | Studio | Medium | `#FB8C00` |
| `domain:explorer` | Browsing and discovery experiences. | Studio | Medium | `#FB8C00` |
| `domain:review` | Review surfaces and evaluation flows. | Studio | Dark | `#A64D00` |
| `domain:visualization` | Visual representations of ecosystem knowledge. | Studio | Medium | `#FB8C00` |

## Views

Recommended GitHub Project views:

| View | Purpose | Useful Grouping |
| --- | --- | --- |
| Process | Track workflow state and active delivery. | Status, Priority, Milestone |
| Architecture | Inspect work by ecosystem structure. | Layer, Domain, Repository |
| Repository | Separate work by owning repository. | Repository, Domain |
| Roadmap | Track delivery over time. | Milestone, Epic, Priority |
| Capability | Inspect capability-oriented work. | Layer, Domain, Epic |

Views are navigational. They must not redefine canonical classification concepts.

## Governance

GitHub is only one implementation of the classification model.

GitHub labels must conform to the vault classification model. Domain labels should use the `domain:*` namespace so they remain easy to filter and distinguish from workflow or status labels.

Generic workflow and status labels should use neutral colors. They should not reuse layer colors unless they also represent a layer-bound semantic classification.

New semantic labels must map to a canonical layer and domain. If no existing layer or domain fits, update the canonical classification model through vault governance before treating the new label as authoritative.

## Validation

A GitHub classification mapping is valid when:

- Every domain label maps to exactly one layer.
- Every domain label maps to exactly one shade category.
- Every label description is under 100 characters.
- No random colors remain in semantic domain labels.
- Generic workflow and status labels use neutral colors.
- No canonical classification rules are redefined by GitHub configuration.
- Repository-specific labels preserve repository boundaries.
- GitHub-specific syntax remains implementation-specific.
