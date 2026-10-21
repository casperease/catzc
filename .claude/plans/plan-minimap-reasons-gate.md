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

- [ ] After plan-xdr-codes' rewrite (it changes the codes in diagram subtitles, so one render serves both), re-render the stale minimaps
      (the user, 2026-10-21): `Build-Diagrams -Stale`, then `Test-Diagrams` over the tree, and a few re-rendered pngs Read against their yml
      (check: `Test-Diagrams` reports 0 issues and 0 stale minimaps).
- [ ] `pwsh/Catzc.Base.Slides/private/Write-DiagramMinimapData.ps1`, last: drop a drawn cell the yml does not list, and report it (check:
      `Invoke-TestFile` on its test file with a widget fixture whose yml omits one cell, and `Build-Diagrams -Path` on one folder draws
      every cell).

## Open questions

- Should a script that compares `git show` output in Python name `encoding="utf-8"` by default, through one line in the `git-readonly`
  capability? A Windows default code page turned 25 clean ymls into false losses during the minimap move. Recommendation: yes, a merged
  clause, no new line (catzc-61, 2026-10-21).

- Should `Test-Diagrams -Path` accept a legend-role folder (`docs/explanation/.assets/glyphs`), checking that its png carries the painted
  `glyphs.xml` model, so the glyph library is gated like every other diagram rather than by a hand comparison? Recommendation: yes, one
  branch beside the role checks in `drawio_forward.py` (catzc-61, 2026-10-21).
