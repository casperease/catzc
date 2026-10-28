# Slides kit: patterns, fields and the writing rules for a deck

The kit that `Build-SlideDeck` renders a deck from ([ADR-REPO-SLIDES](../../../../docs/drs/repository/slides-as-markdown.md)). A deck is a
folder of slide files; a slide file names one pattern from `patterns/` and fills its fields; the shared look is `slides.yml`. This page says
what the patterns are and how a slide is written. The values live in `slides.yml` only and are not repeated here.

## The canvas and the format

A slide is one `<section>` on a 1920 × 1080 px canvas with a 128 px gutter, in the Slides artifact type's slide format: every style inline,
px lengths, hex colours, flex or grid layout, `<h1>` to `<h3>`, `<p>`, lists, tables, `<x-shape>`, and one `<aside>` of speaker notes as the
section's last child. A pattern is that section with placeholders. Every pattern is dark: its background is one of the three dark tokens,
and no light background exists.

## Placeholders

A pattern holds two kinds of placeholder.

- **Kit values**, `{{@token.<name>}}`, `{{@face.<name>}}`, `{{@scale.<name>}}`, `{{@layout.<name>}}`: read from `slides.yml`. Two more are
  derived per slide: `{{@id}}`, the slide file's stem, and `{{@page}}`, its position in the deck.
- **Fields**, filled from the slide file. An inline field, `{{title}}`, takes one line of text and is required; `{{eyebrow?}}` with a `?` is
  optional, and the element that holds an absent optional field is removed. A block field is an element with `data-field="<name>"` whose
  children are templates: the renderer clones the child marked `data-item` once per paragraph, list item or table row of the field, filling
  `{{item}}` with the item's text and `{{item.lead}}` with its leading bold phrase when the template asks for one; a `<tr>` template clones
  its one `<td>` or `<th>` per cell, filling `{{cell}}`; `data-item="header"` is the template for a table's header row; an element marked
  `data-separator` is placed between consecutive items. `data-max` is the block's capacity in items and `data-max-words` its capacity in
  words; a field over either is a render fault, and nothing shrinks. A block field marked `data-optional` may be absent. An optional field
  that fills an attribute, `src="{{image?}}"`, removes the element holding the attribute when it is absent, and any other element marked
  `data-optional`, such as a `<figure>`, is removed once the fields it held are gone.

The title of a slide is its level-one heading, so `{{title}}` is never a `## Title` field. Format-Code writes a comment head into each
pattern file; the renderer strips HTML comments before it fills a pattern.

## The patterns

- **`cover`**
  - What it is for: The first slide: the deck's name and its one-sentence promise.
  - Fields: `eyebrow`, title, `body`, `footer?`, `notes?`
  - Capacity: body 1 × 30 words
- **`divider`**
  - What it is for: The first slide of a section.
  - Fields: `eyebrow`, title, `body`, `notes?`
  - Capacity: body 1 × 45 words
- **`statement`**
  - What it is for: The one claim the deck turns on, set apart on the raised tone.
  - Fields: `eyebrow`, title, `lead`, `body?`, `notes?`
  - Capacity: lead 1 × 45, body 1 × 45
- **`rule`**
  - What it is for: One rule or one idea, stated in prose.
  - Fields: `eyebrow`, title, `body`, `notes?`
  - Capacity: body 2 × 70 words
- **`pair`**
  - What it is for: Two things set side by side as cards.
  - Fields: `eyebrow`, title, `cards` (lead + text each), `body?`, `notes?`
  - Capacity: cards 2 × 45 each, body 1 × 50
- **`tiles`**
  - What it is for: A small set of short items shown as a grid.
  - Fields: `eyebrow`, title, `body?`, `tiles`, `notes?`
  - Capacity: tiles 8 × 6 words
- **`table`**
  - What it is for: Rows that pair a thing with where it lives, or a prefer-over list.
  - Fields: `eyebrow`, title, `rows` (a markdown table), `body?`, `notes?`
  - Capacity: rows 6 + header, 3 columns
- **`stack`**
  - What it is for: Layers that depend only on the one below.
  - Fields: `eyebrow`, title, `layers` (lead = the role, text = the members), `notes?`
  - Capacity: layers 6 × 12 words
- **`closing`**
  - What it is for: The last slide: what rests on this, and the sentence to leave with.
  - Fields: `eyebrow`, title, `lead`, `body?`, `notes?`
  - Capacity: lead 1 × 45, body 1 × 60
- **`fact`**
  - What it is for: One checkable proposition of an x-of-y show, beside the diagram that cites its rule when one does.
  - Fields: `eyebrow`, title, `lead`, `image?`, `caption?`, `notes?`
  - Capacity: lead 1 × 45, image 640 wide

A `fact` slide's picture is optional. It shows a catalogue diagram only when that diagram's declaration cites the rule the slide's eyebrow
names, and a slide with no such diagram has no `## Image`, no `## Caption` and no `picture` in its head: its text takes the full width. The
picture is made by `slide_png.py`: the head's `picture` in mode `reduce`, `zoom` or `redraw` (a named variation), viewed by `tilt` and
`rotate`.

Backgrounds: `cover` and `rule` sit on `bg`; `pair`, `tiles`, `table`, `stack` and `fact` on `bg_deep`; `divider`, `statement` and `closing`
on `bg_raised`. A deck that alternates patterns alternates tones by itself.

## The slide file

```markdown
---
catzc:
  edges:
    cites: [PDR-EAC-DIFFABLEISVERSIONED]
  config:
    pattern: rule
    deck: product-thesis
    order: 14
    quotes: PDR-EAC-DIFFABLEISVERSIONED
---

# If it can be diffed, it belongs in version control

## Eyebrow

PDR-EAC-DIFFABLEISVERSIONED · Everything as code

## Body

If an artifact can be diffed, reviewed, and rolled back it belongs in version control. Prefer tools that store their configuration as files
over UIs, databases, or proprietary formats.

## Notes

Rule two is the test. If it can be diffed, reviewed and rolled back, it belongs in version control.
```

A field heading is the field's name with a capital, `## Body` for `body`, `## Cards` for `cards`. A `cards`, `layers` or `tiles` field is a
list; an item's leading `**bold**` is its lead. A `rows` field is a markdown table whose first row is the header. `Notes` is plain text a
person reads aloud; it is never a second copy of the body. A field that fills an attribute, the `## Image` of a `fact` or `image` slide,
holds one markdown link whose text is the file's stem, and the attribute takes its target:

```markdown
## Image

[ask-the-coordinator](.assets/ask-the-coordinator.png)
```

A bare path or anything else there is a render fault naming the slide file.

## Writing a slide

- **One claim per slide.** The title states it as a sentence; the body carries it; nothing on the slide repeats the title.
- **Cite the code.** A slide that states a rule carries the code in its eyebrow and in the head's `cites`, and quotes the registry's text
  verbatim; the renderer reports any drift. A slide that paraphrases a rule does not quote it, and says so in its notes.
- **Words, not numbers.** A count or a list on a slide is traceable to a registry, an index paragraph or a config file; nothing is
  estimated.
- **Plain English, present tense,** the authoring conventions of the ADR index. No "it's not X, it's Y" drama, no changelog words.
- **Under capacity.** A body over its words is two slides, not a smaller font.
- **Notes are the voice.** The notes say what the presenter adds, in plain English. A dialect, a joke or a performance is not kept in the
  tree.

The head's `config` takes `pattern`, `deck` and `order`, and `quotes` when the body is one rule's text taken verbatim from its ADR: the
render compares the body to the registry and reports any difference. A slide that paraphrases a rule carries no `quotes`.

## The deck folder

`docs/explanation/<domain>/<deck>/` holds `deck.md`, the deck file, and the slide files. The deck file's level-one heading is the deck's
title; its `## Sections` list has one item per section, `- <id of the first slide>: <one sentence>`; the prose the deck is the visual of
follows under its own headings. The order is the `order` head key, never a prefix in the name; a gap or a duplicate is a render fault.

## Rendering and publishing

`Build-SlideDeck -Deck <folder>` writes `out/slides/<deck>/project/deck.json`, one `project/slides/<id>.html` per slide and
`<deck>.script.md`, and reports every fault beside them. `Test-Slides` runs the same checks per file as a gate. Publishing the `project/`
tree to the Slides artifact is a step a person takes after reading the render; nothing publishes on its own.

## Adding a pattern

One new `patterns/<name>.html`, one section with placeholders as above, dark, within the type scale, and one row in the table on this page.
The renderer changes for no pattern.
