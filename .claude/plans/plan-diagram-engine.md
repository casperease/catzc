---
plan:
  status: active
  value: high
  reviewed: 2026-10-19
  targets:
    [
      .claude/drawio,
      .claude/slides,
      .claude/drawio/minimaps,
      python,
      pwsh/Catzc.Base.Maps,
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

## Why its value is high

Every diagram and slide depends on it, and the fix list below cannot be judged until the renderer is correct.

## Decided (2026-10-19, from the user)

- Home: `python/Catzc.Diagrams` under the existing `python/` track (`pyproject.toml`, `uv.lock`), with the slide patterns, `STYLE.md` and
  `slides.yml` as its assets; `.claude` keeps only the agents and skills that call it. The whole of `.claude/drawio` moves (the renderer,
  the atlas, catalogue, contact sheet, gallery and migration scripts), not only the minimap code.
- The declaration of a diagram is a yml beside its `.drawio.png`, in the same `.assets/<name>/` folder, in two sections: `content:` (bands,
  glyphs, labels, span bars, groups, minimaps, legend, flow, theme) and `layout:` (position and size per named cell). Two directions, both
  deterministic: **put** renders the yml into the XML embedded in the `.drawio.png` and then the raster from that XML, so the file stays
  editable in the draw.io editor; **get** reads the embedded XML back into the yml, so a hand edit in draw.io is folded back before anything
  else reads it. A cell without a `layout:` entry is placed by the grid; a cell with one keeps it; a cell whose name is not in `content:` is
  removed. A drift gate fails when a committed yml and its png disagree (get of the png differs from the yml). Markdown is prose only: the
  article, and the describe page, which becomes a page derived from the yml.
- Themes are selectors: every slide and diagram renders in dark and in light; a theme is one token set (`slides.yml` `token` block today,
  `drawio.yml` `renderer.page`), chosen by a `-Theme` selector on the build commands with the default declared once on the config type, and
  no style names a colour, only a token. Only the default theme's raster is committed; the other renders on demand to `out/`.
  `migrate_dark.py`, the one-way light-to-dark migration, goes.
- The lifecycle rungs get a registry: one yml with main-uat, release-uat, pre-prod and prod, each with its gate and the environment suffix
  it maps to, in a new vendor-neutral module `Catzc.Base.Flow` (no Base module owns pipeline detection today; `Test-IsRunningInPipeline` is
  not a file under `pwsh/`), read by the lifecycle position minimap, `plan-promotion-ladder`'s rename and `Catzc.Azure.DevOps` for its
  environment names.
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
  no merge; the derived describe page is committed, as the readable diff of a diagram change; the XML-centred agents and skills
  (`drawio-png`, `write-drawio-files`, `drawio-model-edit`) are retired and one yml-editing agent plus one renderer skill replace them; a
  validation error names the allowed values of the vocabulary it failed, so the errors teach the kit.

## What the tree holds (checked 2026-10-19)

166 tracked `.drawio.png` (152 under `docs/explanation`, 11 under `docs/references`, 3 under `docs/adr`), 161 describe pages written by
`describe.py` from the drawings, and 21 slides; none has a declaration. `describe.py` already reduces every drawing to the closed vocabulary
of the kit (bands, glyphs from the glyph library, markers, span bars, legend, sidebar), which is what **get** writes into `content:`; the
drawio export is deterministic for one XML and pinned fonts, which is what **put** relies on. The first declaration of every existing
diagram is a **get**, so no drawing is redrawn to adopt the model; the round trip over the tree is the proof of the renderer, and a diagram
that fails it (a glyph outside the library, an element get cannot name) is the real fix list, whose size is unknown until that run.

## Open steps

- [ ] Move the renderer code from `.claude/drawio` into `python/Catzc.Diagrams` with its three test files (`test_drawio_png.py`,
      `test_gallery_pdf.py`, `test_slide_facts.py`); the two PowerShell steps in `minimaps/` (`highlights.ps1`, `stamp.ps1`) go to
      `pwsh/Catzc.Base.Maps` and `pwsh/Catzc.Base.Slides`, since the module is Python only; the `git mv` set is the user's
      (task-user-runs-and-commits), prepared in `out/run-user-git.ps1`; then the callers, one file each: `Build-Diagrams.ps1:20`,
      `SlidesConfig.cs:14` (`DefaultKit`), `configs/slides.yml:1`, `python.yml:3` (`extra_paths`), `MapsHighlight.cs:9`,
      `output-formats.yml:95,101,121,128`, `Get-FileKind.Tests.ps1:16`, `.gitattributes-template:99`, `terminology.yml:112`, the four agents
      and four skills under `.claude/`, and the `docs/references/pwsh/claude-drawio` pages (check: pytest on the moved tests passes;
      `git grep '\.claude/drawio'` finds only the ~20 `diagram.drawio.md` command lines, which the re-render step rewrites).
- [ ] Move the slide assets from `.claude/slides` (`slides.yml`, `STYLE.md`, the nine `patterns/*.html`) into the module's assets (check:
      Build-SlideDeck still renders one deck).
- [ ] Define the yml declaration: one schema with `content:` (`bands`, `glyphs`, `spans` with label and covered columns or bands, `groups`
      that may nest, `minimaps` of three ids, `legend`, `flow` left-to-right default or top-to-bottom, `theme`) and `layout:` (per named
      cell), one parser, and the two commands, **put** (yml to embedded XML to raster) and **get** (embedded XML to yml) (check: put then
      get returns the same yml and get then put the same XML in a test; a span label outside the declared vocabularies fails validation; a
      nested group round-trips; a cell without `layout:` is placed by the grid).
- [ ] Add the drift gate, `Test-Diagrams`, that runs get on every committed png and fails when the result differs from the committed yml
      (check: the gate passes on a folder whose yml came from get; it fails when one label in the yml is edited and not put).
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
- [ ] Declare the rungs registry, one yml with its C# config type in a new module `pwsh/Catzc.Base.Flow` (declared in `dependencies.yml`;
      the type carries the defaults), and read it from the lifecycle position data function (check: an L0 test on the type; the minimap's
      test lights a cell per rung from `cites` edges; `environment-approvals.yml` derives its environment names from it;
      Test-ModuleDependency clean).
- [ ] Make the theme a selector: one token set per theme in the renderer config, `-Theme` on `Build-Diagrams` and `Build-SlideDeck` with the
      default declared once on `SlidesConfig`, every style a token reference, `migrate_dark.py` removed, the non-default theme rendered to
      `out/` (check: one diagram and one slide render in both themes from the same declaration in a test; `git grep` of a hex colour under
      the module's patterns finds only the two token sets; the tree holds one raster per diagram).
- [ ] Extend ADR-REPO-SLIDES with the rules the decisions above state, one rule per landing step, in the same change as the step (check:
      Test-Adr clean; the index lists each new ADR-REPO-SLIDES code; the plan's Decided list names no decision without a rule).
- [ ] Draw the span bar from the `spans:` declaration with its label vocabulary, and give it to every existing diagram whose columns are
      stages, rungs, layers, tracks or kinds (check: the three diagrams that carry a hand-placed `CI` bar today render it from the
      declaration; the kit's `STYLE.md` names the vocabularies).
- [ ] Build the five further minimaps, each with its data function and a test on its data, and the two pools as the kind defaults (check:
      each minimap renders from its function with no hand-drawn cell).
- [ ] Run **get** over all 166 diagrams and 21 slides, one folder at a time, to write their first declarations, then **put** each and
      compare; write the list of the ones whose rendering differs from the drawing, with the reason per diagram (a glyph outside the
      library, an element get cannot name, a style outside the tokens) (check: the list is in this plan with a count; each entry names a
      reason a function stated; the describe page of each folder is regenerated from the yml and equals the old one).
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

- `.claude/drawio/drawio.yml`, `.claude/drawio/minimaps/render.py` (grid, chain, tree) and `describe.py` (the sister files).
- `plan-iac-and-repo-placement` authors five explanation diagrams as yml declarations in this plan's format and waits on the renderer steps.
- Memory: minimap-placements-reasoned, diagram-slides-symbols-plus-articles, render-nothing-without-asking.
