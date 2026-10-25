---
plan:
  status: active
  value: high
  reviewed: 2026-10-25
  class: docs
  targets: [docs/drs/design/visual-design.md, python/catzc_diagrams/configs, docs/explanation/index.md]
---

# Model atlas: explanation articles on the physical and meta models, and C0–C4 zoom slides at chosen points of the tree

The link graph (`Get-LinkEdge`, `Test-LinkDirections`) now maps the relations between the physical files, and the meta queries (`Get-Track`,
`Get-TrackPlace`, `Get-Aspect`, `Get-ModuleDependency`, `Get-ModuleOrder`, `Get-ModuleProfile`, `Get-DrsDomainEdges`, `Get-DrsUsage`) answer
for modules, tracks, aspects and decision domains. No article says what those models are, where each one is declared, or how they fit
together, and no diagram zooms from the world outside the repository down to one file. This plan adds both: one explanation domain `model`,
and a C0–C4 zoom ladder drawn at a few chosen points of the tree.

## Why its value is high

A reader, human or agent, has no single entry to the models today and finds them by grepping configs. The atlas turns the queries that
already exist into a map anyone can read, and every slide is generated from those queries, so it stays true as the tree changes.

## Decided (this session, solo, from the domain rules)

- **Zoom is a new axis, not a lens.** A lens says _what_ a diagram shows; a zoom level says _how far out_ it stands. They cross, so a C2
  slide can be architecture or governance. One closed list `zooms:` sits beside `lenses:` in the renderer vocabulary, declared once
  (`PDR-CONFIG`, `ADR-AUTO-DEFAULT-ONERESOLUTIONORDER`), and `about.zoom` is optional with no default: a diagram without it is unchanged.
  (The C4 ladder is Simon Brown's model; C0 is added here.)
- **The levels, in catzc's terms:**
  - **C0 landscape:** the truth stores around the repository: fact sources, state machines and adjacent stores (`TDR-STORES`).
  - **C1 context:** the repository as one system, with its actors: the engineer, the devbox, the pipelines, ADO and Azure.
  - **C2 containers:** the tracks, crossed with the engines and languages: the world map, drawn as boxes.
  - **C3 components:** one container's modules or units, with their dependency edges (`Get-ModuleDependencyEdges`) and aspects.
  - **C4 code:** one module's files (functions, types, configs, tests, comment pages) and their link edges (`Get-LinkEdge`).
- **Points of the tree**, one ladder each and nothing more until the user asks (render nothing unasked): the repository root (C0–C2),
  `pwsh/` (C2–C3), `pwsh/.internal/` (C3–C4), `pwsh/Catzc.Base.Config` (C3–C4), `docs/drs/` (C2–C4, decision domains as the containers).
- **Slides follow the thesis deck form:** symbol-only slides, with the words in an article `.md` beside them (`docs/explanation/thesis/` as
  the model).
- **Every C3/C4 slide is generated from a query**, never hand-placed: the declaration stores the inputs (the point and the level), and the
  builder asks the query (minimap inputs only, the same rule).

## Open steps

1. [ ] `docs/drs/design/visual-design.md`: rule `DDR-VISUAL-ZOOMISANAXIS` (the C0–C4 list, orthogonal to the lens, the zoom badge, and the
       subtitle `<lens> · C<n>`); then `Build-DrsIndex`. Check: `Test-DrsRegistry` and `Test-Links` on the file.
2. [ ] `python/catzc_diagrams/configs/` (the vocabulary holding `lenses:`): add `zooms:` with the five levels; `declaration.py` accepts the
       optional `about.zoom` and rejects a value outside the list. Check: the kit's pytest for `declaration.py` (new cases: absent, valid,
       out of list).
3. [ ] Renderer: the zoom badge next to the lens badge, and the C3/C4 boxes filled from the query rows passed in by `Build-Diagrams`
       (`pwsh/Catzc.Base.Slides`). Check: the kit's pytest, plus one sample render in `out/diagrams/zoom-sample/` for the user to approve
       (the engine changes, so the render is read).
4. [ ] `docs/explanation/model/index.md` and these articles, one diagram each, narrated, citing their rules: - `the-physical-model.md`: the
       tree, the tracks and their places, file languages, aspects, and the four link relations. - `the-meta-model.md`: modules, dependencies
       and their order, engines, decision kinds and domains, the glossary. - `where-each-model-is-declared.md`: one table, model → config
       file → query command → gate that keeps it true. - `the-zoom-ladder.md`: C0–C4 and how they cross the lenses. Add `model` to
       `docs/explanation/index.md`. Check: `Test-Links`, `Test-Glossary` on the new files, `Format-Code`.
5. [ ] The five ladders of the points listed above as `.drawio.yml` declarations plus pngs under `docs/explanation/model/.assets/`, one
       article per ladder (`zoom-<point>.md`). Check: `Test-Diagrams`, `Test-Slides`, `Test-Links`.

## Open questions

- Should `docs/explanation/index.md` drop its five-lens table in favour of a link to `the-zoom-ladder.md` once step 4 lands, so a reader
  meets lens and zoom in one place? Recommendation: yes.

## Refs

DDR-VISUAL, DDR-TRACK-WORLDMAP, DDR-ASPECT, TDR-STORES, ADR-REPO-LINKS, ADR-AUTO-DEPM, PDR-CONFIG, PDR-ONELIVE.
