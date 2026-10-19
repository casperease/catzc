---
plan:
  status: active
  value: high
  reviewed: 2026-10-19
  targets:
    [
      python/Catzc.Diagrams,
      pwsh/Catzc.Base.Maps,
      pwsh/Catzc.Base.Slides,
      docs/adr/design/commit-lifecycle.md,
      docs/adr/repository/slides-as-markdown.md,
      .claude/agents,
      .claude/skills,
      docs/adr/azure/.assets/azure-name-assembly/diagram.drawio.png,
      docs/adr/design/.assets/commit-lifecycle-states/diagram.drawio.png,
      docs/adr/design/.assets/sync-point/diagram.drawio.png,
      docs/explanation/automation/.assets/a-declared-allow-list-of-layers/diagram.drawio.png,
    ]
---

# The diagram engine: a correct, reproducible minimapper and slider, then the diagram fixes

The diagram and slide code is proof of concept and lives in `.claude/drawio` and `.claude/slides`. It becomes one module,
`python/Catzc.Diagrams`, whose input is a declaration: a person or an LLM edits the yml beside a diagram, runs the renderer, and gets a
`.drawio.png` with correct embedded XML and raster; a person may also edit the `.drawio.png` in the draw.io editor and fold the edit back
into the yml. The minimaps are redefined first; the diagram fix list waits for that.

This plan is an **isolated track** (the user, 2026-10-19): it sits outside the master's chunk order, is taken by its own session, and no
other chunk waits on any step here. The two things it once shared with other plans are cut: the rungs registry is declared by
`plan-promotion-ladder` (this plan's lifecycle minimap reads it once it exists, and is built last), and the five IaC explanation diagrams of
`plan-iac-and-repo-placement` are authored here, in the content list below. The other plans keep using today's renderer
(`Build-Diagrams -Path`) to regenerate `.assets` pages until this plan's engine replaces it.

## Why its value is high

Every diagram and slide depends on it, and the fix list below cannot be judged until the renderer is correct.

## Decided (2026-10-19, from the user)

- Home: `python/Catzc.Diagrams` under the existing `python/` track (`pyproject.toml`, `uv.lock`), with the slide patterns, `STYLE.md` and
  `slides.yml` as its assets; `.claude` keeps only the agents and skills that call it. The whole of `.claude/drawio` moves (the renderer,
  the atlas, catalogue, contact sheet, gallery and migration scripts), not only the minimap code.
- One source per diagram, and no markdown in the diagram folder (2026-10-19, from the user: "drawio.png + yml + whatever articles"; "the
  diagram itself does not know its article"): the `.assets/<name>/` folder holds `diagram.drawio.yml`, the one source (`description:`, a
  sentence or two of what the diagram shows; `content:`, the declaration: bands, glyphs, labels, span bars, groups, minimaps, legend, flow
  and its relation, theme; `layout:`, position and size per named cell), and `diagram.drawio.png`, the render. The diagram names no article;
  articles and slides embed the png, any number of them, and automation finds them by what links to the asset. The walkthrough lives in each
  article that uses the diagram. Two directions, both deterministic: **put** renders the declaration into the XML embedded in the
  `.drawio.png` and then the raster from that XML, so the file stays editable in the draw.io editor; **get** reads the embedded XML back
  into the yml (the description kept), so a hand edit in draw.io is folded back before anything else reads it. A cell without a layout entry
  is placed by the grid; a cell with one keeps it; a cell whose name is not in the content is removed. A drift gate fails when a committed
  yml and its png disagree (get of the png differs from the declaration).
- Minimaps are claims in the diagram's yml, checked, never generated files (2026-10-19, from the user): the declaration's `minimaps:` names
  each minimap and what it lights and why; put draws from that; the drift gate recomputes the lit set from `Catzc.Base.Maps` and fails a
  claim the repository no longer supports or a place that now cites the codes and is missing. The sister `grid`, `tree` and `chain` `.md`
  and `.png` files (924 tracked) go: the pictures are embedded in the render, the reasons are in the page. This replaces the earlier rule
  that every lit cell's reason sits in a checked-in generated sister page.
- The ADR codes appear once on a diagram, in its subtitle; the sidebar carries the minimaps, the lens badge and the map key's four swatches
  only (2026-10-19, from the user).
- Themes are selectors: every slide and diagram renders in dark and in light; a theme is one token set (`slides.yml` `token` block today,
  `drawio.yml` `renderer.page`), chosen by a `-Theme` selector on the build commands with the default declared once on the config type, and
  no style names a colour, only a token. Only the default theme's raster is committed; the other renders on demand to `out/`.
  `migrate_dark.py`, the one-way light-to-dark migration, goes.
- The lifecycle rungs get a registry, declared by `plan-promotion-ladder` in a new vendor-neutral module `Catzc.Base.Flow`: one yml with
  main-uat, release-uat, pre-prod and prod, each with its gate and the environment suffix it maps to. This plan's lifecycle position minimap
  reads it and is built after it exists; nothing here declares it.
- The span-bar labels and the flow direction come from closed vocabularies in the renderer's config: a `vocabularies:` block names each list
  (axis words, rungs, layers, tracks, IaC kinds), each read from its registry where one exists, and a label outside them fails validation.
- The ADR home of every decision here is ADR-REPO-SLIDES, `docs/adr/repository/slides-as-markdown.md`: its seven rules already cover the
  markdown slide file, the fail-forward render and the one build command; the yml declaration, the two directions, the drift gate, the three
  minimaps, the span bar, the flow, the nested groups and the themes join it as rules in the same change that lands each one
  (ADR-REPO-PLANS-DECISIONSBECOMERULES). Slides stay markdown files (ADR-REPO-SLIDES-SLIDEFILE); the diagram declaration is the yml.
- The look stays: the diagrams are liked; the work is the code behind them. A diagram has a right column of four slots (three minimaps and
  the minimap legend) and a left side of header and subheader (the ADR list), the diagram, then the diagram legend.
- A diagram always shows exactly three minimaps, declared in its yml as a `minimaps:` list of three ids; the renderer validates the count
  and each id, and the diagram kind (explanation or reference) supplies the default three. Slides follow the same rules.
- Minimap data is generated from well-defined functions, never drawn by hand. The actor strip (who acts) has no registry to derive from and
  is dropped; there are eight minimaps.
- The eight minimaps: grid, code locations, axis, layer stack, lifecycle position, track placement, engine strip, module neighbourhood, each
  derived from a function over a config.
- Minimap data is computed in PowerShell and drawn in Python: `Catzc.Base.Maps` gets one data function per minimap, built on the file-fact
  functions, and returns JSON as the world map does today; the Python module reads that JSON and draws, and never parses a head
  (ADR-REPO-FILEMETA-NOREADBACK: facts are derived from the registries, git and the disk, never read back from a file's head).
- A diagram's subject is the ADR codes in its subtitle plus the files that cite them; every minimap is a projection of that subject's files
  and their facts onto its axes, so a lit cell always has a reason a function can state.
- Two pools, overlapping on the grid: explanation diagrams pick from axis, lifecycle position, layer stack and grid; reference diagrams pick
  from code locations, track placement, engine strip, module neighbourhood and grid.
- Redefinitions: the legend is simplified, much less text; the tree becomes the more generic **code locations** view that still shows which
  code files are hit, without the static frame (the grid is the more correct replacement for the old tree); the chain is renamed **axis**
  with two relevant axes, build, qc, release, deploy, access across and the top ADR domains (design with principles and thesis, flow, auto,
  cloud) down, and the value chain leaves it.
- `commit-lifecycle-states`: the whole ADR `docs/adr/design/commit-lifecycle.md` (ADR-DSGN-LIFE) moves to `docs/adr/flow`, the diagram is
  renamed `commit-promotion-states`, and its text goes into an article.
- `a-declared-allow-list-of-layers` is generalized: vendor-neutral layers with the call through base to the vendor tool as the last hop; the
  Azure case (Az CLI) becomes one worked example in its article.
- The **span bar** (the kit's name, `STYLE.md:138`, glyph "span bar: stages over bands"), the `|---- CI ----|` bracket over a run of
  columns, is a declared element of `content:` and is used far more widely than today: a diagram declares `spans:` with a label and the
  columns or bands each covers, and the labels come from the vocabulary the diagram is about, not only CI, CD and DEPLOY: the axis words
  (build, qc, release, deploy, access), the lifecycle rungs, the layer names, the track names, the three IaC kinds. The renderer draws it; a
  maker never hand-places it. A span bar is horizontal over columns or vertical beside bands, so a diagram that flows top to bottom gets
  vertical `|---- CI ----|` markers.
- Flow direction: a diagram always moves in the direction of its flow, left to right by default, top to bottom when that reads better; the
  yml declares the direction once and the renderer lays out bands, span bars and arrows along it.
- Nested groups: a group may hold groups, so a frame can sit inside a frame; the declaration allows it, the renderer draws it, and the kit's
  `STYLE.md` says it is used only when the nesting is the point of the picture.
- Registry facts checked 2026-10-19 (the explorer's survey): the layers are prose in `docs/adr/automation/layers.md:71,103` and `adrs.yml`
  tags ADRs with `layer:` (language, engine, importer), so the layer stack projects the subject's `cites` edges onto ADR layers, not modules
  onto layers; the lifecycle rungs have no registry (`environment-approvals.yml:7-13` lists environments per unit, not rungs); the engines
  are the C# `ExecutionEngines` (`pwsh/Catzc.Base.Engines/types/ExecutionEngines.cs`, Names = pwsh, bash, zsh); module dependencies are
  `pwsh/Catzc.Base.ModuleSystem/configs/dependencies.yml` with `DependenciesConfig.cs`, enforced by the Builder's closure check.
- The journeys (the user, 2026-10-19, all four as recommended): after a draw.io edit one command syncs, get then put then the drift gate on
  the folder (`Build-Diagrams -FromDrawing <folder>`), and get and put stay callable alone; a tree change that makes committed minimaps
  stale is a report of `Test-Diagrams`, never a failure, and the bulk `Build-Diagrams` over the stale set regenerates them; a pair whose yml
  and png were both edited is a conflict, `Test-Diagrams` names the diverging cells and neither direction runs until the author picks one,
  no merge; the yml is the readable diff of a diagram change; the XML-centred agents and skills (`drawio-png`, `write-drawio-files`,
  `drawio-model-edit`) are retired and one yml-editing agent plus one renderer skill replace them; a validation error names the allowed
  values of the vocabulary it failed, so the errors teach the kit.

## What the tree holds (checked 2026-10-19)

166 tracked `.drawio.png` (152 under `docs/explanation`, 11 under `docs/references`, 3 under `docs/adr`), 161 describe pages written by
`describe.py` from the drawings, and 21 slides; none has a declaration. `describe.py` already reduces every drawing to the closed vocabulary
of the kit (bands, glyphs from the glyph library, markers, span bars, legend, sidebar), which is what **get** writes into `content:`; the
drawio export is deterministic for one XML and pinned fonts, which is what **put** relies on. The first declaration of every existing
diagram is a **get**, so no drawing is redrawn to adopt the model; the round trip over the tree is the proof of the renderer, and a diagram
that fails it (a glyph outside the library, an element get cannot name) is the real fix list, whose size is unknown until that run.

## Done (2026-10-19) and why

- The kit is the module `python/Catzc.Diagrams` of the python track, in the layout the module system holds every language track to
  (plan-module-system-per-language, landed the same day): the scripts at the module root, the minimap scripts flattened to
  `minimap_describe.py`, `minimap_render.py` and `minimap_join.py`, `configs/drawio.yml`, `assets/` for the glyph sheet, the template slide,
  the atlas template and `STYLE.md`, `tests/` for the three test files, and the slides kit as `assets/slides/`. The user ran the `git mv`
  set (37 renames). The two PowerShell steps are the commands `Export-MinimapData` (`Catzc.Base.Maps`) and `Update-MinimapPageHead`
  (`Catzc.Base.Slides`), which the renderer runs in a pwsh that loads the importer. Every caller re-pointed: `SlidesConfig.cs`,
  `slides.yml`, `MapsHighlight.cs`, `output-formats.yml`, `file-kinds.yml`, `variants.yml` (the `.claude-kits` track is gone),
  `comments.yml` (`python/*` pages under `docs/references/python/`), `.gitattributes-template`, `terminology.yml`, the two agents and four
  skills, ADR-REPO-SLIDES, the two reference articles, the glossary and the comment pages; the ~160 `diagram.drawio.md`, `grid.md` and
  `tree.md` command lines still name `.claude/drawio` and are rewritten by the re-render step. Checks: pytest on the moved tests
  `34 passed`; `Test-PythonTypes`: `No python-types issues found.`; `Test-PythonLint`: `No python-lint issues found.`; `Build-SlideDeck` on
  the thesis deck: `21 slide(s) rendered`, `0 fault(s)`; `Build-Diagrams -DryRun` names the new renderer path; `Test-Comments`,
  `Test-GeneratedFiles`, `Test-Links`, `Test-AgentDefinitions`: no issues (20:50).

- The reference article `docs/references/python/catzc-diagrams.md` and the `python/*` pattern in `readme.yml`:
  `Build-Readme -Folder python/Catzc.Diagrams` writes `python/Catzc.Diagrams/README.md`; `Test-Links` on both: `No links issues found.`
  (21:09).
- The yml declaration, `python/Catzc.Diagrams/declaration.py`: one schema (`content:` with title, adrs, lens, kind, flow, theme, bands,
  spans over bands, groups that nest through `in`, glyphs with kind and holder, edges, markers, chips, legend, three minimaps; `layout:` per
  named cell), one parser whose every vocabulary is closed and names the allowed values on refusal, put (yml to model XML to raster through
  `drawio_png`, the grid placing what `layout:` does not name, the legend and sidebar derived) and get (model XML to yml by the glyph
  library's style signatures, band containment and parent groups, a layout entry kept only where a cell sits off the grid). The vocabularies
  live in `configs/drawio.yml` (`kinds`, `themes`, `minimaps` with the ids and the two kind defaults, `vocabularies` with the span word
  lists); `pyyaml` joins `python.yml`; the crossbar paints rotated for top-to-bottom flow. Rules 8 and 9 of ADR-REPO-SLIDES (`DECLARATION`,
  `TWODIRECTIONS`) and the glossary term landed with it. Checks: `tests/test_declaration.py` proves put then get the same yml, get then put
  the same XML, a span label outside the vocabularies refused with the words, a nested group round trip, grid placement and a moved cell
  kept, top-to-bottom, the minimap defaults and count, and the embedded png read back; kit pytest `43 passed`; ruff and pyright clean;
  `Test-Spelling`: no issues (21:11).
- The one-source model and the conversion pass (2026-10-19, evening). Each diagram folder holds `diagram.drawio.yml` (`description:`,
  `about:` with lens, adrs, tracks, languages, modules, files, each checked against its registry; `content:`; `layout:`) and the render; no
  markdown, no sister files, no layout file; the diagram names no article. The kit grew: the smooth renderer (supersampled), the lens chip
  opening the title row (the subtitle holds only the ADR codes, the sidebar no codes), minimaps computed from `about:` (code locations,
  module neighbourhood, delivery axis, grid; the rest a labelled frame) in `minimaps.py`, the two-swatch map key, `relation:` naming the
  flow legend, edges and markers and chips on groups and bands, numbered rule chips keyed in the legend (dashed when ungated), commit states
  in the locked palette with ghosts (`commits:` in `drawio.yml`), spans over whole bands or the glyphs of one band, stacking, with the
  drawing area moved down when they need room, and markers that take the corner away from arriving edges. `Update-MinimapPageHead` is
  removed; minimap outputs land in `out/drawio/minimaps/`; `Build-Diagrams` runs the renderer in the kit's uv project and puts a folder that
  has a yml. 148 of 166 diagrams are converted by hand-written ymls (7 by this session, 141 by seven workers on `out/drawio/pass/BRIEF.md`),
  their describe pages and minimap files deleted and the article links removed; `adronly` joined the coined terms. Checks: kit pytest
  `56 passed`; all 148 put; the gates per slice clean (lint, types, links, spelling).
- The kit gaps the later batch named (2026-10-19): an edge marker sits halfway along the edge's `via` path, in put and get; the span
  vocabulary reads its track names from `variants.yml` (the hand list in `drawio.yml` said `pipelines`, the registry says `ado-pipelines`);
  "declared" and "derived" stay groups, as `two-declared-layers-one-derived` draws them, since a span covers one band's items and those
  cross bands. No converted diagram had a marker on a routed edge, so none needed a new put.
- The sync source (the user, 2026-10-19: "the BVT verified server head is both the sync source and the main-uat source (if deployed)"): the
  rule is renamed ADR-DSGN-LIFE-SYNCFROMVERIFIEDHEAD and rewritten with its section, `server-remote-integration.md` follows, every citation
  is re-cited by `Update-AdrCitation`, and the eight `docs/explanation/design` articles are re-pointed; the ladder of
  `integrators-sync-from-the-bvt-verified-head` reads left to right in promotion order; the two articles whose titles named the occupant and
  the certified commit are retitled and moved by `Move-Diagram` (`integrators-sync-from-the-bvt-verified-head`,
  `sync-from-the-bvt-verified-head`). Checks: Test-AdrRegistry, Test-Links, Test-Spelling and Test-Glossary clean.
- The drift gate `Test-Diagrams` (`Catzc.Base.Slides`): the kit's `declaration.py check` compares the model embedded in each png with put of
  its yml and names the cells that differ; a differing minimap alone is stale, a fact and not an issue (ADR-REPO-SLIDES-TWODIRECTIONS says
  so). Its first run found 29 drifted folders (subtitles after the re-cite, count chips after the corner rule, and titles where put escaped
  an apostrophe, a kit bug fixed: labels escape `<`, `>` and `&` only); all were put again. Checks: kit pytest `64 passed`, Pester
  `Test-Diagrams.Tests.ps1` 6 passed, the check over all 162 folders 0 drifted.
- Two handed-over steps closed: the old `pipelines/` label reads `.ado/pipelines/cd-apex.yaml` in
  `apex-thirteen-rules-seven-includes-six-excludes` and `print-projection-then-drift-names-the-filter`
  (`globs-projects-and-three-consumers-read` already did), both put; the `what-gates-each-bundle-stage` `{chain,grid,tree}.md` pages that
  cited `docs/adr/pwsh` were deleted by the conversion, so nothing is left to rewrite. The root-config pages of
  `docs/explanation/repository` describe the headed copy (the root-config worker's pass); `git grep FILESYSTEMLINK docs/explanation` finds
  nothing.

## Open steps

- [ ] `Test-Diagrams` detects a conflict: when the yml differs from get of the png in `content:` and the png's XML differs from put of the
      yml, the gate fails and names the diverging cells; `-FromDrawing` and put refuse the pair until the author runs get or put by name
      (check: a fixture with both sides edited fails with the cell names; get or put alone clears it).
- [ ] Add `-FromDrawing` to `Build-Diagrams`: get, put, then the drift gate on the folder, with the put stage skipped when get reports a
      conflict (check: a draw.io-edited fixture folder syncs in one call and passes `Test-Diagrams`; a conflicted fixture stops before put
      and names the cells).
- [ ] `Test-Diagrams` reports stale minimaps: for each committed diagram it recomputes the minimap data and lists the diagrams whose lit
      cells differ, as a report line, not an issue; `Build-Diagrams -Stale` rebuilds that set (check: renaming one cited file in a fixture
      tree makes the gate report one diagram and keep issues=0; `-Stale` rebuilds only it).
- [ ] Validation errors name the allowed values: a span label, glyph id, minimap id, flow or theme outside its vocabulary fails with the
      list it may choose from (check: a test per vocabulary asserts the error text holds every allowed value).
- [ ] Redefine the legend, code locations and axis as above, and write the sister files from the same data (check: the minimap tests pass;
      each lit cell has its reason).
- [ ] Expose the file facts through one public read-only command in the module that owns them (today `Get-FileMetaFact` is private to
      `Catzc.Base.QualityGates`, called only by `Invoke-FileMetaEngine.ps1:137`, and returns `Immutable` and `Edges` from the
      `file-meta.yml` kinds), returning the facts the imprint would write without writing a head (check: its output equals the imprint's for
      ten sample files; stripping every head changes no output, ADR-REPO-FILEMETA-NOREADBACK).
- [ ] Define the minimap data contract once: one JSON shape for a minimap (axes, cells, lit cells each with its reason), validated by a C#
      type in `pwsh/Catzc.Base.Maps/types/`, cut from the `WorldMap.ToJson()` shape (`WorldMap.cs:114`: tracks, file_languages, cells of
      track by file_language, files with citations) and `WorldMapHighlight.ToJson()` (`WorldMapHighlight.cs:126`: kind, requested, lit cells
      with sources) (check: the grid, code locations and axis serialize to it; a test per minimap).
- [ ] The lifecycle position data function reads the rungs registry of `Catzc.Base.Flow` once `plan-promotion-ladder` has declared it; until
      then this minimap is the last of the eight to be built (check: the minimap's test lights a cell per rung from `cites` edges; the
      registry is read through `Get-Config`, never a literal list).
- [ ] Make the theme a selector: one token set per theme in the renderer config, `-Theme` on `Build-Diagrams` and `Build-SlideDeck` with the
      default declared once on `SlidesConfig`, every style a token reference, `migrate_dark.py` removed, the non-default theme rendered to
      `out/` (check: one diagram and one slide render in both themes from the same declaration in a test; `git grep` of a hex colour under
      the module's patterns finds only the two token sets; the tree holds one raster per diagram).
- [ ] Extend ADR-REPO-SLIDES with the rules the decisions above state, one rule per landing step, in the same change as the step (check:
      Test-Adr clean; the index lists each new ADR-REPO-SLIDES code; the plan's Decided list names no decision without a rule).
- [ ] Build the five further minimaps, each with its data function and a test on its data, and the two pools as the kind defaults (check:
      each minimap renders from its function with no hand-drawn cell).
- [ ] The last three diagrams without a yml (162 of 166 are converted; the glyph legend stays rendered from `assets/glyphs.xml`):
      `10-commits-story` and `state-changes` (about 60 cells each; they wait on a time-axis lane with branch and merge curves, vertical gate
      rules across lanes, lane templates and a free text note) and `commit-lifecycle-states` (rename to `commit-promotion-states` and
      re-home with the ADR in flow, after the ADR-DSGN-LIFE move below) (check: each put and reviewed; the kit's `STYLE.md` sections on the
      `.drawio.md` visual description rewritten to the yml).
- [ ] `Build-Diagrams` stops treating "the one article that embeds the folder" as an input: it finds every article and slide that embeds the
      png, and the supports-drift check holds each one's Supports line against the yml's codes; ADR-REPO-SLIDES-ONEBUILDCOMMAND says so;
      `gallery_pdf.py` prints the yml's `description:` instead of the deleted describe page (check: a second article embedding one of the
      two ado diagrams builds clean; Test-Adr clean). The two ado folders already hold only `diagram.drawio.yml` and the png.
- [ ] Redraw each listed diagram, one at a time, the four below first, extending the glyph library or the schema only when a reason repeats
      across diagrams (check: each is put from its declaration, passes `Test-Diagrams`, and is reviewed by the user).
- [ ] Rework the data of every existing diagram's minimaps on the new definition (check: re-render one folder, review, then the rest).
- [ ] Retire `.claude/agents/drawio-png.md`, `.claude/agents/write-drawio-files.md` and `.claude/skills/drawio-model-edit/`, and add one
      yml-editing agent (edits `content:`, runs put in the background under the safeguard, reports the warnings) and one renderer skill
      (put, get, `-FromDrawing`, `-Theme`, `-Stale`); the registry entries in `pwsh/Catzc.Base.Docs/configs/agents.yml` and
      `capabilities.yml` and the agent list in `.claude/CLAUDE.md` change in the same step (check: Test-AgentDefinitions clean;
      `drawio-diagram-waves` and `print-artifacts` call the new skill).
- [ ] Fix the four diagrams below once the steps above are done, one diagram at a time (check: each is put from its declaration and reviewed
      by the user; blocked on the renderer steps).
- [ ] Move ADR-DSGN-LIFE to `docs/adr/flow` with `Update-AdrCitation` re-citing its codes (check: Test-Adr and Test-Links clean;
      `plan-promotion-ladder` re-points its target).
- [ ] The IaC explanation diagram of the three kinds, from `plan-iac-and-repo-placement`: article and yml declaration under
      `docs/explanation/azure`, working slug `three-kinds-of-infrastructure-code`: templates, configs and reusable modules, what each holds,
      and how a template pulls its configs and modules together (check: the diagram is put from its declaration and passes `Test-Diagrams`;
      the article cites the ADR rules that plan writes for each kind, so it lands after them).
- [ ] The four IaC management diagrams, each its own article and folder under `docs/explanation/azure`, working slugs
      `change-one-configuration-slot`, `a-module-change-fans-out-to-its-templates`, `add-a-template`, `add-an-environment-slot` (check: each
      is put from its declaration, names the track place it edits as a span bar from the IaC kinds vocabulary, and is reviewed by the user).

## Where each minimap's data comes from

The facts below are the ones the file-meta kinds already produce (`file-meta.yml`): `file-path`, `file-name`, `file-type`, `file-role`,
`file-language`, `track`, `track-type`, `vendor`, `module-name`, `module-type`, `catzc-bundle`, `visibility`, and the edges `cites`,
`defines`, `links`, `page`, `test`. Status is what was checked on 2026-10-19.

| Minimap              | Projection                                             | Facts and registries                                              | Status                                                               |
| -------------------- | ------------------------------------------------------ | ----------------------------------------------------------------- | -------------------------------------------------------------------- |
| grid                 | track by file language                                 | `track`, `file-language`, the world map                           | exists (`Get-WorldMap`, `Get-WorldMapHighlight`)                     |
| code locations       | tracks, modules and folders the subject's files sit in | `track`, `module-name`, `module-type`, `file-path`, `cites` edges | facts exist; the generic view replaces the static treemap frame      |
| axis                 | ADR domain down, build/qc/release/deploy/access across | the ADR registry (domain, concern), `cites` edges                 | exists as the value-chain map; the new axes are a re-cut (unchecked) |
| layer stack          | which layer the subject's cited ADRs belong to         | `cites` edges, the `layer:` tags in `adrs.yml`                    | registry exists (ADR to layer); no module-to-layer map, none needed  |
| lifecycle position   | the rung of the commit lifecycle the subject concerns  | the rungs registry (its step above), `cites` edges                | registry decided, not yet declared                                   |
| track placement      | which tracks, track types and vendors the files sit in | `track`, `track-type`, `vendor`                                   | facts exist                                                          |
| engine strip         | which file languages and engines the subject touches   | `file-language`, `ExecutionEngines.cs` (pwsh, bash, zsh)          | facts and registry exist                                             |
| module neighbourhood | the subject's modules and their dependency edges       | `module-name`, `dependencies.yml` (`DependenciesConfig`)          | facts and registry exist                                             |

## The diagram fix list (waits on the renderer)

- `azure-name-assembly`: far too crowded. Keep the top row. Add a full-width `Resource Name` bracket above it. Cut the middle rows hard.
  Keep the final row of boxed name listings, but move the type names out of the boxes as headers (Resource Groups, Storage, Virtual
  Machine). Rework the legend. Minimaps later.
- `commit-lifecycle-states`: solid; rename to `commit-promotion-states`, move its text into an article, and re-home it with the ADR in flow.
- `sync-point`: it is about not working from a shared dirty head but taking the latest BVT-verified server HEAD. That head is also the next
  candidate for main-UAT, but the diagram reads as syncing from main-UAT. Make the BVT-verified HEAD the sync source and show the main-UAT
  queue as a separate fact.
- `a-declared-allow-list-of-layers`: generalize as decided above.

## Refs

- `python/Catzc.Diagrams/configs/drawio.yml`, `minimap_render.py` (grid, chain, tree), `minimap_describe.py` (the sister files) and
  `declaration.py` (the yml declaration, put and get).
- `plan-iac-and-repo-placement` authors five explanation diagrams as yml declarations in this plan's format and waits on the renderer steps.
- Memory: minimap-placements-reasoned, diagram-slides-symbols-plus-articles, render-nothing-without-asking.
