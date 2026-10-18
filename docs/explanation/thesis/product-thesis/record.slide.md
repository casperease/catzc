---
catzc:
  immutable:
    repo_status: clean
    path: docs/explanation/thesis/product-thesis/record.slide.md
    folder: docs/explanation/thesis/product-thesis
    name: record-slide
    filetype: md
    role: slide
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    cites:
      - ADR-THES-ONETRUTH#2
  config:
    pattern: pair
    deck: product-thesis
    order: 5
---

# The repository is the configuration record, and it answers

## Eyebrow

ADR-THES-ONETRUTH#2 and #3 · Mechanics

## Cards

- **No second database** Infrastructure is reproducible from a commit, so the code takes the place of the CMDB. Nothing about delivery state
  lives outside the repository.
- **Answers as data** Every Get cmdlet reads the repository and returns a typed answer, and emits it as JSON, so a service-management tool
  reads the truth without PowerShell.

## Body

One adjacent store is allowed, such as a GitOps repository, driven one way from the trunk's pipelines and never edited beside it: a
projection of the truth, never a second record.

## Notes

Rules two and three. The code replaces the CMDB, the tooling replaces the second database that would answer queries, and the one allowed
second store is a projection the pipelines write.
