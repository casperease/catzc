# The artifact-diagramming skill, met by the drawio.png kit

```text
Claude's artifact-diagramming skill draws inline SVG on a claude.ai page. Cats draws .drawio.png slides through its own kit.
The skill's judgement (draw the mechanism, label the arrows, one figure one claim) is ours already; its SVG mechanics apply
to one place only: a page a session publishes with the Artifact tool. Nothing under docs/ is ever an SVG.

claude.ai page      the Diagram Waves Review page and any ad-hoc page    inline SVG, the skill's mechanics
docs/.assets        every slide an article embeds                         .drawio.png, the kit (python/catzc_diagrams/assets/STYLE.md)
```

The `/artifact-diagramming` skill is vendor know-how that Claude Code loads into a session on request. It is not one of our capabilities
under `.claude/skills/`, no robot lists it, and it is never read from a file in this repository. This page says what it teaches, in cats'
own terms, and where each lesson meets or stops at the drawio.png practice our robots and capabilities already follow.

## Two lanes, one judgement

A diagram in cats lives in exactly one of two lanes, and the lane decides which rules draw it.

- **The docs lane.** A diagram is a folder under an `.assets/` beside its article: the `diagram.drawio.yml` that declares it element by
  element and the `diagram.drawio.png` put from it, a draw.io model embedded in a PNG, with an article in `docs/explanation/` that narrates
  it. The kit in `python/catzc_diagrams/assets/STYLE.md` owns its words, glyphs, colours and sidebar; the kit renderer is the one way its
  raster is made, put from the diagram's yml (`drawio-declaration` step 1). The `drawio-*` capabilities and the three diagram robots work
  only in this lane.
- **The page lane.** A claude.ai page a session publishes with the Artifact tool. Today that is the Diagram Waves Review page the
  `print-artifacts` robot republishes through `artifact-publish`, plus any page a session draws for a reader at the user's ask. A picture
  drawn on such a page is inline SVG, and the skill's mechanics govern it. The page lane never lands a file under `docs/`, and a review
  bundle for a reader is a PDF or a claude.ai page, never a local HTML file (`drawio-waves` step 3).

The skill's **judgement** carries across both lanes unchanged. Its **mechanics** stop at the page lane.

## What the skill teaches, in our terms

| The skill says                                                 | In cats                                                                                                                                       | Holds in the docs lane                                                             |
| -------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------- |
| A diagram earns its place when a sentence cannot say it faster | An explanation article narrates one diagram; the diagram shows the mechanism, the Walkthrough says the rest                                   | yes: one article, one diagram, one finding                                         |
| Depict the mechanism, not its name                             | Every word comes from the source ADR or code; never invent a number, part or loop (STYLE.md "Ids and words"; `drawio-diagram-waves` step 6)   | yes: a maker verifies each claim into `<name>.verify.md`                           |
| Comparing options? Draw the difference                         | A slide's title cell states the finding the reader leaves with, not the topic                                                                 | yes                                                                                |
| Match complexity to the stakes                                 | At most 1300 wide, grow downward; at most 3 rebuilds per maker                                                                                | yes, as the kit's canvas and the wave budget                                       |
| Label the arrows                                               | A flow edge is "the one relationship the diagram's legend names"; a thick, dashed or red edge changes that meaning (glyphs "Lines and marks") | partly: one relationship per slide is named once in the legend, not on every arrow |
| A legend only when an encoding repeats                         | Every slide carries its own legend panel, because the glyph library repeats on every slide                                                    | no: the legend is always there, by design                                          |
| One figure, one claim; the caption states it                   | The article's heading is the claim, the yml's `description:` is the long caption, the image's alt text repeats the claim                      | yes                                                                                |
| Theme with `currentColor` so both themes read the same         | Every rendered output is dark on `#1E2430`; a dark-mode and a light-mode viewer get the same raster (STYLE.md "Canvas")                       | met by the opposite means: one fixed dark page instead of inherited colour         |
| Size by `viewBox`, let CSS scale                               | A fixed page of at most 1300 wide; the PNG is the size it is                                                                                  | no: a raster has no `viewBox`                                                      |
| Arrowheads are markers or polygons, never images               | Edge styles come verbatim from `glyphs.xml`; copy, never retype                                                                               | yes, in draw.io's own terms                                                        |
| Text 11 to 13 px, short labels                                 | A dark label on the dark page or text cut by its box is a finding (`drawio-look` step 2)                                                      | yes: the look checks it on the raster                                              |
| Align to a grid                                                | `gridSize="10"`, ids are semantic slugs, markers number the Walkthrough steps                                                                 | yes                                                                                |
| Stay self-contained: no script, style or foreign object        | The model is an `mxGraphModel` in a PNG `tEXt` chunk; it round-trips through put and get or it fails (`drawio-declaration` step 1)            | yes, and stricter: picture and XML must agree                                      |
| Counts, state and meaning                                      | Counts come from the model, never from the picture (`drawio-look` step 3)                                                                     | ours only; the skill has no equivalent                                             |

Three rows read "no" or "partly". They are not drift. The kit chooses a legend on every slide, a fixed dark page and one named relationship
per slide because a reader decodes a slide shape first, colour second, name last, the same way across every diagram. The skill writes for a
single page a reader sees once. Our docs lane is a library a reader returns to.

## What each robot and capability reads

| Robot or capability                           | Lane | Reads                                                                                            |
| --------------------------------------------- | ---- | ------------------------------------------------------------------------------------------------ |
| `drawio-diagram-waves`, `drawio-waves`        | docs | STYLE.md, `glyphs.xml`, the source decision records                                              |
| `drawio-renderer`                             | docs | the diagram's yml, the markdown pages that embed it                                              |
| `edit-diagram-yml`, `drawio-declaration`      | docs | the diagram's `diagram.drawio.yml`, its vocabularies                                             |
| `drawio-look`                                 | docs | the PNG, against STYLE.md's vocabulary                                                           |
| `print-artifacts`, `artifact-publish`         | page | the saved page file and the catalogue; it draws nothing, so the skill does not apply to it today |
| a session with `/artifact-diagramming` loaded | page | the skill, for any SVG it hand-authors on a page                                                 |

A robot never loads the skill: a robot's know-how is a capability of at most 10 lines, registered in `capabilities.yml`, and the skill is
neither. When a page lane robot would one day draw, the drawing rule becomes a capability of our own that restates the skill's mechanics in
these terms, the way `drawio-look` restates the kit.

## When to reach for which

1. **A reader needs a picture in the docs.** The docs lane: ask `drawio-diagram-waves` for a new slide and `edit-diagram-yml` for a changed
   label, cell or layout. The user lands the approved file.
2. **A reader needs a picture on a review page.** The page lane: a session loads `/artifact-diagramming`, hand-authors the SVG inside the
   page, and publishes with the Artifact tool. The page is the deliverable; nothing is written under `docs/`.
3. **A picture would say less than a sentence.** Neither lane. Write the sentence.
