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
      docs/adr/flow/commit-lifecycle.md,
      docs/adr/repository/slides-as-markdown.md,
      .claude/agents,
      .claude/skills,
      docs/adr/flow/.assets/commit-lifecycle-states/diagram.drawio.png,
    ]
---

# The diagram engine: the rest of the minimapper and slider

`python/Catzc.Diagrams` renders each diagram from the yml beside it, and a draw.io edit folds back into the yml. Open: the edit-both
conflict and the sync from a drawing, the minimap contract and the minimaps still missing, themes, every embedding page as an input, the
last three diagrams, the agent retirement, and the five IaC diagrams.

This plan is an **isolated track** (the user, 2026-10-19): it sits outside the master's chunk order, is taken by its own session, and no
other chunk waits on any step here. Its lifecycle minimap reads the rungs registry, and is built last.

## Why its value is high

Every diagram and slide depends on it: a renderer that cannot fold back a draw.io edit, or minimaps that are not computed, leave the
pictures unchecked.

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
- `commit-lifecycle-states`: the whole ADR, now `docs/adr/flow/commit-lifecycle.md` (ADR-FLOW-CD-LIFE), sits in flow; the diagram is renamed
  `commit-promotion-states`, and its text goes into an article.
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

## Open steps

- [x] `Test-Diagrams` detects a conflict against the committed pair at git `HEAD` (decided 2026-10-20, ADR-REPO-SLIDES-CONFLICTNEEDSAPICK):
      both sides moved from `HEAD` and get of the png states other content than the yml; the gate fails and names the cells, the bulk put
      skips the pair, put or get by name clears it; one side moved or an untracked pair is no conflict. Verdict: test_declaration.py "35
      passed"; Test-Diagrams.Tests.ps1 "Passed"; Test-AdrRegistry "No adr-registry issues found."
- [x] Add `-FromDrawing` to `Build-Diagrams`: the kit's `sync` runs get when the drawing moved since `HEAD` (put alone when only the yml
      moved), then put, then `Test-Diagrams` on the folders, and stops on a conflict before put naming the cells. Verdict:
      test_declaration.py "38 passed"; Build-Diagrams.Tests.ps1 "Passed"; Test-Links "No links issues found."
- [x] `Test-Diagrams` reports stale minimaps as a report line and the `StaleFolders` fact, not an issue; `Build-Diagrams -Stale` rebuilds
      only that set. The fixture swaps what the minimaps draw, since today's minimaps read `about:` and the disk, not citations. Verdict:
      test_declaration.py "40 passed"; Build-Diagrams.Tests.ps1 and Test-Diagrams.Tests.ps1 "Passed".
- [x] Validation errors name the allowed values: a span label, glyph kind, edge kind, minimap view, flow or theme outside its vocabulary
      fails with the whole list it may choose from (ADR-REPO-SLIDES-DECLARATION already states it). Verdict: test_declaration.py "46
      passed", one parametrized case per vocabulary.
- [ ] Redefine the legend, code locations and axis as above; each lit cell's reason travels in the minimap JSON and in the page, never a
      sister file (decided 2026-10-20). Waits on catzc-9f's minimap schema (check: the minimap tests pass; each lit cell has its reason).
- [x] Expose the file facts through one public read-only command in the module that owns them: `Get-FileMetaFact -Path` is public in
      `Catzc.Base.QualityGates`, the imprint keeps its `-State` call (verdict 2026-10-20: ten headed front-matter files, equals-imprint=True
      and strip-unchanged=True for all ten; the Get-FileMetaFact and Invoke-FileMetaEngine test files "Passed"; Test-Links "No links issues
      found.").
- [x] Define the minimap data contract once: `contracts/catzc/0.0.0/Catzc.Base.Maps/minimap.schema.json` with its sample, the C#
      `MinimapData` type (from the world map and the value chain), and the kit's `minimap_contract.py` on `jsonschema` 4.26.0; the
      code-locations serialization test moves to the redefine step (the orchestrator, 2026-10-20) (verdict 2026-10-20: MinimapData.Tests
      "Passed" for the grid and the axis; the kit pytest "6 passed"; Test-Contracts "No contracts issues found.").
- [ ] The lifecycle position data function reads the rungs registry of `Catzc.Base.Flow` once `plan-promotion-ladder` has declared it; until
      then this minimap is the last of the eight to be built (check: the minimap's test lights a cell per rung from `cites` edges; the
      registry is read through `Get-Config`, never a literal list).
- [x] The light slide palette (ADR-REPO-SLIDES-THEMESELECTOR): `token-light` landed in `slides.yml` after the user's review, its accent
      darkened to `#A8620F`. The legacy minimap files stay out of the hex check until the last-three-diagrams step retires that path.
      Verdict: SlidesKit.Tests.ps1 "Passed" (the shipped kit in both themes); `Build-SlideDeck -Theme light` "21 slide(s) rendered ... 0
      fault(s)"; Test-Spelling and Test-Terminology "No ... issues found."
- [ ] Extend ADR-REPO-SLIDES with the rules the decisions above state, one rule per landing step, in the same change as the step (check:
      Test-Adr clean; the index lists each new ADR-REPO-SLIDES code; the plan's Decided list names no decision without a rule).
- [ ] Build the five further minimaps, each with its data function and a test on its data, and the two pools as the kind defaults (check:
      each minimap renders from its function with no hand-drawn cell).
- [ ] The last three diagrams without a yml (162 of 166 are converted; the glyph legend stays rendered from `assets/glyphs.xml`):
      `10-commits-story` and `state-changes` (about 60 cells each; they wait on a time-axis lane with branch and merge curves, vertical gate
      rules across lanes, lane templates and a free text note) and `commit-lifecycle-states` (rename to `commit-promotion-states` and its
      folder already sits beside the ADR in `docs/adr/flow/.assets/`); their png still embed the pre-P6 minimaps (`ci-automation`), so the
      first render from the yml refreshes them (check: each put and reviewed; the kit's `STYLE.md` sections on the `.drawio.md` visual
      description rewritten to the yml).
- [ ] `Build-Diagrams` stops treating "the one article that embeds the folder" as an input: it finds every article and slide that embeds the
      png, and the supports-drift check holds each one's Supports line against the yml's codes; ADR-REPO-SLIDES-ONEBUILDCOMMAND says so;
      `gallery_pdf.py` prints the yml's `description:` instead of the deleted describe page (check: a second article embedding one of the
      two ado diagrams builds clean; Test-Adr clean). The two ado folders already hold only `diagram.drawio.yml` and the png.
- [ ] Rework the data of every existing diagram's minimaps on the new definition (check: re-render one folder, review, then the rest).
- [ ] Retire `.claude/agents/drawio-png.md`, `.claude/agents/write-drawio-files.md` and `.claude/skills/drawio-model-edit/`, and add one
      yml-editing agent (edits `content:`, runs put in the background under the safeguard, reports the warnings) and one renderer skill
      (put, get, `-FromDrawing`, `-Theme`, `-Stale`); the registry entries in `pwsh/Catzc.Base.Docs/configs/agents.yml` and
      `capabilities.yml` and the agent list in `.claude/CLAUDE.md` change in the same step (check: Test-AgentDefinitions clean;
      `drawio-diagram-waves` and `print-artifacts` call the new skill).

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

## Refs

- `python/Catzc.Diagrams/configs/drawio.yml`, `minimap_render.py` (grid, chain, tree), `minimap_describe.py` (the sister files) and
  `declaration.py` (the yml declaration, put and get).
- `plan-iac-and-repo-placement` authors five explanation diagrams as yml declarations in this plan's format and waits on the renderer steps.
- Memory: minimap-placements-reasoned, diagram-slides-symbols-plus-articles, render-nothing-without-asking.
