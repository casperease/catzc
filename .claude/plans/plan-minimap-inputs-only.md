---
plan:
  status: active
  value: highest
  reviewed: 2026-10-23
  class: feature
  targets: [pwsh/Catzc.Base.Slides, pwsh/Catzc.Base.Maps, docs/drs/repository/slides-as-markdown.md]
---

# Minimap inputs only: a diagram's declaration holds what its minimaps are computed from, never the computed cells

Every diagram declaration (9 `*.drawio.yml` files and 168 Markdown files with a `yml drawio` block) carries, under
`content.minimaps.code-locations`, every lit cell with the files and rule codes that lit it (`{ cell, by: [...] }`), written back by
`declaration.py minimaps` from what `Get-CodeLocationsMinimapData` computes. The only input is the declaration's own `about.adrs`: the cells
and `by` lists are the files that cite those codes, projected onto track, module and folder. So the declaration stores derived data that
goes stale whenever a citing file moves or is added, churns on edits nobody made to the diagram, and runs to dozens of lines per diagram.

## Why its value

A declaration that stores only its input is short, never stale, and changes only when its author changes it (PDR-ONELIVE: one source, the
citations in the tree; the copy in the declaration is a second one). It removes the bulk of every diagram block in the docs.

## Decided (the user, 2026-10-23)

- A declaration saves only the input of its minimaps' file-dependency and location data, never the data itself, starting with
  `minimaps: code-locations:`. This reverses the 2026-10-21 decision that the placed cells with their `by` lists live in the declaration.
- The input today is `about.adrs`; the cells and their reasons are computed at build time from the tree, as `Get-CodeLocationsMinimapData`
  already does.

## Open steps

- [ ] `docs/drs/repository/slides-as-markdown.md`, ADR-REPO-SLIDES-MINIMAPSFROMDATA: the declaration names which minimaps it shows and their
      inputs only; the lit cells and their reasons are computed at build from `about.adrs` and the citing files, kept in `out/minimaps/`,
      never written back; the "undeclared lit cell is dropped" gate goes with the listing. (check: `Test-Links` and `Test-DrsRegistry` at 0
      on the page)
- [ ] `pwsh/Catzc.Base.Slides/private/Write-DiagramMinimapData.ps1` and the kit's `declaration.py minimaps`: the write-back of `cell`/`by`
      rows is removed, and the drawn minimap uses the computed cells directly; `Test-Diagrams`' stale-minimap finding compares the inputs,
      not stored cells. (check: `Invoke-TestFile` on `Write-DiagramMinimapData.Tests.ps1` and `Test-Diagrams.Tests.ps1` green, with a case
      where a new citing file changes the drawn minimap and leaves the declaration unchanged)
- [ ] The 177 carriers lose their stored `code-locations` rows, through the declaration tool (put/get round-trip), one folder per run, never
      a text sweep; each carrier's png re-rendered and compared with its previous render. (check: `Test-Diagrams` at 0, and a grep for `by:`
      under `code-locations` finds none)

## Open questions

- The other minimaps with the same `{ cell, by }` shape (`module-neighbourhood`, `axis` and the rest of the eight): the same rule for all of
  them? Recommendation: yes, one mechanism per kind; the user named `code-locations` first.
- What replaces the review the stored cells gave (a lit cell nobody listed was dropped)? Recommendation: nothing stored by default; an
  optional per-minimap `exclude:` input in the declaration for a cell the author rejects, so the declaration still holds only inputs.
- Does the rendered png stay committed, given it now changes whenever a citing file moves? Recommendation: yes, re-rendered by
  `Build-Diagrams -Stale`, with `Test-Diagrams` naming the stale ones, as today.
