# Design: Visual design of the value-chain diagrams — branch geometry and commit-colour semantics

The value-chain / promotion diagrams under `docs/.assets/commits-quality` are a domain language: a reader must be able to decode a commit's
delivery state and a branch's role from position and colour alone, without a per-diagram key. This DDR fixes that grammar so every diagram
draws the same shapes for the same meaning. The delivery states themselves are owned by the flow domain; this DDR owns only how they are
_drawn_.

## Rules: DDR-VISUAL

### Rule DDR-VISUAL-LEFTTORIGHTISTIME

Every value-chain diagram reads **left → right = time = value chain = delivery process = git history**, on one shared axis. The mainline
(`main` / `master` / `release`) is the horizontal spine; a commit's horizontal position is its point in time. Nothing in the grammar encodes
meaning on a right-to-left or top-down time axis.

- [One axis, read left to right](#one-axis-read-left-to-right)

### Rule DDR-VISUAL-BRANCHDIRECTIONISROLE

**Branch direction encodes branch role: release branches render above the mainline, topic branches below it.** A line leaving the spine
upward is a release branch; a line leaving downward is a topic (development) branch. The direction is not decorative — it is the single cue
that tells release work apart from topic work, so it is never inverted or mixed.

- [Up is release, down is topic](#up-is-release-down-is-topic)

### Rule DDR-VISUAL-COMMITDRAWNONCE

**A commit is drawn once and only recoloured; the history lane never deletes a commit.** Colour is the commit's furthest-reached delivery
state, not a separate token. A rejected or ignored commit keeps its place on the line in its terminal colour; the pipeline lanes may
_project_ or _discard_ a copy, but the commit itself stays in history.

- [Colour and history](#colour-and-history)

### Rule DDR-VISUAL-FIXEDCOMMITPALETTE

The **commit-colour palette is fixed**:

- **slate / steel** (the WIP blue range) — local work in progress, not yet integrated: **slate** is staged, **steel** unstaged. Lives on
  topic branches; release branches may also carry it (see DDR-VISUAL-FIXFORWARDTHENCHERRYPICK). Never an integrated mainline state, and
  never to be read as the saturated L3 **blue**, which is a verified state.
- **grey** — neutral: empty, or integrated onto `main` / `master` / `release`. Grey never appears on a topic branch (a topic commit that has
  not integrated is WIP blue, not grey).
- **ghost-grey** (faded, dashed) — a commit that exists in history but was silently ignored: no successor ever took it up. Still a real
  commit, still on the line.
- **yellow** — on `main` / `master` / `release` **and** past the BVT process, with an immutable artifact under version control.
- **ghost-yellow** (faded, dashed) — a _pre-verified_ BVT result that is **not on main/master**: produced either by the pre-commit
  build-validation / PR-gate pipeline on a WIP topic commit, or by a local devbox invocation of the BVT process. It is not the
  version-controlled BVT artifact and confers no promotion.
- **blue / light-blue / light-green / green** — the post-BVT promotion states: **blue** is L3-verified on the on-demand environment;
  **light-blue** is rolled onto the always-on `main-UAT` non-prod environment; **light-green** is release-verified on the release-uat track;
  **green** is in production.
- **red** — rejected by any process and must not progress further. Red is the one colour allowed on **every** branch (topic, release, or
  mainline), because rejection can happen anywhere.

The **pre-prod** rung has no hue of its own: its occupant is drawn green, the same bytes already validated for production, and the neutral
environment box, not the colour, says which of the two it sits in (DDR-VISUAL-ENVIRONMENTISCONTAINER).

Every hue has one locked hex pair (fill / stroke), owned by the renderer's commit-palette config; see
[Canonical palette (locked)](#canonical-palette-locked). A commit drawn in any other hex for one of these meanings is a drift error.

- [The fixed palette](#the-fixed-palette)

### Rule DDR-VISUAL-GREYYELLOWATBVT

**Grey and yellow separate on the BVT boundary, and the simulation is drawn as a ghost.** A commit is grey until an immutable,
version-controlled BVT artifact exists for it, at which point it is yellow. A _local_ pre-flight BVT the developer runs before the PR is
drawn ghost-yellow — same hue, faded — precisely so the diagram cannot be read as claiming a governed artifact where there is only a local
dry run.

- [The BVT boundary and its ghost](#the-bvt-boundary-and-its-ghost)

### Rule DDR-VISUAL-FIXFORWARDTHENCHERRYPICK

**Release-branch fixes flow fix-forward then cherry-pick up.** A release branch may carry WIP-blue development commits, and a supported
process for merging that work back to `main` / `master` exists — but the recommended and default-drawn path is the reverse: land the fix on
`main` / `master` first, then cherry-pick it **up** onto the release branch. The diagram favours the upward cherry-pick arrow so the
mainline stays the source of truth.

- [Fix forward, cherry-pick up](#fix-forward-cherry-pick-up)

### Rule DDR-VISUAL-PROMOTIONISFUNNEL

**Promotion is a funnel: population strictly thins as state advances.** Across any one diagram the count of commits in each state decreases
along the promotion order — more WIP blue than grey, fewer yellow than grey, fewer blue than yellow, fewer light-blue than blue, fewer
light-green than light-blue, fewer green (pre-prod and production together) than light-green. A drawing that shows as many promoted commits
as candidates misrepresents the gate as a pass-through.

- [The funnel thins](#the-funnel-thins)

### Rule DDR-VISUAL-COLOURISTEMPORAL

**Colour is temporal: it is the commit's state at a moment, and one commit may be drawn at several colours to show its progression.** A
commit does not own a fixed colour — it starts WIP blue or grey and is recoloured as it moves through the flow (WIP blue → grey → yellow →
blue → light-blue → light-green → green), or terminates (→ red, or is left as a ghost). Showing the same commit at grey in git, yellow in
the BVT lane, and red in the discard lane is not a contradiction; it is the commit's history rendered as colour-over-time.

- [Colour as a moment](#colour-as-a-moment)

### Rule DDR-VISUAL-STAGECOLOURCONTRACT

**Each pipeline stage has a fixed colour contract — the input colours it accepts, the output colour it produces, and that it may reject to
red.** The contract is what a stage box in the pipeline lane means:

- **BVT** accepts **WIP blue or grey**, and produces **yellow** (an immutable versioned artifact). It may reject a candidate to **red**.
- **L3** accepts **yellow** and validates/continues only on yellow; **WIP blue or grey** enter L3 only by manual invocation (as they may in
  BVT). L3 produces **blue** and may **invalidate its inputs to red**.
- **The PR gate / pre-commit build-validation** is human-initiated: a developer opts a **WIP-blue** topic commit into pre-commit validation,
  yielding a **ghost-yellow** (pre-verified, off main) — via the build-validation/PR pipeline or a local devbox BVT run.
- **main-UAT** accepts **blue** and produces **light-blue** (rolled onto the always-on non-prod environment). Its manual release gate is
  **RC** (Release Certification).
- **release-uat** accepts **light-blue** and produces **light-green** (release-verified). Its manual release gate is **RBC** (Release Branch
  Certification).
- **DEPLOY-Prod** takes **light-green** (release-verified) through a **pre-prod** staging environment and produces **green** (in
  production); **DEPLOY-Non-Prod** is the deploy into the earlier non-prod AT environments.

Env boxes carry **`-uat`** labels (the environment) and stage/gate boxes carry **`-AT`** labels (the acceptance testing) — two layers:
`main-AT`/`release-AT` are the testing drawn at the RC/RBC gates, `main-uat`/`release-uat` the environments they run against.

A stage never emits a colour outside its contract, so the palette doubles as the flow's type system.

- [Stages have colour contracts](#stages-have-colour-contracts)

### Rule DDR-VISUAL-NUMBERTIESAPPEARANCES

**A number ties a commit's appearances across lanes into one identity.** When a diagram traces specific commits, each gets a small number
(1, 2, 3, …) drawn on it, and every later appearance of that commit — in the pipeline, discard, or timeline lane — carries the same number.
The number is the thread that lets a reader follow one commit's colour-over-time across the lanes without guessing which dot is which.

- [Commit numbers](#commit-numbers)

### Rule DDR-VISUAL-GHOSTSINEVERYCOLOUR

**Ghosts exist in every colour, and a ghost is a faded rendering of the state it held while alive, drifting toward grey/green.** A ghost is
the diagram's _generic_ commit — "some commit in this stage" — drawn faded and dashed in the colour of that stage's state (ghost slate,
ghost steel, ghost-grey, ghost-yellow, ghost-blue, …), not a separate grey-only token. A ghost carries **no number**: numbered means "this
specific commit, part of a traced journey"; un-numbered/ghost means "a representative commit here". ghost-grey (silently ignored) is just
the grey member of this family.

- [Ghosts of every colour](#ghosts-of-every-colour)

### Rule DDR-VISUAL-ONLYGITLANEISTIME

**Only the GIT lane is a real left-to-right time axis; the commit numbers are the time-code that carries that ordering into the other
lanes.** In git, horizontal position is actual time (commit `0` precedes `1` precedes `2` …). The pipeline, discard, and env lanes are
organised by _stage_, not by time, so a commit can sit anywhere horizontally there — its **number** is what restores its identity and its
moment. Each number is one commit's whole story: the same number reappears across lanes in its state-of-the-moment colour and ends where
that commit was discarded, abandoned, or promoted.

- [Git is the only true timeline](#git-is-the-only-true-timeline)

### Rule DDR-VISUAL-ENVIRONMENTISCONTAINER

**An environment box is a neutral container; the commit inside it is its occupant, in that commit's own state colour.** The hexagon is drawn
as neutral chrome — its label names the environment (on-demand, main-UAT, release-uat, production) and it carries no per-stage tint and no
state colour of its own. The single commit drawn _inside_ — generic or numbered — is the environment's occupant (the one commit it holds),
coloured for whatever state that commit is in right now, not for a fixed property of the box. So production holds a **green** commit,
release-uat a **light-green** one, main-UAT a **light-blue** one, and the on-demand L3 environment whatever it is hosting at the moment (a
**yellow** commit mid-verification, a **blue** one just verified). Reading the inner colour tells you the state of what currently lives
there; the label tells you where.

- [Environment boxes](#environment-boxes)

### Rule DDR-VISUAL-DISTINCTENDINGS

**The lifecycle endings each have a distinct rendering; they are not all red.** The endings of the commit lifecycle are drawn as:
**discarded** — red, on the line and in the DISCARDED/Retired lane; **retired** — kept in its production colour (green) and moved into the
DISCARDED/Retired lane, never repainted red; **superseded** — its last promotion colour drawn as a ghost (faded), because it was valid but
abandoned; **dirty HEAD** — its failed-stage colour with a rejection mark, distinct from an occupant in a clean state; **in-process** — the
input colour drawn inside the stage box; **environment occupant** — the single numbered commit inside an environment box. The ② lane is
therefore labelled _DISCARDED / Retired_, because retirement is a success that shares the lane, not the colour, of discard.

- [Lifecycle endings](#lifecycle-endings)

### Rule DDR-VISUAL-ACTIONISALENS

The **action lens** is the value `action` of a declaration's `about.lens`, the closed list of lenses declared once in the renderer's
vocabulary. A diagram under it, an action diagram, draws one action and its cascading effects on the system; a diagram under the proof lens
(DDR-VISUAL-PROOFISALENS) draws the action's proof alone, and a diagram under any other lens keeps the geometry of bands of glyphs and the
edges between them. The lens badge prints ACTION, and the subtitle ends in `action`, beside `source`. The lens is independent of the
declaration's `kind` (explanation or reference), so an action diagram is either. There is one declaration format and one renderer, with the
lens the switch inside them, never a second module
([PDR-ONELIVE-ONEVERSION](../principles/one-living-version.md#rule-pdr-onelive-oneversion)).

- [The action lens](#the-action-lens)

### Rule DDR-VISUAL-CAUSEONTHELEFTRIM

A **cause** is the half-disc on the left rim of an action diagram, its flat side flush with the frame's outer left boundary (the frame clips
it). Its label names the actor or trigger in plain words. The drawing reads left to right as cause, action, effects, the same axis as every
diagram (DDR-VISUAL-LEFTTORIGHTISTIME).

- [The cause sits on the left rim](#the-cause-sits-on-the-left-rim)

### Rule DDR-VISUAL-ONEFRAMEONECAPTION

A **frame** is the one rounded-corner boundary box around the whole of an action diagram; its caption, in the top-left corner, is the
declaration's `title`. An action diagram has no bands and no groups, and declares no edges or spans: the renderer draws the flow from the
cause to the action and from the action, or the effect an effect follows, to each effect. The frame has a fixed height, set in the
renderer's vocabulary or pinned by the layout. A declared `edges`, `bands`, `groups` or `spans` is a validation error that names the reason.

- [One frame, one caption](#one-frame-one-caption)

### Rule DDR-VISUAL-ACTIONISACCOSTED

An **action** is the innermost glyph of an action diagram, right of the cause: one contracted command in the contract form, verbatim, or a
**call site**, a run of several commands drawn as one stacked glyph with one line per command. Only the contract form appears, as the
accosted language defines it, and the action may be any contracted command, one that changes state included, so every statement on the
drawing is a call that `cats` can run. A long call wraps at `/`, `,`, space and `.`, so no text spills out of its glyph.

- [The action is a contracted command](#the-action-is-a-contracted-command)

### Rule DDR-VISUAL-EFFECTSINZONES

A **ring** is a circle centred on the cause's rim, drawn only as the arc between the frame's inner top and bottom, so it stands steep
through the centre lane; a **zone** is the band between two arcs, and an **effect** is a note box standing in a zone: a state change the
action causes, or an execution it triggers. An effect's `zone` is its causal hop, a whole number from 1 with no gaps, and says nothing about
its place. A state change says in plain words which state it modifies, proves it with an accosted observation, and names its place, `local`
or `remote` from a closed list; an execution is a `call`, a contracted command in the contract form. The declaration's `where` is the
default place of every effect, declared once in the renderer's vocabulary, and a place chip is drawn only on an effect whose place differs
from it. An effect's `show` says what its note prints, its words, its call or both, and both is the default. An effect may name `after`, an
effect declared before it, in its own zone or one nearer the action; its flow edge then comes from that effect, not from the action, and
naming a later effect is an error. A **story number** is the number every box carries: the cause 1, the action 2, the effects in declared
order. Notes stand inside their zone, spread over the fixed centre lane in story order. The renderer computes the layout and takes palette
and ink from the same theme tokens as every diagram.

- [Effects stand in zones](#effects-stand-in-zones)

### Rule DDR-VISUAL-EDGEWORDSAREOPERATORS

Every flow edge of an action diagram carries one word, drawn by the renderer and never named in the declaration; the word follows from the
edge's source and target, never from the author. The word stands in the pill of DDR-VISUAL-TRANSITIONPILL, or beside its line where the
renderer is configured to the word presentation and the line crosses no boundary. The **cats operator** is the word at the actor's hand,
where the statement is done; no line runs from the head to the hand, and `Test-AccostedCommand` checks the action. The **executes operator**
is every edge leaving the action, whatever its target: the statement is handed to the state machine as an instruction, and the runner
running it checks it. The **affects operator** is the edge between two effects where the target is an execution: one execution triggers
another, and `Test-AccostedCommand` checks that call. The **effects operator** is the edge between two effects where the target is a state
change: an execution changes state, and its observation in the proof file checks it. An effect's `after` picks the source of its edge, the
action when it names none. The legend of every action diagram lists the four words, or with `legend: used` only the operators the drawing
uses, and adds "execution: a triggered command" when one is drawn. The declaration's `relation` and `thick` are refused under the action
lens.

- [Edges carry their operator](#edges-carry-their-operator)

### Rule DDR-VISUAL-STEEPEDGEWORDBESIDEIT

A **steep edge** is an edge that climbs or falls more than it runs, in an action diagram and in a band diagram alike. Where its word is
beside the line (the word presentation) and the line crosses no boundary, its word stands left-aligned a few pixels to the right of its
line, at the middle of the line, so the word reads beside the edge and never on it or across it. The distance is declared once in the
renderer's vocabulary, and the draw.io model and the painted raster place the word the same way. A word on a line that crosses a boundary is
the transition pill's (DDR-VISUAL-TRANSITIONPILL).

- [A steep edge's word](#a-steep-edges-word)

### Rule DDR-VISUAL-PROOFISTHEACCOSTEDFILE

The **proof** of an action diagram is the accosted file its `about.proves` names, `<module>/accosted/<name>.accosted.yml`, the one living
file the runs are kept in. Every state change's observation occurs verbatim in that file, and `Test-Diagrams` checks it, so the picture
never claims an observation the proof does not run. The action, and every execution among the effects, is a contracted command in the
contract form, which `Test-Diagrams` checks against its command contract. An article shows the proof as a fenced `yml accosted` block copied
from that file, or links the file. An engine's text in an article is a rendering of the contract form, produced by the accosted language's
one reader and never written by hand; a linked engine script asset is not taken, since it would be a second version of the same runs
([PDR-ONELIVE-ONEVERSION](../principles/one-living-version.md#rule-pdr-onelive-oneversion)).

- [The proof is the accosted file](#the-proof-is-the-accosted-file)

### Rule DDR-VISUAL-PROOFBOXUNDERTHEFRAME

A **proof box** is the box captioned Proof under the frame of an action diagram, as wide as the frame. For each call of the action it prints
the call's normalized statement, written with the word cats, and the words each engine runs it as, in the idiom of that engine. The engines
and their idioms are declared once in the renderer's vocabulary, never in a declaration. An action diagram shows the proof box by default,
and `content.proof: hidden` turns it off, the default being declared once in the same vocabulary.

- [The proof box](#the-proof-box)

### Rule DDR-VISUAL-PROOFISALENS

The **proof lens** is the value `proof` of a declaration's `about.lens`: a diagram under it draws the proof box alone, from
`content.action`, where the frame would stand. It declares no cause and no effects, and no `content.proof`, since the box is the whole
drawing. Its lens badge prints PROOF, and its subtitle ends in `proof`.

- [The proof lens](#the-proof-lens)

### Rule DDR-VISUAL-ONELEGENDBAND

A **legend band** is the one band under every drawing, band diagrams included, and a **legend segment** is one captioned box of it, as wide
as the part of the drawing it stands under: Action and Proof under the frame, Map key under the sidebar. In every segment the swatches stand
centred in a left column and the words are left-aligned beside them. The band never starts above the bottom of the sidebar's projections, so
a drawing shorter than the sidebar leaves room beneath itself and the band stays under the sidebar.

- [One legend band](#one-legend-band)

### Rule DDR-VISUAL-STICKMANOVERLAY

The **stick man** is the onlooker's stand-in drawn over a finished action diagram, last of all: the cause's circle fragment is his head,
with the idea in it, and his body hangs from the fragment as four plain lines between anchors, a spine, the arms across, two legs, free to
overflow the rim and whatever stands near. He is not part of the drawing: nothing moves to make room for him, no legend lists him, and get
skips his cells as the kit's own. The renderer's vocabulary declares him shown once, and `actor: hidden` there turns him off.

- [The stick man](#the-stick-man)

### Rule DDR-VISUAL-HEADABOVEHAND

The head thinks the statement and the hand does it. The cause's fragment stands above the centre line, so it may grow sideways over the
statement, and the statement, box 2, stands on the centre line at the stick man's right hand, the word cats beside the hand. Nothing is
drawn between head and hand: what runs from the idea to the statement runs through the body and is inferred, so the **hand placement** is
the only link the drawing shows. The rings stay centred on the rim at the statement's height.

- [Head above hand](#head-above-hand)

### Rule DDR-VISUAL-TRANSITIONPILL

A **pill** is the default presentation of an edge's word: a round-cornered box hugging the word with a small inner margin on every side and
no height beyond the text, standing on the line, centred on the first boundary the line crosses (the border of the band it enters in a band
diagram, the first ring arc it crosses in an action diagram) and else at the middle of the line. A pill never covers the arrowhead: it
stands only where the line keeps a clear stretch on both sides of it, and a line too short to hold one gets the same pill beside it, a few
pixels off the line, clear of every box and every other pill. The line keeps no word of its own, and get reads the word back from the pill.
The configured alternative is the **word** presentation, where the word stands beside its line and only a line crossing into another band or
zone has a pill. The presentation (`edge-label`, `pill` or `word`), the margin and the clear stretches are declared once in the renderer's
vocabulary, the same for every diagram, and the legend lists "label: the word on a line" for pills, "transition: into a new state" for the
word presentation when a line crosses. This holds in every lens.

- [The transition pill](#the-transition-pill)

### Rule DDR-VISUAL-ARROWSPOINTATDEPENDENCY

An arrow runs from the one that acts, its initiator, to what it acts on or depends on, its receiver: the caller to the callee, the consumer
to its provider, a resolver to the sources it reads, and the head is always the receiver. Code acts and is not acted on, so a plain arrow
ends on a code block only from an actor, an author or a trigger, which a diagram may place at the start of a flow; a call is the declared
exception, an arrow labelled `calls` whose head is the code it runs, and a feed is the second, an arrow labelled `feeds` whose head is the
code that takes in what the tail supplies (its tail still initiates). Only a word says otherwise: an arrow whose label names another meaning
(`reads`, `writes`, `feeds`, `failed`) means that. Four words carry the relations that are not a dependency of code, each with its tail as
the initiator: `else` runs from the first choice to its fallback, `composes` from a whole to the part it is built from, `then` from a step
to what comes after it (the next rung, the next step, or the form derived from it), and `in` from the contained to its container. A diagram
that gives its plain arrows one other meaning states it as its `relation`, which every plain arrow then carries and which opts the diagram
out of the check. The `relation` opt-out is for state and commit diagrams only, where an arrow is a step between states rather than a
dependency, and such a diagram says so with `states: true`: the validator refuses a `relation` without it and `states: true` without a
relation. `commit-promotion-states` declares "advances one rung", and `sync-point` "points at"; any other diagram's plain arrows keep the
default meaning. The default meaning, the code kinds, the labels that may end on code and each label's initiating end are declared once, in
the `edge-semantics` and `edge-labels` of the kit's `drawio.yml`; the legend entry of a plain arrow reads `flow: initiator to receiver` from
that declaration, and a declaration that breaks the rule is refused naming the edge.

The kind of each end orders the arrow. The kit's `edge-rank` lists the ranks, lowest first (actor, code, file or config, store or set,
result or failure), each with its glyph kinds, and the lower rank acts on the higher: an edge between cells of different rank runs from the
lower to the higher, so a file or config is the receiver of the code that reads it and never an initiator. An edge with no label of the
vocabulary is oriented this way: declared against its rank it is refused naming the edge, and declared with its rank it takes the label its
kind pair names in `edge-defaults` (code to file or set `reads`, to store `writes`, to failure `failed`; an actor to code none), drawn in
the label presentation like any other label. The source keeps that edge minimal: get and tidy never write a derived label, and a label the
author wrote that equals its pair's default is the same edge, so the one form leaves it out; a label of another meaning is kept, and so are
the direction as written (get never rewrites `from` and `to` into `between`) and every edge of a diagram with its own `relation`. An edge
may be declared minimally as `between: [a, b]` and the kit orients it; ends of one rank are declared with `from` and `to`, between two code
blocks with a `calls` label or an actor. An edge that no waypoint routes leaves the side its two ends face (across the axis they overlap on,
else the axis of their wider centre distance) and takes an even share of that side with every other edge that meets it there, in the order
of the other ends, one edge alone at the side's middle, so edges between aligned cells run straight and edges sharing a side fan out without
crossing. A cell that is neither end of an edge is a keep-out zone for it: the cell grown by the 8 px deadzone and its marker, and a path
that enters one is an `E_KEEPOUT` error under the kit's one findings setting; bands, groups and spans are no obstacle. An edge whose two
ends share no x overlap and no y overlap has no straight line and is routed as one orthogonal elbow by default (`edge-route: elbow` in the
renderer, `straight` keeps the diagonal): it leaves the side facing across, runs along that row to the column of the side it enters, with
the deadzone at both ends and its pill on the longer leg; the route is derived, never written to the declaration, and an edge whose ends
overlap on an axis stays straight. An edge may also carry a `count`, `n/m` with n at most m (`count: 13/28`), shown in its pill after its
label as `calls 13/28`; a count is no label and decides no direction, and a label that is only an `n/m` is read as the edge's count. Where
every flow edge of a diagram carries one and the same word (all `calls`), no pill is drawn on each: the legend entry of the plain arrow says
it once (`flow: calls`), derived at render time under the renderer's `uniform-label: legend` and never written back; an edge with a count
keeps its pill for the count, and a failure edge does not count toward the sameness. A label outside the vocabulary is free text, not an
arrow meaning, and the edge is oriented by rank like an unlabelled one. The kinds in `edge-rules` `trusted-kinds` (the gate) keep the
direction their author declared, and a diagram with its own `relation` keeps its plain arrows as they are. The edge audit reads the same
ranks and defaults.

- [Arrows point at what they depend on](#arrows-point-at-what-they-depend-on)

### Rule DDR-VISUAL-ZOOMISANAXIS

A diagram's **zoom** is how far out it stands, and it is an axis of its own, crossing the lens: the lens says what a diagram shows, the zoom
how much of the world it holds. The levels are one closed list, `zooms:`, declared once in the renderer's vocabulary beside `lenses:`, from
C0 to C4: **C0 landscape**, the truth stores around the repository; **C1 context**, the repository as one system with its actors; **C2
containers**, the tracks crossed with the engines and languages; **C3 components**, one container's modules or units and their dependency
edges; **C4 code**, one module's files and their link edges. A declaration names its level in the optional `about.zoom`, which has no
default, so a diagram without it is drawn as before, and a value outside the list is refused naming it. A diagram with a zoom carries a zoom
badge printing `C<n>` beside its lens badge, and the badge alone carries the level: the subtitle stays the diagram's ADR codes. A C3 or C4
slide is filled from the query rows of its level, never placed by hand: its declaration stores the inputs, the level and the point of the
tree in `about.point`, and `Build-Diagrams` asks the level's query for that point and hands the rows to the renderer by an address it names,
which expands them into generated cells that the source never holds. A query slide of at most the renderer's `query-edges-max-nodes` cells
(45 by default, declared once in the kit's `drawio.yml`) draws its cells in one column and every edge in a vertical lane of its own beside
it, so no edge crosses a cell; a larger one draws its cells with a count chip of their edges in and out on each, since its edges live one
zoom down, in each component's own neighbourhood.

- [The zoom ladder](#the-zoom-ladder)

### Rule DDR-VISUAL-NONAMEINPICTURE

A diagram or a slide never names **catzc** or **cats** as a word: it says what the thing is, "the modules", "the platform", "the run", or
names it by an identifier. A name joined into an identifier passes, whether by `.`, `-`, `_` or `/`, so `Catzc.Base.Git`,
`Get-CatzcModuleRoot`, `Import-Catzc` and `Catzc/<v>` all stand. A line that names both draws the contrast between them and passes. Every
other mention is a declared contrast or the thing itself, listed once in `slides.yml` under `name_mentions` by diagram stem or slide path
with its reason. `Test-Diagrams` reports each remaining mention in a declaration, and `Test-Slides` each in a slide, as `path:line`.

- [No name in the picture](#no-name-in-the-picture)

### Rule DDR-VISUAL-FLOWISALENS

The **flow lens** is the value `flow` of `lenses:`, beside `source` and `action`: a diagram under it draws how a commit flows through the
repository's pipelines and workflows, one lane per pipeline or workflow, time left to right. Its badge prints FLOW. The lens is a switch
inside the one declaration format and the one renderer (DDR-VISUAL-ACTIONISALENS), and its name stands apart from the `content.flow`
direction key. A flow declaration stores its inputs alone, the pipeline and workflow files in `about.point`, and carries no content key
beyond `title` and `kind`; `Build-Diagrams` asks the engine readers for those files' rows and hands them to the renderer by address, the
same handoff a zoom slide rides (DDR-VISUAL-ZOOMISANAXIS). Each engine has one reader that maps its files to the same rows (lane, type,
stage, job, step, environment, trigger, edge), so a new engine adds a reader, never a branch in the renderer, and the renderer never parses
a pipeline definition. A lane's environments are the rungs its unit deploys to, read from the rungs registry, and a deploy pipeline joins
its certifying run by the shared unit name, drawn with the operator word `pins`.

- [The flow lens](#the-flow-lens)

### Rule DDR-VISUAL-FLOWGLYPHSAREWORDS

A flow glyph is a **word** of exactly three symbols from the one alphabet `O 0 - _ = .`, drawn in three equal parts of its box: `O` an empty
circle and `0` the same circle with a dot, the dot their only difference; `-` a middle line and `_` a bottom line, with a riser where two
lines of different heights meet; `=` a thin double line, stroke 1 against 1.6 for the rest; `.` a dot. The words are one closed list,
`flow-glyphs:` in the renderer's vocabulary, each with its id, word, meaning and a `hint:` naming the editor file icon it is styled after;
the hint is for the reader only, so the editor icons and the diagram glyphs stay two sets. One generator renders every word to an SVG with
`@ink` strokes, which the renderer resolves to the theme's colour on embedding; a word not three symbols long, or a symbol outside the
alphabet, is refused naming it.

- [Glyphs are words](#glyphs-are-words)

### Rule DDR-VISUAL-RHOMBUSINFLOWLENS

Under the flow lens an environment is a **rhombus**, its name under it and its occupant commit inside it in that commit's state colour.
Everything DDR-VISUAL-ENVIRONMENTISCONTAINER says of the environment box holds; only the shape differs, and only in this lens. The rhombus
is a container glyph of the kit beside the environment box, not a word, since it holds a commit rather than standing for one.

- [The rhombus](#the-rhombus)

### Rule DDR-VISUAL-SPANNERSNAMETAXONOMY

A **spanner** is a span bar on the `spans` layer, capped with its taxonomy glyph, in one row of words over the lanes of a flow diagram.
Three kinds stand there, each read from what the tree declares, never declared again for the picture: the pipeline type over a lane, read
from its file name's prefix and named from the pipeline types' one list, never redeclared for the picture; **Approve** over a rung whose
gate is not `none`, read from the rungs registry; and **Review** over a lane a pull request triggers. A frame spanning one route from
trigger to production is the full flow, drawn as a lane with its start `O` and end `0` caps.

- [Spanners](#spanners)

## One axis, read left to right

One spine lets a reader trace a commit from candidate to production without switching mental models; a lane with its own time axis breaks
the alignment that makes the lanes comparable.

## Up is release, down is topic

Encoding role in direction keeps the colour channel free for delivery state and means the reader never has to read a label to know which
kind of branch a line is: release branches are long-lived and promotion-bearing, topic branches short-lived development forks.

## Colour and history

`Colour is state, history is permanent`

Git history is append-only, and the diagram mirrors it: drawing a rejected commit as "gone" would contradict the history it belongs to.

## The fixed palette

A fixed palette makes the diagrams a language rather than a set of one-off pictures: a colour never has to be re-explained. The promotion
hues share a warm-to-cool progression that reads as forward motion through the flow. The flow domain defines the states; the palette owns
only their colours.

## The BVT boundary and its ghost

Grey-to-yellow is the palette's most consequential line, where an integrated commit gains a governed artifact. The ghost treatment of the
local run is a poka-yoke against mistaking a simulation for the governed CI gate.

## Fix forward, cherry-pick up

Drawing the upward cherry-pick as the default lets the geometry itself nudge teams toward keeping the mainline authoritative; the supported
merge-down stays undrawn unless a case needs it.

## The funnel thins

Every gate exists to reject, so the shape of the cloud, a wide base narrowing to a few green commits in production, shows the flow's
selectivity at a glance.

## Colour as a moment

`Colour is a moment, not a label`

A commit's colour answers "what state is this commit in right now", not "what kind of commit is this"; since the flow moves a commit through
states, recolouring it at each step is the honest way to draw its life.

## Stages have colour contracts

Every stage is a typed transform on colours, and stating the type keeps the diagram honest about what each stage can do:

| Stage                              | Accepts (input)                                                  | Produces                                                 | Rejects to                      |
| ---------------------------------- | ---------------------------------------------------------------- | -------------------------------------------------------- | ------------------------------- |
| Pre-commit / PR gate (human-opted) | WIP blue (topic)                                                 | ghost-yellow (off main; PR pipeline or local devbox BVT) | red                             |
| BVT                                | WIP blue, grey                                                   | yellow (immutable versioned artifact)                    | red                             |
| L3                                 | yellow (validates/continues); WIP/grey only by manual invocation | blue                                                     | red (may invalidate its inputs) |
| main-UAT (gate: RC)                | blue                                                             | light-blue (rolled onto always-on non-prod)              | red, or held at the gate        |
| release-uat (gate: RBC)            | light-blue                                                       | light-green (release-verified)                           | red, or held at the gate        |
| DEPLOY-Prod (through pre-prod)     | light-green                                                      | green (in production)                                    | —                               |

The manual runs of grey and WIP blue are the exception the contract names rather than hides. An arrow leaving L3 in any colour but blue or
red is a drawing error. The flow domain defines what the stages are; this rule owns only how they are drawn.

## Commit numbers

`Numbers thread one commit across lanes`

A bare dot cannot be tracked across three lanes of similar dots; with a number the reader learns "landed, then BVT rejected it" from the
number plus the colour change. The digits are a reading aid for worked examples, not a permanent identifier every commit must carry.

## Ghosts of every colour

Restricting ghosts to grey would lose the point of the generic placeholder: it still tells you the stage it stands in, and the faded, dashed
form reads as inactive.

## Git is the only true timeline

Only history is intrinsically ordered, so reading a stage-organised lane as a timeline would be a mistake.

## Environment boxes

`Environment boxes: a neutral container showing its occupant`

An environment is not a commit, so it is drawn as a container. Each always-on environment hosts exactly one commit, so its picture is "what
is deployed here", not "what this stage is for".

## Canonical palette (locked)

The hex pairs live once, in the renderer's commit-palette config; this record binds each hue to its meaning, and any other hex for one of
these meanings is drift and must be normalised.

- **slate** (staged) and **steel** (unstaged) — local work in progress, the WIP blue range; muted and dark, so they never read as the
  verified L3 blue.
- **grey** — neutral: empty, or landed on main.
- **yellow** — BVT-verified.
- **blue** — L3-verified, saturated.
- **light-blue** — main-UAT (always-on non-prod).
- **light-green** — release-verified (release-uat).
- **green** — in production (pre-prod and production occupants).
- **red** — rejected / discarded (any branch).
- **ghost-topic**, **ghost-BVT**, **ghost-L3** — dedicated tones for the busiest candidate queues (a commit that _has been / is queued_ in
  that stage), drawn as their own colour rather than a reduced-opacity fill so they read in a crowded queue lane.
- **ghost** — any other state: that state's fill at reduced opacity, dashed outline, its own stroke. Ghost-grey and ghost-yellow are members
  of this family, with no separate hex.

Pipeline **stage-box** tints are _chrome_, not commit states, and are not part of this palette: the pale green on the pre-prod and
production boxes is only a box tint, never the production commit's green. **Environment** boxes carry no tint at all — they are neutral
containers coloured only by their occupant (DDR-VISUAL-ENVIRONMENTISCONTAINER).

## Lifecycle endings

`Lifecycle endings are not all red`

The single biggest legibility risk is painting every "not in production" commit red, which would erase the difference between a defect and a
success. So the colour still carries the state, and the _lane_ and the _fade/mark_ carry the ending. The delivery flow's commit lifecycle
owns what these endings mean; this rule owns how they look.

## The action lens

The other lenses show parts and the relations between them; nothing in them shows what one call does to the system. The action lens draws
exactly that, a cause and its effects, and reads from the same declaration with the same renderer, the same put and get, and the same gates.
Making it one value of the lens every declaration already carries keeps the declaration format as it is, and keeping it inside the one
renderer keeps a single living version of how a diagram is drawn. The role of the diagram, explanation or reference, is a separate axis:
what a diagram is for does not decide how it is drawn.

## The cause sits on the left rim

An action diagram is a story in one direction, so its beginning sits where every other diagram's begins: at the left. The half-disc, cut
flat by the frame's edge, reads as something entering the picture from outside it, which is what an actor or a trigger is. Naming it in
plain words keeps the first thing a reader meets a sentence, not a command.

## One frame, one caption

The whole drawing is one boundary, so the picture is one thing with one name, the caption. Bands and groups would cut it into regions that
this lens does not have, and the flow needs no declared edges because it is fixed by construction: the cause leads to the action and the
action leads to each effect. A declaration that tries to say otherwise is refused with the reason, rather than drawn wrongly.

## The action is a contracted command

The action is the one place a call appears as a call. Writing it in the contract form makes the statement on the drawing something `cats`
can execute, not a description of something it might do, and a command that changes state is what an action usually is. A call site gathers
several commands that act together into one glyph, one line each, so the picture still shows one action.

## Effects stand in zones

What a call changes is not one thing, and the effects are ordered by how far the change travels from the call: the first zone holds what the
action changes directly, the next what that change causes. The zone is that causal distance, which is why the place, local or remote, is a
separate chip: a remote effect can be one hop away and a local one three. An effect that follows from another says so with `after`, forward
only, so the drawing never draws a cause arriving after its effect. The story numbers give the reading order, so a reader and the renderer
agree on it. Each effect pairs a sentence with an observation that shows it, so the claim and its evidence sit in the same note.

## Edges carry their operator

A reader who sees an arrow should not have to guess what it asserts. The four words name the four things an arrow can say: someone ran the
command, the command was handed on, one command set off another, or a command changed a state. Because the word follows from where the arrow
starts and ends, the author never picks it, and two diagrams cannot call the same arrow by different words. Each word also names the check
that stands behind it, so an arrow is never a claim the tooling does not test.

## Arrows point at what they depend on

A diagram of code or of data is read by following its arrows, so the arrows must mean one thing before a label does. Initiator to receiver
is the direction a reader already holds for a call graph, a module graph and a file that reads another, and the direction a change travels
back along: change the receiver and the initiator is affected. Code acts and is never the thing acted on, except by the one who writes it,
which is why an arrow ending on a code block needs an actor behind it or the word `calls` or `feeds` on it, and why an actor is the glyph
that starts a flow. Drawing every plain arrow that way means a reader never has to decide whether a head marks the caller or the callee, and
a diagram that wants the opposite reading (data moving forward, a write, a failure) has to say so in a word, which the legend then lists.

## A steep edge's word

On a near-level edge a word centred on the line reads cleanly, because the line runs under the letters' baseline. On a steep one the line
cuts straight through the middle of the word. Standing the word beside the line, always on the same side and left-aligned, keeps the reading
direction constant and lets a reader pick out the line and the word as two things. Placing it the same way in the editor and in the raster
means the picture does not change when it is opened for editing.

## The proof is the accosted file

A drawing and its proof are two renderings of one set of runs, so the runs live once, in the accosted file, and the diagram refers to them.
Requiring each observation on the picture to occur verbatim in that file means the drawing cannot drift from what the proof runs, and
checking the action against its command contract means it names a command that exists. The words in an article follow from the same file
through the one reader, so a prose version of a call can never differ from the call.

## The proof box

A call is one statement to cats and a different spelling in each engine, and a reader who sees only the statement cannot tell what each
engine is asked to run. The box under the frame prints both, from the same normalized statement, so the spelling in an engine is derived and
never written. It is shown by default because the statement is the thing the drawing claims, and an author who needs the room turns it off
with one key.

## The proof lens

Sometimes the call is the whole point: a drawing of what an engine runs. The proof lens draws the box and nothing else, from the action
alone, so a call needs no cause and no effects to be shown in every engine's words.

## One legend band

A legend that changes shape from one drawing to the next has to be found again each time. One band under every drawing, with one captioned
box per part of the drawing above it, puts every key where the eye already is, and centred swatches beside left-aligned words read as one
column of symbols and one of words whatever the segment holds.

## The stick man

A reader standing over a map on a table sees the map, and sees themselves in it only as a figure laid on top. The stick man is that figure:
the cause's fragment already holds the idea, so it is his head by position, and his body is drawn afterwards over the finished drawing,
overlapping what it overlaps. Keeping him out of the layout and out of get means the drawing is the same drawing with or without him, and a
drawing that has no room for a reader's stand-in switches him off with one key.

## Head above hand

An idea is thought before it is done, and a reader follows that order downwards: the head above, the hand below on the line the rest of the
drawing runs along. Drawing an arrow from head to hand would say something a body already says, so the link is left to the body and the eye,
and the one word at the hand says what the hand does. Lifting the head above the line also gives the idea room to grow sideways without
pushing the statement.

## The transition pill

A word on a line says what the line means, and a pill hugging it keeps it legible over the line and any border it sits on. Where the line
crosses into another band or another zone, the crossing is the moment the word is about, so the pill stands there; elsewhere it stands at
the middle of the line, where it reads as the line's own name. One pill per line, with the arrowhead left clear, keeps every word the same
shape. A diagram set that prefers the quieter look configures the word beside the line instead, one setting for all of them.

## The zoom ladder

A lens and a distance answer different questions, so folding one into the other would multiply the lenses by every distance: a C2 slide can
be an architecture slide or a governance slide, and both stand equally far out. Keeping the zoom a second closed list leaves the lens list
as it is and lets any lens be drawn at any level. The ladder is Simon Brown's C4 model with a level C0 added under it for the truth stores
the repository sits among, since a repository is never the whole landscape. The badge prints the level beside the lens, so a reader moving
down a ladder always knows how far out the slide stands, and the subtitle keeps its one job of naming the decisions. The deep levels are
generated, because a hand-placed module or file list goes stale with the first rename, and the queries that answer it already exist.

## No name in the picture

A picture that says "catzc does it" tells the reader nothing the frame does not already say, since every diagram here is about this system.
Naming what acts, the importer, the modules or the platform band, carries the meaning instead. The name stays where it is the thing itself:
an identifier, a bundle a build prints, a product cover, or a band drawn against another system. Those exceptions are few, so each is
declared once with its reason rather than guessed by a pattern, and the check holds the rest at zero.

## The flow lens

The pipelines and workflows already declare how a commit moves: their files, the rungs registry and the pipeline-type naming. A third lens
draws that from them, so the picture of the delivery flow can never drift from the files that run it. Keeping the rows in PowerShell, where
the pipeline knowledge already lives, leaves one reader of pipeline YAML; the renderer only lays out rows, as it does for a zoom slide.
Environments come from the rungs because a deploy stage names its environment through a template expression, which a static read cannot
resolve, and a deploy pipeline is joined to its certifying run by name because nothing in its trigger points back.

## Glyphs are words

A small alphabet read in fixed places lets a reader learn the set once: the same circle open or dotted, a line high or low, a double line
for a thin link. Three symbols are enough to tell the pipeline, stage, job, step, template and variables apart, and short enough to read at
a lane's height. The glyphs echo the editor's file icons, so the tree and the diagrams look like one family, but the hint only points at the
icon; the two sets are drawn for different sizes and stay apart.

## The rhombus

In a flow diagram the lanes are full of boxes, so an environment drawn as one more box would read as a step. A different shape keeps it a
place a commit arrives at; the occupant rule stays the one rule every diagram follows.

## Spanners

A reader of a flow wants to see at a glance which lanes are CI or CD, where a person approves, and where review happens. A span bar over the
lanes, each with its glyph, carries that without crowding the lanes, and reading each from the tree keeps the bars as current as the files.
