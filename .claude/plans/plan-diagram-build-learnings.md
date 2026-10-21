---
plan:
  status: active
  value: medium
  reviewed: 2026-10-21
  class: meta
  targets:
    [
      pwsh/Catzc.Base.Maps/private/Get-MinimapSubject.ps1,
      pwsh/Catzc.Base.Slides/Build-Diagrams.ps1,
      pwsh/Catzc.Base.Slides/Test-Diagrams.ps1,
      python/catzc_diagrams/declaration.py,
    ]
---

# Diagram build learnings: what a "hung" Build-Diagrams taught, folded back into the build, the renderer and one drawing

A bare `Build-Diagrams` looked hung: the minimap stage alone took minutes before the first render. This plan carries what is left of that
lesson: the rest of the minimap cost, a sample that the gates can reach, the renderer's edge vocabulary, and one drawing of the pipeline.

## Why its value is medium

Every agent and every user who runs a full `Build-Diagrams` pays for the minimap stage, and every sample is put by hand outside the gates.
None of it blocks a feature.

## Recommendations (the agent's, each with its reason)

- Profile before changing the minimap subject: the world map is built once per call now, and what is left is paid on every minimap call, so
  the next lever is whatever that call still repeats. A per-run load or batch, never a session cache (a guard's verdict is never cached
  across runs).
- The drawing is one sample for approval, never a batch, and lands only with the article that embeds it.

## Decided (the user, 2026-10-21, decision round)

- **The pipeline drawing lives on an explanation page** on how a diagram is built, in that page's own `.assets/<slug>/`, so the reference
  page stays text; the user names the page when the sample is approved.
- **No `-Sample` path**: a build reading the gitignored `out/` would break ADR-REPO-SLIDES-ONEBUILDCOMMAND and keep state outside version
  control; the two manual calls (`Write-DiagramMinimapData` inside its module, then `put`) stay, and the help names them.

## Open steps

### Drawing

- [ ] The sample in `out/diagrams/dark-sample/build-diagrams-pipeline/` waits for the user's approval: the Build-Diagrams pipeline as five
      symbols (diagram folders, articles, minimap data, render or sync, report), marker 1 on the minimap stage as the cost, `about.adrs`
      `ADR-REPO-SLIDES-MINIMAPSFROMDATA`; words go in the article (check: the user's approval).
- [ ] On approval: the folder lands in the `.assets` of the explanation page that embeds it (the user names the page), put with
      `Build-Diagrams -Path` (check: `Test-Diagrams` on the folder, `Test-Links` on the article).
- [ ] `Build-Diagrams` and `Test-Diagrams`: `-Path` accepts `out/diagrams/dark-sample/`, so a sample is gated and needs no hand put; today
      `Test-Diagrams -Path` refuses a folder outside `docs/**/.assets/` (check:
      `Test-Diagrams -Path out/diagrams/dark-sample/build-diagrams-pipeline`).
- [ ] `python/catzc_diagrams/declaration.py`, with `assets/glyphs.xml` and `assets/STYLE.md` following: `read` and `junction` edge kinds,
      and the thick edge's legend phrase set per diagram rather than fixed to "to a named set", with cases in `tests/test_declaration.py`
      (check: `Invoke-PythonTest Catzc.Base.Slides -Folder python/catzc_diagrams/tests`, then one sample re-rendered).

## Refs
