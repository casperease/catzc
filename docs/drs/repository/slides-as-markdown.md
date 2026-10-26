# ADR-REPO-SLIDES: slides as markdown files, rendered through patterns

## Rules: ADR-REPO-SLIDES

### Rule ADR-REPO-SLIDES-SLIDEFILE

A **slide file** is one markdown file per slide, `<stem>.slide.md`, in a deck folder `docs/explanation/<domain>/<deck>/` beside the **deck
file**, `deck.md`, which names the deck's title and its sections. The slide's level-one heading is its title, and each level-two heading is
a **field** the slide's pattern fills. The head's `config` carries `pattern`, `deck` and `order`; the order is a head key, never a prefix in
the name ([ADR-REPO-FOLDERS-STABLEFILENAMES](conventional-folders.md#rule-adr-repo-folders-stablefilenames)), and a gap or a duplicate in a
deck's orders is a render failure.

- [One file, one slide](#one-file-one-slide)

### Rule ADR-REPO-SLIDES-PATTERN

A **pattern** is one file, `patterns/<name>.html` in the slides kit, the `assets/slides` folder of the `catzc_diagrams` module of the python
track: one section in the slide format whose placeholders name its fields and say which are required. A slide names its pattern in its head.
Adding a layout is a new pattern file and one line in the kit's `STYLE.md`, never a change to the renderer
([PDR-CONFIG-VARYINGBEHAVIOURISCONFIG](../principles/configure-not-program.md#rule-pdr-config-varyingbehaviourisconfig),
[PDR-CONFIG-NEWINSTANCEISCONFIGCHANGE](../principles/configure-not-program.md#rule-pdr-config-newinstanceisconfigchange)). What every
pattern shares, the dark tones, the faces, the type scale, the footer and the output folder, is declared once in the kit's `slides.yml`
([PDR-CONFIG-DEFAULTDECLAREDONCE](../principles/configure-not-program.md#rule-pdr-config-defaultdeclaredonce)). A pattern is dark; no light
background exists.

- [Patterns are configuration](#patterns-are-configuration)

### Rule ADR-REPO-SLIDES-FAILFORWARDRENDER

The render is fail-forward. `Build-SlideDeck` always writes `out/slides/<deck>/`: the deck tree the Slides artifact type reads and
`<deck>.script.md`, the speaker notes in order. A missing required field, a field the pattern does not know, a pattern that does not exist
and a field with more items than the pattern holds are each reported with the file and the field; nothing shrinks and nothing is guessed
([PDR-POKAYOKE-DETECTEARLIEST](../principles/poka-yoke.md#rule-pdr-pokayoke-detectearliest)). The render never publishes. The diagram kit's
build is fail-forward the same way and reports every finding it makes (a conflict, a refused put, an undeclared slide, an orphan, a Supports
drift, a drawn line through a cell) as an error with an `E_` code, and the one setting `renderer: findings-fail` of its `drawio.yml` makes
every such error fail the run: the kit has no warning.

- [Render forward, publish by hand](#render-forward-publish-by-hand)

### Rule ADR-REPO-SLIDES-CHECKABLECLAIMS

Every claim on a slide is checkable. Every code in the head's `cites` exists in the DRS index; a field that quotes a rule carries the
registry's text verbatim, or the drift is reported with both texts; and every field's text is found in the rendered section. `Test-Slides`
is the gate over these checks, one file at a time; a fact about the deck as a whole (slide-order gaps and duplicates) is checked per deck.

- [Claims are asserted, not trusted](#claims-are-asserted-not-trusted)

### Rule ADR-REPO-SLIDES-DECKISPROJECTION

The published deck is a projection of the slide files. The files are the deck's one living version
([PDR-ONELIVE-ONEVERSION](../principles/one-living-version.md#rule-pdr-onelive-oneversion)), and no state of the deck lives outside them
([PDR-EAC-NOSTATEOUTSIDEVERSIONCONTROL](../principles/everything-as-code.md#rule-pdr-eac-nostateoutsideversioncontrol)): the deck is
replaced whole on publish, and an edit made in the deck's own editor is carried back into the slide file or discarded. No slide has a verify
record of its own, because rule 4 derives what such a record would hold.

- [One source of truth for a deck](#one-source-of-truth-for-a-deck)

### Rule ADR-REPO-SLIDES-SLIDEFILEKIND

`file-kinds.yml` places a slide file in the kind `slide` (`docs/**/*.slide.md`), ahead of the two documentation trees as the diagram kinds
are, and the kit in `slides-kit` (`python/catzc_diagrams/assets/slides/**`). The renderer, the gate and their types live in
`Catzc.Base.Slides`, and their tests run on neutral fixture decks, never on a real one
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).

- [Kinds and home](#kinds-and-home)

### Rule ADR-REPO-SLIDES-ONEBUILDCOMMAND

Every draw.io slide renders from the tree by one command on its declaration, `Build-Diagrams -Path <name>.drawio.yml`; the whole tree is
that command repeated over every `*.drawio.yml` found under `docs/**/.assets/`, so no setting lists the diagrams. Its inputs are the
diagram's declaration (or, for a render without one, the model embedded in its `<name>.drawio.png`) and the repository's maps. The articles
and slides that embed the png are not inputs: the build finds every one of them, wherever it sits, and holds each one's Supports line
against the declaration's rule codes and lens. No step of it asks a session or a model to decide anything
([PDR-EAC-NOSTATEOUTSIDEVERSIONCONTROL](../principles/everything-as-code.md#rule-pdr-eac-nostateoutsideversioncontrol)). A raster is never
drawn by hand or by the draw.io CLI: a session edits a model, and the kit renders it.

- [One command renders every diagram](#one-command-renders-every-diagram)

### Rule ADR-REPO-SLIDES-DECLARATION

A diagram is its render `<name>.drawio.png` in an `.assets/` folder, named by the diagram, and its one source, the **diagram declaration**,
in one of two carriers (below). `description:` says in a sentence or two what the diagram shows. `content:` says it in the kit's closed
vocabulary: the title, the ADR codes, the lens, the kind, the flow and the one relation its flow edges mean, the theme, the bands, the span
bars with the bands each covers, the groups, which may nest, the glyphs with their kind and holder, the edges, the markers, the chips, the
legend and which minimaps it shows. `layout:` says where a named cell sits. Every vocabulary is closed and declared once, in the kit's
`drawio.yml` (the lenses, kinds, themes, minimap ids and span words) or in its glyph library (the glyph and edge kinds), and a value outside
it fails validation with the list the author may choose from
([PDR-POKAYOKE-DETECTEARLIEST](../principles/poka-yoke.md#rule-pdr-pokayoke-detectearliest)). A cell without a layout entry is placed by the
grid; a cell with one keeps it; a cell whose id is not in the content is removed. A diagram names no article: articles and slides embed its
png, any number of them, and the build finds them by what embeds it. The kit prints a declaration with each leaf node (a mapping or list
whose children are all scalars) as one flow line in Prettier's form when that line, its indent and key included, fits the `max_line_length`
of the root `.editorconfig`'s `[*.md]` section, and in block style otherwise.

The declaration has two carriers, one per diagram. The default is a fenced block in an article, the way a `mermaid` block renders where it
stands: its info string is `yml drawio`, so GitHub still shows it as YAML and the kit finds exactly that block, and it sits directly above
the image that embeds `<name>.drawio.png`, which names the diagram it declares. The other is the file `<name>.drawio.yml` beside the png,
for a diagram no single article embeds. The carrier is what is on disk: a yml beside the png is the file carrier, a block above its image in
an article is the article carrier, and a diagram with neither yet takes the kit's `renderer.carrier` (`article`); the png stays in
`.assets/` either way. A diagram declared by both carriers, or by two blocks in the article carrier, is a finding. One command moves a
declaration between the carriers, `declaration.py carry <stem> <carrier>`: it writes the declaration in the other carrier, merges a file's
`cspell:ignore` words into the page's own ignore comment, removes the old carrier, and restores every file when the moved declaration no
longer loads the same, so a carry never loses a word or a cell.

- [The declaration is the source](#the-declaration-is-the-source)

### Rule ADR-REPO-SLIDES-TWODIRECTIONS

Two directions join the declaration and the drawing, and both are deterministic. Put renders the yml into the model embedded in the
`.drawio.png` and then the raster from that model, so the file stays editable in the draw.io editor. Get reads the embedded model back into
the yml, so a hand edit in the editor is folded back before anything else reads it. Put then get returns the same yml, get then put the same
model, and the kit's tests prove both on a fixture. A hand-moved cell comes back as a `layout:` entry; a cell that sits where the grid would
put it needs none. The quality gate `Test-Diagrams` fails every diagram whose embedded model differs from put of its yml and names the cells
that differ. A cell the kit derives and get never reads back (a minimap, the legend, the map key, the sidebar) that differs only because a
registry or the kit changed is stale, reported and not failed, and `Build-Diagrams -Stale` rebuilds it. What a drawing cannot show stays
with the yml: the kind, the flow, the relation, the band order when the layout places every band, and the band of a laid-out item. Get
guesses them only for a drawing without a yml, and a layout that places an item inside another band than its own fails put. Moving the
drawing area down for span room never moves the declared layout or waypoints: put then get returns them as written.

- [Two directions, one truth](#two-directions-one-truth)

### Rule ADR-REPO-SLIDES-CONFLICTNEEDSAPICK

The base of a diagram pair is the pair committed at git `HEAD`, read with `git show`. A pair whose yml and png both moved from that base,
and whose png states other content than its yml under get, is a **conflict**: `Test-Diagrams` fails it and names the diverging drawn cells
(never a derived one, which is stale at worst), and no bulk run puts or gets it. The author picks the side that wins by running put or get
on the diagram by name; nothing merges. A pair where only one side moved is no conflict, and an untracked pair, which has no base, never is
one. The base is read from git, never stamped into the files
([ADR-REPO-FILEMETA-NOREADBACK](file-meta.md#rule-adr-repo-filemeta-noreadback)).

- [Two directions, one truth](#two-directions-one-truth)

### Rule ADR-REPO-SLIDES-LENSPICKSPATH

**The declaration's `about.lens` picks the renderer path.** The lens `action` (DDR-VISUAL-ACTIONISALENS) takes the action path, and every
other lens takes the band path; both belong to the one renderer and the one declaration format. Put, get, conflicts and the stale rebuild
apply to both unchanged: put renders the yml into the embedded model and the raster, get folds a hand edit back, a pair whose yml and png
both moved is a conflict the author settles by name, and `Build-Diagrams -Stale` rebuilds a stale derived cell. A value outside the closed
list of lenses fails validation with the list the author may choose from.

- [One renderer, two paths](#one-renderer-two-paths)

### Rule ADR-REPO-SLIDES-THEMESELECTOR

A theme is one token set, and a style never names a colour, only a token. The diagram kit declares its sets as `theme-<name>` in
`drawio.yml`, and a style says `@<token>`; the slides kit declares `token` for the default theme and `token-<name>` for each other, and a
pattern says `{{@token.<name>}}`. `Build-Diagrams` and `Build-SlideDeck` take `-Theme`, whose default is declared once, on `SlidesConfig`.
Only the default theme's diagram raster is committed; every other theme renders on demand to `out/`, so the tree holds one raster per
diagram. A token no set declares fails, naming the tokens it may be.

- [The declaration is the source](#the-declaration-is-the-source)

### Rule ADR-REPO-SLIDES-MINIMAPSFROMDATA

A projection of the repository is computed by a `Get-*` command over the generated truths, never drawn by hand and never stored in the
source that shows it: the source holds only the inputs the projection is computed from and the parts its author rejects, so a file that is
added or moves changes the projection and leaves the source as it is. The projection's data is contract JSON
([ADR-REPO-CONTRACT](api-contracts.md)), written to `out/` by the commands that build and check it and never written back; whatever draws it
only validates and draws it. A source whose projection is missing does not render. A diagram's minimaps are one such projection
([minimaps](../../explanation/repository/minimaps.md)).

- [The declaration is the source](#the-declaration-is-the-source)

### Rule ADR-REPO-SLIDES-SIDEBARSHAPE

A diagram has two sides. The left holds the title, the subtitle (the rule codes, which appear on the diagram there and nowhere else), the
drawing and the legend, whose entries print the name of each kind alone. The right column holds four slots: the three minimaps and the map
key. The lens badge stands before the title, on its line. Every part is placed by put, so a declaration says what the diagram shows, never
where the sidebar goes.

- [The declaration is the source](#the-declaration-is-the-source)

### Rule ADR-REPO-SLIDES-TIMEAXIS

A diagram that runs along time declares it in shorthand, and put writes the shorthand out. A **lane** is a band of numbered steps: its
commits and glyphs sit by step and by row (-1, 0 or 1), with an optional trunk and marks. A **rule** is a gate line across the lanes after a
step, solid red for a manual gate and dashed for an automated one, and the legend names both. A **template** maps steps to the commit states
they reach; a **row** walks a template from its start state, with its dots, drops and step-labelled edges written out, and a `skip` drawn as
a bypass under the dot it skips. A **ladder** is a band whose glyphs climb left to right along their forward edges, spread over the band's
width, each `rise` px above the one before and the first on the band's floor, every rung `w` by `h` when the hint says so, and each climb
leaving its rung's top centre, up, then right into the next rung's left centre, so a promotion reads as the stairs it is; the hint is the
source's alone, and the drawing carries only the places and routes it gave. A **note** is free text in a band, and a commit is a dot or a
box. Get folds the drawing back to the shorthand while the drawing still draws what the shorthand expands to. A span over glyphs of one band
lies above that band in either flow; a span over whole bands stands beside them in a top-to-bottom flow.

- [Time reads along one axis](#time-reads-along-one-axis)

### Rule ADR-REPO-SLIDES-PAINTORDER

A line never cuts a glyph. The kit declares the paint order once, in `drawio.yml` `layers:`, back to front: panels, frames, span bars, lines
(gate rules, lane trunks and bypasses), edges, glyphs, marks, then text. Put orders the model by it, each container followed by its own
cells in that order. draw.io paints a frame's whole contents where the frame stands, so put moves every edge into a frame that holds no
frame of its own, where it paints before every glyph: the innermost frame around both its ends when that frame holds none, else the first
such frame painted. The raster paints the model in the order draw.io paints it, so the editor and the png show the same picture. An edge
stops short of every box it joins, by the one clearance `renderer.edge-deadzone` in `drawio.yml` declares (8 px), measured straight out from
the box side at any angle and written into the model as the edge's perimeter spacing. The png shrinks that clearance on a short edge so the
line keeps at least `renderer.edge-deadzone-min-line` (12 px) between the heads; the model keeps the nominal spacing.

- [Time reads along one axis](#time-reads-along-one-axis)

## Context

A deck is prose with a layout. Written straight into a presentation tool, the prose is reachable only through that tool, its claims are
checked by nobody, and a change to a rule it quotes never reaches it. The repository already carries one answer to that problem for
diagrams: a `.drawio.png` is drawn from a kit, the `catzc_diagrams` module of the python track, with a style guide and a template, rendered
forward into `out/`, described beside the article it illustrates, and never landed without a person asking. A deck is the same kind of thing
with words instead of glyphs, so it gets the same shape: files in the tree as the truth, patterns as the vocabulary, a renderer that fails
forward, and checks that tie every claim to the rule it states.

## Decision

A slide is a markdown file; a layout is a pattern; the deck is rendered from them and checked against the rules it cites.

### One file, one slide

`The smallest reviewable unit`

A slide file holds one claim and the words that carry it, so a diff of a deck is a diff of slides, and a slide is reviewed on its own. The
headings are the fields because a heading is what markdown already has for naming a part; no key-value syntax is invented for it. The order
is a head key so the file name stays a stable locator, and the renderer refuses a deck whose orders have a gap or a duplicate rather than
guessing which slide was meant to move.

### Patterns are configuration

`One mechanism per layout kind, one file per layout`

A pattern is the layout of one kind of slide: a cover, a divider, a statement, a rule, a pair of cards, a grid of tiles, a table, a stack, a
closing. The renderer knows how to fill a pattern's fields and nothing about any one pattern, so a new layout is a new file. Every pattern
reads the shared tones, faces and scale from one place, which keeps the deck one deck; a pattern that needs its own colour has a reason
written in the style guide beside it.

### Render forward, publish by hand

`Always something in out/, never anything published unasked`

The render always lands the deck tree and the script, with every fault reported beside them, so the person has something to read even when a
slide is wrong. Publishing the tree to the artifact is a separate step the person takes, exactly as a diagram lands under `docs/` only when
approved.

### Claims are asserted, not trusted

`A quoted rule is the registry's text or a reported drift`

A slide that states a rule cites its code, and the renderer reads that rule from the registry. The text on the slide is the registry's text,
verbatim, or the render says where the two differ, so a rule edited in its ADR is a reported drift on the slide that quotes it, never a
silent one. The gate runs the same checks per file, so a slide can be wrong only until the next run.

### One source of truth for a deck

`The files, not the page`

The artifact that shows the deck is a projection: it holds what the last publish wrote and nothing a person typed into it survives the next
publish unless it was carried into a slide file first. A per-slide verify record would be a second copy of what the registry check already
proves, so there is none.

### Kinds and home

`A kind for the file, a module for the code`

The slide kind comes before the documentation trees in the kind registry so a slide file is a slide, not a page. The renderer and the gate
are a module because that is where cats keeps a command with its types, its tests and its help; the draw.io kit is a Python folder because
draw.io's own tooling is, and nothing here needs Python.

### One command renders every diagram

`A picture is a build output`

A slide whose raster only a session can make is a slide nobody can rebuild: the next checkout, the next pipeline and the next person get
whatever picture was last committed, and the model and the picture drift apart unseen. With one command over the tree, a clean checkout
gives the same slides, a changed map or a changed rule reaches every slide that shows it, and an agent's part ends at editing a model.

### The declaration is the source

`A diagram is data first`

A diagram that lives only as embedded XML can be reviewed only as a picture, and a change to it can be judged only by eye. The declaration
puts what the diagram says in a few lines of yml that a pull request shows as a diff, a gate can read, and a vocabulary can bound: a span
label, a glyph kind or a minimap id is right or it is refused with the list it should have come from. The layout stays separate, so the
content reads without coordinates and a moved box is a one-line change.

A declaration is dense data: glyphs, edges and groups of three or four short keys each. One key per line spends most of the file on
structure, so a glyph printed as one flow line reads as one row of a table and the file shrinks to about a third, less to read for every
session that opens one. The limit is the markdown line length, read where it is declared, never copied, and Prettier wraps at the same
width, so a flow line that fits passes Test-Formatting as printed. YAML reads flow and block alike, so no reader changes.

### Two directions, one truth

`Edit in either, drift in neither`

The draw.io editor stays the place to nudge a box; the yml stays the place to say what a diagram shows. Put and get make the two the same
file seen two ways: a session writes yml and puts, a person drags in the editor and gets, and the tests prove each direction returns what
the other wrote. Nothing is hand-drawn into the raster, so a raster is always the put of a declaration. When both were edited since the last
commit and they disagree, neither direction guesses: the author runs the one that wins, by name. When span room moves the drawing area down,
the title carries how far, because over laid-out bands no reading of the drawing can recover it; it is the one input get lacks, not a
derived fact stamped into the file, and get takes it off so the yml's layout and waypoints come back as declared.

### One renderer, two paths

`One declaration format, one switch`

A diagram's lens changes what is drawn, not how a diagram is kept. Because the lens is a key every declaration already carries and the
renderer branches on its value, every tool that handles a declaration (put, get, the conflict check, the stale rebuild, the gate) handles
both paths with the same code, and there is no second module to keep in step with the first. Only the value `action` takes the action path,
so a declaration under any other lens renders in the band geometry.

### Time reads along one axis

`A story of commits is a few lines, not sixty cells`

A promotion story draws the same things again and again: a commit at a step, a gate after a step, a ladder of states with a drop under each.
Written cell by cell, such a diagram is sixty entries that no reviewer reads and every edit breaks. Lanes, rules and rows say it once, in
the words of the story, and leave the cells to put, so the yml diff of a changed story is the change and the drawing cannot place a commit
off its step. A story drawn this densely crosses its own lines, so the kit, not the author, decides what lies on top: a line passes beneath
the commit it crosses, and the picture in the editor is the picture in the png.

### How this is enforced

- **`Build-SlideDeck`** renders a deck forward into `out/slides/<deck>/` and reports every fault (rule 3).
- **`Test-Slides`** fails a slide file whose pattern, fields, cited codes or quoted rule text break rules 1, 2 and 4.
- **`Get-FileKind`** places slide files and the kit by rule 6, and the file-kind reachability test keeps both kinds reachable.
- **`Build-Diagrams`** rebuilds one diagram, or every `*.drawio.yml` it finds under `docs/**/.assets/`, through the kit's renderer, one
  render per diagram, and warns for each embedding page whose Supports line disagrees with the declaration (rule 7); with `-FromDrawing` it
  syncs named diagrams after an edit, get when the drawing moved since `HEAD`, then put, then `Test-Diagrams`, and stops on a conflict
  before put (rule 10); with `-Stale` it rebuilds only the diagrams `Test-Diagrams` reports as carrying stale minimaps (rule 9);
  **`Move-Diagram`** moves a diagram's pair with its links re-pointed.
- **`declaration.py`** of the kit validates a declaration against the closed vocabularies and runs put and get (rules 8 and 9); its tests
  prove the two round trips, the vocabulary refusals, the nested group and the grid placement. Its check names the cells of a conflicted
  pair against the `HEAD` base (rule 10), and the bulk put skips that pair. Its tests prove that a lane, a row and its skip expand and fold
  back to the shorthand, and that a rule names itself in the legend (rule 14), and that a line crossing a commit or a discard arrow passes
  beneath it, in the model and in the raster (rule 15).

## Consequences

- A deck is reviewed as files in a pull request, and its history is git's.
- A rule edited in its ADR shows up as a drift on every slide that quotes it, at the next render or gate run.
- A new layout costs one pattern file and one style-guide line; a new slide costs one markdown file.
- The published deck can be deleted and rebuilt from the tree at any time, and nothing is lost.
