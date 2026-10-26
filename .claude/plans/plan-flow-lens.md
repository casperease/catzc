---
plan:
  status: active
  value: medium
  reviewed: 2026-10-26
  class: feature
  targets:
    [
      pwsh/Azure.DevOps/Get-AdoFlowRows.ps1,
      pwsh/Tooling.Github/Get-GithubFlowRows.ps1,
      python/diagrams/declaration_place_flow.py,
      python/diagrams/tests/test_flow_lens.py,
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

- Should the `catzc-run` capability say in one line that the diagram kit runs from its editable build copy, so a changed or new
  `python/diagrams/*.py` needs `uv sync --reinstall-package catzc-diagrams` before a render or test sees it? Recommended: yes, a render read
  stale twice before the reinstall.

## Open steps

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
