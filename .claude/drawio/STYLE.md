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
              pageScale="1" pageWidth="1300" pageHeight="940" background="#1E2430" math="0" shadow="1">
```

Keep it at most 1300 wide and grow downward. No gradients. **Every filled shape casts one slight shadow that fades to black**: the model's
`shadow="1"` switches draw.io's shadow on for the whole diagram, every edge carries `shadow=0;` so lines stay flat, and text casts none. The
preview rasters (`drawio_png.py`, the minimaps, the sample renderers) draw the same shadow themselves: the shape's silhouette in `#000000`
at 30 %, offset 2 px right and 3 px down, blurred 2 px, painted just before the shape. Every rendered output is **dark**: the background
`#1E2430` (dark grey with blue in it) is drawn first, behind everything else, and almost all text is a soft light grey `#CDD3DC` (titles and
names on a glyph `#DDE2E9`, quiet text `#949FAE`), so a dark-mode and a light-mode viewer show the same page.

**Dark-theme tokens** (the single source; every value below and in [`glyphs.xml`](glyphs.xml) comes from here):

| Token     | Value                 | Used for                                                                      |
| --------- | --------------------- | ----------------------------------------------------------------------------- |
| page      | `#1E2430`             | the canvas and every rendered output's base layer                             |
| band      | `#262E3B` / `#3A4555` | band fill / border; band label `#B0BAC7`                                      |
| panel     | `#222A36` / `#3A4555` | legend and outer panels                                                       |
| sidebar   | `#2E2823` / `#453C33` | the minimap column's backing: a soft brown sheet above the page, below it all |
| ink       | `#CDD3DC`             | text; title and on-glyph names `#DDE2E9`                                      |
| quiet ink | `#949FAE`             | legend text and notes                                                         |
| line      | `#AAB4C3`             | flow edges and their arrowheads, chip rims, the ADR-only dash                 |
| marker    | `#E6EAF0` / `#1E2430` | marker disc fill / digit and rim (a light disc on the dark page)              |
| chip      | `#262E3B` / `#AAB4C3` | fraction, rule and count chips: fill / rim; text `#CDD3DC`                    |
| red       | `#8E2424` / `#E57373` | the only red: failure fill / rim and the failure-path edge (`#E57373`)        |

## Ids and words

- Ids are semantic kebab/underscore slugs (`title`, `note`, `step-build`, `edge-build-test`). Never random ids.
- Every word comes from the source ADR or code, using its exact terms. Don't invent numbers, parts or loops.
- Stereotypes use guillemets: `<b>Name</b><br><i>&#171;module&#187;</i>`. Cite rules in parentheses, e.g. `(ADR-FLOW-CD#3)`. Write an em
  dash as `&#8212;`.
- The first cell after the root is a `title` text whose words are the finding the reader should leave with, not just the topic.

## Glyphs: one kind, one shape, one colour, one legend phrase

A reader decodes a slide by **shape first** (what kind of thing), **colour second** (structure or state), and the name last. So every kind
of thing has exactly one glyph, the same on every slide of every diagram, and its legend entry always uses the same phrase. A colour never
means two things across slides (grey is not "config" on one slide and "drift" on the next). The verbatim style strings are in
[`glyphs.xml`](glyphs.xml); its preview is `out/diagrams/wave-7/_glyphs.drawio.png`. Copy from there, never retype.

**Structure in mid-tones, state set apart.** On the dark page, structural kinds use lifted mid-tone fills with a light rim of the same hue
and soft light names (`fontColor=#DDE2E9`): slate `#4E6378` / `#9FB3C8`, mauve `#6A567E` / `#B9A6CC`, olive `#5B7653` / `#A9C29F`. Neutral
kinds are a dark fill with a light rim. Results and failures are saturated with a bright rim, and commits keep the locked palette
(ADR-DSGN-VISUAL#4), so no structural glyph can be mistaken for a commit state. Slate is shared by code unit, store and runner on purpose:
their shapes (box, cylinder, pill) tell them apart.

| Kind (legend phrase) | Shape                             | Fill / stroke         | Use it for                                                                         |
| -------------------- | --------------------------------- | --------------------- | ---------------------------------------------------------------------------------- |
| code unit            | rounded box                       | `#4E6378` / `#9FB3C8` | a module, function, type or script that runs; text `#DDE2E9`                       |
| named set            | rounded box                       | `#6A567E` / `#B9A6CC` | a group, globset, track, aspect or other named collection; text `#DDE2E9`          |
| file                 | page with a folded corner         | `#5B7653` / `#A9C29F` | a config, YAML, manifest or other file read as data (`shape=note`); text `#DDE2E9` |
| store                | cylinder                          | `#4E6378` / `#9FB3C8` | the repository, a registry, a cache, a feed (`shape=cylinder3`); text `#DDE2E9`    |
| runner               | pill                              | `#4E6378` / `#9FB3C8` | a pipeline, stage, task or job that executes (`arcSize=50`); text `#DDE2E9`        |
| gate                 | rhombus, 3 px rim                 | `#2C3542` / `#C7D0DB` | a check that passes or stops the flow; never red, never yellow; text `#CDD3DC`     |
| environment          | hexagon                           | `#2C3542` / `#C7D0DB` | a deployment target; neutral, coloured only by its occupant (ADR-DSGN-VISUAL#13)   |
| external tool        | square box                        | `#2C3542` / `#C7D0DB` | a vendor tool the code delegates to (az CLI, Bicep, git); text `#CDD3DC`           |
| actor                | circle                            | `#1E2430` / `#C7D0DB` | a person (developer, reviewer); text `#CDD3DC`                                     |
| result               | rounded box                       | `#2E7D5B` / `#7FD3AE` | what a step produces; text `#DDE2E9`                                               |
| failure              | rounded box                       | `#8E2424` / `#E57373` | a throw, rejection or discard; the only red; text `#EFD4D4`                        |
| ADR-only             | the kind's shape, dashed, on page | `#1E2430` / `#AAB4C3` | something an ADR states that no code runs or checks; text `#CDD3DC`                |

**Source-lens phrases** (the `source` lens, below) are variants of the code unit. They stay in slate, so they add no colour to the budget.
Copy them from `glyphs.xml` (`g-private`, `g-type` + `g-type-tag`, `g-module`):

| Phrase         | Shape                                                  | Fill / stroke                      | Use it for                                                                 |
| -------------- | ------------------------------------------------------ | ---------------------------------- | -------------------------------------------------------------------------- |
| private helper | code unit, 36 px tall, dark fill, 11 px name           | `#2F3B4A` / `#9FB3C8`              | a function in the module's `private/` folder; never dashed; text `#CDD3DC` |
| C# type        | code unit with a `C#` tag (26 × 16) on its top-right   | `#4E6378` / `#9FB3C8`, tag on page | a class or record under `types/*.cs`                                       |
| catzc module   | slate frame, no fill, `strokeWidth=1.5`, name top-left | none / `#9FB3C8`                   | another `Catzc.*` module the drawn code calls; its members sit inside it   |

The private helper's dark fill is what sets it apart at preview scale. A dimmer or thinner rim on the code-unit fill was tried in the wave-9
sample and read as identical to a code unit, so the difference is in the fill, never only in the rim. Italic labels don't show in the
preview.

**Count chip and marker placement.** A step marker sits on a box's top-left corner. A count chip sits on the box's bottom-right corner,
overlapping the rim, never on the top edge and never within 40 px of a marker. Both are small numbered shapes, so a chip beside a marker
reads as a second marker.

The slide's own module is a band (chrome), not a `catzc module` frame. `external tool` stays a vendor tool (az, git, dotnet), never a catzc
module.

- **Chrome** is not a kind: band `#262E3B` / `#3A4555` (`arcSize=3`, label `#B0BAC7`), legend and outer panel `#222A36` / `#3A4555`
  (`arcSize=6`), ink `#CDD3DC`, quiet ink `#949FAE`, lines `#AAB4C3`.
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
| red discarded           | `#8E2424` | `#E57373` |

Ghosts use the state fill plus `strokeWidth=1.2;dashed=1;opacity=60;`. A commit's digit is dark ink `#1E2430` on the light states and on
brown, and `#DDE2E9` on red and green.

On a slide that shows commit states, the structural kinds never collide with a commit colour. The result (green, near release-uat and prod)
is still avoided there; draw commits as dots.

**Recolouring a slide to the dark theme:** map by kind and shape, never by hex alone, using the glyph table above, and recolour each kind's
legend swatch with it. A `<font color=…>` inside a cell's value turns to the kind's text colour or is removed. The commit colours stay,
except red.

## Style strings (copy verbatim)

Glyph styles come from [`glyphs.xml`](glyphs.xml). These are the chrome and line strings:

- Band:
  `rounded=1;html=1;arcSize=3;fillColor=#262E3B;strokeColor=#3A4555;verticalAlign=top;align=left;spacingLeft=8;fontStyle=1;fontSize=12;fontColor=#B0BAC7;`
- Title: `text;html=1;align=left;verticalAlign=middle;fontSize=16;fontStyle=1;fontColor=#DDE2E9;`
- Body/note: `text;html=1;whiteSpace=wrap;align=left;verticalAlign=top;fontSize=11;fontColor=#949FAE;`
- Commit dot: `ellipse;html=1;fillColor=<state>;strokeColor=<state>;strokeWidth=1.5;fontStyle=1;fontSize=11;fontColor=<digit>;`, with its
  digit as the value.
- Edge: `edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;fontSize=10;fontColor=#CDD3DC;endArrow=block;strokeColor=#AAB4C3;shadow=0;`. Give it
  `source`/`target` ids and `<mxGeometry relative="1" as="geometry"/>`. An edge label sits on `labelBackgroundColor=#1E2430`.
- Thick edge (to a named set): add `strokeWidth=2.5;`. ADR-only edge: add `dashed=1;`. Failure path: `strokeColor=#E57373;`, solid.
- Span bar (eac's phase brace and the commit-story's top axis):
  `shape=crossbar;html=1;fillColor=none;strokeColor=#AAB4C3;strokeWidth=1.5;shadow=0;` 14 px tall, with a caps label cell centred above it.
  Use it over bands to group stages (CI, CD); never as an edge.

## Every diagram: verify, then simplify (applies to ALL makers)

The user's standard, from the wave-1 review: the information must be **verified against the ADR AND the code AND the configs**, and the
picture must be **simple**. A diagram that is only true to the ADR prose is not done.

1. **Verify first.** For every claim in the picture (each box, edge, order, name, parameter, path and number), find its source in the ADR,
   the code (`automation/**`, `importer.ps1`, root scripts) and the configs (`configs/*.yml`, pipeline YAML). Write
   `<name>.drawio.verify.md` next to the XML: a table with the columns claim → source (`file:line`) → **confirmed / contradicted /
   ADR-only**.
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
- **`governance`** (≤ 8 boxes) shows which ADR rule constrains each stage, which gate checks it, and what is ADR-only. It drops mechanics
  and paths.

- Name the files `<name>.<lens>.xml` / `<name>.<lens>.drawio.png`. The title states the lens's finding, e.g. "Meta: …".

### The `source` lens (wave 9 onward)

A sixth lens, drawn from the code alone rather than split from an ADR diagram. It draws one responsibility of one module.

- **`source`** (≤ 10 boxes) shows the module's real public functions, private helpers, `configs/*.yml`, C# types and the other catzc
  modules they call, in call order. Every box is a name that exists today (a Glob hit). Every edge is a call site (`file:line`) in the
  `.drawio.verify.md`, and an edge without one is not drawn. It drops ADR wording and rationale.
- **Subtitle:** `Module <Name> · source lens`. The **Supports** chips name the ADRs the drawn code cites (ADR codes in its comments and
  error messages), found by grep, not guessed.
- **Stem:** `<finding-slug>` (3–7 kebab words, ≤ 48 chars), with no ADR prefix and no lens suffix. It lands at
  `docs/.assets/references/automation/<module-kebab>/<stem>.drawio.png` with `<stem>.drawio.md` and `<stem>.drawio.verify.md`. There is no
  `docs/explanation/` article: the module's reference article embeds the slide under `## What the module does` with a one-paragraph
  lead-in, and the `.drawio.md` carries the words (At a glance, Reading path, Glyphs, Edges, Legend, Where the code and the ADR differ).
- **No minimaps** on source slides yet (wave 9 decision D4). The sidebar holds only the lens badge (`SRC`) and the Supports chips. With
  no minimaps the panel has room, so put one ADR code per line: two codes joined by ` · ` (about 40 characters) overflow the 240 px panel at
  11 px. Grow the `supports` cell's height to fit.
- **Save legend rows.** Source slides reach the 8-entry legend cap fast (code unit, private helper, C# type, catzc module, file, failure,
  flow, marker). A glyph and its own edge kind share one row (`failure, and its failure path`). The `catzc module` frame needs no row
  when its label names the module.
- **A gate rhombus holds a name of about 25 characters at 11 px when it is 280 px wide.** Size the rhombus to its name, not to the boxes.
- **A file the code reads has no edge** when the slide's flow means "calls" (the run.json and options.yml precedents). Place the file
  under the code unit that reads it, and say so in the description's Edges section.
- **Name the direction when results flow back.** If the arrows run from a callee to its caller (a result handed up), the legend says
  `flow: feeds (a result to its caller)`, so the reader doesn't take it for a call.
- **Store access is its own edge kind.** A read or write of a store (a `$script:` map, a cache) is not a call. Draw it as a plain line
  with `endArrow=none`, legend `store access (reads or writes)`, and keep the flow edge for calls only. Don't stretch the flow phrase
  to "uses".
- **`catzc module` covers `Catzc.Internal.*` too.** The `.psm1` modules under `automation/.internal/` get the same frame, labelled
  with the module name (`Catzc.Internal.Loader`).
- **Escaping and encoding.** A literal `<Tool>` inside an HTML value is double-escaped (`&amp;lt;Tool&amp;gt;`). A generator script reads
  and writes UTF-8 explicitly (`encoding="utf-8"`), or a replace on `·` silently misses on Windows.
- **One input, many readers.** When one config type feeds three or more readers, frame the readers on one row and end a single edge
  on the frame. Put a second input band (such as the live session) above that row, so its edge drops in without a crossing.
- **Supports holds only the ADRs that govern what is drawn.** Leave out codes the drawn code cites only for parts the slide doesn't
  draw, and list them in the verify file.
- **A module whose members fall in two bands** gets one tall `catzc module` frame spanning both bands, never two frames with the same
  name.
- **The Supports panel sets only the word `Supports` bold** (`<b>Supports</b>`), with the codes in regular weight at 11 px. Don't set
  `fontStyle=1` on the cell.
- **Fan-in from three or more columns** ends on a wide target box with one port cell above each column, so every edge stays a straight
  vertical in the preview and in draw.io.
- **A named set is named for its members, not for a type** (`access checks`, not `SubscriptionAccessState`), so it isn't read as a C#
  type.
- **A PowerShell built-in** (`Invoke-Expression`, `Start-Process`) is a code unit, not an `external tool`, which means a vendor tool.
- **A computed type is not a box name.** When the code builds a type it looks up at run time (`$type::new($raw)`), draw a `C# type` glyph
  named for the role (`registered type`) and say in the description that the name varies per config. Don't invent a class name.
- The flow edge means `flow: calls` on a source slide, or `flow: feeds` when data, not control, moves (one meaning per slide).
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
that `Get-WorldMapHighlight -Adr <the slide's ADR codes>` returns (ADR-DSGN-TRACK#12), each with its reason. A minimap answers "where does
this slide sit", not "how dense is the map": no cell is shaded by its count. The counts belong to the full maps (the world-map PDFs; a full
value-chain view is still to come). A minimap lights the repository's citations of the slide's ADRs, never the slide's own words: the files
under `docs/.assets/` (the slide descriptions and the minimaps' sister files), `docs/explanation/` (the articles the slides illustrate) and
`.claude/drawio/` (this tooling) cite nothing for the highlight (`maps.yml` `highlight.citation_exclude`); they still sit in their cell.

1. **Grid** (`<stem>.grid.png`). Rows are the tracks and columns the file languages, in the map's order, with the root-file row and the
   unlisted-file column last. Every cell is an idle grey box, empty ones included, and every **lit cell** is filled in the lit colour. A
   cell lit only by passing mentions (citations in body comments, not in a file's header or text) is **touched**: the lighter lit colour.
   Only the lit rows and columns are named, each with a tick on its axis: a row by its track (the root-file row by `labels.root_files`,
   ADR-DSGN-TRACK#7, #13), a column by a short horizontal code, the file language's first extension (`.ps1`, `.md`; `other` for the unlisted
   files, ADR-DSGN-TRACK#8). The codes of neighbouring lit columns alternate between two lines so they never touch.
2. **Repository tree map** (`<stem>.tree.png`). A treemap of the files of the world map, with area set by file count and grouped by
   top-level folder (`automation/<Module>`, `pipelines/`, `infrastructure/`, `docs/adr/<folder>`, `.github/`, root scripts). Every tile is
   idle grey; the files the highlight lights are lit (the lighter lit colour when lit only by passing mentions); a lit ADR file has a dark
   rim in the page colour.

### The value-chain map (always shown)

**Value-chain grid** (`<stem>.chain.png`). The **value-chain map** of `Get-ValueChainMap` (ADR-DSGN-TRACK#16), lit by
`Get-ValueChainHighlight -Adr <the slide's ADR codes>`: rows are the **value-chain stack** (`PRIN`, `DSGN`, `AUTO`, `PIPE`, `CLOUD`,
ADR-DSGN-TRACK#14) and columns the **value-chain concerns** (ADR-DSGN-TRACK#15), both closed sets in their declared order and always all
named by capital codes, horizontal: a row by its code, a column by the initials of a hyphenated concern or else the whole concern in
capitals, never truncated (`BUILD`, `QC`, `RELEASE`, `DEPLOY`, `ACCESS`). The column codes sit on **one line**, centred over their columns.
The `automation` concern has **no column**: the stack's `AUTO` row already names it, so the minimap prints five columns, and the sister
`.md` and the map key describe those five. `describe.py` (`HIDDEN_CONCERNS`, `shown_chain`) hides it in one place, so the picture, the
sister `.md` and the key never disagree; the concern stays declared in `adrs.yml` and is lit on the full maps. The lit rows and columns are
named in ink with a tick, the others in the label grey. Every cell is an idle grey box, empty ones included; a lit cell is filled in the lit colour. The axis titles are not
printed on the minimap: the map key and the sister `.md` name the axes and expand the codes.

### The sister `.md` of each minimap

Every minimap PNG has a **sister `.md`** with the same stem, next to it (`<stem>.grid.md`, `<stem>.tree.md`, `<stem>.chain.md`). `render.py`
writes it in the same run, from the same data (`describe.py`), and never by hand. It opens with its path as the H1 (ADR-REPO-FORMAT#6),
states once that every unlit cell is idle and why a cell holds nothing (no file of that track and file language; no ADR's value-chain
concern lands there), expands the minimap's short codes under **Key**, and gives **every lit cell or lit group its reason**:

- **World map:** the root folder names the track (ADR-DSGN-TRACK#1), or the file is a root file (#7); the extension names the file language
  (#6), or the file is an unlisted file (#8); then each lit file with the ADR code that selects it, its basis (the ADR's own file, only that
  one file: an ADR's domain picks only its value-chain row, never extra world-map files; its own citations, its owner module's files through
  `files.yml`, its globset) and the citing lines with their kind (header, body comment, text). A reviewed pin of `maps.yml` is its own
  reason. A file cited only in body comments is a passing mention, and a cell of passing mentions only is marked touched.
- **Tree:** each lit group's folder, then each lit file with its cell and its reason as above.
- **Value chain:** each lit ADR with the code that selects it, its ADR domain's row (#14), its value-chain concerns and whether they are the
  ADR domain's default or the ADR's own override (#15), lit per #12.

Nothing is lit without a reason and no reason stands without a lit cell: `describe.py` checks both per minimap and fails the run on a
mismatch. Links are relative to the `.md`'s folder and point at tracked files, checked when written; the keywords link to the glossary. A
view adds its sections in `describe.py`'s `VIEWS`.

### Colours (minimaps only; drawings keep the palettes above)

- A minimap has a **page of its own**, a dark green-grey nuance `#1C2A24`, drawn first, so the three insets read as maps set into the slide
  and never as a fourth band of the page (`#1E2430`). The lit colour comes from the `palette` of `maps.yml` (`Get-Config -Config maps`), the
  same as the world-map PDFs: `highlight`, the light ink `#E6EAF0`, which the PDFs use for a lit cell's outline.
- **One lit encoding on all three minimaps:** a lit cell or file is filled in the lit colour; lit by passing mentions only, in the lit
  colour at 40 % over the idle cell. One map-key entry covers both on the grid, the tree and the value-chain map.
- Idle cells and tiles are `#243229`, with `#3B4D43` borders, the same nuance one step up. Labels are `#CDD3DC` (lit) and `#949FAE` (not
  lit). The map key on the slide shows its idle swatch in these minimap tokens, not in the slide's band tokens.
- A lit ADR file tile on the tree has a 1 px rim in the minimap page colour `#1C2A24` (a dark ring on the light tile).
- The **lens badge** is dark text `#1E2430` on `#E6EAF0`: `META`, `ARCH`, `IMPL`, `OPS` or `GOV`.
- No hue appears inside a minimap beyond its page's green cast: red stays reserved for failure inside drawings, and yellow for the BVT
  commit state.
- The lens badge sits on the **grid** minimap only, in its empty top-left corner. On the tree map it would hide tiles.
- A lit file is often a tiny square inside a big group, so its **group tile gets a 3 px edge** in the lit colour as well.
- A row is shorter than its 18 px name, so the names of two lit rows side by side are moved apart; the tick marks the exact row.
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
  - `mapkey` at x 1316, y 626 (or 8 px below taller ADR chips, which `join.py` sizes at 14 px a line), 240 × 170: the minimap legend, one
    swatch each shared by all three minimaps (lit; lit by passing mentions only; a lit ADR file, dark rim; idle), then the key to the short
    labels (grid columns: a file language's first extension; value-chain rows: the value-chain stack; the abbreviated value-chain columns).
- **Minimap PNGs** are rendered at 2× (480 × 300, 480 × 360 and 480 × 300) and placed at 1×. Text is ≥ 9 px at 1×. Every label is
  horizontal: the grid names a lit row by its track and a lit column by its short code; the value-chain map names every row and column by
  its capital code. Lit tree groups are labelled with their full names, most lit files first; a label may run past its tile (the page-colour
  halo keeps it legible) and is cut only at the image edge, never to a stub like "Module…"; a label that would cover one already printed is
  left out.
- **Title:** ≤ 60 chars on one line, 16 px bold, and it states the finding. **Subtitle:** ≤ 120 chars, in the form
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

| File                      | Reader                                | Holds                                                                                                  |
| ------------------------- | ------------------------------------- | ------------------------------------------------------------------------------------------------------ |
| `<stem>.drawio.png`       | everyone                              | the slide: glyphs, names, markers, chips, the legend, and the sidebar (three minimaps and the map key) |
| `<stem>.md`               | a newcomer                            | the **article**: what the slide shows and why it holds, as well-written prose                          |
| `<stem>.drawio.md`        | anyone who can't see it, or checks it | the **visual description** (landed as the asset description): what is drawn, with no meaning           |
| `<stem>.drawio.verify.md` | the lead and reviewers                | the claim → `file:line` → status table, the corrections, and the drift                                 |

A `source` lens slide (below) has no `<stem>.md` article: its words go into the module's reference article and its `<stem>.drawio.md`.

The article and the visual description are read by people, so they carry no audit trail: no line numbers in the prose, no claim tables, no
"corrected from wave N", no notes about how the slide was made. All of that lives in `<stem>.drawio.verify.md`.

### The article

`<stem>.md`

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
- [Visual description](<stem>.drawio.md) · [Verification](<stem>.drawio.verify.md)
```

- The Walkthrough follows the markers in reading order; every marker has exactly one step and every step has a marker.
- Numbers appear in the prose where they matter ("26 modules"), not as line references.
- No meta-talk: never "the slide shows…" more than once (in the lede), never "this maker", "wave", "pilot", "preview".

### The visual description

`<stem>.drawio.md`

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

The sidebar stands on its own backing, the `sidebar` token: one flat rectangle (`sidebar-bg`, no shadow) from 12 px left of the minimaps to
the page edge, lowest in the z-order, so the column reads as a region apart from the bands. `join.py` draws it and the slide template
carries it; the three minimaps, the lens badge, the ADR chips and the map key sit on it.

<The grid minimap's lit and touched cells by name (track × file language), the tree minimap's lit tiles by group label, the value-chain
minimap's lit cells (value-chain stack × value-chain concern), the lens badge, the map key; the facts come from the slide's sister `.md`
files.>
```

### The verification file

`<stem>.drawio.verify.md`

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
- **numbered markers**: a 22 px `#E6EAF0` disc with a 2 px `#1E2430` rim and a `#1E2430` bold digit, on a box's top-left corner or beside an
  edge. Each number is one Walkthrough step in `<stem>.md`. A marker always touches what it numbers (a glyph's corner, or the middle of an
  edge); a marker floating on empty canvas is a defect. An edge marker sits beside its edge with its rim touching the line (disc x = edge
  x + 2), never centred on it: the preview draws edges over every glyph, so a centred disc is struck through. To say "nothing here" (e.g. a
  rung with no throw), draw nothing and say it in the article;
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
`#3A4555` 1 px rim, `arcSize=6`); the edge ends on the frame, and the legend needs no row for it.

## Reporting drift found while verifying

Verification regularly finds the ADR, the code or the code comments out of step: a file the ADR names that doesn't exist, a rule the checker
enforces more loosely, a comment citing the wrong rule. Draw the side the brief says (normally what the code does). List every drift in the
reply and the `.verify.md` table. The lead collects these for the user. Never fix them from a maker.

## Layout

- Leave at least 20 px between boxes. A box is as wide as its longest line × 7 px + 24.
- Use `<br>` to break lines yourself.
- Put a legend (an outer-panel box) bottom-right whenever colour carries meaning.
