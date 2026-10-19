---
plan:
  status: active
  value: high
  reviewed: 2026-10-19
  targets: [.claude/drawio, .claude/slides, .claude/drawio/minimaps, docs/adr/azure/.assets/azure-name-assembly/diagram.drawio.png, docs/adr/design/.assets/commit-lifecycle-states/diagram.drawio.png, docs/adr/design/.assets/sync-point/diagram.drawio.png, docs/explanation/automation/.assets/a-declared-allow-list-of-layers/diagram.drawio.png]
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
- A diagram always generates and shows exactly three minimaps, chosen by the diagram; reference diagrams get three from a different
  subset than the explanation diagrams; slides follow the same rules. Minimap data is generated from well-defined functions, never by hand.
- Look stays: the diagrams are liked; the work is the code behind them.
- The layout of a diagram: right column holds three minimaps and the minimap legend (four slots); the left holds header and subheader
  (the ADR list), the diagram, then the diagram legend.
- Minimap redefinition:
  - the legend is simplified, much less text;
  - the tree becomes a more generic view of code locations that still shows which code files are hit, without the static frame
    (docs always big left and top right); the grid is the more correct replacement for it;
  - the chain is renamed **axis**: two relevant axes, the top one build, qc, release, deploy, access, the y one top ADR domains (design
    with principles and thesis, flow, auto, cloud); the value chain leaves it.
- Six more minimaps are proposed to reach nine, each derivable from a function: layer stack, lifecycle position, track placement, engine
  strip, module neighbourhood, actor strip.

## Open steps

- [ ] Move the renderer code from `.claude/drawio` into `python/Catzc.Diagrams`, one file at a time, with its tests (check: pytest on the
      moved tests passes; no import path names `.claude`).
- [ ] Move the slide assets from `.claude/slides` into the module's assets (check: Build-SlideDeck still renders one deck).
- [ ] Define the markdown declaration a diagram and a slide read, one schema, one parser (check: a round trip, md to png and back to the
      same md facts, in a test).
- [ ] Redefine the legend, the tree and the axis as above, and write the sister files from the same data (check: the minimap tests pass;
      each lit cell has its reason).
- [ ] Decide how a diagram chooses its three minimaps (declared in its markdown or derived) and which subset the reference diagrams get
      (check: the answer is recorded here).
- [ ] Pick the six further minimaps with the user and define each one's data function (check: each has a test on its data).
- [ ] Rework the data of every existing diagram's minimaps on the new definition (check: re-render one folder, review, then the rest).
- [ ] Fix the four diagrams below once the steps above are done, one diagram at a time (check: each is re-rendered from its markdown and
      reviewed by the user; blocked on the renderer steps).

## The diagram fix list (waits on the renderer)

- `azure-name-assembly`: far too crowded. Keep the top row. Add a full-width `Resource Name` bracket above it. Cut the middle rows hard.
  Keep the final row of boxed name listings, but move the type names out of the boxes as headers (Resource Groups, Storage, Virtual
  Machine). Rework the legend. Minimaps later.
- `commit-lifecycle-states`: a solid diagram. Move its text into an article; the high-level definitions probably belong in an ADR-FLOW
  ADR, not design. It needs a rename (open: the name and the home).
- `sync-point`: it is about not working from a shared dirty head but taking the latest BVT-verified server HEAD. That head is also the
  next candidate for main-UAT, but the diagram reads as syncing from main-UAT. Make the BVT-verified HEAD the sync source and show the
  main-UAT queue as a separate fact.
- `a-declared-allow-list-of-layers`: it uses Azure as the example and lacks the call through base to the vendor tool (the Az CLI).
  Either an Azure example with all the tools or a vendor-neutral one with the vendor call as the last hop (open: the user picks;
  generalized is probably the choice).

## Refs

- `.claude/drawio/drawio.yml`, `.claude/drawio/minimaps/render.py` (grid, chain, tree) and `describe.py` (the sister files).
- Memory: minimap-placements-reasoned, diagram-slides-symbols-plus-articles, render-nothing-without-asking.
