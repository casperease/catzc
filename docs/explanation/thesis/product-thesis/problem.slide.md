---
catzc:
  config:
    pattern: rule
    deck: product-thesis
    order: 2
    quotes: TDR-ONETRUTH-ONESTOREDECIDES
---

# Delivery is slow because the truth is scattered

## Eyebrow

TDR-ONETRUTH-ONESTOREDECIDES · The thesis

## Body

A **source of truth** is the one store whose content decides what is true about the delivered system. Delivery is slow because that truth is
spread across disjoint stores that drift apart: servers, databases, CMDBs, deployment engines, ticket systems, requirement databases.
The answer is one source of truth, the repository, with one simple, fast, and robust change process for everything in it, never
synchronisation between stores inside its responsibility domain.

## Notes

This is the first rule of the thesis, quoted as the registry holds it. Managing the scattered stores better keeps the problem, because every
synchronisation path is one more way to drift. The thesis removes the problem instead.
