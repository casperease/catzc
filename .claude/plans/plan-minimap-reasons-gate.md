---
plan:
  status: active
  value: medium
  reviewed: 2026-10-21
  class: feature
  targets: [python/catzc_diagrams/declaration.py, pwsh/Catzc.Base.Slides/private/Write-DiagramMinimapData.ps1]
---

# Minimap reasons gate

`Write-DiagramMinimapData` draws every lit minimap cell the minimap data yields. A lit cell nobody declared is unverifiable, so the gate
drops a drawn cell the diagram's declaration does not list, and reports it.

## Why its value is medium

Every placement on a minimap becomes as checkable as the diagram's claim. Nothing breaks today, but no diagram declares its minimap cells
yet, so every one goes dark when the gate turns on; that is why the declared cells come first.

## Decided (the user, 2026-10-21)

- **The reason is the correctly placed data, in the diagram's one source, no prose:** `content.minimaps` in `diagram.drawio.yml` becomes an
  ordered map from each of the three shown minimap ids to its lit cells, each
  `{ cell: <at values joined by />, by: [<files>, <rule codes>] }`, a minimap that lights nothing mapping to `[]`. It replaces the list of
  three ids (164 of 176 ymls declare it today).
- Writing the cells is a tool's job: one folder per call, from the folder's computed data in `out/minimaps/<folder>/`, each result read once
  against the drawing.
- The prose reasons in `diagram.drawio.verify.md` retire with the files that held only them; ADR-REPO-SLIDES-MINIMAPSFROMDATA, the
  conventional-folders sentence and the how-to line say the cells live in the diagram's declaration.

## Open steps

- [ ] The gate is on and drops 95 computed lit cells in 54 folders whose `diagram.drawio.yml` predates them (the 54 `Test-Diagrams` names
      stale, mostly `docs/explanation/flow/.assets/` and `docs/references/pwsh/.assets/`): re-declare each folder with
      `declaration.py minimaps <folder>`, one folder per call, read the new cells against the drawing, then `Build-Diagrams -Stale` (check:
      `Test-Diagrams` over the tree reports 0 issues, 0 stale and no Write-DiagramMinimapData warning). The same pass drops declared cells
      the data no longer lights, such as `ado-pipelines/pipeline-yaml` in `build-diagrams-runs-five-stages`.
