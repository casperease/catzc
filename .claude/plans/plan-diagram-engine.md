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
      docs/adr/design/commit-lifecycle.md,
      docs/adr/azure/.assets/azure-name-assembly/diagram.drawio.png,
      docs/adr/design/.assets/commit-lifecycle-states/diagram.drawio.png,
      docs/adr/design/.assets/sync-point/diagram.drawio.png,
      docs/explanation/automation/.assets/a-declared-allow-list-of-layers/diagram.drawio.png,
    ]
---

# The diagram engine: a correct, reproducible minimapper and slider, then the diagram fixes

The diagram and slide code is proof of concept and lives in `.claude/drawio` and `.claude/slides`. It becomes one module,
`python/Catzc.Diagrams`, whose only input is markdown: a person or an LLM edits the markdown declarations, runs the renderer, and gets
`.drawio.png` files with correct XML and rendering, and slides. The minimaps are redefined first; the diagram fix list waits for that.

## Why its value is high

Every diagram and slide depends on it, and the fix list below cannot be judged until the renderer is correct.

## Decided (2026-10-19, from the user)

- Home: `python/Catzc.Diagrams`, with the slide patterns, `STYLE.md` and `slides.yml` as its assets; `.claude` keeps only the agents and
  skills that call it.
- The source of a diagram is a markdown file beside its `.drawio.png`, in the same `.assets/<name>/` folder; functions take only markdown.
- The look stays: the diagrams are liked; the work is the code behind them. A diagram has a right column of four slots (three minimaps and
  the minimap legend) and a left side of header and subheader (the ADR list), the diagram, then the diagram legend.
- A diagram always shows exactly three minimaps, declared in its markdown head as a `minimaps:` list of three ids; the renderer validates
  the count and each id, and the diagram kind (explanation or reference) supplies the default three. Slides follow the same rules.
- Minimap data is generated from well-defined functions, never drawn by hand.
- The nine minimaps: grid, code locations, axis, and six more (layer stack, lifecycle position, track placement, engine strip, module
  neighbourhood, actor strip), each derived from a function over a config.
- Two pools, overlapping on the grid: explanation diagrams pick from axis, lifecycle position, layer stack, actor strip and grid; reference
  diagrams pick from code locations, track placement, engine strip, module neighbourhood and grid.
- Redefinitions: the legend is simplified, much less text; the tree becomes the more generic **code locations** view that still shows which
  code files are hit, without the static frame (the grid is the more correct replacement for the old tree); the chain is renamed **axis**
  with two relevant axes, build, qc, release, deploy, access across and the top ADR domains (design with principles and thesis, flow, auto,
  cloud) down, and the value chain leaves it.
- `commit-lifecycle-states`: the whole ADR `docs/adr/design/commit-lifecycle.md` (ADR-DSGN-LIFE) moves to `docs/adr/flow`, the diagram is
  renamed `commit-promotion-states`, and its text goes into an article.
- `a-declared-allow-list-of-layers` is generalized: vendor-neutral layers with the call through base to the vendor tool as the last hop; the
  Azure case (Az CLI) becomes one worked example in its article.

## Open steps

- [ ] Move the renderer code from `.claude/drawio` into `python/Catzc.Diagrams`, one file at a time, with its tests (check: pytest on the
      moved tests passes; no import path names `.claude`).
- [ ] Move the slide assets from `.claude/slides` into the module's assets (check: Build-SlideDeck still renders one deck).
- [ ] Define the markdown declaration a diagram and a slide read, with the `minimaps:` list, one schema, one parser (check: a round trip, md
      to png and back to the same md facts, in a test).
- [ ] Redefine the legend, code locations and axis as above, and write the sister files from the same data (check: the minimap tests pass;
      each lit cell has its reason).
- [ ] Build the six further minimaps, each with its data function and a test on its data, and the two pools as the kind defaults (check:
      each minimap renders from its function with no hand-drawn cell).
- [ ] Rework the data of every existing diagram's minimaps on the new definition (check: re-render one folder, review, then the rest).
- [ ] Fix the four diagrams below once the steps above are done, one diagram at a time (check: each is re-rendered from its markdown and
      reviewed by the user; blocked on the renderer steps).
- [ ] Move ADR-DSGN-LIFE to `docs/adr/flow` with `Update-AdrCitation` re-citing its codes (check: Test-Adr and Test-Links clean).

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
- Memory: minimap-placements-reasoned, diagram-slides-symbols-plus-articles, render-nothing-without-asking.
