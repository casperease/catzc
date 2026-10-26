---
plan:
  status: active
  value: medium
  reviewed: 2026-10-26
  class: feature
  targets:
    [
      docs/drs/design/visual-design.md,
      python/diagrams/configs/drawio.yml,
      python/diagrams/declaration_constants.py,
      python/diagrams/declaration_normalise.py,
      python/diagrams/query_rows.py,
      python/diagrams/embed_images.py,
      python/diagrams/assets,
      pwsh/Base.Slides/private/Write-DiagramQueryRows.ps1,
      pwsh/Azure.DevOps,
      js/file-icons/assets,
    ]
---

# Flow lens

## Why its value

The repository's CI/CD is spread across `.ado/pipelines/` (with `extends/`, `stages/`, `jobs/` and `steps/` folders) and
`.github/workflows/`, and no diagram shows how a commit actually flows through them. A third lens beside `source` and `action` draws that
flow from what the tree already declares: the pipeline files, the rungs registry and the pipeline-type naming. Its small glyph set grows out
of the same symbols as the VS Code file icons, so the editor tree and the diagrams look like one family.

## Decided (2026-10-26, the user took every recommendation)

- **The lens is `flow`.** It is a value of `lenses:` in `python/diagrams/configs/drawio.yml`, a switch inside the one declaration format and
  the one renderer, never a second module (DDR-VISUAL-ACTIONISALENS, PDR-ONELIVE-ONEVERSION). The badge prints FLOW. The name lives in the
  lens vocabulary, apart from the existing `content.flow` direction key (`left-to-right` | `top-to-bottom`), and the new rule says so in one
  line.
- **One core alphabet, words of three.** Every flow glyph is a word of exactly three symbols from `O 0 - _ = .`, in three equal slots of its
  box: `O` an empty circle and `0` the same circle with a dot (the dot the only difference), `-` a middle line, `_` a bottom line (adjacent
  lines at different heights join with a riser), `=` a thin double line at stroke 1 against 1.6 for the rest, `.` a dot.
- **The engine words:** pipeline/workflow `O=0`, stage `=0=`, job `=O_`, step `O_-`, extends `0=0` (a template feeding a pipeline),
  variables `O..` (an empty circle with dots).
- **The flow SVGs live in `python/diagrams/assets/flow/`, rendered from words.** Each glyph is one entry of a closed `flow-glyphs:` list in
  `drawio.yml`: id, word, meaning and `hint:`, the path of the `js/file-icons/assets/*.svg` it is styled after. The hint is for the reader
  only: nothing reads the JS file and the JS icons are not generated from it, so the editor's 16 px icons and the diagram glyphs stay two
  sets, not one behaviour in two places (PDR-ONELIVE). One generator writes every SVG through Write-FileIfChanged, with the warning head.
  Strokes are the theme token `@ink`, never a hex; `put` writes the theme's hex when it embeds the SVG as `image=data:image/svg+xml`, so
  dark and light both render.
- **Environment = rhombus**, its name under it and the occupant commit inside it in that commit's state colour, so
  DDR-VISUAL-ENVIRONMENTISCONTAINER holds and only the shape differs, in this lens only. The rhombus is a glyph of `glyphs.xml`
  (`g-env-flow`, a `rhombus` style beside `g-env`), not a word: it is a container, not a symbol.
- **Spanners**, span bars on the existing `spans` layer, each capped with its taxonomy glyph, one row of words over the lanes (CI → CD →
  Approve → Deploy):
  - the pipeline types, from the one list of FDR-CD-TYPE-SIXTYPES (CRON, CI, CD, CDe, DEPLOY, INPUT), never redeclared; a lane's type is
    read from its file name's prefix (the naming rule in `docs/drs/ado/pipeline-naming-and-placement.md`), never declared;
  - **Approve**, over a rung whose gate is not `none` (rc, rbc, prod-approval in `RungsConfig`), read from `Get-Rung`;
  - **Review**, over a lane that a pull request triggers (`pr:` in ADO, `pull_request:` in GitHub).
- **Full flow:** a frame spanning one end-to-end route, trigger to production, drawn as a lane with its start `O` and end `0` caps.
- **Chips:** a trigger chip (push, pull request, schedule, manual) and an engine chip (`ado` or `github`) on each lane, by the action lens's
  where-chip mechanism.
- **Time runs left to right** (DDR-VISUAL-LEFTTORIGHTISTIME), one lane per pipeline or workflow; edges carry their operator word, arrows
  point at what they depend on.
- **Inputs only; the rows come from PowerShell.** A flow declaration stores its inputs alone: the pipeline and workflow files in
  `about.point`. `Build-Diagrams` already asks a query and hands rows to the renderer by address (`Write-DiagramQueryRows`,
  `query_rows.py`); the flow lens rides the same handoff. The pipeline knowledge already lives in `Azure.DevOps` (`Get-AdoYamlInventory`,
  `Resolve-AdoYamlClassification`, `Get-PipelineTemplateReference`), so the rows are built there and Python never parses pipeline YAML (one
  living reader, PDR-ONELIVE).
- **Environments come from the rungs, not from the YAML.** The deploy stages name their environments through template expressions
  (`${{ parameters.Unit }}-${{ f.env }}` in `.ado/pipelines/stages/deploy-unit.yaml`), which a static read cannot resolve, so a lane's
  rhombi are the rungs of `Get-Rung` that its unit deploys to, named `<unit>-<rung>` as `environment-approvals.yml` names them.
- **Cross-pipeline edges are derived from the naming.** A DEPLOY pipeline has `trigger: none` and takes the certifying CD run's id
  (`CiRunId`, FDR-CD-TYPE-DEPLOYISPINNED), so no trigger joins them: `cd-<unit>` → `deploy-<unit>` is drawn from the shared unit name, the
  operator word `pins`.
- **The engines are pluggable.** One reader per engine maps its files to the same rows (lane, type, stage, job, step, environment, trigger,
  edge): ADO in `Azure.DevOps`, GitHub beside it. A later engine adds a reader and an entry, never a branch in the renderer.

## Open questions

- Should `python/diagrams/README.md` say in one line that glyphs are draw.io styles in `glyphs.xml` and `embed_images.py` embeds PNG only,
  and that a headless Edge `--screenshot` renders a standalone SVG? Recommended: yes, it saves the next session the search.

## Open steps

- [ ] `docs/drs/design/visual-design.md`: add four DDR-VISUAL rules, their codes chosen when written: flow is a lens (the lens, its
      inputs-only declaration, the rows from the pipeline query); flow glyphs are words (the alphabet, the words, the hint); the rhombus in
      the flow lens (the shape exception to DDR-VISUAL-ENVIRONMENTISCONTAINER); and the taxonomy spanners (types cited from
      FDR-CD-TYPE-SIXTYPES, Approve from the rung gates, Review from the pull-request trigger), each with its context section. (check:
      `Test-Links` on the file; `Test-Glossary` reports no collision)
- [ ] `pwsh/Base.QualityGates/configs/terminology/` and the owning `configs/glossary.yml`: add the coined term `spanner` and the flow lens
      before any article uses them, through glossary-keeper. (check: `Test-Glossary` reports no issue)
- [ ] `python/diagrams/configs/drawio.yml`: add `flow` to `lenses:`, a `flow-lens:` block (lane height, slot size, stroke widths 1.6 and 1,
      the glyph kinds) and the closed `flow-glyphs:` list of id, word, meaning and `hint:`. (check: `Invoke-PythonTest` on the kit passes)
- [ ] `python/diagrams/flow_glyphs.py`: the word renderer: three slots, `O`/`0` the same circle with or without the dot, `@ink` strokes, an
      unknown symbol or a word not three symbols long refused by name; writes `python/diagrams/assets/flow/<id>.svg`. (check:
      `Invoke-PythonTest` on a new `tests/test_flow_glyphs.py` that renders every entry and compares it with the committed SVG)
- [ ] `python/diagrams/assets/glyphs.xml`: add `g-env-flow`, the rhombus container beside `g-env`. (check: `Invoke-PythonTest` on the kit;
      the glyph legend re-renders)
- [ ] `python/diagrams/embed_images.py`: embed an SVG as `image=data:image/svg+xml` beside the PNG path, with the theme's hex written for
      every `@token`. (check: `Invoke-PythonTest` on `tests/test_flow_glyphs.py` renders one glyph in dark and in light)
- [ ] `python/diagrams/query_rows.py` and `declaration_normalise.py`: key a row by (point, lens or level) so a flow row rides the same file;
      `about.point` is accepted under the flow lens as well as at C3/C4; `FLOW_LENS` in `declaration_constants.py`; a flow declaration with
      any content key beyond `title` and `kind` refused. The row shape changes in one go with its writer (PDR-ONELIVE). (check:
      `Invoke-PythonTest` on a new `tests/test_flow_lens.py` and the existing `tests/test_zoom.py`)
- [ ] `pwsh/Azure.DevOps/Get-AdoFlowRows.ps1`: the ADO reader: lanes from `Get-AdoYamlInventory`, the type from the file prefix, stages,
      jobs and steps from the template references, triggers from `trigger:`/`pr:`, rhombi from `Get-Rung`, Approve from the rung gates,
      `cd-<unit>` → `deploy-<unit>` edges. L0 fixtures are neutral widget/gadget pipelines, never the real `.ado` files. (check:
      `Invoke-TestFile` on `pwsh/Azure.DevOps/tests/Get-AdoFlowRows.Tests.ps1`)
- [ ] `pwsh/Base.Slides/private/Write-DiagramQueryRows.ps1`: ask the engine readers for a flow declaration's points and write its rows.
      (check: `Invoke-TestFile` on `pwsh/Base.Slides/tests/Write-DiagramQueryRows.Tests.ps1`)
- [ ] The GitHub reader, beside `Tooling.Github`: lanes from `.github/workflows/*.yml`, jobs and steps, `on:` triggers, the same rows.
      (check: `Invoke-TestFile` on its test file)
- [ ] `python/diagrams/declaration_place_flow.py`: lay out the lanes, rhombi, spanners, chips and the full-flow frame, time left to right,
      the spanners on the `spans` layer. (check: `Invoke-PythonTest` on `tests/test_flow_lens.py`; render
      `tests/flow-lens/flow-sample.drawio.yml` and read the PNG)
- [ ] `docs/explanation/flow/.assets/`: one flow diagram of the real `ci-pwsh` → `cd-apex` → `deploy-apex` route, declared by its files
      alone. (check: `Build-Diagrams` writes it; `Test-Diagrams` clean)
- [ ] The readers' rows carry each rung's occupant commit, and the rhombus prints it. (check: the `test_flow_lens` rhombus case asserts the
      commit text)

## Refs

- The lens rules: `docs/drs/design/visual-design.md` (DDR-VISUAL-ACTIONISALENS, -ENVIRONMENTISCONTAINER, -ZOOMISANAXIS).
- The pipeline types and the deploy tail: `docs/drs/flow/pipeline-types.md` (FDR-CD-TYPE-SIXTYPES, -DEPLOYISPINNED); the naming:
  `docs/drs/ado/pipeline-naming-and-placement.md`.
- The rungs and their gates: `pwsh/Base.Flow/types/RungsConfig.cs`, `Get-Rung`; the approval environments:
  `pwsh/Azure.DevOps/configs/environment-approvals.yml`.
- The query handoff: `python/diagrams/query_rows.py`, `pwsh/Base.Slides/private/Write-DiagramQueryRows.ps1`.
- The glyph inspiration: `js/file-icons/assets/pipe*.svg`; the three-slot prototype `glyphs.py` in a past session's scratchpad, rebuilt in
  the kit, not copied.
