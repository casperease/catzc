---
catzc:
  immutable:
    repo_status: clean
    path: docs/explanation/thesis/product-thesis/boundary.slide.md
    folder: docs/explanation/thesis/product-thesis
    name: boundary-slide
    filetype: md
    role: slide
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    cites:
      - ADR-THES-ONETRUTH#4
  config:
    pattern: pair
    deck: product-thesis
    order: 6
---

# Inside the trunk only HEAD, versions only at the boundary

## Eyebrow

ADR-THES-ONETRUTH#4 and #5 · Mechanics

## Cards

- **Inside the trunk** Everything is at HEAD. Modules depend on each other at the current commit with no internal version numbers, so a
  shared change lands in one commit with all its consumers.
- **At the boundary** Synchronisation exists in one place and one form, a pin: tool versions, vendored modules and depended-on contracts
  come in pinned, and the bundle goes out as one immutable artifact.

## Body

There is no repository-wide version. A consumer pins a released bundle or keeps its own clone; consuming cats implicitly across a boundary
is neither.

## Notes

Rules four and five. Inside, no synchronisation at all. At the edge, a pin the consumer controls. Nothing versions the repository as a
whole.
