# ADR: The CI discipline and the promotion flow — domains keyed by the tagged artifact

## Rules: ADR-FLOW

### Rule ADR-FLOW:1

_Continuous Integration_ is a **discipline before it is a pipeline**: the team practice of _integrating work into one mainline
continuously_, _in small increments, each validated fast enough that the mainline stays continuously integrable_. The pipeline _concept_ CI
— build-validation and the BVT — is how that discipline is enforced mechanically, not a second, separate thing the word denotes. The
discipline is primary; the CI pipeline is its instrument.

- [CI is a discipline, the pipeline is its instrument](#ci-is-a-discipline-the-pipeline-is-its-instrument)

### Rule ADR-FLOW:2

The discipline's binding constraint is a **5–10 minute integration cycle, on a team basis**: getting a change _into_ main/master must clear
its build-validation inside that budget, because a gate slower than that stops being a gate and becomes a queue that stalls the whole team's
flow into the mainline. The CI pipeline concept confines pre-commit validation and the post-commit BVT to that budget
([pipeline-types](../pipelines/pipeline-types.md#rule-adr-pipetype4)); this rule is _why_. The budget binds the **inner** CI gate only — the
slower system-test **outer loop** (CI+, ADR-FLOW:8) is deliberately exempt and runs post-commit, where its cost is affordable.

- [The integration budget is a team constraint](#the-integration-budget-is-a-team-constraint)

### Rule ADR-FLOW:3

CI, CD, CDe, and DEPLOY are **separate pipeline domains keyed together by the tagged artifact**, not merged into one construct. Each is its
own ADO pipeline with its own trigger, governance, and history (see [pipeline-types](../pipelines/pipeline-types.md)); they compose into a
promotion flow because they share one key — the immutable, **tagged** artifact a CI component produces and every downstream domain consumes
unchanged. Build-once, deploy-many: nothing downstream rebuilds, so what reaches prod is byte-identical to what was certified in non-prod.

- [Separate domains, one key](#separate-domains-one-key)

### Rule ADR-FLOW:4

A **CD pipeline always contains a CI component; a solo CI pipeline contains only it.** The CI component is the same build-and-verify in both
— one CI engine ([ADR-PIPETYPE:3](../pipelines/pipeline-types.md#rule-adr-pipetype3)). A solo CI's terminal output is the **tagged
artifact** plus a pass/fail signal; a CD does that same build and then takes the artifact in a direction (ADR-FLOW:5). "CD includes CI" is
not duplication — it is the one engine run as the front of a longer pipeline.

- [A CD is a CI that keeps going](#a-cd-is-a-ci-that-keeps-going)

### Rule ADR-FLOW:5

**CD takes the tagged artifact in a direction, entirely within non-prod.** After its CI component a CD pipeline (a) deploys the artifact to
an **on-demand environment** and runs **L3 system-level end-to-end tests** there — vertical (one slice through all layers) or horizontal
(broad across a layer) — then (b) rolls the same artifact onto an **always-on, hands-off non-prod environment that tracks latest
main/master** (`main-UAT` / `DEV` / `TEST`, whichever the organization's semantics name it). The environment _shape_ — always-on,
automatically reconciled to latest main — is fixed here; its _name_ is org semantics.

- [CD's direction through non-prod](#cds-direction-through-non-prod)

### Rule ADR-FLOW:6

**Progression toward prod leaves the automated flow and enters DEPLOY.** From non-prod, the same tagged artifact is promoted toward
production via **DEPLOY** activities — a solo, manually-governed DEPLOY pipeline that drives the artifact into a **non-automated (manually
gated)** environment ([ADR-PIPETYPE:8–ADR-PIPETYPE:11](../pipelines/pipeline-types.md#deploy--the-governed-deploy-tail-extracted)). The
boundary between CD and DEPLOY is the automated/manual-governance line: CD owns the automated non-prod direction; the human certification is
a hands-on gate — **RC** at main-UAT or **RBC** at release-uat (ADR-FLOW:9) — and **DEPLOY** is the pipeline that actuates the roll to prod
once that gate clears. RC/RBC decide _whether_ to proceed; DEPLOY performs the advance.

- [The boundary to prod is DEPLOY](#the-boundary-to-prod-is-deploy)

### Rule ADR-FLOW:7

CDe (Continuous Deployment) is a CD that **internalizes the prod promotion**: it runs the same CI component and the same non-prod direction
(ADR-FLOW:4–ADR-FLOW:5), then **automatically** rolls the locked commit's tagged artifact the rest of the way to production — the step CD
leaves to a separately-triggered DEPLOY (ADR-FLOW:6). Internal manual gates (an approval stage before production) may punctuate the roll,
but the **activity of advancing a locked commit-and-build toward prod is automatically determined**, not started by a human as a separate
pipeline. This is the Continuous **Delivery** vs Continuous **Deployment** line: **CD** stops at non-prod and hands prod to DEPLOY's
human-owned decision; **CDe** owns the whole path to prod as one automated flow. Build-once still holds — CDe consumes the same tagged
artifact CI stamped and never rebuilds; internalizing the prod step changes _who decides_, not _what ships_.

- [CDe internalizes the automated roll to prod](#cde-internalizes-the-automated-roll-to-prod)

### Rule ADR-FLOW:8

**The CI discipline has an inner loop and an outer loop, and integration is not complete until the outer loop returns.** The **inner CI
loop** is the fast build-validation gate bound by the 5–10 minute budget (ADR-FLOW:2) — L0–L2 and the BVT — proving at machine speed that
the merge is integrable. The **outer CI+ loop** adds the post-commit **system tests** (the L3-vertical run of ADR-FLOW:5) and is
deliberately **not** bound by that budget: it can take an hour or two. A green inner CI is necessary but not sufficient — from the
contributor's view the change is not truly integrated until the CI+ outer loop reports back — so CI+ is where the slow verification the
inner gate cannot afford is allowed to live. CI+ is a part of the CI discipline, not a separate pipeline domain (ADR-FLOW:3); mechanically
its L3 leg runs in the CD pipeline's post-commit path.

- [The outer CI+ loop closes integration](#the-outer-ci-loop-closes-integration)

### Rule ADR-FLOW:9

**RC and RBC are the two hands-on release gates, and they are gates, not pipelines.** A promotion toward production stops at a **manual,
human-owned certification gate** on an always-on environment: **RC** (Release Certification) gates at **main-UAT**, and **RBC** (Release
Branch Certification) gates at **release-uat**. Each clears when its **acceptance testing (AT)** is verified — RC on **main-AT** (AT against
the `main-uat` environment), RBC on **release-AT** (AT against `release-uat`), the automated and manual tests a commit must pass there
(ADR-FLOW:10) — with a human certifying the environment's current occupant (ADR-LIFE:5) before it may advance. The gate is distinct from the
**DEPLOY** pipeline that actuates the advance once the gate clears (ADR-FLOW:6): RC/RBC decide _whether_ to proceed, DEPLOY performs the
roll. Clearing a gate is a promotion; failing it holds or discards the occupant. Whether a human owns the gate (delivery) or the pipeline
advances past it automatically (deployment) is the CD-vs-CDe posture of ADR-FLOW:6/ADR-FLOW:7.

- [RC and RBC: the two hands-on release gates](#rc-and-rbc-the-two-hands-on-release-gates)

### Rule ADR-FLOW:10

**Acceptance testing (AT) is the verification; a UAT is the environment it runs in — two distinct concepts, not one renamed to the other.**
A **UAT** (User Acceptance Testing environment) is a running deployment a user-mimic can interact with — `main-uat` (tracking main) and
`release-uat` (the release branch). **AT** (Acceptance Testing) is the verification _activity_: the **automated and manual** acceptance
tests a commit must pass in that environment to be release-verified. So a stage's `-AT` name marks the testing and a `-uat` name marks the
environment: **`L3-vertical-AT`** is the automated AT run in an on-demand slot (the automatic L3 gate); **`main-AT`** is the AT against
`main-uat` (the manual RC gate, ADR-FLOW:9); **`release-AT`** is the AT against `release-uat` (the manual RBC gate). A commit state
`release-at-verified (main-uat)` reads "passed AT, in the main-uat environment" — the `-AT` is the testing, the `(…-uat)` is where.

- [AT is the verification, UAT is the environment](#at-is-the-verification-uat-is-the-environment)

### Rule ADR-FLOW:11

**The prod tail adds a pre-prod rung, and DEPLOY splits by target into non-prod and prod.** Past the RBC gate the artifact is promoted
through a **pre-prod** environment (staged, not yet live) before **production**, so the promotion ladder's tail is
`release-uat → pre-prod → production` (ADR-LIFE:1). The DEPLOY activity (ADR-FLOW:6) is correspondingly two-part on the same build-once
artifact: **DEPLOY-Non-Prod** drives it into the non-prod AT environments (the on-demand slots, `main-uat`, `release-uat`), and
**DEPLOY-Prod** drives the RBC-cleared artifact through `pre-prod` into `production`. Only the target and its governance differ; the tagged
artifact is identical across both.

- [Pre-prod, and DEPLOY split non-prod / prod](#pre-prod-and-deploy-split-non-prod--prod)

### Rule ADR-FLOW:12

**Deploy-to-prod is a two-slot activation: stage the artifact _inactive_ in pre-prod, validate the exact bytes, then activate it _live_ to
production.** DEPLOY-Prod never deploys straight into the serving environment. It first deploys the RBC-cleared artifact to **pre-prod** — a
production-grade environment that is **not serving live traffic** (the "inactive" slot) — where the identical bytes get a final rehearsal
against production-shaped dependencies. Only then is that same artifact **activated to live production** (the inactive → live cutover). The
go-live is therefore a **promotion of already-validated bytes, not a fresh untested deploy**, which is what keeps the production cutover
low-risk. When the new version goes live, the previous production occupant is superseded and steps down (ADR-LIFE:3/ADR-LIFE:4). Build-once
holds throughout: pre-prod and production receive the identical tagged artifact (ADR-FLOW:3).

- [Deploy-to-prod: stage inactive, then activate live](#deploy-to-prod-stage-inactive-then-activate-live)

## Context

[pipeline-types](../pipelines/pipeline-types.md) is the _taxonomy_ — it fixes what each of the six ADO artifact kinds **is**. This ADR is
the _design layer_ above it: it records that "CI" names a **discipline** before it names a pipeline, and that the pipeline kinds are not a
flat list but **domains that compose into a directional promotion flow**, keyed together by one shared object — the tagged artifact. The
taxonomy answers "what is a CD pipeline"; this answers "what is Continuous Integration as a practice, and how do CI, CD, and DEPLOY chain a
commit all the way to production without any of them rebuilding it."

Two of those kinds share the letters "CD" and must not be confused. **CD is Continuous _Delivery_**: the flow is automated through non-prod
and the artifact is left _ready_ for prod, with the production cutover handed to a separately-governed DEPLOY (ADR-FLOW:5–ADR-FLOW:6). **CDe
is Continuous _Deployment_**: the same flow with the prod roll internalized and automated, so a locked commit reaches production without a
human starting a separate pipeline (ADR-FLOW:7). Delivery makes prod a human decision; deployment makes it an automated activity of the
pipeline.

The word "CI" carries both meanings, and conflating them is the mistake this ADR guards against. Read as a pipeline only, "CI" shrinks to a
YAML file that compiles something. Read as a discipline, it is the team-scale practice — small, frequent integrations into one mainline,
each proven fast — that the pipeline exists to _serve_. The 5–10 minute budget, the always-on environment that mirrors main, and the
build-once artifact that flows to prod are all consequences of taking the discipline as primary. The complement is
[shared-fate-ci](../../notes/shared-fate-ci.md), which diagnoses what goes wrong when a slow release-candidate suite squats in the fast CI
slot.

## Decision

CI is a discipline; the CI, CD, and DEPLOY pipeline domains are keyed together by the tagged artifact into a directional promotion flow from
main to prod. The flow, end to end:

```text
CI (discipline)   keep every integration into main/master ≤ 5–10 min  ──  team-wide
      │
      ▼  the CI pipeline concept produces
CI (pipeline)  ──►  tagged artifact   (build-once — the key every domain shares)
      │
      ▼  a CD is that same CI, then a direction (all non-prod, automated)
CD (pipeline = CI component + direction)
      ├─ deploy → on-demand environment → L3 E2E (vertical / horizontal)   ── the CI+ outer loop (ADR-FLOW:8)
      └─ deploy → always-on env tracking latest main   (main-UAT / DEV / TEST — org semantics)
      │
      ▼  same tagged artifact, now certified across non-prod — two governance postures to prod:
      │
      ├─ delivery (CD → RC/RBC gate → DEPLOY):  a human certifies (RC @ main-UAT / RBC @ release-uat), then DEPLOY rolls to prod
      │     DEPLOY (pipeline — solo, the actuator once the gate clears)
      │        └─ promote → non-automated / manually-gated environment → … → prod
      │
      └─ deployment (CDe):  the CD internalized the prod roll — no separate trigger
            └─ automatically advance the locked artifact → [optional internal approval] → prod
```

### CI is a discipline, the pipeline is its instrument

Continuous Integration is first a way a team works: everyone integrates into one mainline continuously, in small increments, and every
increment is validated before it is allowed to define the new state of main. The **pipeline** named CI — the pre-commit build validation and
the post-commit Build Verification Test — is the mechanism that makes the discipline hold at machine speed and team scale. Naming the
pipeline "CI" is correct, but it is the instrument, not the idea. When a design choice trades off between "make the pipeline do more" and
"keep the integration cycle fast and continuous," the discipline wins, because the pipeline exists to serve it.

### The integration budget is a team constraint

The discipline only works if integrating _into_ main is cheap and fast for the whole team at once. That is the 5–10 minute figure (Farley's
pre-commit budget; DORA's ten-minute working number). It is a **team** constraint, not an individual one: one contributor waiting fifteen
minutes is an annoyance, but a fifteen-minute gate applied to every merge across a team is a standing queue, and a queue is the opposite of
_continuous_ integration. So the budget is a hard design constraint on the CI pipeline concept, enforced there
([ADR-PIPETYPE:4](../pipelines/pipeline-types.md#rule-adr-pipetype4)); this ADR records that the reason is the discipline, not the
pipeline's convenience. Work too slow for the budget is pushed right — into the CD deploy path or a DEPLOY step — never into the pre-commit
gate.

### Separate domains, one key

CI, CD, and DEPLOY are deliberately **separate ADO constructs** — separate triggers, separate governance, separate run histories — because
they answer to different owners and cadences (build-and-verify on every change; automated non-prod promotion; human-gated production
cutover). What keeps them from being three disconnected things is that they are **keyed together by one shared object**: the immutable,
tagged artifact. A CI component stamps it once; CD consumes exactly that tag; DEPLOY promotes exactly that tag to prod. The tag (and its
commit) is the join key across the domains, the same way a subscription name joins the two Azure config layers
([data-model](../azure/azure-data-model.md)). Because the key is an immutable artifact and no domain rebuilds it — build-once, deploy-many —
what runs in production is byte-identical to what was certified in non-prod. The domains stay small and independently reasoned; the artifact
carries the continuity.

### A CD is a CI that keeps going

There is exactly one CI component, and both a solo CI pipeline and a CD pipeline run it — the same build-and-verify engine
([ADR-PIPETYPE:3](../pipelines/pipeline-types.md#rule-adr-pipetype3)). The difference is only what happens _after_ it:

- A **solo CI pipeline** stops at the artifact. Its terminal output is the tagged, immutable artifact plus a pass/fail signal — the build
  was green (or not), and here is the thing it built. It deploys nothing.
- A **CD pipeline** runs that same CI component and then takes the artifact in a direction (below). "CD contains CI" therefore costs no
  duplicated build logic: it is the one engine, run as the front of a longer pipeline, followed by the deploy-and-verify tail.

This is why the taxonomy calls CI "a CD pipeline with the deploy removed" — the two are the same engine, plus or minus a direction.

### CD's direction through non-prod

A CD pipeline's job, after the build, is to move the artifact through non-prod in a fixed direction:

1. **On-demand environment + L3 E2E.** Deploy the tagged artifact to a throwaway, on-demand environment and run **L3 system-level
   end-to-end** tests against it ([test-automation](../automation/test-automation.md) L3 tier). E2E here is either **vertical** — one thin
   slice exercised through every layer — or **horizontal** — broad coverage across a layer. This is the artifact proving itself against real
   cloud dependencies, in an environment that exists only for the run.
2. **The always-on mirror of main.** Then roll the same artifact onto an **always-on, hands-off non-prod environment that continuously
   matches latest main/master** — reconciled automatically by the post-commit run, so it is always a live reflection of the mainline.
   Whether an organization calls this `main-UAT`, `DEV`, or `TEST` is its own semantics; the **shape** is what this ADR fixes: always up, no
   manual step to refresh it, tracking the head of main.

All of this is automated and lives entirely in non-prod. CD never touches production.

### The boundary to prod is DEPLOY

The step from non-prod to production is where automation stops and organizational governance begins, and that is exactly the CD/DEPLOY
boundary. From the certified non-prod state, the **same tagged artifact** is promoted toward prod through **DEPLOY** activities: a solo,
manually-governed DEPLOY pipeline that drives the artifact into a **non-automated, manually-gated** environment
([ADR-PIPETYPE:8–ADR-PIPETYPE:11](../pipelines/pipeline-types.md#deploy--the-governed-deploy-tail-extracted)). A DEPLOY pipeline is where a
certification environment locked to a release commit, or an approval-gated production cutover, lives. The line is clean: **CD is the
automated non-prod direction; DEPLOY is the human-governed step toward prod** — two domains, one artifact, keyed together at the boundary
rather than fused into a single pipeline that would bury the manual gate inside an automated flow.

### CDe internalizes the automated roll to prod

The CD/DEPLOY split above is Continuous **Delivery**: the pipeline brings a change to a certified non-prod state automatically, and a human
then triggers a separately-governed DEPLOY to take it the rest of the way to prod. Continuous **Deployment** removes that hand-off — the
promotion to production is not a separate, human-initiated pipeline but an **automated continuation of the same flow**. That construct is
**CDe**.

What defines CDe is _where the promotion decision lives_, not whether a human ever approves anything:

- In **CD → DEPLOY**, the decision to roll to prod is **external**: a person starts a DEPLOY pipeline, which owns the prod step with its own
  trigger, governance, and history.
- In **CDe**, the decision is **internalized**: for a locked commit and its build, the pipeline itself advances toward prod automatically. A
  CDe may still **pause at an internal gate** — a required approval before the production stage — but that gate is a checkpoint _inside_ an
  automated promotion, not a separate pipeline someone must remember to go and start. The activity, "advance this locked artifact toward
  prod," is determined by the pipeline.

So CDe is **a CD that internalized DEPLOY**: the same CI component, the same non-prod direction, then the prod roll folded back in and
automated. A deployable unit is governed **either** as CD → DEPLOY (delivery — automated to non-prod, human-triggered to prod) **or** as CDe
(deployment — automated the whole way), never both; the choice is a per-unit governance posture. Build-once, deploy-many is untouched: CDe
promotes the same tagged artifact CI stamped, so automating the prod step changes _who decides_ to ship, not _what_ ships. This is the
Humble & Farley Delivery/Deployment distinction made a first-class pipeline kind, so a design conversation can name which posture a unit is
under instead of leaving "CD" to mean both.

### The outer CI+ loop closes integration

Continuous Integration as a discipline (ADR-FLOW:1) asks that every change be validated fast enough that the mainline stays continuously
integrable. In practice that validation runs at two speeds, and conflating them is the mistake. The **inner loop** — the CI gate — must
clear in 5–10 minutes (ADR-FLOW:2) or it stops being a gate and becomes a queue; it runs the fast, hermetic checks (L0–L2) and the BVT. The
**outer loop** — CI+ — runs the system-level tests that exercise the built artifact against real boundaries (the L3-vertical run of
ADR-FLOW:5), and those cannot be made to fit the inner budget: they take an hour or two, and forcing them into the pre-commit slot is
exactly the shared-fate failure the budget rule exists to prevent.

The discipline's honesty depends on naming this. A green inner CI proves the merge builds and passes the fast checks; it does not prove the
system works. Integration, as the contributor experiences it, is not finished until the CI+ outer loop returns — that feedback, not the fast
gate, is what closes the loop. So CI+ is not a weaker or optional CI: it is the part of the discipline the fast gate deliberately defers,
run post-commit where its cost is affordable, and a change is "integrated" only once it is green. Because CI+ is discipline, not a domain,
it adds no ADO pipeline kind (ADR-FLOW:3) — its L3 leg is the CD pipeline's on-demand system test, named as the outer loop rather than
forked into a second pipeline.

### RC and RBC: the two hands-on release gates

The automated flow (ADR-FLOW:5) carries the artifact through non-prod on its own. Progression toward production, by contrast, passes through
**human certification** — and there are two such gates, one per always-on release environment, each a deliberate hands-on stop rather than
an automated check:

- **RC — Release Certification**, at **main-UAT**. The always-on environment that tracks latest main holds a current occupant (ADR-LIFE:5);
  RC is the human decision to certify that occupant for onward release. It is the gate a Continuous **Delivery** posture stops at, handing
  the production step to DEPLOY.
- **RBC — Release Branch Certification**, at **release-uat**. When a release variant is stabilized on a release branch, RBC is the human
  certification of the release-uat occupant before it is cut to production.

Both are **gates, not pipelines**. The gate is the human decision; the **DEPLOY** pipeline (ADR-FLOW:6) is the actuator that rolls the
certified artifact onward once the gate clears. Keeping them distinct is what lets one DEPLOY mechanism serve either gate, and lets a
Continuous **Deployment** (CDe) posture internalize the roll (ADR-FLOW:7) by automating past the point where RC/RBC would otherwise stop it.
Which gates a unit passes through — and whether a human or the pipeline owns the decision to advance — is the delivery-vs-deployment posture
of ADR-FLOW:6/ADR-FLOW:7.

### AT is the verification, UAT is the environment

The value chain names two layers that are easy to conflate. A **UAT** is a _place_ — a running environment where the built artifact is
deployed and a human (or an automated user-mimic) can exercise it; the diagram's env lane labels these `main-uat` and `release-uat`. **AT**
is what happens there — the acceptance testing, automated and manual, that a commit must pass before it is release-verified. Keeping the two
apart is what lets one environment host successive commits' testing over time (the UAT persists; each commit's AT is a fresh verification),
and lets the same verification idea span an automated slice (`L3-vertical-AT`) and manual slices (`main-AT`, `release-AT`).

The `-AT` / `-uat` suffixes are a deliberate two-word grammar, not redundancy: `main-AT` is the acceptance testing performed against the
`main-uat` environment, and clearing it is the RC gate; `release-AT` is the acceptance testing against `release-uat`, and clearing it is the
RBC gate. A commit labelled `release-at-verified (main-uat)` has passed its AT in the main-uat environment. The environment is durable and
shared; the AT is per-commit and is what the gate certifies.

### Pre-prod, and DEPLOY split non-prod / prod

The promotion tail is longer than "non-prod, then prod." After the RBC gate the artifact lands first in a **pre-prod** environment — staged
and inactive, a last rehearsal of the exact bytes before they go live — and only then in **production**. So the ladder gains a rung,
`release-uat → pre-prod → production` (ADR-LIFE:1), and pre-prod is a single-occupant environment like the others (ADR-LIFE:5).

Because the deploy activity now spans several environments with different governance, it reads as two named halves of one build-once flow.
**DEPLOY-Non-Prod** is the deploy into the non-prod AT environments — the on-demand L3 slots, `main-uat`, and `release-uat` — the targets
CD's automated direction covers (ADR-FLOW:5). **DEPLOY-Prod** is the governed deploy of the RBC-cleared artifact through `pre-prod` into
`production` (ADR-FLOW:6, and [ADR-PIPETYPE:11](../pipelines/pipeline-types.md#rule-adr-pipetype11)). The split is by _target and
governance_, not by artifact: the same tagged build flows through both, so build-once / deploy-many holds end to end.

### Deploy-to-prod: stage inactive, then activate live

Going to production is not one step of "push the bytes at the live environment." It is two, and separating them is the point. First,
**DEPLOY-Prod deploys the RBC-cleared artifact into `pre-prod` — a production-grade environment that is _inactive_** (staged, not serving
live traffic). This is the last place the _exact_ bytes that will go live are exercised against production-shaped dependencies, with real
production configuration, before any user sees them. Second, once pre-prod is good, **the same artifact is _activated_ to
`live / production`** — the inactive slot becomes the serving one. The two boxes in the diagram, `inactive / pre-prod` and
`live / production`, are precisely these two states of the prod deploy: staged-but-dark, then live.

The reason to split them is risk. Because the live cutover is the **activation of bytes already validated in a prod-identical environment**,
not a fresh deploy of something only ever seen in non-prod, the moment of going live carries almost no new risk — nothing is compiled,
rendered, or first-run at cutover (build-once, ADR-FLOW:3). What flips is _which slot serves traffic_, not _what the bytes are_. When the
new version goes live, the previous production occupant is superseded and steps down (ADR-LIFE:4) — the diagram shows the new version
occupying both `pre-prod` and `production` at the moment of cutover, and the version it replaced leaving. Whether that activation is a
human-triggered DEPLOY (delivery) or an automated continuation (CDe, deployment) is the posture of ADR-FLOW:6/ADR-FLOW:7; either way the
mechanic — stage inactive, validate, activate live — is the same.

## How this is enforced

- **The pipeline taxonomy carries the mechanics.** The 5–10 minute budget, the CI-engine sharing, and the DEPLOY governance rules are
  enforced through [pipeline-types](../pipelines/pipeline-types.md) (ADR-PIPETYPE:3, ADR-PIPETYPE:4, ADR-PIPETYPE:8–ADR-PIPETYPE:11) and the
  runner pattern. This ADR is the design rationale those rules point back to; it is enforced in **code review** of pipeline design, using
  the flow above as the reference shape.
- **Artifact identity is the checkable invariant.** A promotion that rebuilds — a CD, CDe, or DEPLOY that recompiles instead of consuming
  the CI component's tagged artifact — violates ADR-FLOW:3 and is caught in review: the same tag must flow from CI through the non-prod
  direction to the prod step (DEPLOY's, or CDe's internalized one), never re-derived.
- **Delivery vs deployment is a named posture.** Review checks that a unit that auto-rolls to prod is a **CDe** (ADR-FLOW:7) — the prod
  promotion internalized and automated, with any human step expressed as an _internal_ gate — and not a DEPLOY's human-owned cutover fused
  into a CD under the "CD" label. Which posture a unit is under is a deliberate, reviewable choice, not an accident of where a stage was
  placed.
- **The environment shape, not its name, is the contract.** Review checks that the always-on non-prod environment is auto-reconciled to
  latest main (ADR-FLOW:5), whatever the org names it — a manually-refreshed "UAT" that drifts from main is not the always-on mirror this
  flow requires.
- **CI+ and the release gates are review-checked.** Review confirms the slow system tests live in the CI+ outer loop, never the inner CI
  gate (ADR-FLOW:2/ADR-FLOW:8), and that a promotion to prod passes a named hands-on gate — RC at main-UAT or RBC at release-uat
  (ADR-FLOW:9) — with DEPLOY as the actuator, not a human cutover fused into CD under another label.

## Consequences

- "CI" stops being ambiguous: the discipline (fast, continuous integration into one mainline) and the pipeline (the BVT that enforces it)
  are named as cause and instrument, so a design conversation can say which one it means.
- The pipeline kinds read as a **flow**, not a flat list: a solo CI produces the artifact, a CD carries it through non-prod, a DEPLOY
  promotes it to prod — one artifact keying three independently-governed domains.
- Build-once, deploy-many is structural: because the tagged artifact is the join key and no domain rebuilds, production runs exactly the
  bytes non-prod certified.
- The manual/automated line has a home: under **delivery**, everything automated lives in CD's non-prod direction and everything human-gated
  lives in DEPLOY, with the boundary explicit rather than an approval buried in an automated pipeline. Under **deployment (CDe)**, the prod
  roll is internalized and automated, and the boundary moves _inside_ the pipeline as an optional approval gate — still explicit, but now a
  checkpoint in an automated flow rather than a separately-triggered construct.
- "CD" stops meaning two things: Continuous **Delivery** (prod is a human-triggered DEPLOY) and Continuous **Deployment** (CDe — the prod
  roll is automated) are named apart, so a unit's promotion posture is stated, not inferred.
- The cost is that promotion is several keyed constructs rather than one monolith. That is the intended trade: separate domains with their
  own access, isolation, and history, held together by an immutable artifact — not a single pipeline that conflates a fast team gate, an
  automated non-prod rollout, and a governed production cutover.

## Related

- [pipeline-types](../pipelines/pipeline-types.md) — the taxonomy this ADR layers on (CRON / CI / CD / CDe / DEPLOY / INPUT).
- [pipeline-runner-pattern](../pipelines/pipeline-runner-pattern.md) — how every pipeline domain invokes automation.
- [test-automation](../automation/test-automation.md) — the L0–L3 tiers; L3 is the system-level E2E CD runs in its on-demand environment,
  and the outer CI+ loop (ADR-FLOW:8).
- [repo-variants](../repository/repo-variants.md) — the `git_workspace` variant (`ADR-VARIANT:6`) is the PR-vs-Direct integration mode the
  value-chain diagrams prefix a flow with.
- [everything-as-code](../principles/everything-as-code.md), [reduce-waste](../principles/reduce-waste.md) — build-once/deploy-many and the
  version-aligned artifact are these principles applied to the flow.
- Notes: [shared-fate-ci](../../notes/shared-fate-ci.md) — the failure mode when a slow suite squats in the fast CI slot.

## Dora explains

DORA's research links continuous integration, continuous delivery, and deployment automation to faster, safer releases. Separating CI, CD,
and DEPLOY as distinct domains keyed by immutable artifacts enables fast feedback loops, reliable promotion, and clear governance
boundaries.

- [Continuous integration](https://dora.dev/capabilities/continuous-integration/) — the 5-10 minute integration budget keeps the team's
  mainline continuously integrable.
- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — automated non-prod certification enables confidence before
  production promotion.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — build-once/deploy-many via immutable, tagged artifacts
  ensures production safety.
- [Streamlining change approval](https://dora.dev/capabilities/streamlining-change-approval/) — clear CD/DEPLOY boundary separates automated
  validation from human governance.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
