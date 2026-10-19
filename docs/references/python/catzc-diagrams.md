# Catzc.Diagrams

The diagram kit, a module of the python track. It owns the rendering of every `.drawio.png` of the repository from the model embedded in it,
the three minimaps a slide's sidebar carries and their sister pages, and the review bundles a person reads a wave of drawings through
([ADR-REPO-SLIDES](../../adr/repository/slides-as-markdown.md)). It deliberately does **not** decide anything: what a diagram shows comes
from the tree, the maps come from `Catzc.Base.Maps`, and the one command that rebuilds a diagram folder is `Build-Diagrams` of
`Catzc.Base.Slides`.

## Responsibilities

| Responsibility   | Area    | Name                                                                                         |
| ---------------- | ------- | -------------------------------------------------------------------------------------------- |
| responsibility:1 | render  | [Fail-forward render of a drawing](#responsibility1--fail-forward-render-of-a-drawing)       |
| responsibility:2 | minimap | [The minimaps of a slide](#responsibility2--the-minimaps-of-a-slide)                         |
| responsibility:3 | kit     | [The kit: glyphs, tokens and patterns](#responsibility3--the-kit-glyphs-tokens-and-patterns) |
| responsibility:4 | review  | [Review bundles](#responsibility4--review-bundles)                                           |

### responsibility:1 — Fail-forward render of a drawing

A `.drawio.png` carries its own draw.io model. `drawio_png.py` draws the raster from that model on the dark page, so the picture and the
embedded XML stay honest to each other, and `drawio_forward.py` runs that render fail-forward: it always lands a source copy, a result PNG,
the decoded model and a report under `out/drawio/`, forwards every warning, and never stops silently. Over a whole diagram folder it runs in
stages that each fit the time safeguard: prepare, highlight, join.

### responsibility:2 — The minimaps of a slide

A slide's sidebar shows where it sits: two views of the world map and the value-chain map, lit for the ADR codes the slide supports. The
data comes from the map processors through `Export-MinimapData` (`Catzc.Base.Maps`); `minimap_render.py` draws the three PNGs and
`minimap_describe.py` writes the sister page of each, where every lit cell has the reason that lit it, both under `out/drawio/minimaps/`,
never in the tree; `minimap_join.py` lays the sidebar out in the slide's model, embeds the PNGs and rebuilds the slide. The module places
nothing itself: every lit cell is the highlight's.

### responsibility:3 — The kit: glyphs, tokens and patterns

The closed vocabulary every drawing is made of lives in the module's assets: the glyph library (`glyphs.xml`), the template slide, the style
guide (`STYLE.md`) with the dark-theme tokens and the readability rules, the renderer's defaults (`configs/drawio.yml`: page, output folder,
lenses, folder roles), and the slides kit (`assets/slides/`: `slides.yml`, its style guide and the patterns `Build-SlideDeck` fills). A
maker edits a model and reads the guide; the kit draws.

### responsibility:4 — Review bundles

What a wave of drawings produced, printed for a person: the lens contact sheet (`contact_sheet.py`), the local gallery and its PDF for
readers without an HTML viewer (`gallery.py`, `gallery_pdf.py`), the atlas page for claude.ai (`atlas.py`), the catalogue the review page
reads (`catalogue.py`), and the image embedding they share (`embed_images.py`). Every bundle reads what is on disk and lands under `out/`.

## What the module does

A drawing is a build output (ADR-REPO-SLIDES-ONEBUILDCOMMAND). The source is the model embedded in the PNG beside its article; the render
reads that model and the repository's maps, and nothing in between asks a session or a model to decide. So the module is a pipeline of
deterministic steps: decode the model, draw it, compute the slide's facts from its subtitle, ask the maps for the highlights, draw and
describe the minimaps, join them into the sidebar, rebuild the slide, report. A step that fails becomes a warning in the report and the
artifacts still land, so the person always has something to read.

The kit is the module's configuration in the sense of ADR-PRIN-CONFIG: a new glyph is a library entry and a legend phrase, a new lens is a
line in `drawio.yml`, a new slide layout is a pattern file. The scripts know the vocabulary's shape, never its instances. The migration
script, `migrate_dark.py`, is the one-way move of a light-era slide to the dark tokens and leaves with the theme selector the diagram plan
lands.

The tests run from the module's own `tests/` folder through the language bridge, on fixture models in the neutral widget vocabulary, never
on a real drawing.

## Division

The module's scripts and configuration, sorted into the responsibilities above.

| Responsibility                                          | Function                    |
| ------------------------------------------------------- | --------------------------- |
| responsibility:1 — Fail-forward render of a drawing     | `drawio_forward.py`         |
|                                                         | `drawio_png.py`             |
|                                                         | `migrate_dark.py`           |
| responsibility:2 — The minimaps of a slide              | `minimap_render.py`         |
|                                                         | `minimap_describe.py`       |
|                                                         | `minimap_join.py`           |
| responsibility:3 — The kit: glyphs, tokens and patterns | `configs/drawio.yml`        |
|                                                         | `assets/glyphs.xml`         |
|                                                         | `assets/template-slide.xml` |
|                                                         | `assets/STYLE.md`           |
|                                                         | `assets/slides/slides.yml`  |
| responsibility:4 — Review bundles                       | `contact_sheet.py`          |
|                                                         | `gallery.py`                |
|                                                         | `gallery_pdf.py`            |
|                                                         | `atlas.py`                  |
|                                                         | `catalogue.py`              |
|                                                         | `embed_images.py`           |
