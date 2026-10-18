---
catzc:
  immutable:
    repo_status: clean
    path: docs/explanation/thesis/product-thesis/problem.slide.md
    folder: docs/explanation/thesis/product-thesis
    name: problem-slide
    filetype: md
    role: slide
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    cites:
      - ADR-THES-ONETRUTH#1
  config:
    pattern: rule
    deck: product-thesis
    order: 2
    quotes: ADR-THES-ONETRUTH#1
---

# Delivery is slow because the truth is scattered

## Eyebrow

ADR-THES-ONETRUTH#1 · The thesis

## Body

A **source of truth** is the one store whose content decides what is true about the delivered system. Delivery is slow because that truth is
spread across disjoint stores that drift apart — servers, databases, CMDBs, deployment engines, ticket systems, requirement databases.
Catzc's answer is one source of truth, the repository, with one simple, fast, and robust change process for everything in it, never
synchronisation between stores.

## Notes

This is the first rule of the thesis, quoted as the registry holds it. Managing the scattered stores better keeps the problem, because every
synchronisation path is one more way to drift. The thesis removes the problem instead.
