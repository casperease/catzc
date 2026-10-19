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

A **pattern** is one file, `patterns/<name>.html` in the slides kit, the `assets/slides` folder of the `Catzc.Diagrams` module of the python
track: one section in the slide format whose placeholders name its fields and say which are required. A slide names its pattern in its head.
Adding a layout is a new pattern file and one line in the kit's `STYLE.md`, never a change to the renderer
([ADR-PRIN-CONFIG-VARYINGBEHAVIOURISCONFIG](../principles/configure-not-program.md#rule-adr-prin-config-varyingbehaviourisconfig),
[ADR-PRIN-CONFIG-NEWINSTANCEISCONFIGCHANGE](../principles/configure-not-program.md#rule-adr-prin-config-newinstanceisconfigchange)). What
every pattern shares, the dark tones, the faces, the type scale, the footer and the output folder, is declared once in the kit's
`slides.yml` ([ADR-PRIN-CONFIG-DEFAULTDECLAREDONCE](../principles/configure-not-program.md#rule-adr-prin-config-defaultdeclaredonce)). A
pattern is dark; no light background exists.

- [Patterns are configuration](#patterns-are-configuration)

### Rule ADR-REPO-SLIDES-FAILFORWARDRENDER

The render is fail-forward. `Build-SlideDeck` always writes `out/slides/<deck>/`: the deck tree the Slides artifact type reads and
`<deck>.script.md`, the speaker notes in order. A missing required field, a field the pattern does not know, a pattern that does not exist
and a field with more items than the pattern holds are each reported with the file and the field; nothing shrinks and nothing is guessed
([ADR-PRIN-POKAYOKE-DETECTEARLIEST](../principles/poka-yoke.md#rule-adr-prin-pokayoke-detectearliest)). The render never publishes.

- [Render forward, publish by hand](#render-forward-publish-by-hand)

### Rule ADR-REPO-SLIDES-CHECKABLECLAIMS

Every claim on a slide is checkable. Every code in the head's `cites` exists in the ADR index; a field that quotes a rule carries the
registry's text verbatim, or the drift is reported with both texts; and every field's text is found in the rendered section. `Test-Slides`
is the gate over these checks, one file at a time.

- [Claims are asserted, not trusted](#claims-are-asserted-not-trusted)

### Rule ADR-REPO-SLIDES-DECKISPROJECTION

The published deck is a projection of the slide files. The files are the deck's one living version
([ADR-PRIN-ONELIVE-ONEVERSION](../principles/one-living-version.md#rule-adr-prin-onelive-oneversion)), and no state of the deck lives
outside them
([ADR-PRIN-EAC-NOSTATEOUTSIDEVERSIONCONTROL](../principles/everything-as-code.md#rule-adr-prin-eac-nostateoutsideversioncontrol)): the deck
is replaced whole on publish, and an edit made in the deck's own editor is carried back into the slide file or discarded. No slide has a
verify record of its own, because rule 4 derives what such a record would hold.

- [One source of truth for a deck](#one-source-of-truth-for-a-deck)

### Rule ADR-REPO-SLIDES-SLIDEFILEKIND

`file-kinds.yml` places a slide file in the kind `slide` (`docs/**/*.slide.md`), ahead of the two documentation trees as the diagram kinds
are, and the kit in `slides-kit` (`python/Catzc.Diagrams/assets/slides/**`). The renderer, the gate and their types live in
`Catzc.Base.Slides`, and their tests run on neutral fixture decks, never on a real one
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).

- [Kinds and home](#kinds-and-home)

### Rule ADR-REPO-SLIDES-ONEBUILDCOMMAND

Every draw.io slide renders from the tree by one command on its diagram folder, `Build-Diagrams -Path <folder>`; the whole tree is that
command repeated over every diagram folder found under `docs/**/.assets/**`, so no setting lists the folders. Its inputs are the model
embedded in the folder's `diagram.drawio.png`, the one article beside the folder's `.assets` that embeds it, and the repository's maps, and
no step of it asks a session or a model to decide anything
([ADR-PRIN-EAC-NOSTATEOUTSIDEVERSIONCONTROL](../principles/everything-as-code.md#rule-adr-prin-eac-nostateoutsideversioncontrol)). A raster
is never drawn by hand or by the draw.io CLI: a session edits a model, and the kit renders it.

- [One command renders every diagram](#one-command-renders-every-diagram)

### Rule ADR-REPO-SLIDES-DECLARATION

The **diagram declaration** is `diagram.yml` beside `diagram.drawio.png` in the diagram's folder, in two sections. `content:` says what the
diagram shows in the kit's closed vocabulary: the title, the ADR codes, the lens, the kind, the flow, the theme, the bands, the span bars
with the bands each covers, the groups, which may nest, the glyphs with their kind and holder, the edges, the markers, the chips, the legend
and the three minimaps. `layout:` says where a named cell sits. Every vocabulary is closed and declared once, in the kit's `drawio.yml` (the
lenses, kinds, themes, minimap ids and span words) or in its glyph library (the glyph and edge kinds), and a value outside it fails
validation with the list the author may choose from
([ADR-PRIN-POKAYOKE-DETECTEARLIEST](../principles/poka-yoke.md#rule-adr-prin-pokayoke-detectearliest)). A cell without a `layout:` entry is
placed by the grid; a cell with one keeps it; a cell whose id is not in `content:` is removed.

- [The declaration is the source](#the-declaration-is-the-source)

### Rule ADR-REPO-SLIDES-TWODIRECTIONS

Two directions join the declaration and the drawing, and both are deterministic. Put renders the yml into the model embedded in the
`.drawio.png` and then the raster from that model, so the file stays editable in the draw.io editor. Get reads the embedded model back into
the yml, so a hand edit in the editor is folded back before anything else reads it. Put then get returns the same yml, get then put the same
model, and the kit's tests prove both on a fixture. A hand-moved cell comes back as a `layout:` entry; a cell that sits where the grid would
put it needs none.

- [Two directions, one truth](#two-directions-one-truth)

## Context

A deck is prose with a layout. Written straight into a presentation tool, the prose is reachable only through that tool, its claims are
checked by nobody, and a change to a rule it quotes never reaches it. The repository already carries one answer to that problem for
diagrams: a `.drawio.png` is drawn from a kit, the `Catzc.Diagrams` module of the python track, with a style guide and a template, rendered
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

### Two directions, one truth

`Edit in either, drift in neither`

The draw.io editor stays the place to nudge a box; the yml stays the place to say what a diagram shows. Put and get make the two the same
file seen two ways: a session writes yml and puts, a person drags in the editor and gets, and the tests prove each direction returns what
the other wrote. Nothing is hand-drawn into the raster, so a raster is always the put of a declaration.

### How this is enforced

- **`Build-SlideDeck`** renders a deck forward into `out/slides/<deck>/` and reports every fault (rule 3).
- **`Test-Slides`** fails a slide file whose pattern, fields, cited codes or quoted rule text break rules 1, 2 and 4.
- **`Get-FileKind`** places slide files and the kit by rule 6, and the file-kind reachability test keeps both kinds reachable.
- **`Build-Diagrams`** rebuilds one diagram folder, or every diagram folder it finds under `docs/**/.assets/**`, through the kit's renderer,
  stage by stage, and stops on a folder two articles embed (rule 7); **`Move-Diagram`** moves a folder with its links re-pointed.
- **`declaration.py`** of the kit validates a declaration against the closed vocabularies and runs put and get (rules 8 and 9); its tests
  prove the two round trips, the vocabulary refusals, the nested group and the grid placement.

## Consequences

- A deck is reviewed as files in a pull request, and its history is git's.
- A rule edited in its ADR shows up as a drift on every slide that quotes it, at the next render or gate run.
- A new layout costs one pattern file and one style-guide line; a new slide costs one markdown file.
- The published deck can be deleted and rebuilt from the tree at any time, and nothing is lost.
