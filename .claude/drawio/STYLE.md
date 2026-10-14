# .claude/drawio/STYLE.md

`Maker kit: style for new docs/.assets diagrams`

<!-- cspell:ignore mxGraphModel mxCell guillemets minimap minimaps treemap worldmap mapkey lede weudiscvm nfig -->

The living style kit for the `drawio-diagram-waves` agent and every maker it launches. The lead updates it whenever a review teaches
something.

Tool: `uv run -q --with pillow python .claude/drawio/drawio_png.py <name>.xml <name>.drawio.png`. It embeds the model, draws a preview
raster, and asserts the round-trip. The XML root is
`<mxGraphModel …><root><mxCell id="0"/><mxCell id="1" parent="0"/>…</root></mxGraphModel>`.

## Canvas

```xml
<mxGraphModel dx="1024" dy="768" grid="0" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1"
              pageScale="1" pageWidth="1300" pageHeight="940" background="#E6ECF2" math="0" shadow="0">
```

Keep it at most 1300 wide and grow downward. Flat look: no shadows, no gradients. Every rendered output has the grey-bluish background
`#E6ECF2` drawn first, behind everything else, so a dark-mode and a light-mode viewer show the same page.

## Ids and words

- Ids are semantic kebab/underscore slugs (`title`, `note`, `step-build`, `edge-build-test`). Never random ids.
- Every word comes from the source ADR or code, using its exact terms. Don't invent numbers, parts or loops.
- Stereotypes use guillemets: `<b>Name</b><br><i>&#171;module&#187;</i>`. Cite rules in parentheses, e.g. `(ADR-FLOW-CD:3)`. Write an em
  dash as `&#8212;`.
- The first cell after the root is a `title` text whose words are the finding the reader should leave with, not just the topic.

## Glyphs: one kind, one shape, one colour, one legend phrase

A reader decodes a slide by **shape first** (what kind of thing), **colour second** (structure or state), and the name last. So every kind
of thing has exactly one glyph, the same on every slide of every diagram, and its legend entry always uses the same phrase. A colour never
means two things across slides (grey is not "config" on one slide and "drift" on the next). The verbatim style strings are in
[`glyphs.xml`](glyphs.xml); its preview is `out/diagrams/wave-7/_glyphs.drawio.png`. Copy from there, never retype.

**Structure is dark, state is light.** Structural kinds use draw.io's dark, muted swatches with white text (`fontColor=#FFFFFF`): slate
`#647687` / `#314354`, mauve `#76608a` / `#432d57`, olive `#6d8764` / `#3a5431`. Results, failures and every commit colour are light. The
two families never meet, so no structural glyph can be mistaken for a commit state from the locked palette (ADR-DSGN-VISUAL#4). Slate is
shared by code unit, store and runner on purpose: their shapes (box, cylinder, pill) tell them apart.

| Kind (legend phrase) | Shape                           | Fill / stroke         | Use it for                                                                       |
| -------------------- | ------------------------------- | --------------------- | -------------------------------------------------------------------------------- |
| code unit            | rounded box                     | `#647687` / `#314354` | a module, function, type or script that runs; white text                         |
| named set            | rounded box                     | `#76608a` / `#432d57` | a group, globset, track, aspect or other named collection; white text            |
| file                 | page with a folded corner       | `#6d8764` / `#3a5431` | a config, YAML, manifest or other file read as data (`shape=note`); white text   |
| store                | cylinder                        | `#647687` / `#314354` | the repository, a registry, a cache, a feed (`shape=cylinder3`); white text      |
| runner               | pill                            | `#647687` / `#314354` | a pipeline, stage, task or job that executes (`arcSize=50`); white text          |
| gate                 | rhombus, 3 px rim               | `#f5f5f5` / `#666666` | a check that passes or stops the flow; never red, never yellow                   |
| environment          | hexagon                         | `#f5f5f5` / `#666666` | a deployment target; neutral, coloured only by its occupant (ADR-DSGN-VISUAL#13) |
| external tool        | square box                      | `#f5f5f5` / `#666666` | a vendor tool the code delegates to (az CLI, Bicep, git)                         |
| actor                | circle                          | `#FFFFFF` / `#666666` | a person (developer, reviewer)                                                   |
| result               | rounded box                     | `#9BE7C4` / `#0E9F6E` | what a step produces; font `#0B5C43`                                             |
| failure              | rounded box                     | `#EF9A9A` / `#C62828` | a throw, rejection or discard; the only red                                      |
| ADR-only             | the kind's shape, dashed, white | `#FFFFFF` / `#666666` | something an ADR states that no code runs or checks                              |

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

On a slide that shows commit states, the dark structural kinds never collide with a commit colour. The result (green, near release-uat and
prod) is still avoided there; draw commits as dots.

**Recolouring a wave-6 slide (wave 7):** map by kind and shape, never by hex alone, because the old store, gate, environment and external
tool all shared `#f5f5f5` / `#666666`, and the old code-unit fill `#dae8fc` is also the main-uat commit colour.

| Old fill / stroke                        | Kind                | New fill / stroke (+ `fontColor=#FFFFFF`) |
| ---------------------------------------- | ------------------- | ----------------------------------------- |
| `#dae8fc` / `#6c8ebf` (not a commit dot) | code unit           | `#647687` / `#314354`                     |
| `#e1d5e7` / `#9673a6`                    | named set           | `#76608a` / `#432d57`                     |
| `#f8fff8` / `#82b366`                    | file (`shape=note`) | `#6d8764` / `#3a5431`                     |
| `#f5f5f5` / `#666666`, `shape=cylinder3` | store               | `#647687` / `#314354`                     |
| `#fff2cc` / `#d6b656`, `arcSize=50`      | runner              | `#647687` / `#314354`                     |
| count chip stroke `#9673a6`              | count chip          | stroke `#432d57`, fill stays white        |

Recolour the legend swatch of each kind with it. A `<font color=…>` inside a recoloured cell's value must turn white or be removed. Gate,
environment, external tool, actor, result, failure, ADR-only, chrome and every commit colour stay as they are.

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
  14 px tall, with a caps label cell centred above it. Use it over bands to group stages (CI, CD); never as an edge.

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

## Fan-out: ADR-support drawings with three minimaps

Every lens drawing is republished as an **explanation that supports its ADR(s)**: the committed slides in `docs/.assets/explanation/`, and
the review waves under `out/diagrams/`. A sidebar carries three minimaps showing where the drawing sits: two views of the world map (where
its files are) and the value-chain map (where its ADRs sit in the value chain). The tooling that draws and joins them is
`.claude/drawio/minimaps/`; it places nothing itself.

### The world map (two views, both always shown)

The minimaps draw the **world map** of the world-map processor (module `Catzc.Base.Maps`, ADR-DSGN-TRACK#9), and light the cells and files
that `Get-WorldMapHighlight -Adr <the slide's ADR codes>` returns (ADR-DSGN-TRACK#12), each with its reason.

1. **Grid** (`<stem>.grid.png`). Rows are the tracks and columns the file languages, in the map's order, with the root-file row and the
   unlisted-file column last. A cell that holds files is an idle tile, an empty cell stays open, and every **lit cell** is filled. A cell
   lit only by passing mentions (citations in body comments, not in a file's header or text) is **touched**: filled pale. Only the lit rows
   and columns are named, each with a tick on its axis. The two buckets print as their defined terms, `labels.root_files` and
   `labels.unlisted_files` of `maps.yml` (ADR-DSGN-TRACK#7, #8, #13), never as the map's bucket keys; so does the root-files tile of the
   tree.
2. **Repository tree map** (`<stem>.tree.png`). A treemap of the files of the world map, with area set by file count and grouped by
   top-level folder (`automation/<Module>`, `pipelines/`, `infrastructure/`, `docs/adr/<folder>`, `.github/`, root scripts). The files the
   highlight lights are lit (pale when lit only by passing mentions); a lit ADR file is framed.

### The value-chain map (always shown)

**Value-chain grid** (`<stem>.chain.png`). The **value-chain map** of `Get-ValueChainMap` (ADR-DSGN-TRACK#16), lit by
`Get-ValueChainHighlight -Adr <the slide's ADR codes>`: rows are the **value-chain stack** (`PRIN`, `DSGN`, `AUTO`, `PIPE`, `CLOUD`,
ADR-DSGN-TRACK#14) and columns the **value-chain concerns** (`automation`, `build`, `quality-control`, `release`, `deploy`, `access`,
ADR-DSGN-TRACK#15), both closed sets in their declared order and always all named; the lit rows and columns are named in ink with a tick,
the others in the label grey. Each cell holding ADRs is shaded by its ADR count, from `palette.cell` towards `palette.shade` at most half
strength (so a lit cell always stands out); an empty cell stays open; a lit cell is filled and outlined as on the grid. The top-left corner
prints `value_chain_column_axis`, and `value_chain_row_axis` runs upright along the left edge (`maps.yml` labels).

### The sister `.md` of each minimap

Every minimap PNG has a **sister `.md`** with the same stem, next to it (`<stem>.grid.md`, `<stem>.tree.md`, `<stem>.chain.md`). `render.py`
writes it in the same run, from the same data (`describe.py`), and never by hand. It opens with its path as the H1 (ADR-REPO-FORMAT#6) and
gives **every lit cell or lit group its reason**:

- **World map:** the root folder names the track (ADR-DSGN-TRACK#1), or the file is a root file (#7); the extension names the file language
  (#6), or the file is an unlisted file (#8); then each lit file with the ADR code that selects it, its basis (an ADR file of that code's
  ADR domain, its own citations, its owner module's files through `files.yml`, its globset) and the citing lines with their kind (header,
  body comment, text). A reviewed pin of `maps.yml` is its own reason. A file cited only in body comments is a passing mention, and a cell
  of passing mentions only is marked touched.
- **Tree:** each lit group's folder, then each lit file with its cell and its reason as above.
- **Value chain:** each lit ADR with the code that selects it, its ADR domain's row (#14), its value-chain concerns and whether they are the
  ADR domain's default or the ADR's own override (#15), lit per #12.

Nothing is lit without a reason and no reason stands without a lit cell: `describe.py` checks both per minimap and fails the run on a
mismatch. Links are relative to the `.md`'s folder and point at tracked files, checked when written; the keywords link to the glossary. A
view adds its sections in `describe.py`'s `VIEWS`.

### Colours (minimaps only; drawings keep the palettes above)

- The background and the lit colour come from the `palette` of `maps.yml` (`Get-Config -Config maps`), the same colours as the world-map
  PDFs: `background` `#E6ECF2`, drawn first, and `highlight` `#F4B942`.
- Idle cells and tiles are `#ECEFF1`, with `#CFD8DC` borders. Labels are `#263238`.
- A **lit cell** is filled with the lit colour and outlined `#263238` (2 px at 2×); a **touched** cell is the lit colour at 35 % over the
  idle grey, outlined in the lit colour. Lit tree tiles are the lit colour (45 % for a passing mention); a lit ADR file tile is outlined
  `#263238`.
- The **lens badge** is white text on `#263238`: `META`, `ARCH`, `IMPL`, `OPS` or `GOV`.
- Red never appears in a minimap; it stays reserved for failure inside drawings.
- The lens badge sits on the **grid** minimap only, in its empty top-left corner. On the tree map it would hide tiles.
- A lit file is often a tiny square inside a big group, so its **group tile gets a 3 px edge** in the lit colour as well.
- A row is shorter than its 18 px name, so the names of two lit rows (or upright column names) side by side are moved apart; the tick marks
  the exact row or column.
- The tree layout follows the files of the world map, so re-rendering after the repo changes shifts tiles. Re-render all minimaps together,
  never one by one (below).

### Limits

- **Display:** the drawing is at most 1572 × 1000 px. That's the 1300 px content area plus a 272 px right sidebar, which fits a 1920 × 1080
  screen at 100 %. The minimum height is 360 px; with the sidebar below, a slide is at least 768 px tall.
- **Sidebar** (x 1300–1572; exact geometry, ids fixed; `join.py` lays it out):
  - `minimap-grid` image at x 1316, y 16, 240 × 150;
  - `minimap-tree` image at x 1316, y 182, 240 × 180;
  - `minimap-chain` image at x 1316, y 378, 240 × 150;
  - `lens-badge` at x 1316, y 544, 240 × 24;
  - `supports` (the ADR chips) at x 1316, y 576, 240 × ≤ 46: with the map key fixed at y 626 this holds the bold "Supports" line plus at
    most 2 lines, so pack several ADR codes per line (`ADR-A · ADR-B`) and leave the rest to the `.md`. With more than 4 codes, put the
    first code inline after "Supports" and set the cell at 10.5 px;
  - `mapkey` at x 1316, y 626 (or 8 px below taller ADR chips, which `join.py` sizes at 14 px a line), 240 × 122: the minimap legend, one
    swatch each for a lit cell, a touched cell, a lit file (framed: an ADR file) and a value-chain cell shaded by its ADRs.
- **Minimap PNGs** are rendered at 2× (480 × 300, 480 × 360 and 480 × 300) and placed at 1×. Text is ≥ 9 px at 1×. The grid names a lit row
  by its track and a lit column by its file language, in full; the column names are turned upright. Lit tree groups are labelled with their
  full names, most lit files first; a label may run past its tile (the white halo keeps it legible) and is cut only at the image edge, never
  to a stub like "Module…"; a label that would cover one already printed is left out.
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
  - The minimaps are `<same stem>.grid.png`, `<same stem>.tree.png` and `<same stem>.chain.png`, each with its sister `.md`, next to the
    drawing.

### Who does what, and how to rerun

- Flow A **conforms and renames**: it keeps the content, cuts it to the limits, adds the sidebar placeholders, and picks the explanation
  slug.
- A **slide list** keys the minimap run: a JSON file `{ "slides": [ { "id", "stem", "lens", "adrs": [...], "xml" } ] }` naming each slide's
  ADR codes and its source XML.
- The minimap tooling in `.claude/drawio/minimaps/` runs in three steps from the repository root, each in the background:
  1. `pwsh -NoProfile -File .claude/drawio/minimaps/highlights.ps1 -Slides <slides.json>` asks the map processors and writes the data
     (default `out/minimaps/`);
  2. `uv run -q --with pillow python .claude/drawio/minimaps/render.py --slides <slides.json>` draws the three minimaps and their sister
     `.md` files into the target folder (`--target`, default `docs/.assets/explanation`; `--facts` also writes each slide's sidebar facts,
     `--overview` the full-size tree world map of an `out/` wave);
  3. `uv run -q --with pillow python .claude/drawio/minimaps/join.py --slides <slides.json>` lays out each slide's sidebar in its source
     XML, embeds the three PNGs and builds `<target>/<stem>.drawio.png` (`--start` and `--end` slice the list to fit the time limit).
- An `out/` wave runs the same three steps with `--target out/diagrams/<wave>`.

## Slides and their companions

A fan-out drawing is a **slide**: glyphs on the picture, words in prose. Every slide ships as four files with one stem, side by side:

| File                | Reader                                | Holds                                                                                                  |
| ------------------- | ------------------------------------- | ------------------------------------------------------------------------------------------------------ |
| `<stem>.drawio.png` | everyone                              | the slide: glyphs, names, markers, chips, the legend, and the sidebar (three minimaps and the map key) |
| `<stem>.md`         | a newcomer                            | the **article**: what the slide shows and why it holds, as well-written prose                          |
| `<stem>.visual.md`  | anyone who can't see it, or checks it | the **visual description**: what is drawn, in this kit's terms, with no meaning                        |
| `<stem>.verify.md`  | the lead and reviewers                | the claim → `file:line` → status table, the corrections, and the drift                                 |

The article and the visual description are read by people, so they carry no audit trail: no line numbers in the prose, no claim tables, no
"corrected from wave N", no notes about how the slide was made. All of that lives in `<stem>.verify.md`.

### The article (`<stem>.md`)

Write it as a short explanation article, in the voice of the ADRs: plain English, present tense, active voice, full sentences, one idea per
paragraph. Use the ADR's own terms (and the glossary's), real names in backticks, and "cats" for the system in prose. It reads well with the
image removed.

```markdown
# <the finding, as a sentence-style title>

<Lede: 2–4 sentences. What this part of cats is, what the slide shows about it, and why a reader should care.>

![<alt: the finding in a few words>](<stem>.drawio.png)

## Walkthrough

1. **<Name at marker 1>.** <1–3 sentences: what it is and what it does here.>
2. **<Name at marker 2>.** …

## Why it holds

<A short paragraph, or 2–4 bullets, each restating one ADR rule in plain words with its citation code: "Every dependency is declared before
it is used (ADR-AUTO-DEPM#1).">

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

Describe only what is drawn, never what it means, using this kit's vocabulary: **canvas, drawing area, sidebar, band, span bar, glyph** (by
its legend phrase: code unit, named set, file, store, runner, gate, environment, external tool, actor, result, failure, ADR-only, commit),
**edge** (flow, thick, ADR-only, failure path), **marker, fraction chip, rule chip, legend, map key, grid minimap, tree minimap, value-chain
minimap, lit cell, touched cell, lit tile, lens badge**. Write it after reading the built PNG, and make every count match the XML.

```markdown
# <title>: visual description

**At a glance.** <One paragraph: canvas size, reading direction, the bands, how many glyphs of each kind, where the eye lands first.>

## Reading path

1. <Where the eye starts, by marker number and band.>
2. …

## Glyphs

| Glyph (legend phrase) | Count | Where                              |
| --------------------- | ----- | ---------------------------------- |
| named set             | 3     | top band, middle band, bottom band |

## Edges

| Edge kind | Count | From → to |
| --------- | ----- | --------- |

## Legend

<One sentence on its position, then the entries left to right as a table: swatch → phrase.>

## Sidebar

<The grid minimap's lit and touched cells by name (track × file language), the tree minimap's lit tiles by group label, the value-chain
minimap's lit cells (value-chain stack × value-chain concern), the lens badge, the map key; the facts come from the slide's sister `.md`
files.>
```

### The verification file (`<stem>.verify.md`)

A table of every claim on the slide and in the article: claim → source (`file:line`) → **confirmed / contradicted / ADR-only**, followed by
`## Corrections` (what changed against the previous wave, one line each) and `## Drift` (ADR vs code, one line each). Re-verify every
number, name, path and order against the repository as it is today; the repository moves between waves.

### The slide

**What stays on the slide:**

- the title (the finding, ≤ 60 chars) and a subtitle of the form `<ADR-CODE>:<rules> · <lens>`;
- band labels as one or two caps words (`TOP LAYER`);
- glyph names only: one bold name, ≤ 28 chars, no second line and no stereotype text (the glyph carries the kind). A longer name is elided
  in the middle with `…`, keeping the verb and the last noun (`Assert-Unique…FunctionName`); the article gives it in full;
- an ADR-only gate is the gate rhombus with a thin dashed rim (not 3 px) inside a dashed frame, legend `gate, ADR-only (no code)`;
- numbers as symbols, each shown once: edge fractions (`4/5`, bold, on a white patch) first; a count chip (white pill, box-stroke rim;
  `m-count` in `glyphs.xml`, legend `count chip: <what it counts>`) only for a number no fraction already shows. Leaner wins: a symbol that
  repeats what another symbol says is cut, and the number goes to the `.md`;
- **numbered markers**: a 22 px `#37474F` disc with a 2 px white rim and a white bold digit, on a box's top-left corner or beside an edge.
  Each number is one Walkthrough step in `<stem>.md`. A marker always touches what it numbers (a glyph's corner, or the middle of an edge);
  a marker floating on empty canvas is a defect. An edge marker sits beside its edge with its rim touching the line (disc x = edge x + 2),
  never centred on it: the preview draws edges over every glyph, so a centred disc is struck through. To say "nothing here" (e.g. a rung
  with no throw), draw nothing and say it in the article;
- **span bars** over the bands when the flow has named stages (CI, CD, DEPLOY), as the commit-story's top axis does;
- **every edge that exists in the code is drawn**: a failure glyph has its failure-path edge from the glyph that raises it, a result has the
  edge from what produces it. An unconnected glyph is a defect unless the article says why it stands alone;
- **rule chips** on governance slides: a short white chip (`#3`, or `L4` / `T35` when several ADRs share a slide) beside the box that a rule
  governs, never inside the box name. The legend gives the chips one row that names the letter → ADR mapping. A rule no gate checks gets a
  dashed chip, legend `dashed rule chip: ADR-only (no gate)`.

**Lessons from wave 5 (apply them):**

- Keep markers inside the drawing area: start full-width boxes at x ≥ 40, and inset a marked box ≥ 100 px from its band's left edge so the
  disc does not cover the band label. A marker at x < 20 widens the canvas and shifts the sidebar.
- Legend entries longer than about 40 chars go in column 3, not column 4, or they run into the panel edge.
- A label under a circle that a vertical edge leaves is struck through: put it beside the circle, away from the edge.
- A fraction on a short horizontal edge is struck through by the preview line: put it as a bold chip just above the edge.
- An ADR claim the code contradicts is NOT red (red is failure only). Draw it as its normal glyph with its numbered marker; the article
  states the drift. (Dashes and thick rims already mean "no gate" and "gate".)
- `dashed` means one thing on every slide: "ADR-only: no code runs or checks it" (no gate). Don't reuse dashes for anything else. The
  preview ignores `verticalAlign=bottom` on hexagons: put a commit dot above the centre, never on the centred label. The preview draws a
  dashed hexagon or rhombus solid, so mark those ADR-only with a dashed frame around the shape.
- A generator that rewrites the XML strips the embedded minimaps: after any regeneration, rebuild every slide it wrote.

**What moves to the article:** the lede, every body line, stereotype text, edge labels that are words, footers and side notes. Nothing is
dropped: every word a drawing carried appears in the article or is replaced by a glyph or chip the legend explains.

**Every slide has a proper legend**, a full-width outer panel at the bottom of the drawing area. It has one swatch per glyph, edge kind,
chip and marker on the slide, each with its glyph-library phrase (≤ 8 entries, in columns, kinds before lines before marks). A slide that
needs a phrase the library lacks adds it to `glyphs.xml` and this kit first. A flow edge's legend phrase is
`flow: <its one meaning on this slide>` (e.g. `flow: runs before`, `flow: feeds`); the part after the colon is the only slide-specific
wording in a legend. One arrow never carries two meanings (not "calls; up from a gate: checks"): a second meaning goes to the article, or
the slide is two slides. The minimaps get their own **map key** in the sidebar.

### Landing in `docs/explanation/` (wave 7 onward)

A finished slide lands in the repository as three files; the verify file stays in `out/diagrams/wave-N/` (plan:
`out/plan-diagram-wave-7.md`).

| File                                             | From                   | Shape                                                                                          |
| ------------------------------------------------ | ---------------------- | ---------------------------------------------------------------------------------------------- |
| `docs/explanation/<adr-domain>/<explanation>.md` | the article            | path H1 (ADR-REPO-FORMAT#6), the title in backticks, a `text` overview block, then the article |
| `docs/.assets/explanation/<stem>.drawio.png`     | the built slide        | copied, never overwriting an existing asset                                                    |
| `docs/.assets/explanation/<stem>.drawio.md`      | the visual description | path H1, the title in backticks, a `text` at-a-glance block, then the description              |

- `<explanation>` is the middle part of the stem; `<adr-domain>` is the adrs.yml domain of the stem's ADR code.
- **The `text` overview** of an article: the finding in one line; a blank line; one line per marker, `<n>  <name>  <what it is>`, names
  padded to one column; a blank line; `Supports <ADR-CODE>#a, #b and #c (<lens> lens).` Plain ASCII inside the block (`->`, not `→`).
- **Words by audience:** the article uses the ADR's and glossary's terms (group, module, gate as the ADR names it); the asset description
  uses the glyph library's phrases (named set, code unit). Neither uses the other's vocabulary.
- **Links:** the article links its image and its asset description under `../../.assets/explanation/`, the ADR, its sibling lenses, its
  domain index and `../index.md#how-to-read-the-diagrams`. The asset description links the PNG and the article. ADRs never link to either.
- **Checks:** run `out/diagrams/wave-7/_check_docs.ps1 <paths…>` on your files (formats, then title, markdownlint, spelling, links). Report
  unknown words; never edit `terminology.yml` from a maker. A quoted message holding `<name>`-style placeholders goes in a code span (bare
  angle brackets fail markdownlint MD033). Example names copied from an ADR that are not words (`weudiscvm`) get a local `cspell:ignore`
  line, as the ADR does; never split a word across markup (`Co(nfig)` flags `nfig`).

Quality bar for this format: the wave-7 pilot, `docs/explanation/automation/three-layers-edges-point-down.md` with
`docs/.assets/explanation/adr-auto-depm--three-layers-edges-point-down--architecture.drawio.{png,md}`.

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
both the preview and draw.io. A bent edge (e.g. a return into a gate earlier in the flow) is straight segments between port cells, with
`endArrow=none` on all but the last segment. Several targets one edge enters together share a **frame** (chrome, not a kind: no fill,
`#CFD8DC` 1 px rim, `arcSize=6`); the edge ends on the frame, and the legend needs no row for it.

## Reporting drift found while verifying

Verification regularly finds the ADR, the code or the code comments out of step: a file the ADR names that doesn't exist, a rule the checker
enforces more loosely, a comment citing the wrong rule. Draw the side the brief says (normally what the code does). List every drift in the
reply and the `.verify.md` table. The lead collects these for the user. Never fix them from a maker.

## Layout

- Leave at least 20 px between boxes. A box is as wide as its longest line × 7 px + 24.
- Use `<br>` to break lines yourself.
- Put a legend (an outer-panel box) bottom-right whenever colour carries meaning.
