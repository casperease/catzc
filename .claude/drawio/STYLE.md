# .claude/drawio/STYLE.md

`Maker kit: style for new docs/.assets diagrams`

<!-- cspell:ignore mxGraphModel mxCell guillemets minimap minimaps treemap worldmap -->

The living style kit for the `drawio-diagram-waves` agent and every maker it launches. The lead updates it whenever a review teaches
something.

Tool: `uv run -q --with pillow python .claude/drawio/drawio_png.py <name>.xml <name>.drawio.png`. It embeds the model, draws a preview
raster, and asserts the round-trip. The XML root is
`<mxGraphModel …><root><mxCell id="0"/><mxCell id="1" parent="0"/>…</root></mxGraphModel>`.

## Canvas

```xml
<mxGraphModel dx="1024" dy="768" grid="0" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1"
              pageScale="1" pageWidth="1300" pageHeight="940" background="#ffffff" math="0" shadow="0">
```

Keep it at most 1300 wide and grow downward. Flat look: no shadows, no gradients.

## Ids and words

- Ids are semantic kebab/underscore slugs (`title`, `note`, `step-build`, `edge-build-test`). Never random ids.
- Every word comes from the source ADR or code, using its exact terms. Don't invent numbers, parts or loops.
- Stereotypes use guillemets: `<b>Name</b><br><i>&#171;module&#187;</i>`. Cite rules in parentheses, e.g. `(ADR-FLOW-CD:3)`. Write an em
  dash as `&#8212;`.
- The first cell after the root is a `title` text whose words are the finding the reader should leave with, not just the topic.

## Glyphs: one kind, one shape, one colour, one legend phrase

A reader decodes a slide by **shape first** (what kind of thing), **colour second** (the same kind, confirmed), and the name last. So every
kind of thing has exactly one glyph, the same on every slide of every diagram, and its legend entry always uses the same phrase. A glyph
never borrows another kind's colour, and a colour never means two things across slides (grey is not "config" on one slide and "drift" on
the next). The verbatim style strings are in [`glyphs.xml`](glyphs.xml); its preview is `out/diagrams/wave-6/_glyphs.drawio.png`. Copy
from there, never retype.

| Kind (legend phrase) | Shape                           | Fill / stroke         | Use it for                                                                  |
| -------------------- | ------------------------------- | --------------------- | --------------------------------------------------------------------------- |
| code unit            | rounded box                     | `#dae8fc` / `#6c8ebf` | a module, function, type or script that runs                                |
| named set            | rounded box                     | `#e1d5e7` / `#9673a6` | a group, globset, track, aspect or other named collection of code units     |
| file                 | page with a folded corner       | `#f8fff8` / `#82b366` | a config, YAML, manifest or other file read as data (`shape=note`)          |
| store                | cylinder                        | `#f5f5f5` / `#666666` | the repository, a registry, a cache, a feed (`shape=cylinder3`)             |
| runner               | pill                            | `#fff2cc` / `#d6b656` | a pipeline, stage, task or job that executes (`arcSize=50`)                 |
| gate                 | rhombus, 3 px rim               | `#f5f5f5` / `#666666` | a check that passes or stops the flow; never red, never yellow              |
| environment          | hexagon                         | `#f5f5f5` / `#666666` | a deployment target; neutral, coloured only by its occupant (ADR-DSGN-VISUAL#13) |
| external tool        | square box                      | `#f5f5f5` / `#666666` | a vendor tool the code delegates to (az CLI, Bicep, git)                    |
| actor                | circle                          | `#FFFFFF` / `#666666` | a person (developer, reviewer)                                              |
| result               | rounded box                     | `#9BE7C4` / `#0E9F6E` | what a step produces; font `#0B5C43`                                        |
| failure              | rounded box                     | `#EF9A9A` / `#C62828` | a throw, rejection or discard; the only red                                 |
| ADR-only             | the kind's shape, dashed, white | `#FFFFFF` / `#666666` | something an ADR states that no code runs or checks                         |

- **Chrome** is not a kind: band `#F6F8FA` / `#E1E4E8` (`arcSize=3`), legend and outer panel `#FAFAFA` / `#CFD8DC` (`arcSize=6`), ink
  `#37474F`, quiet ink `#666666`.
- **Colour budget:** at most four kinds on one slide, plus chrome. A fifth kind means the slide is two slides.
- **A drift is not a kind.** An ADR claim the code contradicts is drawn as its normal glyph with a numbered marker; the article states it.

**Commit-lifecycle diagrams** (`commits-quality/`) use ONLY the locked commit palette from ADR-DSGN-VISUAL#4.

| Commit state            | Fill      | Stroke    |
| ----------------------- | --------- | --------- |
| brown topic             | `#C4915C` | `#7A4B25` |
| grey landed             | `#C9CCD1` | `#6B7178` |
| yellow BVT              | `#FFE082` | `#F9A825` |
| blue L3                 | `#64B5F6` | `#1565C0` |
| light-blue main-uat     | `#dae8fc` | `#6c8ebf` |
| light-green release-uat | `#d5e8d4` | `#82b366` |
| green prod              | `#60a917` | `#2D7600` |
| red discarded           | `#EF9A9A` | `#C62828` |

Ghosts use the state fill plus `strokeWidth=1.2;dashed=1;opacity=60;`.

## Style strings (copy verbatim)

Glyph styles come from [`glyphs.xml`](glyphs.xml). These are the chrome and line strings:

- Band:
  `rounded=1;html=1;arcSize=3;fillColor=#F6F8FA;strokeColor=#E1E4E8;verticalAlign=top;align=left;spacingLeft=8;fontStyle=1;fontSize=12;fontColor=#455A64;`
- Title: `text;html=1;align=left;verticalAlign=middle;fontSize=16;fontStyle=1;fontColor=#37474F;`
- Body/note: `text;html=1;whiteSpace=wrap;align=left;verticalAlign=top;fontSize=11;fontColor=#666666;`
- Commit dot: `ellipse;html=1;fillColor=<state>;strokeColor=<state>;strokeWidth=1.5;fontStyle=1;fontSize=11;`, with its digit as the value.
- Edge: `edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;fontSize=10;endArrow=block;strokeColor=#666666;`. Give it `source`/`target` ids and
  `<mxGeometry relative="1" as="geometry"/>`.
- Thick edge (to a named set): add `strokeWidth=2.5;`. ADR-only edge: add `dashed=1;`. Failure path: `strokeColor=#C62828;`, solid.
- Span bar (eac's phase brace and the commit-story's top axis): `shape=crossbar;html=1;fillColor=none;strokeColor=#546E7A;strokeWidth=1.5;`
  14 px tall, with a caps label cell centred above it. Use it over bands to group phases (CI, CD); never as an edge.

## Every diagram: verify, then simplify (applies to ALL makers)

The user's standard, from the wave-1 review: the information must be **verified against the ADR AND the code AND the configs**, and the
picture must be **simple**. A diagram that is only true to the ADR prose is not done.

1. **Verify first.** For every claim in the picture (each box, edge, order, name, parameter, path and number), find its source in the ADR,
   the code (`automation/**`, `importer.ps1`, root scripts) and the configs (`configs/*.yml`, pipeline YAML). Write `<name>.verify.md` next
   to the XML: a table with the columns claim → source (`file:line`) → **confirmed / contradicted / ADR-only**.
2. **Code wins on facts. The ADR wins on intent.**
   - If the code contradicts the drawing, fix the drawing and report the contradiction.
   - If the ADR states something the code doesn't do yet, keep it only when it's essential to the finding, and mark it ADR-only in the
     table.
   - Never silently "fix" the ADR or the code.
3. **Get the order from the code.** For sequences (load order, precedence, pipeline steps), the call order in the code is the authority.
4. **Real names only.** Every function, parameter, env var, file path and task version must exist exactly as spelled. If the brief names
   something that doesn't exist (e.g. `Build-Catzc`), use the real name and report it.
5. **Hold terminology that is under review.** Don't rename or coin terms. Keep the ADR's current words and flag them. "Build mode" is
   currently being re-split (possibly into cached / installed / saved / temporary), so don't invent states for it.
6. **Then simplify** to the readability rules below. Cut detail into one footer line or leave it to the ADR. A cut is fine; a wrong or
   invented claim is not.

The maker's reply gives: the path, the title, the claim counts (confirmed / contradicted / ADR-only), each contradiction in one line, and
what was cut.

Lessons from wave 4:

- **Run the ADR's own example when it's cheap.** Reading `Get-ConfigValue` passed, but running the ADR's example address threw (a typed
  `Dictionary` has no `Contains`). Run probes in the background behind `timeout <s>`, from a script in your own output folder.
- **Every title is ≤ 100 characters on one line**, not only fan-out drawings. Shorten the brief's draft title when you have to, and say so.
- **Check the result colour.** A fail-open "proceed" result isn't a pipeline/runner, so don't borrow `#fff2cc` for it. Use the neutral grey
  unless the palette has a role for it.
- **The time-safeguard limit can change mid-wave.** If the hook denies a call, its message names the current limit. Report the denial, and
  never retry with a larger limit.

## Lens variants (one diagram, five simplifications)

A lens split redraws one diagram as five variants. Each variant is simplified toward one lens. All five **keep the source's flow axis**: the
same reading direction, and the same order of the main flow's stages, so the variants line up side by side. A variant drops what its lens
doesn't need. It never adds claims the source or its sources don't support.

- **`meta`** (≤ 5 boxes) shows the idea and its invariant: what kind of thing this is, and the one rule that holds. It drops every function,
  file, path and parameter name.
- **`architecture`** (≤ 8 boxes) shows the components or layers, their boundaries, and who depends on whom. It drops the call order inside a
  component, and parameters.
- **`implementation`** (≤ 10 boxes) shows the real functions, files, configs and parameters in code order, each verified to a `file:line`.
  It drops rationale and ADR wording.
- **`operations`** (≤ 8 boxes) shows what a person or pipeline runs and sees: entry commands, outputs, failure messages. It drops internals
  nobody operates directly.
- **`governance`** (≤ 8 boxes) shows which ADR rule constrains each stage, which gate checks it, and what is ADR-only. It drops mechanics
  and paths.

- Name the files `<name>.<lens>.xml` / `<name>.<lens>.drawio.png`. The title states the lens's finding, e.g. "Meta: …".
- Lenses share the source's colour meanings, so a stage keeps its colour across all five.
- If a lens has nothing honest to show (e.g. no operator touches it), draw nothing for it, and say so in the reply.
- **Keep helper scripts in your own output folder** (e.g. `out/diagrams/lenses/<name>/_gen.py`), never under a shared name in the
  scratchpad. Makers run in parallel, and a shared `gen_lenses.py` once let one maker overwrite another's files.
- Lens variants live in `out/diagrams/lenses/<name>/`. At fan-in, the lead tiles them for review with
  `uv run -q --with pillow python .claude/drawio/contact_sheet.py out/diagrams/lenses/<name>`, which writes `<name>.sheet.png`: five rows in
  lens order, with a "skipped" row for any missing lens.

## Fan-out: ADR-support drawings with two minimaps

Every lens drawing is republished to `out/diagrams/fan-out/` as an **explanation that supports its ADR(s)**. A sidebar carries two minimaps
showing where the drawing sits in the world.

### The world map (two views, both always shown)

1. **Stack × domain grid** (`.stack.png`). Rows are the system stack, top to bottom: `PRIN` principles (docs/adr/principles) · `DSGN` design
   · `AUTO` automation modules · `PIPE` pipelines and CI · `CLOUD` Azure. Columns are the domains, by function: `LOAD` (importer, run modes,
   module loading) · `CONFIG` · `GLOBS` (globsets, tracks, scopes) · `BUILD` (bundle, aspects, folders, dependencies) · `DEPLOY` (promotion,
   lifecycle, naming, templates) · `ACCESS` (auth, server remote, git). The drawing's main cell is filled and framed; every other cell its
   files touch gets a small neutral dot; its row and column are marked on the axes only.
2. **Repository tree map** (`.tree.png`). A treemap of the real repository, with area set by tracked-file count and grouped by top-level
   folder (`automation/<Module>`, `pipelines/`, `infrastructure/`, `docs/adr/<domain>`, `.github/`, root scripts). The files the drawing
   shows (from its `.verify.md` `file:line` refs and its ADR files) are lit.

### Colours (minimaps only; drawings keep the palettes above)

| Domain column | Hue       |
| ------------- | --------- |
| `LOAD`        | `#5C6BC0` |
| `CONFIG`      | `#FFA726` |
| `GLOBS`       | `#26A69A` |
| `BUILD`       | `#AB47BC` |
| `DEPLOY`      | `#42A5F5` |
| `ACCESS`      | `#EC407A` |

- The background is `#FFFFFF`. Idle cells and tiles are `#ECEFF1`, with `#CFD8DC` borders. Labels are `#546E7A`.
- **Exactly one cell is ever framed:** the **main cell**, the domain hue at 40 % fill with a 3 px stroke at 100 %. Its row and column are
  marked only by a bold axis label and a hue tick, never by tinting the cells: a tinted cross or a hued ring on another cell reads, while
  paging through slides, as the previous slide's selection left behind.
- The 40 % fills (also the map key's "this slide's cell" swatch): `LOAD` `#BEC4E6`, `CONFIG` `#FFDCA8`, `GLOBS` `#A8DBD7`, `BUILD`
  `#DDB5E5`, `DEPLOY` `#B3DBFB`, `ACCESS` `#F7B3CA`. Use the main cell's domain, not the pilot's purple.
- **Touched cells** carry a small `#546E7A` dot (7 px radius at 2×), with no fill and no frame.
- The **you-are-here dot** is `#263238` with a 2 px white ring. Lit tree tiles are the hue of the main cell's domain at 100 %. An ADR file
  tile is outlined `#263238`.
- The **lens badge** is white text on `#263238`: `META`, `ARCH`, `IMPL`, `OPS` or `GOV`.
- Red never appears in a minimap; it stays reserved for failure inside drawings.
- The lens badge sits on the **stack** minimap only. On the tree map it would hide tiles.
- A lit file is often a tiny square inside a big group, so its **group tile gets a 2 px edge** in the hue of its ADR domain as well.
- The tree layout follows `git ls-files`, so re-rendering after the repo changes shifts tiles. Re-render all minimaps together, never one by
  one. The rerun scripts are `out/diagrams/fan-out/_flowB/{worldmap,placements,render}.py`.

### Limits

- **Display:** the drawing is at most 1572 × 1000 px. That's the 1300 px content area plus a 272 px right sidebar, which fits a 1920 × 1080
  screen at 100 %. The minimum height is 360 px.
- **Sidebar** (x 1300–1572; exact geometry, ids fixed):
  - `minimap-stack` image at x 1316, y 16, 240 × 150;
  - `minimap-tree` image at x 1316, y 182, 240 × 180;
  - `lens-badge` at x 1316, y 378, 240 × 24;
  - `supports` (the ADR chips) at x 1316, y 410, 240 × ≤ 46: with the map key fixed at y 460 this holds the bold "Supports" line plus
    at most 2 lines, so pack several ADR codes per line (`ADR-A · ADR-B`) and leave the rest to the `.md`. With more than 4 codes, put the first
    code inline after "Supports" and set the cell at 10.5 px;
  - `mapkey` (the minimap legend: this slide's cell, also touched, a file it shows) at x 1316, y 460, 240 × 122.
- **Minimap PNGs** are rendered at 2× (480 × 300 and 480 × 360) and placed at 1×. Text is ≥ 9 px at 1×. Row labels are ≤ 5 chars and column
  labels ≤ 6 chars. Every lit tree group is labelled with its full name, even when the label runs past its tile (the white halo keeps
  it legible); a label is cut only at the image edge, never to a stub like "Module…".
- **Title:** ≤ 100 chars on one line, 16 px bold, and it states the finding. **Subtitle:** ≤ 120 chars, in the form
  `Supports <ADR-CODE>:<rules> · <lens> lens`.
- **Boxes:**
  - name ≤ 28 chars;
  - body ≤ 2 lines × 40 chars;
  - edge label ≤ 24 chars;
  - legend ≤ 7 entries;
  - footer ≤ 3 lines × 150 chars.
- **Font sizes:** 10.5 px minimum, 18 px maximum.
- **Names:**
  - The drawing is `<adr>--<explanation>--<lens>.drawio.png`. `<adr>` is the main ADR code in lower case (`adr-flow-cd`). `<explanation>` is
    3–7 kebab words, ≤ 48 chars. `<lens>` is one of the five. The whole name is ≤ 90 chars.
  - The minimaps are `minimap-<same stem>.stack.png` and `minimap-<same stem>.tree.png`.

### Who does what

- Flow A **conforms and renames**: it keeps the content, cuts it to the limits, adds the sidebar placeholders, and picks the explanation
  slug.
- Flow B **places and renders** both minimaps.
- Both flows key their work by the manifest id `<diagram>.<lens>` in `out/diagrams/fan-out/_manifest.json`.
- The lead joins them at fan-in: renames the minimaps to the slug, embeds both PNGs as data URIs in the image cells, and rebuilds.

## Slides and their companions

A fan-out drawing is a **slide**: glyphs on the picture, words in prose. Every slide ships as four files with one stem, side by side:

| File                | Reader          | Holds                                                                                                    |
| ------------------- | --------------- | -------------------------------------------------------------------------------------------------------- |
| `<stem>.drawio.png` | everyone        | the slide: glyphs, names, markers, chips, the legend, and the sidebar (both minimaps and the map key)    |
| `<stem>.md`         | a newcomer      | the **article**: what the slide shows and why it holds, as well-written prose                            |
| `<stem>.visual.md`  | anyone who can't see it, or checks it | the **visual description**: what is drawn, in this kit's terms, with no meaning           |
| `<stem>.verify.md`  | the lead and reviewers | the claim → `file:line` → status table, the corrections, and the drift                            |

The article and the visual description are read by people, so they carry no audit trail: no line numbers in the prose, no claim tables, no
"corrected from wave N", no notes about how the slide was made. All of that lives in `<stem>.verify.md`.

### The article (`<stem>.md`)

Write it as a short explanation article, in the voice of the ADRs: plain English, present tense, active voice, full sentences, one idea per
paragraph. Use the ADR's own terms (and the glossary's), real names in backticks, and "cats" for the system in prose. It reads well with
the image removed.

```markdown
# <the finding, as a sentence-style title>

<Lede: 2–4 sentences. What this part of cats is, what the slide shows about it, and why a reader should care.>

![<alt: the finding in a few words>](<stem>.drawio.png)

## Walkthrough

1. **<Name at marker 1>.** <1–3 sentences: what it is and what it does here.>
2. **<Name at marker 2>.** …

## Why it holds

<A short paragraph, or 2–4 bullets, each restating one ADR rule in plain words with its citation code: "Every dependency is declared
before it is used (ADR-AUTO-DEPM#1).">

## Where the code and the ADR differ

<Only when drift exists: one present-tense sentence per drift, saying what the ADR states and what the code does. Omit the section
otherwise.>

## See also

- [<ADR title>](<relative path to the ADR>) — the decision this slide supports.
- [Visual description](<stem>.visual.md) · [Verification](<stem>.verify.md)
```

- The Walkthrough follows the markers in reading order; every marker has exactly one step and every step has a marker.
- Numbers appear in the prose where they matter ("26 modules"), not as line references.
- No meta-talk: never "the slide shows…" more than once (in the lede), never "this maker", "wave", "pilot", "preview".

### The visual description (`<stem>.visual.md`)

Describe only what is drawn, never what it means, using this kit's vocabulary: **canvas, drawing area, sidebar, band, span bar, glyph**
(by its legend phrase: code unit, named set, file, store, runner, gate, environment, external tool, actor, result, failure, ADR-only,
commit), **edge** (flow, thick, ADR-only, failure path), **marker, fraction chip, rule chip, legend, map key, axis minimap, tree minimap,
main cell, touched cell, lit tile, lens badge**. Write it after reading the built PNG, and make every count match the XML.

```markdown
# <title>: visual description

**At a glance.** <One paragraph: canvas size, reading direction, the bands, how many glyphs of each kind, where the eye lands first.>

## Reading path

1. <Where the eye starts, by marker number and band.>
2. …

## Glyphs

| Glyph (legend phrase) | Count | Where                         |
| --------------------- | ----- | ----------------------------- |
| named set             | 3     | top band, middle band, bottom band |

## Edges

| Edge kind | Count | From → to |
| --------- | ----- | --------- |

## Legend

<One sentence on its position, then the entries left to right as a table: swatch → phrase.>

## Sidebar

<The axis minimap's main cell and touched cells by name (row × column), the tree minimap's lit tiles by group label, the lens badge, the
map key.>
```

### The verification file (`<stem>.verify.md`)

A table of every claim on the slide and in the article: claim → source (`file:line`) → **confirmed / contradicted / ADR-only**, followed
by `## Corrections` (what changed against the previous wave, one line each) and `## Drift` (ADR vs code, one line each). Re-verify every
number, name, path and order against the repository as it is today; the repository moves between waves.

### The slide

**What stays on the slide:**

- the title (the finding, ≤ 60 chars) and a subtitle of the form `<ADR-CODE>:<rules> · <lens>`;
- band labels as one or two caps words (`TOP LAYER`);
- glyph names only: one bold name, ≤ 28 chars, no second line and no stereotype text (the glyph carries the kind);
- numbers as symbols, each shown once: edge fractions (`4/5`, bold, on a white patch) first; a count chip (white pill, box-stroke rim)
  only for a number no fraction already shows. Leaner wins: a symbol that repeats what another symbol says is cut, and the number goes
  to the `.md`;
- **numbered markers**: a 22 px `#37474F` disc with a 2 px white rim and a white bold digit, on a box's top-left corner or beside an edge.
  Each number is one Walkthrough step in `<stem>.md`. A marker always touches what it numbers (a glyph's corner, or the middle of an
  edge); a marker floating on empty canvas is a defect. To say "nothing here" (e.g. a rung with no throw), draw nothing and say it in
  the article;
- **span bars** over the bands when the flow has named phases (CI, CD, DEPLOY), as the commit-story's top axis does;
- **every edge that exists in the code is drawn**: a failure glyph has its failure-path edge from the glyph that raises it, a result has
  the edge from what produces it. An unconnected glyph is a defect unless the article says why it stands alone;
- **rule chips** on governance slides: a short white chip (`#3`, or `L4` / `T35` when several ADRs share a slide) beside the box that a
  rule governs, never inside the box name. The legend gives the chips one row that names the letter → ADR mapping.

**Lessons from wave 5 (apply them):**

- Keep markers inside the drawing area: start full-width boxes at x ≥ 40, and inset a marked box ≥ 100 px from its band's left edge so the
  disc does not cover the band label. A marker at x < 20 widens the canvas and shifts the sidebar.
- Legend entries longer than about 40 chars go in column 3, not column 4, or they run into the panel edge.
- A label under a circle that a vertical edge leaves is struck through: put it beside the circle, away from the edge.
- A fraction on a short horizontal edge is struck through by the preview line: put it as a bold chip just above the edge.
- An ADR claim the code contradicts is NOT red (red is failure only). Draw it as its normal glyph with its numbered marker; the article
  states the drift. (Dashes and thick rims already mean "no gate" and "gate".)
- `dashed` means one thing on every slide: "ADR-only: no code runs or checks it" (no gate). Don't reuse dashes for anything else.
  The preview ignores `verticalAlign=bottom` on hexagons: put a commit dot above the centre, never on the centred label.
  The preview draws a dashed hexagon or rhombus solid, so mark those ADR-only with a dashed frame around the shape.
- A generator that rewrites the XML strips the embedded minimaps: after any regeneration, rebuild every slide it wrote.

**What moves to the article:** the lede, every body line, stereotype text, edge labels that are words, footers and side notes. Nothing is
dropped: every word a drawing carried appears in the article or is replaced by a glyph or chip the legend explains.

**Every slide has a proper legend**, a full-width outer panel at the bottom of the drawing area. It has one swatch per glyph, edge kind,
chip and marker on the slide, each with its glyph-library phrase (≤ 8 entries, in columns, kinds before lines before marks). A slide that
needs a phrase the library lacks adds it to `glyphs.xml` and this kit first. The minimaps get their own **map key** in the sidebar.

Quality bar for this format: the wave-6 pilot,
`out/diagrams/wave-6/modules/adr-auto-depm--three-layers-edges-point-down--architecture.{drawio.png,md,visual.md,verify.md}`.

## Readability rules

These come from the wave-1 review. The user rated azure and commits-quality "SUPER" and config-read-path "really bad", and sent
promotion-flow, globset-roles, bundle, importer, dependency-groups, auth and runner back for "simplify and verify".

- **Quality bar:** `docs/.assets/commits-quality/commit-lifecycle-states.drawio.png`. It has labelled bands, one direction, short boxes, a
  footer of meanings, and a swatch legend. Read it before drawing.
- **Group-level beats module-level.** If the source has dozens of nodes (e.g. dependencies.yml), draw the groups and point to the config for
  the per-node detail.
- **State a rule once.** Put "no fallback", "never rebuilt" and the like in one side note or bracket, never as a marker on every step.
- **Don't fan arrows.** A box that acts on three targets gets one bracket or band around the targets, not three diagonal arrows.
- **Compact forks.** A Mode → task mapping is one 3-row chip group, not three separate paths.

- **One reading direction.** Use left → right (or top → down) bands, as in commit-lifecycle-states. Never let the flow snake right, then
  down, then left, then back up.
- **No crossing or long diagonal edges.** If an edge must cross the picture, re-lay out the boxes instead.
- **Boxes: one bold name plus ≤ 2 short lines.** Move detail into one footer note. Don't put an ADR code on every box: give one in the title
  or the band label.
- **Bands with labels** (light containers with a caps-style label, e.g. "PROMOTION LADDER — left → right") group the stages.
- **Colour = meaning, and the legend uses swatches** (a small shape plus its text), not a text-only legend. Gates and checks are NOT red.
  Red is only for failure, throw or discard.
- About 12 boxes at most. More than that means the picture is two pictures, or the detail belongs in the ADR.

## Preview tool caveats

The Pillow preview draws dashed outlines, opacity fades and `<font color>` HTML. It does **not** route edges: they come out as straight
centre-to-centre lines, and draw.io routes them orthogonally on open. Lay boxes out so even straight lines don't cross labels: put connected
boxes in line (same row or same column) wherever possible. When an edge must leave a box off-centre, attach it to an invisible 1 px **port
cell** (`text;html=1;strokeColor=none;fillColor=none;`, id `port-<box>-<side>`) placed on that box's edge. The edge then stays straight in
both the preview and draw.io.

## Reporting drift found while verifying

Verification regularly finds the ADR, the code or the code comments out of step: a file the ADR names that doesn't exist, a rule the checker
enforces more loosely, a comment citing the wrong rule. Draw the side the brief says (normally what the code does). List every drift in the
reply and the `.verify.md` table. The lead collects these for the user. Never fix them from a maker.

## Layout

- Leave at least 20 px between boxes. A box is as wide as its longest line × 7 px + 24.
- Use `<br>` to break lines yourself.
- Put a legend (an outer-panel box) bottom-right whenever colour carries meaning.
