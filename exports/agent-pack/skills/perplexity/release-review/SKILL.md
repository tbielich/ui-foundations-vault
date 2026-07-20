---
name: release-review
description: Load when reviewing release readiness, metadata, traceability, lifecycle state, or unresolved verification risks.
metadata:
  canonical_title: Release Review
  source_id: workflow.operational.release-review
  source_path: operational/release-review.md
---

# Release Review

## Question

How should a release be reviewed?

## Purpose

Use this playbook to review whether a vault release is coherent, traceable, and ready to publish.

## Inputs

- Candidate release scope
- Changed documents
- Known lifecycle states
- Verification notes
- Remaining open questions

## Preconditions

- The release scope is known.
- Changed documents have metadata.
- Reviewers can identify whether changes are normative or informative.

## Steps

1. Identify the knowledge domains changed by the release.
2. Check lifecycle state for each changed document.
3. Check whether new or changed relationships resolve.
4. Check precedence risks and unresolved conflicts.
5. Confirm verification evidence or visible assumptions.
6. Identify whether follow-up documents are required.
7. Record release recommendation.

## Outputs

- Release readiness recommendation
- Changed-domain summary
- Lifecycle findings
- Relationship or metadata issues
- Follow-up list

## Quality Gates

- Changed documents have valid metadata.
- Relationships resolve.
- Deprecated or archived knowledge is not treated as current guidance.
- Assumptions and unresolved issues are visible.

## Related Documents

- `governance.lifecycle`
- `governance.precedence`
- `governance.verification-review`
- `specification.vault-metadata`
