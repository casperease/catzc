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

3. [ ] The query rows' published shape: a JSON schema under `contracts/catzc/0.1.0/catzc.base.maps/` with its `applies_to` line in that
       root's `contract.yml`, matching the shape `python/catzc_diagrams/tests/test_query_rows.py` pins; then one sample render in
       `out/diagrams/zoom-sample/` (a C4 slide of `pwsh/Catzc.Base.Config`) for the user to approve, since the engine changed. Both wait on
       contracts-layout. Check: the contract tests of `catzc.base.maps`, and the sample read.
4. [ ] The four `docs/explanation/model/` articles each gain their one narrated diagram (a `yml drawio` block and its png). Waits on
       contracts-layout, as every render does. Check: `Test-Diagrams` and `Test-Links` on the articles.
6. [ ] Engine: a graph layout for a query slide's generated rows (`query_rows.py` and the drawing engine), so a C3 or C4 slide draws its
       edges, not only their count chips; then `DDR-VISUAL-ZOOMISANAXIS` says the slide draws them. Check: the five query slides
       (`zoom-pwsh-c3`, `zoom-config-c3`, `zoom-drs-c3`, `zoom-drs-c4`, `zoom-internal-c4`) render with their edges and no `E_KEEPOUT`.
5. [ ] The five ladders of the points listed above as `.drawio.yml` declarations plus pngs under `docs/explanation/model/.assets/`, one
       article per ladder (`zoom-<point>.md`). Check: `Test-Diagrams`, `Test-Slides`, `Test-Links`.

## Refs

DDR-VISUAL, DDR-TRACK-WORLDMAP, DDR-ASPECT, TDR-STORES, ADR-REPO-LINKS, ADR-AUTO-DEPM, PDR-CONFIG, PDR-ONELIVE.
