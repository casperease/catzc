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

- [ ] `python/catzc_diagrams/declaration.py`: `content.minimaps` as the ordered map (three ids of the eight, each a list of `{cell, by}`),
      validated in `normalise`, written by `dump`, kept from the source by `save` (the drawing shows the cells but not their `by`), the
      sidebar drawn from its keys; `declaration.py minimaps <folder>` writes the folder's computed cells into its yml;
      `Write-DiagramMinimapData` reads the map's keys as the ids; the list form `normalise` still reads during the move is deleted once
      every yml holds the map (check: `Invoke-PythonTest Catzc.Base.Slides -Folder python/catzc_diagrams/tests` with normalise, round-trip
      and place cases, and `Invoke-TestFile` on `Write-DiagramMinimapData`'s callers' tests).
- [ ] `declaration.py minimaps` run on every diagram folder under `docs/`, one folder per call, each yml read once against its drawing; the
      reason-only `diagram.drawio.verify.md` files are deleted, and `Get-DiagramMinimapReason` is deleted with its test and page (check:
      `Test-Diagrams` reports no issue, and no reason-only verify record is left).
- [ ] ADR-REPO-SLIDES-MINIMAPSFROMDATA, the conventional-folders sentence ("in its computed data and in the diagram's declaration") and the
      how-to line in `add-a-doc-chapter.md` name `content.minimaps` (check: `Test-Links` on the pages).
- [ ] `pwsh/Catzc.Base.Slides/private/Write-DiagramMinimapData.ps1`, last: drop a drawn cell the yml does not list, and report it (check:
      `Invoke-TestFile` on its test file with a widget fixture whose yml omits one cell, and `Build-Diagrams -Path` on one folder draws
      every cell).

## Open questions

- Should `Test-Diagrams -Path` accept a legend-role folder (`docs/explanation/.assets/glyphs`), checking that its png carries the painted
  `glyphs.xml` model, so the glyph library is gated like every other diagram rather than by a hand comparison? Recommendation: yes, one
  branch beside the role checks in `drawio_forward.py` (catzc-61, 2026-10-21).
