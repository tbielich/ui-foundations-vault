---
id: export-pack.agent.perplexity-skills
title: Perplexity Skills Export
type: index
status: draft
owners:
  - ui-foundations
created: 2026-07-20
updated: 2026-07-20
authority: derived
summary: Disposable Perplexity Skill exports that wrap selected canonical Vault documents in the derived SKILL.md format.
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
  references:
    - export-pack.agent
    - docs.cross-repo-knowledge-sync
verification:
  status: assumption
assumptions:
  - Perplexity currently documents an unversioned directory-based SKILL.md format with required name and description frontmatter plus a markdown instruction body.
---

# Perplexity Skills Export

## Purpose

This directory contains derived Perplexity Skill exports for selected canonical Vault documents.

The canonical Vault documents remain the source of truth. These files exist only to package existing Vault knowledge in the Perplexity Skill directory format.

## Relationship to the canonical Vault

- Canonical meaning stays in the source documents under `governance/`, `operational/`, `capabilities/`, and `docs/`.
- The exported Skills are derived wrappers.
- Perplexity-specific metadata lives only in this export layer.
- This layer is disposable and regenerable.

## Export structure

Each exported Skill lives in its own directory named after the Perplexity Skill name and contains a root `SKILL.md` file.

The exported frontmatter uses only documented Perplexity Skill fields:

- `name`
- `description`
- `metadata`

The markdown body after frontmatter is the canonical source document body and serves as the Skill instructions.

## Generation process

1. Read the canonical source document.
2. Preserve the canonical markdown body exactly, excluding canonical Vault frontmatter.
3. Wrap the body in a derived `SKILL.md` file.
4. Add Perplexity Skill frontmatter with:
   - a lower-case hyphenated `name` required by Perplexity
   - a concise routing `description`
   - `metadata` linking back to the canonical source title, id, and path
5. Validate that the resulting file can be mapped to the documented Perplexity Skill schema.

## Update process

When a canonical source document changes:

1. Regenerate the corresponding exported Skill from the canonical source.
2. Keep the derived `description` concise and routing-oriented.
3. Re-run Skill-format validation.
4. Do not edit canonical documents to accommodate Perplexity.

## Supported Perplexity format version

This export targets the current unversioned Perplexity Skill directory format documented at:

- `https://docs.perplexity.ai/docs/agent-api/skills`
- `https://research.perplexity.ai/articles/designing-refining-and-maintaining-agent-skills-at-perplexity`

At validation time, the documented requirements were:

- one directory per Skill
- a root `SKILL.md` file
- required frontmatter `name` and `description`
- `name` must match the directory name
- `name` must use lower-case letters, digits, and hyphens
- markdown body content provides the Skill instructions
- optional supported frontmatter includes `depends` and `metadata`

## Included Skills

- `knowledge-precedence/`
- `verification-review/`
- `architecture-review/`
- `accessibility-review/`
- `release-review/`
- `specification-session/`
- `architecture-analysis/`
- `verification/`
- `synthesis/`
- `reflection-loop/`
