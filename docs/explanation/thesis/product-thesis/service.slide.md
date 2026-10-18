---
catzc:
  immutable:
    repo_status: clean
    path: docs/explanation/thesis/product-thesis/service.slide.md
    folder: docs/explanation/thesis/product-thesis
    name: service-slide
    filetype: md
    role: slide
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    cites:
      - ADR-THES-ONETRUTH-PROCESSESFOLLOWDELIVERY
  config:
    pattern: table
    deck: product-thesis
    order: 7
---

# Service management follows delivery, never the reverse

## Eyebrow

ADR-THES-ONETRUTH-PROCESSESFOLLOWDELIVERY · Mechanics

## Rows

| Process       | Where it lives in cats                      |
| ------------- | ------------------------------------------- |
| Change record | The commit and its review                   |
| Approval      | A step in the one change process            |
| Audit         | The history, read through the query surface |

## Body

A process that keeps its own model of delivery recreates the disjoint store the thesis removes.

## Notes

Rule six. Change management, approvals and audit read the repository and act through its one change process.
