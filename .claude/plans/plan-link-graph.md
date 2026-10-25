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

1. [ ] `pwsh/Catzc.Base.QualityGates/types/LinkVerdict.cs`, `LinkDirectionRow.cs` and `LinkDirectionEngine.cs`: a third verdict `require` (a
       row whose `from` selects the files that must have an edge of the row's relation to `to`), since allow and deny judge only edges that
       exist; the engine reports each selected file with no such edge. Check: `LinkDirectionRow.Tests.ps1` and
       `LinkDirectionEngine.Tests.ps1` alone (new cases: a required edge present, missing, and a file the selector does not pick).
2. [ ] `pwsh/Catzc.Base.QualityGates/configs/link-directions.yml`: the completeness rows as `require` rows (every function with a comment
       page has its docs edge; every unit of a laid-out track has a `tests` aspect), and the validator accepts `require`. Check:
       `Test-ShippedConfigs`, and `Test-LinkDirections.Repository.Tests.ps1` green or its findings triaged as before (more than 25: stop and
       ask).

## Refs

ADR-REPO-LINKS, ADR-REPO-COMMENTS-COMMENTPAGEPLACE, ADR-AUTO-DEPM, DDR-ASPECT.
