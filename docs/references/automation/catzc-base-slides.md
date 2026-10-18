---
catzc:
  immutable:
    repo_status: clean
    path: docs/references/automation/catzc-base-slides.md
    folder: docs/references/automation
    name: catzc-base-slides
    filetype: md
    kind: reference
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/adr/repository/slides-as-markdown.md
---

# Catzc.Base.Slides

The slides module. It owns the render of a deck from its slide files through the patterns of the slides kit, and the gate that checks every
slide file against the rules it quotes ([ADR-REPO-SLIDES](../../adr/repository/slides-as-markdown.md)). It deliberately does **not** own the
kit's content, which is authored under `.claude/slides/`, or the publishing of a rendered deck, which a person does after reading the
render.

## Responsibilities

| Responsibility   | Area   | Name                                                                   |
| ---------------- | ------ | ---------------------------------------------------------------------- |
| responsibility:1 | render | [Fail-forward deck render](#responsibility1--fail-forward-deck-render) |
| responsibility:2 | gate   | [The slides quality gate](#responsibility2--the-slides-quality-gate)   |
| responsibility:3 | kit    | [Reading the kit](#responsibility3--reading-the-kit)                   |

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

The module reads the kit from one configured folder, `slides` in the config registry, `.claude/slides` by default: the kit's `slides.yml`
becomes a `SlidesKit` of tokens, faces, scale and layout, and each `patterns/<name>.html` a `SlidePattern` that knows its fields, which are
required and how much each holds. A pattern's placeholders decide what a slide may say; the module changes for no pattern.

## What the module does

A deck kept in a presentation tool is prose nobody can diff, cite or check. Kept as one markdown file per slide, with the layout as a named
pattern and the kit's look declared once, a deck is reviewed like code, a rule it quotes is compared to the registry at every render, and
the published page is a projection that can be rebuilt from the tree at any time.

## Division

The functions the module exports, indexed by the responsibility each serves, and the config the module owns.

| Responsibility                              | Function          |
| ------------------------------------------- | ----------------- |
| responsibility:1 — Fail-forward deck render | `Build-SlideDeck` |
| responsibility:2 — The slides quality gate  | `Test-Slides`     |
| responsibility:3 — Reading the kit          | `slides.yml`      |
