# ADR: The commit lifecycle — states, environment occupancy, and the stable sync point

The value-chain diagrams under `docs/.assets/commits-quality` — the `value-chain` promotion diagram and its `state-changes` flow-variant
companion — encode more than a promotion ladder: they encode what _happens to a commit_ — how it advances, where it dies, how it retires,
how it is overtaken by a newer commit, which commit an environment currently hosts, and which commit the outside world should integrate
from. This ADR states that lifecycle and integration model. The pipeline _domains_ (CI / CD / DEPLOY, the tagged artifact,
build-once-deploy-many) are owned by [cd-discipline-and-promotion-flow](cd-discipline-and-promotion-flow.md) (`ADR-FLOW-CD`); the _visual
grammar_ (colours, lanes, ghosts, numbers) by [visual-design](visual-design.md) (`ADR-DSGN-VISUAL`). This ADR owns the commit's lifecycle
states and the upstream/downstream sync semantics.

## Rules: ADR-DSGN-LIFE

### Rule ADR-DSGN-LIFE:1

**A commit holds one lifecycle state at a time; the state advances one rung along the promotion ladder or leaves it, and never moves
backward.** The ladder is: topic (brown) → landed on main (grey) → BVT-verified (yellow) → L3-verified (blue) → main-UAT / main-AT-verified
(light-blue) → release-uat / release-AT-verified (light-green) → **pre-prod** (staged, not yet live) → in production (green). The `main-UAT`
and `release-uat` rungs are reached by clearing their **acceptance testing** — `main-AT` and `release-AT` — at the RC and RBC gates
(ADR-FLOW-CD:9/ADR-FLOW-CD:10). At any rung a commit may advance, **hold** as an environment's current occupant, or **leave the ladder**
into a terminal state (discarded, retired, or superseded). It never regresses to an earlier rung — a commit is not "re-verified" downward; a
new attempt is a new commit.

- [The ladder and its one direction](#the-ladder-and-its-one-direction)

### Rule ADR-DSGN-LIFE:2

**Discard is terminal rejection at a named stage, and the discarded commit stays in history.** A process rejects a candidate: **BVT** and
**L3** discard automatically, **release-uat** discards through its manual gate (**RBC**, ADR-FLOW-CD:9), and **main-UAT** can kill a commit
that fails there or hold it at its manual gate (**RC**, ADR-FLOW-CD:9). A discarded commit is coloured red, remains on the line where it was
committed (history is never rewritten), and can never progress. The diagram records _where_ it died, because "discarded at BVT" and
"discarded at release-uat" are different facts about the same outcome.

- [Discard is rejection, and it is named](#discard-is-rejection-and-it-is-named)

### Rule ADR-DSGN-LIFE:3

**Retirement is a successful end-of-life, and it is not a discard.** A commit that reached production, served there, and was then superseded
by a newer production commit is **retired** — it did its job and was decommissioned. Retirement and discard both mean "no longer live", but
they are opposite outcomes: discard is rejection before value was delivered; retirement is graceful hand-off after value was delivered. A
diagram that paints a retired commit the same red as a discarded one erases that difference.

- [Retirement is success, not rejection](#retirement-is-success-not-rejection)

### Rule ADR-DSGN-LIFE:4

**Supersession (rollover) abandons a still-valid commit that a newer commit overtook.** When a newer commit rolls over an older one that was
still progressing toward the same environment, the older is **superseded**: it was never rejected — it was valid — but a fresher commit
became the one carried forward, so the older is abandoned in place. Supersession is the third distinct ending, between "rejected" (discard)
and "delivered then retired": valid, but not chosen.

- [Supersession abandons without rejecting](#supersession-abandons-without-rejecting)

### Rule ADR-DSGN-LIFE:5

**Each always-on environment hosts exactly one current commit, plus a history.** `main-UAT`, `release-uat`, `pre-prod`, and `production` are
stateful, not pass-through: at any moment each holds one **current occupant** — the commit presently deployed there — and a trail of the
commits it held before. An environment box in the diagram is a neutral container naming one live commit, drawn in that occupant's current
state colour (ADR-DSGN-VISUAL:13), so reading its occupant tells you the true state of that environment right now.

- [Environments have a single occupant](#environments-have-a-single-occupant)

### Rule ADR-DSGN-LIFE:6

**The stable integration point is the current `main-UAT` commit, and upstream integrators sync from it — never from HEAD.** `main-UAT` holds
the latest commit certified onto the always-on non-prod environment; that commit, not the raw tip of main, is what external or upstream
consumers integrate against for stability. "Sync from main-UAT" is the safe default because that commit has cleared every automated gate up
to and including the always-on environment.

- [Sync from main-UAT, not HEAD](#sync-from-main-uat-not-head)

### Rule ADR-DSGN-LIFE:7

**The dirty HEAD is the latest commit on main and is not a safe sync or promotion source.** HEAD is simply the newest commit; it may have
_failed_ a downstream stage (for example, died in `main-UAT`). Such a commit is the **dirty HEAD**: it is the tip of main, but it must not
be synced from and cannot be promoted downstream. Consumers who naively track HEAD are pointed instead at the stable `main-UAT` occupant
(ADR-DSGN-LIFE:6). "Latest" and "safe to build on" are different questions, and the model keeps them separate.

- [The dirty HEAD](#the-dirty-head)

### Rule ADR-DSGN-LIFE:8

**A commit that fails a stage cannot go downstream.** Failure at any environment stops both _promotion_ (it will not advance to a later
environment) and _downstream consumption_ (nothing may build on it). Downstream flow is gated on the last successful state, so a failure is
a hard stop, not a soft warning.

- [Failure stops downstream](#failure-stops-downstream)

### Rule ADR-DSGN-LIFE:9

**A topic commit can be deployed out-of-band by a workflow without integrating into main/master.** A workflow or pipeline may deploy a
commit that still lives on a topic branch — a hotfix or an experiment — even though it has not reached main/master. That deploy is
explicitly **not** an integration: the commit remains off-main until it lands normally, and the out-of-band deploy confers no promotion
state on the mainline.

- [Out-of-band topic deploys](#out-of-band-topic-deploys)

### Rule ADR-DSGN-LIFE:10

**A commit's number is its time-ordered identity, and its terminal appearance is where its story ends.** Numbers run in commit time (`0`
before `1` … before `10`); the same number reappears in each lane in its state-of-the-moment colour, and its last appearance names its
ending — discarded, retired, superseded, in-process, an environment's current occupant, or the dirty HEAD. The numbered worked examples are
the canonical encoding of this lifecycle (they render the grammar of [ADR-DSGN-VISUAL:12](visual-design.md#rule-adr-dsgn-visual12)).

- [One number, one story](#one-number-one-story)

## The ladder and its one direction

Promotion is monotonic because each rung is a stronger claim about the same artifact, and a stronger claim is never un-made by moving a
commit backward. A commit that has reached `main-UAT` is not demoted to "just BVT-verified"; if something is wrong, the commit is discarded
and a _new_ commit carries the fix forward. Modelling the ladder as one-directional is what lets a colour mean a durable fact ("this commit
is L3-verified") rather than a mutable label, and it is why the three ways off the ladder — discard, retirement, supersession — are all
terminal.

## Discard is rejection, and it is named

Every gate exists to reject, and the diagram records not just that a commit was rejected but by which gate, because the gate is the
diagnosis. BVT and L3 reject automatically the moment their checks fail; release-uat rejects only when a human opens its manual gate (RBC)
the wrong way; `main-UAT` rejects a commit that cannot stand up on the always-on environment, or that a human holds at its gate (RC).
Keeping the rejection point in the record turns "it was discarded" into "it was discarded at L3", which is the difference between a shrug
and a lead.

## Retirement is success, not rejection

The most consequential distinction in the lifecycle is that leaving production is usually a _win_. A commit reaches production, serves real
traffic, and is eventually replaced by a newer production commit; at that point it retires. Collapsing retirement into discard would make
the diagram claim that a commit which delivered months of value "failed", which is the opposite of the truth. Retirement is drawn as the
production colour moved into the retired lane — the commit keeps the green of what it achieved.

## Supersession abandons without rejecting

Not every commit that fails to reach production was wrong; some were simply overtaken. When a newer commit rolls over an older one on the
way to an environment, the older commit was valid at the moment it was abandoned — no gate rejected it — but a fresher commit became the one
carried forward. Naming this as its own ending (rather than lumping it with discard) matters because a superseded commit tells you the
pipeline was _moving fast_, whereas a discarded commit tells you the pipeline _caught a defect_; conflating them hides both signals.

## Environments have a single occupant

An always-on environment is a place, and a place holds one thing at a time. `main-UAT`, `release-uat`, and `production` each have exactly
one current commit deployed, and treating them as stateful — occupant plus history — is what makes questions like "what is in production
right now" and "what should I sync from" answerable by pointing at a single dot. A pass-through mental model, where commits merely flow
through, cannot answer those questions; the occupant model can.

## Sync from main-UAT, not HEAD

Stability for consumers comes from integrating against a commit that has already been proven on the always-on non-prod environment, which is
precisely the `main-UAT` occupant. The tip of main is younger and less proven; building on it inherits whatever has not yet been caught. The
rule "sync from `main-UAT`" gives every upstream consumer one well-defined, continuously-updated, already-certified commit to depend on,
decoupling their stability from the churn at HEAD.

## The dirty HEAD

HEAD answers "what is newest", not "what is good", and the two diverge exactly when the newest commit has failed downstream. A commit that
died in `main-UAT` is still the tip of main — the dirty HEAD — and a consumer or a downstream stage that follows HEAD blindly would pick up
a known-bad commit. The model marks the dirty HEAD as unusable for sync and for downstream promotion, and redirects both to the stable
`main-UAT` occupant, so "someone committed something broken to the tip" degrades gracefully instead of propagating.

## Failure stops downstream

Downstream flow is a privilege earned by the last successful state, so a failure withdraws it entirely: a commit that cannot stand up on an
environment neither advances to the next environment nor may be consumed by anything downstream. Making failure a hard stop — rather than a
warning that downstream is free to ignore — is what keeps a single bad commit from leaking into later environments or into upstream
consumers' builds.

## Out-of-band topic deploys

There is a legitimate path that skips integration: a workflow can deploy a topic-branch commit directly, for a hotfix or an experiment,
without that commit having reached main/master. The model treats this honestly — the commit is deployed but _not integrated_, stays off-main
(brown) until it lands normally, and its out-of-band deploy grants it no mainline promotion state. Drawing it as a topic commit that
nonetheless reached an environment captures that a deploy and an integration are separate events.

## One number, one story

A single commit is hard to follow across stage-organised lanes, so each traced commit carries a time-ordered number and the number is the
thread. Because git is the only true left-to-right timeline (ADR-DSGN-VISUAL:12), the numbers restore both identity and chronology
everywhere else: the same digit appears in each lane at its state-of-the-moment colour, and its final appearance is the verdict. The worked
examples below are the canonical set.

## Worked lifecycle examples

These commits are the canonical encoding of the model; each number is one commit's whole journey and its ending.

| #   | Journey                                    | Ending                                                                   |
| --- | ------------------------------------------ | ------------------------------------------------------------------------ |
| 0   | progressed up the ladder to release-uat    | **discarded** — manually rejected at the release-uat gate (RBC)          |
| 1   | reached production and served there        | **retired** — decommissioned after a successor took over                 |
| 2   | progressed to L3-vertical on main          | **discarded** — auto-rejected in L3-vertical                             |
| 3   | reached release-uat, valid                 | **superseded** — overtaken by 4's rollover                               |
| 4   | rolled over 3 and shipped                  | **in production (current occupant)**                                     |
| 5   | promoted into release-uat                  | **in release-uat (current occupant)** — the release candidate under test |
| 6   | promoted onto main-UAT                     | **main-UAT (current occupant)** — the stable point upstream syncs from   |
| 7   | entered BVT                                | **discarded** — auto-rejected at BVT                                     |
| 8   | landed on main, entered BVT                | **in-process** — currently being BVT-verified                            |
| 9   | topic commit, deployed by a workflow       | **off-main** — out-of-band deployed, not yet integrated to main/master   |
| 10  | latest commit; entered main-UAT and failed | **dirty HEAD** — tip of main, not a sync/downstream source (use 6)       |

## Dora explains

This model is a statement about how change flows into, through, and out of the mainline, which is the core of what DORA measures. A clear
lifecycle — one direction, named rejection points, a distinction between rejected/retired/superseded, a single stable integration point that
is not HEAD — is what lets a team keep the mainline continuously integrable and lets its consumers depend on it without inheriting its
churn.

- [Trunk-based development](https://dora.dev/capabilities/trunk-based-development/) — the HEAD-vs-stable-sync-point rule and the
  one-directional ladder are how a trunk stays continuously integrable.
- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — the promotion ladder and single-occupant environments are the
  delivery pipeline this capability governs.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — automatic discard at BVT/L3 and the out-of-band topic
  deploy are automated-deployment behaviours.
- [Version control](https://dora.dev/capabilities/version-control/) — "history is never rewritten; a discarded commit stays on the record"
  is a version-control discipline.
- [DORA research overview](https://dora.dev/research/).
