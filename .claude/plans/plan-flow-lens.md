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
      python/diagrams/assets,
      js/file-icons/assets,
    ]
---

# Flow lens

## Why its value

The repository's CI/CD is spread across `.ado/pipelines/` (with `extends/`, `stages/`, `jobs/` and `steps/` folders) and
`.github/workflows/`, and no diagram shows how a commit actually flows through them. A third lens beside `source` and `action` draws that
flow from the pipeline files themselves. Its small glyph set grows out of the same symbols as the VS Code file icons, so the editor tree and
the diagrams look like one family.

## Decided (2026-10-26, from the session with the user)

- **The lens is `flow`.** It is a value of `lenses:` in `python/diagrams/configs/drawio.yml`, a switch inside the one declaration format and
  the one renderer, never a second module (DDR-VISUAL-ACTIONISALENS, PDR-ONELIVE-ONEVERSION). The badge prints FLOW. The name sits in the
  lens vocabulary and does not clash with the existing `content.flow` direction key (`left-to-right` | `top-to-bottom`). The new ADR rule
  says so in one line.
- **One core alphabet, words of three.** Every flow glyph is a word of exactly three symbols from `O 0 - _ = .`, placed in three equal slots
  of its box:
  - `O` is an empty circle and `0` is the same circle with a dot. The dot is the only difference between them.
  - `-` is a middle line and `_` is a bottom line. Adjacent lines at different heights join with a riser.
  - `=` is a thin double line at stroke 1, against 1.6 for the other strokes.
  - `.` is a dot.

  The engine glyph words are taken from the file icons: pipeline/workflow `O=0`, stage `=0=`, job `=O_`, step `O_-`. Extends and variables
  are open questions.

- **The flow SVGs live in `python/diagrams/assets/flow/`, rendered from words.**
  - Each glyph is one entry in a `flow-glyphs:` block of `drawio.yml`, carrying its id, its word and its meaning, plus a `hint:`. The hint
    is the path of the `js/file-icons/assets/*.svg` it is styled after. It is a pointer for the reader only: nothing reads the JS file, and
    the JS icons are not generated from it. That keeps two independent sets, the editor's 16 px icons and the diagram glyphs, not one
    behaviour in two places (PDR-ONELIVE).
  - One generator (the three-slot renderer prototyped in this session, rebuilt in the kit) writes every SVG. The files are generated, carry
    the warning head, and are written through Write-FileIfChanged.
  - Strokes are the theme token `@ink`, never a hex. `put` substitutes the theme's hex when it embeds the SVG as `image=data:image/svg+xml`,
    so dark and light both render.
- **The glyph set**, a closed list, each entry a word plus a frame where it needs one:
  - **Engine structure:** pipeline/workflow, stage, job, step and template/extends, one each.
  - **Environment:** a rhombus with the environment's name. Inside the flow lens it is a neutral container that holds the commit occupying
    it, in that commit's state colour, as DDR-VISUAL-ENVIRONMENTISCONTAINER requires. The rhombus replaces the hexagon in this lens only,
    and the new rule names the exception.
  - **Full flow:** a frame spanning one end-to-end route, trigger to production. It is drawn as a lane with its start `O` and end `0` caps.
  - **Taxonomy spanners:** span bars over a run of stages or jobs, reusing the existing `spans` layer, each capped with its taxonomy glyph.
    - The pipeline types come from the one list in FDR-CD-TYPE-SIXTYPES (CRON, CI, CD, CDe, DEPLOY, INPUT) and are never redeclared.
    - Approve and Review are gate spanners: an approval check on an environment, and a pull-request review.
  - **Trigger and engine chips:** push, pull request, schedule and manual triggers. An engine chip, `ado` or `github`, sits on each lane,
    the same chip mechanism as the action lens's where chips.
- **Time runs left to right** (DDR-VISUAL-LEFTTORIGHTISTIME). One lane per pipeline or workflow. Edges carry their operator word, and arrows
  point at what they depend on.
- **Inputs only, the rows derived.** A flow declaration stores its inputs: the pipeline and workflow files in `about.point` and the taxonomy
  spanners it declares. Stages, jobs, steps, environments and triggers are read from the YAML and expanded into generated cells the source
  never holds, as the zoom ladder's query slides are (DDR-VISUAL-ZOOMISANAXIS). A hand-declared `content` is accepted only for the kit's own
  L0 sample.
- **The engines are pluggable.** One reader per engine (ADO, GitHub) maps its YAML to the same rows (lane, stage, job, step, environment,
  trigger). A later engine adds a reader and an entry, never a branch in the renderer.

## Open questions (each with its recommendation)

- **Extends and variables.** Their words, since `O=0` is taken by pipeline. Recommended: extends `0=0`, a template feeding a pipeline;
  variables `O..`, an empty circle with dots, keeping the raindrop idea as `.` symbols inside the three slots.
- **What the rhombus holds.** Recommended: the environment name under it and the occupant commit inside it, as the hexagon does today, so
  DDR-VISUAL-ENVIRONMENTISCONTAINER needs only the shape exception.
- **Approve and Review: gates or spanners?** Recommended: spanners. They fill the same span row as the types, so the reader sees CI → CD →
  Approve → Deploy as one band of words over the lanes.

## Open steps

- [ ] `docs/drs/design/visual-design.md`: add the rules DDR-VISUAL-FLOWISALENS, DDR-VISUAL-FLOWGLYPHSAREWORDS,
      DDR-VISUAL-RHOMBUSINTHEFLOWLENS and DDR-VISUAL-TAXONOMYSPANNERS, each with its context section. The pipeline types are cited from
      FDR-CD-TYPE-SIXTYPES, never listed again. (check: `Test-Links` on the file; `Test-Glossary` reports no collision)
- [ ] `python/diagrams/configs/drawio.yml`: add `flow` to `lenses:`, a `flow-lens:` block (lane height, slot size, the stroke widths 1.6 and
      1 for `=`), and the closed `flow-glyphs:` list of id, word, meaning and `hint:`. (check: `Invoke-PythonTest` on the kit passes)
- [ ] `python/diagrams/flow_glyphs.py`: the word renderer. Three slots, `O`/`0` the same circle with or without the dot, `@ink` strokes, and
      an unknown symbol or a word that is not three symbols refused by name. It writes `python/diagrams/assets/flow/<id>.svg`. (check:
      `Invoke-PythonTest` on a new `tests/test_flow_glyphs.py` that renders every entry and compares it with the committed SVG)
- [ ] `python/diagrams/embed_images.py`: embed an SVG as `image=data:image/svg+xml`, with the theme's hex substituted for every `@token`.
      (check: `Invoke-PythonTest` on `tests/test_flow_glyphs.py` renders one glyph in dark and in light)
- [ ] `python/diagrams/declaration_constants.py` and `declaration_normalise.py`: `FLOW_LENS` and `FLOW_KEYS`. A flow declaration names its
      files in `about.point` and its spanners in `content.spans`, and any other content key is refused. (check: `Invoke-PythonTest` on a new
      `tests/test_flow_lens.py`)
- [ ] `python/diagrams/flow_read_ado.py` and `flow_read_github.py`: one reader per engine, each turning its YAML into the shared rows. The
      fixtures are neutral widget/gadget pipelines, never the real `.ado` files. (check: `Invoke-PythonTest` on `tests/test_flow_lens.py`)
- [ ] `python/diagrams/declaration_place_flow.py`: lay out the lanes, rhombi, spanners and chips, time left to right, with the spanners on
      the `spans` layer. (check: `Invoke-PythonTest` on `tests/test_flow_lens.py`; render `tests/flow-lens/flow-sample.drawio.yml` and read
      the PNG)
- [ ] `docs/explanation/flow/.assets/`: one flow diagram of the real `ci-pwsh` → `cd-*` → `deploy-*` route, declared by its pipeline files
      alone. (check: `Build-Diagrams` writes it; `Test-Diagrams` clean)

## Refs

- The lens rules: `docs/drs/design/visual-design.md` (DDR-VISUAL-ACTIONISALENS, -ENVIRONMENTISCONTAINER, -ZOOMISANAXIS).
- The pipeline types: `docs/drs/flow/pipeline-types.md` (FDR-CD-TYPE-SIXTYPES).
- The glyph inspiration: `js/file-icons/assets/pipe*.svg`. The three-slot prototype is
  `C:\Users\caspe\AppData\Local\Temp\claude\C--projects-catzc\1179c5b6-7497-460d-8faa-7b3371430831\scratchpad\glyphs.py`, and it is rebuilt
  in the kit, not copied.
