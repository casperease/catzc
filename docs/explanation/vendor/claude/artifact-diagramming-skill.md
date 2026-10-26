# The artifact-diagramming skill, met by the drawio.png kit

```text
Claude's artifact-diagramming skill draws inline SVG on a claude.ai page. Cats draws .drawio.png slides through its own kit.
The skill's judgement (draw the mechanism, label the arrows, one figure one claim) is ours already; its SVG mechanics apply
to one place only: a page a session publishes with the Artifact tool. Nothing under docs/ is ever an SVG.

claude.ai page      the Diagram Waves Review page and any ad-hoc page    inline SVG, the skill's mechanics
docs/.assets        every slide an article embeds                         .drawio.png, the kit (python/diagrams/assets/STYLE.md)
```

The `/artifact-diagramming` skill is vendor know-how that Claude Code loads into a session on request. It is not one of our capabilities
under `.claude/skills/`, no robot lists it, and it is never read from a file in this repository. This page says what it teaches, in cats'
own terms, and where each lesson meets or stops at the drawio.png practice our robots and capabilities already follow.

## Two lanes, one judgement

A diagram in cats lives in exactly one of two lanes, and the lane decides which rules draw it.

- **The docs lane.** A diagram is a pair of files in an `.assets/` beside its article: the `<name>.drawio.yml` that declares it element by
  element and the `<name>.drawio.png` put from it, a draw.io model embedded in a PNG, with an article in `docs/explanation/` that narrates
  it. The kit in `python/diagrams/assets/STYLE.md` owns its words, glyphs, colours and sidebar; the kit renderer is the one way its raster
  is made, put from the diagram's yml (`drawio-declaration` step 1). The `drawio-*` skills and `diagram-review` work only in this lane.
- **The page lane.** A claude.ai page a session publishes with the Artifact tool. Today that is the Diagram Waves Review page the
  `artifact-print` skill republishes, plus any page a session draws for a reader at the user's ask. A picture drawn on such a page is inline
  SVG, and the skill's mechanics govern it. The page lane never lands a file under `docs/`, and a review bundle for a reader is a PDF or a
  claude.ai page, never a local HTML file (`drawio-waves` step 3).

The skill's **judgement** carries across both lanes unchanged. Its **mechanics** stop at the page lane.

## What the skill teaches, in our terms

- **A diagram earns its place when a sentence cannot say it faster**
  - In cats: An explanation article narrates one diagram; the diagram shows the mechanism, the Walkthrough says the rest
  - Holds in the docs lane: yes: one article, one diagram, one finding
- **Depict the mechanism, not its name**
  - In cats: Every word comes from the source decision record or code; never invent a number, part or loop (STYLE.md "Ids and words";
    `drawio-waves`)
  - Holds in the docs lane: yes: a maker verifies each claim into `<name>.verify.md`
- **Comparing options? Draw the difference**
  - In cats: A slide's title cell states the finding the reader leaves with, not the topic
  - Holds in the docs lane: yes
- **Match complexity to the stakes**
  - In cats: At most 1300 wide, grow downward; at most 3 rebuilds per maker
  - Holds in the docs lane: yes, as the kit's canvas and the wave budget
- **Label the arrows**
  - In cats: A flow edge is "the one relationship the diagram's legend names"; a thick, dashed or red edge changes that meaning (glyphs
    "Lines and marks")
  - Holds in the docs lane: partly: one relationship per slide is named once in the legend, not on every arrow
- **A legend only when an encoding repeats**
  - In cats: Every slide carries its own legend panel, because the glyph library repeats on every slide
  - Holds in the docs lane: no: the legend is always there, by design
- **One figure, one claim; the caption states it**
  - In cats: The article's heading is the claim, the yml's `description:` is the long caption, the image's alt text repeats the claim
  - Holds in the docs lane: yes
- **Theme with `currentColor` so both themes read the same**
  - In cats: Every rendered output is dark on `#1E2430`; a dark-mode and a light-mode viewer get the same raster (STYLE.md "Canvas")
  - Holds in the docs lane: met by the opposite means: one fixed dark page instead of inherited colour
- **Size by `viewBox`, let CSS scale**
  - In cats: A fixed page of at most 1300 wide; the PNG is the size it is
  - Holds in the docs lane: no: a raster has no `viewBox`
- **Arrowheads are markers or polygons, never images**
  - In cats: Edge styles come verbatim from `glyphs.xml`; copy, never retype
  - Holds in the docs lane: yes, in draw.io's own terms
- **Text 11 to 13 px, short labels**
  - In cats: A dark label on the dark page or text cut by its box is a finding (`drawio-look` step 2)
  - Holds in the docs lane: yes: the look checks it on the raster
- **Align to a grid**
  - In cats: `gridSize="10"`, ids are semantic slugs, markers number the Walkthrough steps
  - Holds in the docs lane: yes
- **Stay self-contained: no script, style or foreign object**
  - In cats: The model is an `mxGraphModel` in a PNG `tEXt` chunk; it round-trips through put and get or it fails (`drawio-declaration`
    step 1)
  - Holds in the docs lane: yes, and stricter: picture and XML must agree
- **Counts, state and meaning**
  - In cats: Counts come from the model, never from the picture (`drawio-look` step 3)
  - Holds in the docs lane: ours only; the skill has no equivalent

Three rows read "no" or "partly". They are not drift. The kit chooses a legend on every slide, a fixed dark page and one named relationship
per slide because a reader decodes a slide shape first, colour second, name last, the same way across every diagram. The skill writes for a
single page a reader sees once. Our docs lane is a library a reader returns to.

## What each skill reads

- **`drawio-waves`**
  - Lane: docs
  - Reads: STYLE.md, `glyphs.xml`, the source decision records
- **`drawio-renderer`**
  - Lane: docs
  - Reads: the diagram's yml, the markdown pages that embed it
- **`drawio-edit`, `drawio-declaration`**
  - Lane: docs
  - Reads: the diagram's `<name>.drawio.yml`, its vocabularies
- **`drawio-look`**
  - Lane: docs
  - Reads: the PNG, against STYLE.md's vocabulary
- **`artifact-print`**
  - Lane: page
  - Reads: the saved page file and the catalogue; it draws nothing, so the skill does not apply to it today
- **a session with `/artifact-diagramming` loaded**
  - Lane: page
  - Reads: the skill, for any SVG it hand-authors on a page

A drone never loads the skill: a job's know-how is a skill of at most 30 lines, registered in `capabilities.yml`, and the vendor skill is
neither. When a page lane job would one day draw, the drawing rule becomes a skill of our own that restates the skill's mechanics in these
terms, the way `drawio-look` restates the kit.

## When to reach for which

1. **A reader needs a picture in the docs.** The docs lane: run `drawio-waves` for a new slide and brief `drawio-edit` for a changed label,
   cell or layout. The user lands the approved file.
2. **A reader needs a picture on a review page.** The page lane: a session loads `/artifact-diagramming`, hand-authors the SVG inside the
   page, and publishes with the Artifact tool. The page is the deliverable; nothing is written under `docs/`.
3. **A picture would say less than a sentence.** Neither lane. Write the sentence.
