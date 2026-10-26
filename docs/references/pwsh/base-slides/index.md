# Catzc.Base.Slides

The slides module. It owns the render of a deck from its slide files through the patterns of the slides kit, the gate that checks every
slide file against the rules it quotes ([ADR-REPO-SLIDES](../../../drs/repository/slides-as-markdown.md)), and the one command that renders
every draw.io slide of the repository from its source. It deliberately does **not** own the kit's content, which is authored in the
`catzc_diagrams` module of the python track, or the publishing of a rendered deck, which a person does after reading the render.

## Responsibilities

| Responsibility   | Area     | Name                                                                       |
| ---------------- | -------- | -------------------------------------------------------------------------- |
| responsibility:1 | render   | [Fail-forward deck render](#responsibility1--fail-forward-deck-render)     |
| responsibility:2 | gate     | [The slides quality gate](#responsibility2--the-slides-quality-gate)       |
| responsibility:3 | kit      | [Reading the kit](#responsibility3--reading-the-kit)                       |
| responsibility:4 | diagrams | [Diagram render from source](#responsibility4--diagram-render-from-source) |

### responsibility:1 — Fail-forward deck render

`Build-SlideDeck` reads a deck folder, its `deck.md` and every `<stem>.slide.md`, orders the slides by their head's `order`, fills each
one's pattern from the kit, and always writes `out/slides/<deck>/`: the `project/` tree the Slides artifact type reads, the speaker script
in order, and a faults file. A missing or unknown field, an unknown pattern, a gap or a duplicate in the orders, an over-capacity field, a
cited code the ADR index does not know and a quoted rule that differs from the registry are each written beside the render with the file and
the field; nothing shrinks and nothing is guessed. It never publishes.

### responsibility:2 — The slides quality gate

`Test-Slides` runs the same checks over slide files, one at a time, and fails through the quality-gate report. It takes slide files or deck
folders, and with no path checks every slide file under `docs/`.

### responsibility:3 — Reading the kit

The module reads the kit from one configured folder, `slides` in the config registry, `python/diagrams/assets/slides` by default: the kit's
`slides.yml` becomes a `SlidesKit` of tokens, faces, scale and layout, and each `patterns/<name>.html` a `SlidePattern` that knows its
fields, which are required and how much each holds. A pattern's placeholders decide what a slide may say; the module changes for no pattern.

### responsibility:4 — Diagram render from source

Rebuilding a diagram, the pair `<article-folder>/.assets/<name>.drawio.yml` and `<name>.drawio.png`, from what the tree holds: its
declaration, or the model embedded in its png, and the repository's maps, through the draw.io kit's renderer (`drawio_kit` in `slides.yml`,
`python/diagrams` by default), stage by stage. One diagram is one call; the whole tree is that call repeated over every diagram found under
`docs/**/.assets/`, so no session decides anything and a rebuild from a clean checkout gives the same slides. A diagram's article is the one
page beside its `.assets` that embeds the slide: none is an orphan, reported; two stop the run. Moving a diagram moves its pair, with every
relative link into it re-pointed.

## What the module does

A deck kept in a presentation tool is prose nobody can diff, cite or check. Kept as one markdown file per slide, with the layout as a named
pattern and the kit's look declared once, a deck is reviewed like code, a rule it quotes is compared to the registry at every render, and
the published page is a projection that can be rebuilt from the tree at any time.

## Division

The functions the module exports, indexed by the responsibility each serves, and the config the module owns.

| Responsibility                                | Function          |
| --------------------------------------------- | ----------------- |
| responsibility:1 — Fail-forward deck render   | `Build-SlideDeck` |
| responsibility:2 — The slides quality gate    | `Test-Slides`     |
| responsibility:3 — Reading the kit            | `slides.yml`      |
| responsibility:4 — Diagram render from source | `Build-Diagrams`  |
|                                               | `Move-Diagram`    |
|                                               | `Test-Diagrams`   |
