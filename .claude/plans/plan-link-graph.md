---
plan:
  status: active
  value: medium
  reviewed: 2026-10-25
  class: meta
  targets:
    [
      pwsh/Catzc.Base.QualityGates/types/LinkRelation.cs,
      pwsh/Catzc.Base.QualityGates/types/LinkEngine.cs,
      pwsh/Catzc.Base.QualityGates/configs/link-directions.yml,
    ]
---

# Link graph: the relations the conventions imply, on the same facets and rows

`Test-LinkDirections` judges the links files write. The conventions imply more relations no file writes: a test to its subject by its stem
under `tests/`, a file to its comment page by the `pages` map, a module to its declared dependencies. This plan records them as a fourth
relation on the same `LinkEdge`, endpoints and rows, adds completeness rows, and a reader for the blast radius of a file.

## Why its value is medium

It breaks nothing, and it turns "what does this file touch" into one query over the relations the tree already declares, instead of a grep
per convention.

## Decided (the user, 2026-10-24, the link-directions decision round)

- Derived relations are in scope as their own plan, on the facets and rows of ADR-REPO-LINKS.
- A test to its subject, a file to its comment page and a module to its declared dependencies are the first convention relations.

## Open steps

1. [ ] `pwsh/Catzc.Base.QualityGates/configs/link-directions.yml`: the convention rows, and completeness rows (every function with a comment
       page has its docs edge, every unit of a laid-out track has a `tests` aspect). Check: `Test-ShippedConfigs`.
2. [ ] `pwsh/Catzc.Base.QualityGates/Get-LinkEdge.ps1` (new): `-To <path>` returns every relation into a file, written or derived, its blast
       radius. Check: `Invoke-TestFile pwsh/Catzc.Base.QualityGates/tests/Get-LinkEdge.Tests.ps1` (new).
3. [ ] `pwsh/Catzc.Base.QualityGates/Test-LinkDirections.ps1`: judges the convention edges too. Check:
       `Invoke-TestFile pwsh/Catzc.Base.QualityGates/tests/Test-LinkDirections.Repository.Tests.ps1` green.

## Refs

ADR-REPO-LINKS, ADR-REPO-COMMENTS-COMMENTPAGEPLACE, ADR-AUTO-DEPM, DDR-ASPECT.
