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

- **brown** — a development commit. Lives on topic branches; release branches may also carry brown (see
  DDR-VISUAL-FIXFORWARDTHENCHERRYPICK). Never an integrated mainline state.
- **grey** — integrated onto `main` / `master` / `release`. Grey never appears on a topic branch (a topic commit that has not integrated is
  brown, not grey).
- **ghost-grey** (faded, dashed) — a commit that exists in history but was silently ignored: no successor ever took it up. Still a real
  commit, still on the line.
- **yellow** — on `main` / `master` / `release` **and** past the BVT process, with an immutable artifact under version control.
- **ghost-yellow** (faded, dashed) — a _pre-verified_ BVT result that is **not on main/master**: produced either by the pre-commit
  build-validation / PR-gate pipeline on a brown topic commit, or by a local devbox invocation of the BVT process. It is not the
  version-controlled BVT artifact and confers no promotion.
- **blue / light-blue / light-green / green** — the post-BVT promotion states: **blue** is L3-verified on the on-demand environment;
  **light-blue** is rolled onto the always-on `main-UAT` non-prod environment; **light-green** is release-verified on the release-uat track;
  **green** is in production.
- **red** — rejected by any process and must not progress further. Red is the one colour allowed on **every** branch (topic, release, or
  mainline), because rejection can happen anywhere.

The **pre-prod** rung has no hue of its own: its occupant is drawn green, the same bytes already validated for production, and the neutral
environment box, not the colour, says which of the two it sits in (DDR-VISUAL-ENVIRONMENTISCONTAINER).

Every hue has one locked hex pair (fill / stroke); see [Canonical palette (locked)](#canonical-palette-locked). A commit drawn in any other
hex for one of these meanings is a drift error.

- [The fixed palette](#the-fixed-palette)

### Rule DDR-VISUAL-GREYYELLOWATBVT

**Grey and yellow separate on the BVT boundary, and the simulation is drawn as a ghost.** A commit is grey until an immutable,
version-controlled BVT artifact exists for it, at which point it is yellow. A _local_ pre-flight BVT the developer runs before the PR is
drawn ghost-yellow — same hue, faded — precisely so the diagram cannot be read as claiming a governed artifact where there is only a local
dry run.

- [The BVT boundary and its ghost](#the-bvt-boundary-and-its-ghost)

### Rule DDR-VISUAL-FIXFORWARDTHENCHERRYPICK

**Release-branch fixes flow fix-forward then cherry-pick up.** A release branch may carry brown development commits, and a supported process
for merging that work back to `main` / `master` exists — but the recommended and default-drawn path is the reverse: land the fix on `main` /
`master` first, then cherry-pick it **up** onto the release branch. The diagram favours the upward cherry-pick arrow so the mainline stays
the source of truth.

- [Fix forward, cherry-pick up](#fix-forward-cherry-pick-up)

### Rule DDR-VISUAL-PROMOTIONISFUNNEL

**Promotion is a funnel: population strictly thins as state advances.** Across any one diagram the count of commits in each state decreases
along the promotion order — more brown than grey, fewer yellow than grey, fewer blue than yellow, fewer light-blue than blue, fewer
light-green than light-blue, fewer green (pre-prod and production together) than light-green. A drawing that shows as many promoted commits
as candidates misrepresents the gate as a pass-through.

- [The funnel thins](#the-funnel-thins)

### Rule DDR-VISUAL-COLOURISTEMPORAL

**Colour is temporal: it is the commit's state at a moment, and one commit may be drawn at several colours to show its progression.** A
commit does not own a fixed colour — it starts brown or grey and is recoloured as it moves through the flow (brown → grey → yellow → blue →
light-blue → light-green → green), or terminates (→ red, or is left as a ghost). Showing the same commit at grey in git, yellow in the BVT
lane, and red in the discard lane is not a contradiction; it is the commit's history rendered as colour-over-time.

- [Colour as a moment](#colour-as-a-moment)

### Rule DDR-VISUAL-STAGECOLOURCONTRACT

**Each pipeline stage has a fixed colour contract — the input colours it accepts, the output colour it produces, and that it may reject to
red.** The contract is what a stage box in the pipeline lane means:

- **BVT** accepts **brown or grey**, and produces **yellow** (an immutable versioned artifact). It may reject a candidate to **red**.
- **L3** accepts **yellow** and validates/continues only on yellow; **brown or grey** enter L3 only by manual invocation (as they may in
  BVT). L3 produces **blue** and may **invalidate its inputs to red**.
- **The PR gate / pre-commit build-validation** is human-initiated: a developer opts a **brown** topic commit into pre-commit validation,
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
the diagram's _generic_ commit — "some commit in this stage" — drawn faded and dashed in the colour of that stage's state (ghost-brown,
ghost-grey, ghost-yellow, ghost-blue, …), not a separate grey-only token. A ghost carries **no number**: numbered means "this specific
commit, part of a traced journey"; un-numbered/ghost means "a representative commit here". ghost-grey (silently ignored) is just the grey
member of this family.

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
from that file, or links the file. The PowerShell text in an article is a rendering of the contract form, produced by the accosted
language's one reader and never written by hand; a linked `.ps1` asset is not taken, since it would be a second version of the same runs
([PDR-ONELIVE-ONEVERSION](../principles/one-living-version.md#rule-pdr-onelive-oneversion)).

- [The proof is the accosted file](#the-proof-is-the-accosted-file)

### Rule DDR-VISUAL-PROOFBOXUNDERTHEFRAME

A **proof box** is the box captioned Proof under the frame of an action diagram, as wide as the frame. For each call of the action it prints
the call's normalized statement, written with the word cats, and the words each engine runs it as, in the idiom of that engine (PascalCase
for pwsh, kebab-case for every other engine). The engines and their idioms are declared once in the renderer's vocabulary, never in a
declaration. An action diagram shows the proof box by default, and `content.proof: hidden` turns it off, the default being declared once in
the same vocabulary.

- [The proof box](#the-proof-box)

### Rule DDR-VISUAL-PROOFISALENS

The **proof lens** is the value `proof` of a declaration's `about.lens`: a diagram under it draws the proof box alone, from
`content.action`, where the frame would stand. It declares no cause and no effects, and no `content.proof`, since the box is the whole
drawing. Its lens badge prints PROOF, and its subtitle ends in `proof`.

- [The proof lens](#the-proof-lens)

### Rule DDR-VISUAL-ONELEGENDBAND

A **legend band** is the one band under every drawing, band diagrams included, and a **legend segment** is one captioned box of it, as wide
as the part of the drawing it stands under: Action and Proof under the frame, Map key under the sidebar. In every segment the swatches stand
centred in a left column and the words are left-aligned beside them. The band never starts above the bottom of the sidebar's minimaps, so a
drawing shorter than the sidebar leaves room beneath itself and the band stays under the sidebar.

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

### Rule DDR-VISUAL-ARROWSPOINTATWHATTHEYDEPENDON

An arrow runs from the one that acts, its initiator, to what it acts on or depends on, its receiver: the caller to the callee, the consumer
to its provider, a resolver to the sources it reads, and the head is always the receiver. Code acts and is not acted on, so a plain arrow
ends on a code block only from an actor, an author or a trigger, which a diagram may place at the start of a flow; a call is the declared
exception, an arrow labelled `calls` whose head is the code it runs, and a feed is the second, an arrow labelled `feeds` whose head is the
code that takes in what the tail supplies (its tail still initiates). Only a word says otherwise: an arrow whose label names another meaning
(`reads`, `writes`, `feeds`, `failed`) means that, and a diagram that gives its plain arrows one other meaning states it as its `relation`,
which every plain arrow then carries and which opts the diagram out of the check. The `relation` opt-out is for state and commit diagrams
only, where an arrow is a step between states rather than a dependency: `commit-promotion-states` declares "advances one rung", and
`sync-point` declares "points at"; any other diagram's plain arrows keep the default meaning. The default meaning, the code kinds, the
labels that may end on code and each label's initiating end are declared once, in the `edge-semantics` and `edge-labels` of the kit's
`drawio.yml`; the legend entry of a plain arrow reads `flow: initiator to receiver` from that declaration, and a declaration that breaks the
rule is refused naming the edge.

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

## One axis, read left to right

Time, the value chain, the delivery process, and git history all advance together from left to right, so one horizontal axis carries all of
them. Collapsing them onto a single spine is what lets a reader trace a single commit from candidate to production without switching mental
models. A diagram that puts time on a different axis for one lane breaks the alignment that makes the lanes comparable.

## Up is release, down is topic

The mainline is the spine; the two kinds of branch that leave it are told apart by direction alone. Release branches — long-lived,
promotion-bearing — sit above the spine; topic branches — short-lived development forks — sit below it. Encoding role in direction keeps the
colour channel free for delivery state and means the reader never has to read a label to know which kind of branch a line is. Mixing the
directions, or drawing a topic branch above the line, destroys that one-glance decode.

## Colour and history

`Colour is state, history is permanent`

Git history is append-only, and the diagram mirrors that: a commit is placed once and thereafter only changes colour as its state advances
or terminates. Redrawing a rejected commit as "gone" would contradict the history it belongs to; instead it stays in place in its terminal
colour (red or ghost-grey). The pipeline and discard lanes work on _projections_ of the commit, never by removing it from the history lane.

## The fixed palette

A fixed palette is what makes the diagrams a language rather than a set of one-off pictures. Each hue is bound to exactly one delivery
state, and the binding is the same in every diagram, so a colour never has to be re-explained. The promotion hues (yellow → blue →
light-blue → green) share a warm-to-cool progression that reads as forward motion through the flow; brown and grey are the pre-promotion
states; red is terminal rejection and is the only colour that may appear on any branch. The post-BVT promotion states the hues stand for are
defined by the flow domain; the palette owns only their colours.

## The BVT boundary and its ghost

The single most consequential line in the palette is grey-to-yellow: it is where an integrated commit gains a governed, immutable,
version-controlled build artifact. Drawing the local pre-flight BVT in the same solid yellow would let a developer's dry run look like a
certified artifact, so the local case is drawn ghost-yellow — visibly not the real thing. The ghost treatment is a poka-yoke against
mistaking a local simulation for the governed CI gate.

## Fix forward, cherry-pick up

Because the mainline is the source of truth, the default remediation for a release branch is to fix on `main` / `master` and cherry-pick the
change upward onto the release branch, rather than developing on the release branch and merging down. A merge-down process is supported for
cases that need it, but the diagram draws the upward cherry-pick as the recommended path so the geometry itself nudges teams toward keeping
the mainline authoritative.

## The funnel thins

Every gate exists to reject; a diagram that shows equal populations before and after a gate quietly claims the gate rejects nothing. The
grammar therefore requires the drawn counts to strictly decrease along the promotion order, so the shape of the cloud communicates the
selectivity of the flow at a glance — a wide brown/grey base narrowing to a few green commits in production.

## Colour as a moment

`Colour is a moment, not a label`

A commit's colour answers "what state is this commit in right now", not "what kind of commit is this". Because the flow moves a commit
through states, the honest way to draw its life is to recolour it at each step and, where a diagram wants to show the motion, to draw the
same commit more than once at successive colours. A reader who sees commit `#2` grey on the mainline, yellow inside BVT, and red in the
discard lane is reading one commit's history, not three different commits.

## Stages have colour contracts

Every stage in the pipeline is a typed transform on colours, and stating the type is what keeps the diagram honest about what each stage can
and cannot do. The full contract:

| Stage                              | Accepts (input)                                                    | Produces                                                 | Rejects to                      |
| ---------------------------------- | ------------------------------------------------------------------ | -------------------------------------------------------- | ------------------------------- |
| Pre-commit / PR gate (human-opted) | brown (topic)                                                      | ghost-yellow (off main; PR pipeline or local devbox BVT) | red                             |
| BVT                                | brown, grey                                                        | yellow (immutable versioned artifact)                    | red                             |
| L3                                 | yellow (validates/continues); brown/grey only by manual invocation | blue                                                     | red (may invalidate its inputs) |
| main-UAT (gate: RC)                | blue                                                               | light-blue (rolled onto always-on non-prod)              | red, or held at the gate        |
| release-uat (gate: RBC)            | light-blue                                                         | light-green (release-verified)                           | red, or held at the gate        |
| DEPLOY-Prod (through pre-prod)     | light-green                                                        | green (in production)                                    | —                               |

Grey and brown can be _run_ through BVT or L3 by hand, but only yellow is what L3 _validates and continues_; the manual-run cases are the
exception the contract names rather than hides. Because each stage emits exactly one promotion colour, the palette is the flow's type
system: an arrow leaving L3 that is any colour but blue or red is a drawing error.

The flow domain defines what the stages are: the RC and RBC release gates, the `-uat` environments apart from the `-AT` testing drawn at
those gates, and the DEPLOY stages. This rule owns only how they are drawn.

## Commit numbers

`Numbers thread one commit across lanes`

Tracing a specific commit is how the diagram teaches the temporal-colour idea concretely, and a bare dot cannot be tracked across three
lanes of similar dots. A number solves it: commit `#1` grey on the mainline and commit `#1` red in the discard lane are visibly the same
commit, so the reader learns "landed, then BVT rejected it" from the number plus the colour change. The digits are a reading aid for worked
examples, not a permanent identifier every commit must carry.

## Ghosts of every colour

A ghost answers "what does a commit at this stage look like, in general" without asserting which commit it is. Because every stage has a
state colour, ghosts inherit that colour — faded and dashed, drifting toward grey/green to read as inactive — so a ghost-blue in the L3 lane
says "some L3-verified commit sits here" the same way a solid numbered blue says "commit 4, L3-verified, sits here". Restricting ghosts to
grey would lose that: the whole point is that the generic placeholder still tells you the stage it stands in. The number is the only thing
that distinguishes a traced commit from a representative one.

## Git is the only true timeline

Horizontal position means _time_ in exactly one lane — git — and nowhere else, because only history is intrinsically ordered. The pipeline,
discard, and environment lanes group commits by stage, so their left-to-right order is not chronological; reading them as a timeline would
be a mistake. The commit numbers are how time survives the crossing: a numbered commit keeps its identity and its moment no matter where it
lands in a stage-organised lane, and following a single number across the lanes reconstructs that one commit's journey and shows exactly
where it was discarded, abandoned, or promoted.

## Environment boxes

`Environment boxes: a neutral container showing its occupant`

An environment is not a commit, so it is drawn as a container — and the container itself is **neutral chrome**: it carries no state colour
and no per-stage tint, only a label naming which environment it is. What it does carry is its **occupant**: the one commit deployed there
right now, drawn in that commit's own current state colour. So the inner colour is not a fixed property of the box — it is whatever state
the occupant is in: the production occupant is drawn green, the release-uat occupant light-green, the main-UAT occupant light-blue, and the
on-demand L3 environment whatever it currently hosts. Reading the inner colour tells you the state of what lives there now; the label tells
you where. This follows from each always-on environment hosting exactly one commit, its occupant, rather than colouring the box by what it
validates — an environment's picture is "what is deployed here", not "what this stage is for".

## Canonical palette (locked)

These hex pairs are the single source of truth; the enforcing values live in the diagram files, but the meaning-to-hex binding is fixed
here. Any other hex for one of these meanings is drift and must be normalised.

| State / role                                                      | Fill                                                 | Stroke              |
| ----------------------------------------------------------------- | ---------------------------------------------------- | ------------------- |
| brown — off-main / development                                    | `#C4915C`                                            | `#7A4B25`           |
| grey — landed on main                                             | `#C9CCD1`                                            | `#6B7178`           |
| yellow — BVT-verified                                             | `#FFE082`                                            | `#F9A825`           |
| blue — L3-verified                                                | `#64B5F6`                                            | `#1565C0`           |
| light-blue — main-UAT (always-on non-prod)                        | `#dae8fc`                                            | `#6c8ebf`           |
| light-green — release-verified (release-uat)                      | `#d5e8d4`                                            | `#82b366`           |
| green — in production (pre-prod and production occupants)         | `#60a917`                                            | `#2D7600`           |
| red — rejected / discarded (any branch)                           | `#EF9A9A`                                            | `#C62828`           |
| ghost-topic — topic candidate in the Authoring / Pre-Commit queue | `#F47847`                                            | `#6D1F00`           |
| ghost-BVT — BVT-verified candidate queued for L3                  | `#FFF2CC`                                            | `#D6B656`           |
| ghost-L3 — L3-verified candidate queued for main-UAT              | `#1DB6FF`                                            | `#006EAF`           |
| ghost — any other state, faded                                    | that state's fill at reduced opacity, dashed outline | that state's stroke |

The three named `ghost-*` hexes above are dedicated tones for the busiest candidate queues (a commit that _has been / is queued_ in that
stage — the "ghost = been in this state" legend form), drawn as their own colour rather than a reduced-opacity fill so they read in a
crowded queue lane. Every other state's ghost is still that state's fill faded (the last row).

Ghost-grey and ghost-yellow are the grey and yellow members of the ghost family; there is no separate ghost hex. Pipeline **stage-box**
tints (sienna, slate, azure, orange, and the pale green `#9BE7C4`/`#0E9F6E` on the pre-prod and production boxes) are _chrome_, not commit
states, and are not part of this locked commit palette — a production commit is the saturated green `#60a917` above, while `#9BE7C4` is only
the pre-prod / production box tint. **Environment** boxes carry no tint at all — they are neutral containers coloured only by their occupant
(DDR-VISUAL-ENVIRONMENTISCONTAINER).

## Lifecycle endings

`Lifecycle endings are not all red`

The single biggest legibility risk is painting every "not in production" commit red, which would erase the difference between a defect and a
success. So the endings are drawn apart: red for rejection, green-in-the-retired-lane for a commit that served and was decommissioned, a
faded ghost for one that was valid but overtaken, and a marked HEAD for the latest-but-broken tip. The colour still carries the state; the
_lane_ and the _fade/mark_ carry the ending. The delivery flow's commit lifecycle owns what these endings mean; this rule owns how they
look.

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
