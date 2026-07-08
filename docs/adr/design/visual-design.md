# ADR: Visual design of the value-chain diagrams — branch geometry and commit-colour semantics

The value-chain / promotion diagrams under `docs/.assets` are a domain language: a reader must be able to decode a commit's delivery state
and a branch's role from position and colour alone, without a per-diagram key. This ADR fixes that grammar so every diagram draws the same
shapes for the same meaning. The delivery states themselves are owned by
[ci-discipline-and-promotion-flow](ci-discipline-and-promotion-flow.md) (`ADR-FLOW`); this ADR owns only how they are _drawn_.

## Rules: ADR-VISUAL

### Rule ADR-VISUAL:1

Every value-chain diagram reads **left → right = time = value chain = delivery process = git history**, on one shared axis. The mainline
(`main` / `master` / `release`) is the horizontal spine; a commit's horizontal position is its point in time. Nothing in the grammar encodes
meaning on a right-to-left or top-down time axis.

- [One axis, read left to right](#one-axis-read-left-to-right)

### Rule ADR-VISUAL:2

**Branch direction encodes branch role: release branches render above the mainline, topic branches below it.** A line leaving the spine
upward is a release branch; a line leaving downward is a topic (development) branch. The direction is not decorative — it is the single cue
that tells release work apart from topic work, so it is never inverted or mixed.

- [Up is release, down is topic](#up-is-release-down-is-topic)

### Rule ADR-VISUAL:3

**A commit is drawn once and only recoloured; the history lane never deletes a commit.** Colour is the commit's furthest-reached delivery
state, not a separate token. A rejected or ignored commit keeps its place on the line in its terminal colour; the pipeline lanes may
_project_ or _discard_ a copy, but the commit itself stays in history.

- [Colour is state, history is permanent](#colour-is-state-history-is-permanent)

### Rule ADR-VISUAL:4

The **commit-colour palette is fixed**:

- **brown** — a development commit. Lives on topic branches; release branches may also carry brown (see ADR-VISUAL:6). Never an integrated
  mainline state.
- **grey** — integrated onto `main` / `master` / `release`. Grey never appears on a topic branch (a topic commit that has not integrated is
  brown, not grey).
- **ghost-grey** (faded, dashed) — a commit that exists in history but was silently ignored: no successor ever took it up. Still a real
  commit, still on the line.
- **yellow** — on `main` / `master` / `release` **and** past the BVT process, with an immutable artifact under version control.
- **ghost-yellow** (faded, dashed) — a _pre-verified_ BVT result that is **not on main/master**: produced either by the pre-commit
  build-validation / PR-gate pipeline on a brown topic commit, or by a local devbox invocation of the BVT process. It is not the
  version-controlled BVT artifact and confers no promotion.
- **blue / light-blue / light-green / mint** — the post-BVT promotion states owned by `ADR-FLOW`: **blue** is L3-verified on the on-demand
  environment; **light-blue** is rolled onto the always-on `main-UAT` non-prod environment; **light-green** is release-verified on the
  release-uat track; **mint** is in production.
- **red** — rejected by any process and must not progress further. Red is the one colour allowed on **every** branch (topic, release, or
  mainline), because rejection can happen anywhere.

Every hue has one locked hex pair (fill / stroke); see [Canonical palette (locked)](#canonical-palette-locked). A commit drawn in any other
hex for one of these meanings is a drift error.

- [The fixed palette](#the-fixed-palette)

### Rule ADR-VISUAL:5

**Grey and yellow separate on the BVT boundary, and the simulation is drawn as a ghost.** A commit is grey until an immutable,
version-controlled BVT artifact exists for it, at which point it is yellow. A _local_ pre-flight BVT the developer runs before the PR is
drawn ghost-yellow — same hue, faded — precisely so the diagram cannot be read as claiming a governed artifact where there is only a local
dry run.

- [The BVT boundary and its ghost](#the-bvt-boundary-and-its-ghost)

### Rule ADR-VISUAL:6

**Release-branch fixes flow fix-forward then cherry-pick up.** A release branch may carry brown development commits, and a supported process
for merging that work back to `main` / `master` exists — but the recommended and default-drawn path is the reverse: land the fix on `main` /
`master` first, then cherry-pick it **up** onto the release branch. The diagram favours the upward cherry-pick arrow so the mainline stays
the source of truth.

- [Fix forward, cherry-pick up](#fix-forward-cherry-pick-up)

### Rule ADR-VISUAL:7

**Promotion is a funnel: population strictly thins as state advances.** Across any one diagram the count of commits in each state decreases
along the promotion order — more brown than grey, fewer yellow than grey, fewer blue than yellow, fewer light-blue than blue, fewer
light-green than light-blue, fewer mint than light-green. A drawing that shows as many promoted commits as candidates misrepresents the gate
as a pass-through.

- [The funnel thins](#the-funnel-thins)

### Rule ADR-VISUAL:8

**Colour is temporal: it is the commit's state at a moment, and one commit may be drawn at several colours to show its progression.** A
commit does not own a fixed colour — it starts brown or grey and is recoloured as it moves through the flow (brown → grey → yellow → blue →
light-blue → light-green → mint), or terminates (→ red, or is left as a ghost). Showing the same commit at grey in git, yellow in the BVT
lane, and red in the discard lane is not a contradiction; it is the commit's history rendered as colour-over-time.

- [Colour is a moment, not a label](#colour-is-a-moment-not-a-label)

### Rule ADR-VISUAL:9

**Each pipeline stage has a fixed colour contract — the input colours it accepts, the output colour it produces, and that it may reject to
red.** The contract is what a stage box in the pipeline lane means:

- **BVT** accepts **brown or grey**, and produces **yellow** (an immutable versioned artifact). It may reject a candidate to **red**.
- **L3** accepts **yellow** and validates/continues only on yellow; **brown or grey** enter L3 only by manual invocation (as they may in
  BVT). L3 produces **blue** and may **invalidate its inputs to red**.
- **The PR gate / pre-commit build-validation** is human-initiated: a developer opts a **brown** topic commit into pre-commit validation,
  yielding a **ghost-yellow** (pre-verified, off main) — via the build-validation/PR pipeline or a local devbox BVT run.
- **main-uat** accepts **blue** and produces **light-blue** (rolled onto the always-on non-prod environment).
- **release-uat** accepts **light-blue** and produces **light-green** (release-verified).
- **DEPLOY** accepts **light-green** and produces **mint** (in production).

A stage never emits a colour outside its contract, so the palette doubles as the flow's type system.

- [Stages have colour contracts](#stages-have-colour-contracts)

### Rule ADR-VISUAL:10

**A single-digit number ties a commit's appearances across lanes into one identity.** When a diagram traces specific commits, each gets a
small digit (1, 2, 3, …) drawn on it, and every later appearance of that commit — in the pipeline, discard, or timeline lane — carries the
same digit. The number is the thread that lets a reader follow one commit's colour-over-time across the lanes without guessing which dot is
which.

- [Numbers thread one commit across lanes](#numbers-thread-one-commit-across-lanes)

### Rule ADR-VISUAL:11

**Ghosts exist in every colour, and a ghost is a faded rendering of the state it held while alive, drifting toward grey/green.** A ghost is
the diagram's _generic_ commit — "some commit in this stage" — drawn faded and dashed in the colour of that stage's state (ghost-brown,
ghost-grey, ghost-yellow, ghost-blue, …), not a separate grey-only token. A ghost carries **no number**: numbered means "this specific
commit, part of a traced journey"; un-numbered/ghost means "a representative commit here". ghost-grey (silently ignored) is just the grey
member of this family.

- [Ghosts of every colour](#ghosts-of-every-colour)

### Rule ADR-VISUAL:12

**Only the GIT lane is a real left-to-right time axis; the digits 0–9 are the time-code that carries that ordering into the other lanes.**
In git, horizontal position is actual time (commit `0` precedes `1` precedes `2` …). The pipeline, discard, and env lanes are organised by
_stage_, not by time, so a commit can sit anywhere horizontally there — its **number** is what restores its identity and its moment. Each
digit `0`–`9` is one commit's whole story: the same number reappears across lanes in its state-of-the-moment colour and ends where that
commit was discarded, abandoned, or promoted.

- [Git is the only true timeline](#git-is-the-only-true-timeline)

### Rule ADR-VISUAL:13

**An environment box is two-toned: its outline is the stage it belongs to; its fill-commit is the input colour that environment exists to
check.** The hexagon's border/tint names the stage/environment (on-demand, main-UAT, release-uat, production); the commit drawn _inside_ it
— generic or numbered — is coloured for the state that environment validates, not the state it produces. The on-demand L3 environment
therefore holds a **yellow** commit inside (yellow is L3's input), main-UAT holds **blue**, and so on up the ladder.

- [Environment boxes: outline is the stage, fill is the input](#environment-boxes-outline-is-the-stage-fill-is-the-input)

### Rule ADR-VISUAL:14

**The lifecycle endings each have a distinct rendering; they are not all red.** The commit lifecycle states owned by
[ADR-LIFE](commit-lifecycle.md) are drawn as: **discarded** — red, on the line and in the DISCARDED/Retired lane; **retired** — kept in its
production colour (mint) and moved into the DISCARDED/Retired lane, never repainted red; **superseded** — its last promotion colour drawn as
a ghost (faded), because it was valid but abandoned; **dirty HEAD** — its failed-stage colour with a rejection mark, distinct from a clean
occupant; **in-process** — the input colour drawn inside the stage box; **environment occupant** — the single numbered commit inside an
environment box. The ② lane is therefore labelled _DISCARDED / Retired_, because retirement is a success that shares the lane, not the
colour, of discard.

- [Lifecycle endings are not all red](#lifecycle-endings-are-not-all-red)

## One axis, read left to right

Time, the value chain, the delivery process, and git history all advance together from left to right, so one horizontal axis carries all of
them. Collapsing them onto a single spine is what lets a reader trace a single commit from candidate to production without switching mental
models. A diagram that puts time on a different axis for one lane breaks the alignment that makes the lanes comparable.

## Up is release, down is topic

The mainline is the spine; the two kinds of branch that leave it are told apart by direction alone. Release branches — long-lived,
promotion-bearing — sit above the spine; topic branches — short-lived development forks — sit below it. Encoding role in direction keeps the
colour channel free for delivery state and means the reader never has to read a label to know which kind of branch a line is. Mixing the
directions, or drawing a topic branch above the line, destroys that one-glance decode.

## Colour is state, history is permanent

Git history is append-only, and the diagram mirrors that: a commit is placed once and thereafter only changes colour as its state advances
or terminates. Redrawing a rejected commit as "gone" would contradict the history it belongs to; instead it stays in place in its terminal
colour (red or ghost-grey). The pipeline and discard lanes work on _projections_ of the commit, never by removing it from the history lane.

## The fixed palette

A fixed palette is what makes the diagrams a language rather than a set of one-off pictures. Each hue is bound to exactly one delivery
state, and the binding is the same in every diagram, so a colour never has to be re-explained. The promotion hues (yellow → blue →
light-blue → mint) share a warm-to-cool progression that reads as forward motion through the flow; brown and grey are the pre-promotion
states; red is terminal rejection and is the only colour that may appear on any branch.

## The BVT boundary and its ghost

The single most consequential line in the palette is grey-to-yellow: it is where an integrated commit gains a governed, immutable,
version-controlled build artifact. Drawing the local pre-flight BVT in the same solid yellow would let a developer's dry run look like a
certified artifact, so the local case is drawn ghost-yellow — visibly not the real thing. The ghost treatment is a poka-yoke against
mistaking a local simulation for a governed gate.

## Fix forward, cherry-pick up

Because the mainline is the source of truth, the default remediation for a release branch is to fix on `main` / `master` and cherry-pick the
change upward onto the release branch, rather than developing on the release branch and merging down. A merge-down process is supported for
cases that need it, but the diagram draws the upward cherry-pick as the recommended path so the geometry itself nudges teams toward keeping
the mainline authoritative.

## The funnel thins

Every gate exists to reject; a diagram that shows equal populations before and after a gate quietly claims the gate rejects nothing. The
grammar therefore requires the drawn counts to strictly decrease along the promotion order, so the shape of the cloud communicates the
selectivity of the flow at a glance — a wide brown/grey base narrowing to a few mint commits in production.

## Colour is a moment, not a label

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
| Manual gate → release              | blue                                                               | light-blue (release-verified)                            | — (held, not rejected)          |
| DEPLOY                             | light-blue                                                         | mint (in production)                                     | —                               |

Grey and brown can be _run_ through BVT or L3 by hand, but only yellow is what L3 _validates and continues_; the manual-run cases are the
exception the contract names rather than hides. Because each stage emits exactly one promotion colour, the palette is the flow's type
system: an arrow leaving L3 that is any colour but blue or red is a drawing error.

## Numbers thread one commit across lanes

Tracing a specific commit is how the diagram teaches the temporal-colour idea concretely, and a bare dot cannot be tracked across three
lanes of similar dots. A single digit solves it: commit `#1` grey on the mainline and commit `#1` red in the discard lane are visibly the
same commit, so the reader learns "landed, then BVT rejected it" from the number plus the colour change. The digits are a reading aid for
worked examples, not a permanent identifier every commit must carry.

## Ghosts of every colour

A ghost answers "what does a commit at this stage look like, in general" without asserting which commit it is. Because every stage has a
state colour, ghosts inherit that colour — faded and dashed, drifting toward grey/green to read as inactive — so a ghost-blue in the L3 lane
says "some L3-verified commit sits here" the same way a solid numbered blue says "commit 4, L3-verified, sits here". Restricting ghosts to
grey would lose that: the whole point is that the generic placeholder still tells you the stage it stands in. The number is the only thing
that distinguishes a traced commit from a representative one.

## Git is the only true timeline

Horizontal position means _time_ in exactly one lane — git — and nowhere else, because only history is intrinsically ordered. The pipeline,
discard, and environment lanes group commits by stage, so their left-to-right order is not chronological; reading them as a timeline would
be a mistake. The digits 0–9 are how time survives the crossing: a numbered commit keeps its identity and its moment no matter where it
lands in a stage-organised lane, and following a single number across the lanes reconstructs that one commit's journey and shows exactly
where it was discarded, abandoned, or promoted.

## Environment boxes: outline is the stage, fill is the input

An environment is not a commit, so it is drawn as a container whose two tones carry two different facts: the outline is which environment
this is (the stage it serves), and the commit inside is what that environment is currently checking. The inside is coloured for the
environment's **input**, not its output — the L3 on-demand slot exists to validate yellow, so it holds a yellow commit; main-UAT holds blue;
release-uat holds light-blue; production holds light-green. Reading the inner colour tells you what is being certified there; the outer
tells you where.

## Canonical palette (locked)

These hex pairs are the single source of truth; the enforcing values live in the diagram files, but the meaning-to-hex binding is fixed
here. Any other hex for one of these meanings is drift and must be normalised.

| State / role                                 | Fill                                                 | Stroke              |
| -------------------------------------------- | ---------------------------------------------------- | ------------------- |
| brown — off-main / development               | `#C4915C`                                            | `#7A4B25`           |
| grey — landed on main                        | `#C9CCD1`                                            | `#6B7178`           |
| yellow — BVT-verified                        | `#FFE082`                                            | `#F9A825`           |
| blue — L3-verified                           | `#64B5F6`                                            | `#1565C0`           |
| light-blue — main-UAT (always-on non-prod)   | `#dae8fc`                                            | `#6c8ebf`           |
| light-green — release-verified (release-uat) | `#d5e8d4`                                            | `#82b366`           |
| mint — in production                         | `#9BE7C4`                                            | `#0E9F6E`           |
| red — rejected / discarded (any branch)      | `#EF9A9A`                                            | `#C62828`           |
| ghost — any state, faded                     | that state's fill at reduced opacity, dashed outline | that state's stroke |

Ghost-grey and ghost-yellow are the grey and yellow members of the ghost family; there is no separate ghost hex. Stage-box and
environment-outline tints (sienna, slate, azure, orange, and the pale env hexes) are _chrome_, not commit states, and are not part of this
locked commit palette.

## Lifecycle endings are not all red

The single biggest legibility risk is painting every "not in production" commit red, which would erase the difference between a defect and a
success. So the endings are drawn apart: red for rejection, mint-in-the-retired-lane for a commit that served and was decommissioned, a
faded ghost for one that was valid but overtaken, and a marked HEAD for the latest-but-broken tip. The colour still carries the state; the
_lane_ and the _fade/mark_ carry the ending. [ADR-LIFE](commit-lifecycle.md) owns what these endings mean; this rule owns how they look.

## Dora explains

Visual grammar is a communication artifact, and DORA treats the clarity of a team's delivery model as part of how well the team can improve
it: a shared, unambiguous picture of how work flows from commit to production is what lets a team reason about its own bottlenecks. Fixing
branch geometry and colour semantics makes the value stream legible, which is a precondition for the measurement-and-improvement loop DORA
describes.

- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — the diagrams model the promotion flow this capability governs.
- [Trunk-based development](https://dora.dev/capabilities/trunk-based-development/) — the up/release, down/topic geometry and the
  fix-forward-then-cherry-pick rule encode a trunk-based branching model.
- [Working in small batches](https://dora.dev/capabilities/working-in-small-batches/) — the funnel-thinning rule makes batch size and gate
  selectivity visible.
- [DORA research overview](https://dora.dev/research/).
