# Maker kit: style for new docs/.assets diagrams

<!-- cspell:ignore mxGraphModel mxCell guillemets minimap minimaps treemap worldmap mapkey lede weudiscvm nfig -->

The living style kit for the `drawio-diagram-waves` agent and every maker it launches. The lead updates it whenever a review teaches
something.

Tool: `uv run -q --with pillow python python/catzc_diagrams/drawio_png.py <name>.xml <name>.drawio.png`. It embeds the model, draws a
preview raster, and asserts the round-trip. The XML root is
`<mxGraphModel …><root><mxCell id="0"/><mxCell id="1" parent="0"/>…</root></mxGraphModel>`.

## Canvas

```xml
<mxGraphModel dx="1024" dy="768" grid="0" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1"
              pageScale="1" pageWidth="1300" pageHeight="940" background="@page" math="0" shadow="1">
```

Keep it at most 1300 wide and grow downward. No gradients. **Every filled shape casts one slight shadow that fades to black**: the model's
`shadow="1"` switches draw.io's shadow on for the whole diagram, every edge carries `shadow=0;` so lines stay flat, and text casts none. The
preview rasters (`drawio_png.py`, the minimaps, the sample renderers) draw the same shadow themselves: the shape's silhouette in black at 30
%, offset 2 px right and 3 px down, blurred 2 px, painted just before the shape. The `page` is drawn first, behind everything else, and
almost all text is `ink` (titles and names on a glyph `title`, quiet text `quiet`).

**Colours are tokens.** A style never names a colour: it names a token as `@<token>` (`fillColor=@slate;`), and put writes the theme's
colour. Every theme is one token set in [`configs/drawio.yml`](../configs/drawio.yml) (`theme-dark`, `theme-light`), the single source of
every value; the first theme, dark, is the committed raster, and any other renders on demand to `out/drawio/themes/<theme>/`.

| Token                   | Used for                                                                         |
| ----------------------- | -------------------------------------------------------------------------------- |
| page                    | the canvas and every rendered output's base layer                                |
| band / band-rim         | band fill / border; band label `band-label`                                      |
| panel / panel-rim       | legend and outer panels                                                          |
| sidebar / sidebar-rim   | the minimap column's backing: a soft sheet above the page, below it all          |
| ink / title             | text; the title and on-glyph names                                               |
| quiet                   | legend text and notes                                                            |
| line                    | flow edges and their arrowheads, the DRS-only dash                               |
| mark / mark-ink         | marker disc fill / digit and rim                                                 |
| chip / chip-rim         | fraction, rule and count chips: fill / rim; text `ink`                           |
| red / red-rim / red-ink | the only red: failure fill / rim and the failure-path edge, failure text         |
| map-\*                  | the minimaps: page, idle cell, rim, lit place and its ink, dim ink, the question |

## Ids and words

- Ids are semantic kebab/underscore slugs (`title`, `note`, `step-build`, `edge-build-test`). Never random ids.
- Every word comes from the source ADR or code, using its exact terms. Don't invent numbers, parts or loops.
- Stereotypes use guillemets: `<b>Name</b><br><i>&#171;module&#187;</i>`. Cite rules in parentheses, e.g. `(FDR-CD-SEPARATEPIPELINEKINDS)`.
  Write an em dash as `&#8212;`.
- The first cell after the root is a `title` text whose words are the finding the reader should leave with, not just the topic.

## Glyphs: one kind, one shape, one colour, one legend phrase

A reader decodes a slide by **shape first** (what kind of thing), **colour second** (structure or state), and the name last. So every kind
of thing has exactly one glyph, the same on every slide of every diagram, and its legend entry always uses the same phrase. A colour never
means two things across slides (grey is not "config" on one slide and "drift" on the next). The verbatim style strings are in
[`glyphs.xml`](glyphs.xml); its preview is `out/diagrams/wave-7/_glyphs.drawio.png`. Copy from there, never retype.

**Structure in mid-tones, state set apart.** Structural kinds use lifted mid-tone fills with a rim of the same hue and `title` names:
`slate` / `slate-rim`, `mauve` / `mauve-rim`, `olive` / `olive-rim`. Neutral kinds are `neutral` with `neutral-rim`. Results and failures
are saturated with a bright rim, and commits keep the locked palette (DDR-VISUAL-FIXEDCOMMITPALETTE), so no structural glyph can be mistaken
for a commit state. Slate is shared by code unit, store and runner on purpose: their shapes (box, cylinder, pill) tell them apart.

| Kind (legend phrase) | Shape                             | Fill / stroke         | Use it for                                                                                      |
| -------------------- | --------------------------------- | --------------------- | ----------------------------------------------------------------------------------------------- |
| code unit            | rounded box                       | slate / slate-rim     | a module, function, type or script that runs; text `title`                                      |
| named set            | rounded box                       | mauve / mauve-rim     | a group, globset, track, aspect or other named collection; text `title`                         |
| file                 | page with a folded corner         | olive / olive-rim     | a config, YAML, manifest or other file read as data (`shape=note`); text `title`                |
| store                | cylinder                          | slate / slate-rim     | the repository, a registry, a cache, a feed (`shape=cylinder3`); text `title`                   |
| runner               | pill                              | slate / slate-rim     | a pipeline, stage, task or job that executes (`arcSize=50`); text `title`                       |
| gate                 | rhombus, 3 px rim                 | neutral / neutral-rim | a check that passes or stops the flow; never red, never yellow; text `ink`                      |
| environment          | hexagon                           | neutral / neutral-rim | a deployment target; neutral, coloured only by its occupant (DDR-VISUAL-ENVIRONMENTISCONTAINER) |
| external tool        | square box                        | neutral / neutral-rim | a vendor tool the code delegates to (az CLI, Bicep, git); text `ink`                            |
| actor                | circle                            | page / neutral-rim    | a person (developer, reviewer); text `ink`                                                      |
| result               | rounded box                       | green / green-rim     | what a step produces; text `title`                                                              |
| failure              | rounded box                       | red / red-rim         | a throw, rejection or discard; the only red; text `red-ink`                                     |
| DRS-only             | the kind's shape, dashed, on page | page / line           | something a decision record states that no code runs or checks; text `ink`                      |

**Source-lens phrases** (the `source` lens, below) are variants of the code unit. They stay in slate, so they add no colour to the budget.
Copy them from `glyphs.xml` (`g-private`, `g-type` + `g-type-tag`, `g-module`):

| Phrase         | Shape                                                  | Fill / stroke                  | Use it for                                                               |
| -------------- | ------------------------------------------------------ | ------------------------------ | ------------------------------------------------------------------------ |
| private helper | code unit, 36 px tall, dark fill, 11 px name           | neutral-deep / slate-rim       | a function in the module's `private/` folder; never dashed; text `ink`   |
| C# type        | code unit with a `C#` tag (26 × 16) on its top-right   | slate / slate-rim, tag on page | a class or record under `types/*.cs`                                     |
| catzc module   | slate frame, no fill, `strokeWidth=1.5`, name top-left | none / slate-rim               | another `Catzc.*` module the drawn code calls; its members sit inside it |
| nested frame   | the same frame inside a frame (`g-module-holder`)      | none / slate-rim               | a holder's part: a track holds its modules, a module holds its members   |

The private helper's dark fill is what sets it apart at preview scale. A dimmer or thinner rim on the code-unit fill was tried in the wave-9
sample and read as identical to a code unit, so the difference is in the fill, never only in the rim. Italic labels don't show in the
preview.

**Count chip and marker placement.** A step marker sits on a box's top-left corner. A count chip sits on the box's bottom-right corner,
overlapping the rim, never on the top edge and never within 40 px of a marker. Both are small numbered shapes, so a chip beside a marker
reads as a second marker.

The slide's own module is a band (chrome), not a `catzc module` frame. `external tool` stays a vendor tool (az, git, dotnet), never a catzc
module.

- **Chrome** is not a kind: band `band` / `band-rim` (`arcSize=3`, label `band-label`), legend and outer panel `panel` / `panel-rim`
  (`arcSize=6`), `ink`, `quiet`, `line`.
- **Colour budget:** at most four kinds on one slide, plus chrome. A fifth kind means the slide is two slides.
- **A drift is not a kind.** An ADR claim the code contradicts is drawn as its normal glyph with a numbered marker; the article states it.

**Commit-lifecycle diagrams** (`commits-quality/`) use ONLY the locked commit palette from DDR-VISUAL-FIXEDCOMMITPALETTE: the `commits:`
block of [`configs/drawio.yml`](../configs/drawio.yml) gives each state (topic, landed, bvt, l3, main-uat, release-uat, prod, discarded) its
fill, stroke and digit ink, the same in every theme. Ghosts use the state fill plus `strokeWidth=1.2;dashed=1;opacity=60;`.

On a slide that shows commit states, the structural kinds never collide with a commit colour. The result (green, near release-uat and prod)
is still avoided there; draw commits as dots.

## Style strings (copy verbatim)

Glyph styles come from [`glyphs.xml`](glyphs.xml). These are the chrome and line strings:

- Band:
  `rounded=1;html=1;arcSize=3;fillColor=@band;strokeColor=@band-rim;verticalAlign=top;align=left;spacingLeft=8;fontStyle=1;fontSize=12;fontColor=@band-label;`
- Title: `text;html=1;align=left;verticalAlign=middle;fontSize=16;fontStyle=1;fontColor=@title;`
- Body/note: `text;html=1;whiteSpace=wrap;align=left;verticalAlign=top;fontSize=11;fontColor=@quiet;`
- Commit dot: `ellipse;html=1;fillColor=<state>;strokeColor=<state>;strokeWidth=1.5;fontStyle=1;fontSize=11;fontColor=<digit>;`, with its
  digit as the value.
- Edge: `edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;fontSize=10;fontColor=@ink;endArrow=block;strokeColor=@line;shadow=0;`. Give it
  `source`/`target` ids and `<mxGeometry relative="1" as="geometry"/>`. An edge label sits on `labelBackgroundColor=@band`.
- Thick edge (to a named set): add `strokeWidth=2.5;`. DRS-only edge: add `dashed=1;`. Failure path: `strokeColor=@red-rim;`, solid.
- Read edge (reads a fact source): `endArrow=open;dashed=1;dashPattern=1 3;`, dotted. Junction edge (where catzc meets a state machine):
  `startArrow=oval;startFill=1;`, solid, with the block arrow.
- Span bar (eac's phase brace and the commit-story's top axis):
  `shape=crossbar;html=1;fillColor=none;strokeColor=@line;strokeWidth=1.5;shadow=0;` 14 px tall, with a caps label cell centred above it.
  Use it over bands to group stages (CI, CD); never as an edge.

## Every diagram: verify, then simplify (applies to ALL makers)

The user's standard, from the wave-1 review: the information must be **verified against the ADR AND the code AND the configs**, and the
picture must be **simple**. A diagram that is only true to the ADR prose is not done.

1. **Verify first.** For every claim in the picture (each box, edge, order, name, parameter, path and number), find its source in the ADR,
   the code (`pwsh/**`, `importer.ps1`, root scripts) and the configs (`configs/*.yml`, pipeline YAML). Write `<name>.verify.md` beside the
   staged folder in `out/diagrams/wave-N/`: a table with the columns claim → source (`file:line`) → **confirmed / contradicted / DRS-only**.
2. **Code wins on facts. The ADR wins on intent.**
   - If the code contradicts the drawing, fix the drawing and report the contradiction.
   - If the decision record states something the code doesn't do yet, keep it only when it's essential to the finding, and mark it DRS-only
     in the table.
   - Never silently "fix" the ADR or the code.
3. **Get the order from the code.** For sequences (load order, precedence, pipeline steps), the call order in the code is the authority.
4. **Real names only.** Every function, parameter, env var, file path and task version must exist exactly as spelled. If the brief names
   something that doesn't exist (e.g. `Build-Catzc`), use the real name and report it.
5. **Hold terminology that is under review.** Don't rename or coin terms. Keep the ADR's current words and flag them. "Build mode" is
   currently being re-split (possibly into cached / installed / saved / temporary), so don't invent states for it.
6. **Then simplify** to the readability rules below. Cut detail into one footer line or leave it to the ADR. A cut is fine; a wrong or
   invented claim is not.

The maker's reply gives: the path, the title, the claim counts (confirmed / contradicted / DRS-only), each contradiction in one line, and
what was cut.

Lessons from wave 4:

- **Run the ADR's own example when it's cheap.** Reading `Get-ConfigValue` passed, but running the ADR's example address threw (a typed
  `Dictionary` has no `Contains`). Run probes in the background behind `timeout <s>`, from a script in your own output folder.
- **Every title is ≤ 60 characters on one line**, not only fan-out drawings. Shorten the brief's draft title when you have to, and say so.
- **Check the result colour.** A fail-open "proceed" result isn't a pipeline/runner, so don't borrow the runner's colour for it. Use the
  neutral glyph unless the palette has a role for it.
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
- **`governance`** (≤ 8 boxes) shows which ADR rule constrains each stage, which gate checks it, and what is DRS-only. It drops mechanics
  and paths.

- Name the files `<name>.<lens>.xml` / `<name>.<lens>.drawio.png`. The title states the lens's finding, e.g. "Meta: …".

### The `source` lens (wave 9 onward)

A sixth lens, drawn from the code alone rather than split from an ADR diagram. It draws one responsibility of one module.

- **`source`** (≤ 10 boxes) shows the module's real public functions, private helpers, `configs/*.yml`, C# types and the other catzc modules
  they call, in call order. Every box is a name that exists today (a Glob hit). Every edge is a call site (`file:line`) in the `.verify.md`,
  and an edge without one is not drawn. It drops ADR wording and rationale.
- **Subtitle:** `Module <Name> · source lens`. The **Supports** chips name the ADRs the drawn code cites (ADR codes in its comments and
  error messages), found by grep, not guessed.
- **Name:** `<finding-slug>` (3–7 kebab words, ≤ 48 chars), with no ADR prefix and no lens suffix. It lands as the pair
  `docs/references/pwsh/<module-kebab>/.assets/<finding-slug>.drawio.yml` and `<finding-slug>.drawio.png`; the verify notes stay in `out/`.
  There is no `docs/explanation/` article: the module's reference article embeds the png under `## What the module does` with a
  one-paragraph lead-in, and carries the words (Reading path, Where the code and the ADR differ).
- **No minimaps** on source slides yet (wave 9 decision D4). The sidebar holds only the lens badge (`SRC`); the ADR codes are in the
  subtitle, their one place on a slide.
- **Save legend rows.** Source slides reach the 8-entry legend cap fast (code unit, private helper, C# type, catzc module, file, failure,
  flow, marker). A glyph and its own edge kind share one row (`failure, and its failure path`). The `catzc module` frame needs no row when
  its label names the module.
- **A gate rhombus holds a name of about 25 characters at 11 px when it is 280 px wide.** Size the rhombus to its name, not to the boxes.
- **A file the code reads has no edge** when the slide's flow means "calls" (the run.json and options.yml precedents). Place the file under
  the code unit that reads it, and say so in the description's Edges section.
- **Name the direction when results flow back.** If the arrows run from a callee to its caller (a result handed up), the legend says
  `flow: feeds (a result to its caller)`, so the reader doesn't take it for a call.
- **Store access is its own edge kind.** A read or write of a store (a `$script:` map, a cache) is not a call. Draw it as a plain line with
  `endArrow=none`, legend `store access (reads or writes)`, and keep the flow edge for calls only. Don't stretch the flow phrase to "uses".
- **`catzc module` covers `Catzc.Internal.*` too.** The `.psm1` modules under `pwsh/.internal/` get the same frame, labelled with the module
  name (`Catzc.Internal.Loader`).
- **Escaping and encoding.** A literal `<Tool>` inside an HTML value is double-escaped (`&amp;lt;Tool&amp;gt;`). A generator script reads
  and writes UTF-8 explicitly (`encoding="utf-8"`), or a replace on `·` silently misses on Windows.
- **One input, many readers.** When one config type feeds three or more readers, frame the readers on one row and end a single edge on the
  frame. Put a second input band (such as the live session) above that row, so its edge drops in without a crossing.
- **Supports holds only the ADRs that govern what is drawn.** Leave out codes the drawn code cites only for parts the slide doesn't draw,
  and list them in the verify file.
- **A module whose members fall in two bands** gets one tall `catzc module` frame spanning both bands, never two frames with the same name.
- **The Supports panel sets only the word `Supports` bold** (`<b>Supports</b>`), with the codes in regular weight at 11 px. Don't set
  `fontStyle=1` on the cell.
- **Fan-in from three or more columns** ends on a wide target box with one port cell above each column, so every edge stays a straight
  vertical in the preview and in draw.io.
- **A named set is named for its members, not for a type** (`access checks`, not `SubscriptionAccessState`), so it isn't read as a C# type.
- **A PowerShell built-in** (`Invoke-Expression`, `Start-Process`) is a code unit, not an `external tool`, which means a vendor tool.
- **A computed type is not a box name.** When the code builds a type it looks up at run time (`$type::new($raw)`), draw a `C# type` glyph
  named for the role (`registered type`) and say in the description that the name varies per config. Don't invent a class name.
- The flow edge means `flow: calls` on a source slide, or `flow: feeds` when data, not control, moves (one meaning per slide).
- Lenses share the source's colour meanings, so a stage keeps its colour across all five.
- If a lens has nothing honest to show (e.g. no operator touches it), draw nothing for it, and say so in the reply.
- **Keep helper scripts in your own output folder** (e.g. `out/diagrams/lenses/<name>/_gen.py`), never under a shared name in the
  scratchpad. Makers run in parallel, and a shared `gen_lenses.py` once let one maker overwrite another's files.
- Lens variants live in `out/diagrams/lenses/<name>/`, one diagram pair per lens; at fan-in the lead reviews them in lens order, and a lens
  with nothing honest to show is listed as skipped.

## Fan-out: ADR-support drawings with three minimaps

A diagram shows exactly three minimaps in its right column, above the minimap legend (ADR-REPO-SLIDES-MINIMAPSFROMDATA). They are the ones
its declaration names in `content.minimaps`, or else its kind's three defaults: each diagram kind, explanation or reference, has a pool of
minimap ids and three defaults, declared once in `maps.yml`. Every id is one of the eight minimaps: `grid`, `code-locations`, `axis`,
`layer-stack`, `lifecycle-position`, `track-placement`, `engine-strip` and `module-neighbourhood`; an id outside them fails validation,
naming the eight.

**The data is computed, never drawn.** A diagram's subject is the ADR codes in its `about.adrs` and the files that cite them.
`Catzc.Base.Maps` projects that subject onto each minimap's axes with the data command `maps.yml` names for its id, reading a registry (the
world map, the value chain, the ADR layers, the rungs, the tracks, the execution engines, the module dependencies), so every lit cell
carries the file and the requested code that light it. The data is contract JSON
(`contracts/catzc/0.0.0/Catzc.Base.Maps/minimap.schema.json`): axes outermost first, every cell with what it holds, and every lit cell with
at least one reason. `Build-Diagrams` and `Test-Diagrams` write it to `out/minimaps/`; the kit validates it against the schema
(`minimap_contract.py`) and only draws it. No minimap file lives beside a diagram: the picture is embedded in the render, and the reasons
travel in the JSON and in the article that embeds the diagram. A diagram whose minimap data is missing does not put.

**Stale minimaps are a report, not a failure.** A tree change that moves what a subject's files cite leaves a committed diagram's minimaps
stale: `Test-Diagrams` lists those diagrams, and `Build-Diagrams -Stale` rebuilds exactly that set.

### Colours (minimaps only; drawings keep the palettes above)

- A minimap has a **page of its own**, `map-page`, a green-grey nuance drawn first, so the three insets read as maps set into the slide and
  never as a fourth band of the `page`. A lit place is `map-lit` with its name in `map-lit-ink`.
- **One lit encoding on every minimap:** a lit cell is filled in the lit colour; an idle cell is `map-panel` with a `map-rim` border, the
  same nuance one step up. Labels are `map-caption` (lit) and `map-dim` (not lit). The minimap legend shows its idle swatch in these minimap
  tokens, not in the slide's band tokens.
- The **lens badge** is `mark-ink` text on `mark`: `META`, `ARCH`, `IMPL`, `OPS` or `GOV`.
- No hue appears inside a minimap beyond its page's green cast: red stays reserved for failure inside drawings, and yellow for the BVT
  commit state.

### Limits

- **Display:** the drawing is at most 1572 × 1000 px. That's the 1300 px content area plus a 272 px right column, which fits a 1920 × 1080
  screen at 100 %. The minimum height is 360 px.
- **Right column** (x 1300–1572): four slots, the three minimaps and the minimap legend, laid out by the renderer from the declaration; no
  ADR codes, since the subtitle is their one place on a diagram.
- **Title:** ≤ 60 chars on one line, 16 px bold, and it states the finding. **Subtitle:** ≤ 120 chars, the ADR codes of `about.adrs`.
- **Boxes:**
  - name ≤ 28 chars;
  - body ≤ 2 lines × 40 chars;
  - edge label ≤ 24 chars;
  - legend ≤ 7 entries;
  - footer ≤ 3 lines × 150 chars.
- **Font sizes:** 10.5 px minimum, 18 px maximum.
- **Names:** a diagram is two flat files in `.assets/`, `<name>.drawio.yml`, its one source, and `<name>.drawio.png`, the render put from
  it; `<name>` is 3–7 kebab words, ≤ 48 chars.

### Who does what, and how to rerun

- A maker writes the `<name>.drawio.yml`: `description:`, `about:` (the lens and the ADR codes), `content:` and, where a cell must sit
  somewhere the grid would not put it, `layout:`.
- `Build-Diagrams -Path <folder>` computes the minimap data and puts the folder; `-FromDrawing` folds a draw.io edit back first;
  `-Theme <name>` renders another theme to `out/drawio/themes/<name>/`; `-Stale` rebuilds the stale set. Each runs in the background under
  the time safeguard, a large set in slices.

## Slides and their companions

A fan-out drawing is a **slide**: glyphs on the picture, words in prose. A slide is one diagram pair, `.assets/<name>.drawio.yml` and
`.drawio.png`, and the pages that embed its png (ADR-REPO-SLIDES-DECLARATION):

| File                                   | Reader                 | Holds                                                                                             |
| -------------------------------------- | ---------------------- | ------------------------------------------------------------------------------------------------- |
| `.assets/<name>.drawio.yml`            | the author, the gates  | the **declaration**: `description:`, `about:` (the ADR codes and the lens), `content:`, `layout:` |
| `.assets/<name>.drawio.png`            | everyone               | the slide put from the declaration: glyphs, names, markers, chips, the legend and the sidebar     |
| `<page>.md`                            | a newcomer             | the **article**: what the slide shows and why it holds, as well-written prose                     |
| `out/diagrams/wave-N/<name>.verify.md` | the lead and reviewers | the claim → `file:line` → status table, the corrections and the drift; it never leaves `out/`     |

The folder holds no markdown: the diagram names no article, any number of pages embed its png, and the build finds them by what embeds it. A
`source` lens slide (below) has no explanation article: its words go into the module's reference article.

The article and the description are read by people, so they carry no audit trail: no line numbers in the prose, no claim tables, no
"corrected from wave N", no notes about how the slide was made. All of that lives in the `.verify.md`.

### The article

`<page>.md`

Write it as a short explanation article, in the voice of the ADRs: plain English, present tense, active voice, full sentences, one idea per
paragraph. Use the ADR's own terms (and the glossary's), real names in backticks, and "cats" for the system in prose. It reads well with the
image removed.

```markdown
# <the finding, as a sentence-style title>

<Lede: 2–4 sentences. What this part of cats is, what the slide shows about it, and why a reader should care.>

![<alt: the finding in a few words>](.assets/<name>.drawio.png)

## Walkthrough

1. **<Name at marker 1>.** <1–3 sentences: what it is and what it does here.>
2. **<Name at marker 2>.** …

## Why it holds

<A short paragraph, or 2–4 bullets, each restating one ADR rule in plain words with its citation code: "Every dependency is declared before
it is used (ADR-AUTO-DEPM-CODEBUILTFROM).">

## Where the code and the ADR differ

<Only when drift exists: one present-tense sentence per drift, saying what the ADR states and what the code does. Omit the section
otherwise.>

## See also

- [<ADR title>](<relative path to the ADR>) — the decision this slide supports.
```

- The Walkthrough follows the markers in reading order; every marker has exactly one step and every step has a marker.
- Numbers appear in the prose where they matter ("26 modules"), not as line references.
- No meta-talk: never "the slide shows…" more than once (in the lede), never "this maker", "wave", "pilot", "preview".

### The description

`description:` in `<name>.drawio.yml`

One or two sentences of what is drawn, never what it means, in this kit's vocabulary: **band, span bar, glyph** (by its legend phrase: code
unit, named set, file, store, runner, gate, environment, external tool, actor, result, failure, DRS-only, commit), **edge** (flow, thick,
DRS-only, failure path, bypass, reads, junction), **gate rule, lane, marker, chip, legend**. Write it after looking at the built png. It
carries no counts, reading path, legend table or minimap facts: `content:` already declares every glyph and edge, put draws the legend and
the sidebar from it, and `Test-Diagrams` fails a png that states other content than its yml, so a hand-written count would be a second copy
that drifts.

```yaml
description: >-
  Three bands left to right: four code units feed a named set, and a gate at the end sends a failure path back to the first band.
```

### The verification file

`out/diagrams/wave-N/<name>.verify.md`

A table of every claim on the slide and in the article: claim → source (`file:line`) → **confirmed / contradicted / DRS-only**, followed by
`## Corrections` (what changed against the previous wave, one line each) and `## Drift` (ADR vs code, one line each). Re-verify every
number, name, path and order against the repository as it is today; the repository moves between waves. It is a review note: it stays beside
the staged folder in `out/`, and nothing in `docs/` links to it.

### The slide

**What stays on the slide:**

- the title (the finding, ≤ 60 chars) and a subtitle of the form `<ADR-CODE>:<rules> · <lens>`;
- band labels as one or two caps words (`TOP LAYER`);
- glyph names only: one bold name, ≤ 28 chars, no second line and no stereotype text (the glyph carries the kind). A longer name is elided
  in the middle with `…`, keeping the verb and the last noun (`Assert-Unique…FunctionName`); the article gives it in full;
- a DRS-only gate is the gate rhombus with a thin dashed rim (not 3 px) inside a dashed frame, legend `gate, DRS-only (no code)`;
- numbers as symbols, each shown once: edge fractions (`4/5`, bold, on a white patch) first; a count chip (white pill, box-stroke rim;
  `m-count` in `glyphs.xml`, legend `count chip: <what it counts>`) only for a number no fraction already shows. Leaner wins: a symbol that
  repeats what another symbol says is cut, and the number goes to the article;
- **numbered markers**: a 22 px `mark` disc with a 2 px `mark-ink` rim and a `mark-ink` bold digit, on a box's top-left corner or beside an
  edge. Each number is one Walkthrough step in the article. A marker always touches what it numbers (a glyph's corner, or the middle of an
  edge); a marker floating on empty canvas is a defect. An edge marker sits beside its edge with its rim touching the line (disc x = edge
  x + 2), never centred on it: marks paint above edges (`layers:` in `drawio.yml`), so a centred disc hides the line it numbers. To say
  "nothing here" (e.g. a rung with no throw), draw nothing and say it in the article;
- **span bars** over the bands when the flow has named stages (CI, CD, DEPLOY), as the commit-story's top axis does;
- **every edge that exists in the code is drawn**: a failure glyph has its failure-path edge from the glyph that raises it, a result has the
  edge from what produces it. An unconnected glyph is a defect unless the article says why it stands alone;
- **rule chips** on governance slides: a short white chip (`#3`, or `L4` / `T35` when several ADRs share a slide) beside the box that a rule
  governs, never inside the box name. The legend gives the chips one row that names the letter → ADR mapping. A rule no gate checks gets a
  dashed chip, legend `dashed rule chip: DRS-only (no gate)`.

**Lessons from wave 5 (apply them):**

- Keep markers inside the drawing area: start full-width boxes at x ≥ 40, and inset a marked box ≥ 100 px from its band's left edge so the
  disc does not cover the band label. A marker at x < 20 widens the canvas and shifts the sidebar.
- Legend entries longer than about 40 chars go in column 3, not column 4, or they run into the panel edge.
- A label under a circle that a vertical edge leaves is struck through: put it beside the circle, away from the edge.
- A fraction on a short horizontal edge is struck through by the preview line: put it as a bold chip just above the edge.
- An ADR claim the code contradicts is NOT red (red is failure only). Draw it as its normal glyph with its numbered marker; the article
  states the drift. (Dashes and thick rims already mean "no gate" and "gate".)
- `dashed` means one thing on every slide: "DRS-only: no code runs or checks it" (no gate). Don't reuse dashes for anything else. The
  preview ignores `verticalAlign=bottom` on hexagons: put a commit dot above the centre, never on the centred label. The preview draws a
  dashed hexagon or rhombus solid, so mark those DRS-only with a dashed frame around the shape.
- A generator that rewrites the XML strips the embedded minimaps: after any regeneration, rebuild every slide it wrote.

**What moves to the article:** the lede, every body line, stereotype text, edge labels that are words, footers and side notes. Nothing is
dropped: every word a drawing carried appears in the article or is replaced by a glyph or chip the legend explains.

**Every slide has a proper legend**, a full-width outer panel at the bottom of the drawing area. It has one swatch per glyph, edge kind,
chip and marker on the slide, each with its glyph-library phrase (≤ 8 entries, in columns, kinds before lines before marks). A slide that
needs a phrase the library lacks adds it to `glyphs.xml` and this kit first. A flow edge's legend phrase is
`flow: <its one meaning on this slide>` (e.g. `flow: runs before`, `flow: feeds`); the part after the colon is slide-specific wording, and
so is a thick edge's phrase, `content.thick` (e.g. `to a truth store`), which replaces `to a named set` when given. One arrow never carries
two meanings (not "calls; up from a gate: checks"): a second meaning goes to the article, or the slide is two slides. The minimaps get their
own **map key** in the sidebar.

### Landing in `docs/explanation/`

An approved slide lands as its pair and its article; the `.verify.md` stays in `out/diagrams/wave-N/`.

| File                                                      | From                             | Shape                                                                                                      |
| --------------------------------------------------------- | -------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| `docs/explanation/<adr-domain>/<explanation>.md`          | the article                      | path H1 (ADR-REPO-FORMAT-MARKDOWNTITLE), the title in backticks, a `text` overview block, then the article |
| `docs/explanation/<adr-domain>/.assets/<name>.drawio.yml` | the staged declaration           | copied, never over an existing file                                                                        |
| `docs/explanation/<adr-domain>/.assets/<name>.drawio.png` | `Build-Diagrams -Path <the yml>` | built in place, never copied, so its minimaps are computed for its address                                 |

- `<adr-domain>` is the drs.yml domain of the slide's first ADR code; `<explanation>` is the finding as a kebab slug.
- **The `text` overview** of an article: the finding in one line; a blank line; one line per marker, `<n>  <name>  <what it is>`, names
  padded to one column; a blank line; `Supports <ADR-CODE>#a, #b and #c (<lens> lens).` Plain ASCII inside the block (`->`, not `→`).
- **Words by audience:** the article uses the ADR's and glossary's terms (group, module, gate as the ADR names it); the declaration's
  `description:` uses the glyph library's phrases (named set, code unit). Neither uses the other's vocabulary.
- **Links:** the article links its image `.assets/<name>.drawio.png`, the ADR, its sibling lenses, its domain index and
  `../index.md#how-to-read-the-diagrams`. The diagram links nothing.
- **Checks:** run `Test-Diagrams -Path <folder>` on the folder, and `Test-Links` and `Test-Spelling` on the article. Report unknown words;
  never edit `terminology.yml` from a maker. A quoted message holding `<name>`-style placeholders goes in a code span (bare angle brackets
  fail markdownlint MD033). Example names copied from an ADR that are not words (`weudiscvm`) get a local `cspell:ignore` line, as the ADR
  does; never split a word across markup (`Co(nfig)` flags `nfig`).

Quality bar for this format: `docs/explanation/automation/three-layers-edges-point-down.md` with its folder
`docs/explanation/automation/.assets/three-layers-edges-point-down/`.

## Readability rules

These come from the wave-1 review. The user rated azure and commits-quality "SUPER" and config-read-path "really bad", and sent
promotion-flow, globset-roles, bundle, importer, dependency-groups, auth and runner back for "simplify and verify".

- **Quality bar:** `docs/drs/flow/.assets/commit-promotion-states.drawio.png`. It has labelled bands, one direction, short boxes, a footer
  of meanings, and a swatch legend. Read it before drawing.
- **Group-level beats module-level.** If the source has dozens of nodes (e.g. dependencies.yml), draw the groups and point to the config for
  the per-node detail.
- **State a rule once.** Put "no fallback", "never rebuilt" and the like in one side note or bracket, never as a marker on every step.
- **Don't fan arrows.** A box that acts on three targets gets one bracket or band around the targets, not three diagonal arrows.
- **Compact forks.** A Mode → task mapping is one 3-row chip group, not three separate paths.

- **One reading direction.** Use left → right (or top → down) bands, as in commit-promotion-states. Never let the flow snake right, then
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
`panel-rim` 1 px rim, `arcSize=6`); the edge ends on the frame, and the legend needs no row for it.

## Reporting drift found while verifying

Verification regularly finds the ADR, the code or the code comments out of step: a file the ADR names that doesn't exist, a rule the checker
enforces more loosely, a comment citing the wrong rule. Draw the side the brief says (normally what the code does). List every drift in the
reply and the `.verify.md` table. The lead collects these for the user. Never fix them from a maker.

## Layout

- Leave at least 20 px between boxes. A box is as wide as its longest line × 7 px + 24.
- Use `<br>` to break lines yourself.
- Put a legend (an outer-panel box) bottom-right whenever colour carries meaning.
