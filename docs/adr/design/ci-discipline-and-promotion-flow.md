# ADR: The CI discipline and the promotion flow — domains keyed by the tagged artifact

## Rules: ADR-FLOW

### Rule ADR-FLOW:1

Continuous Integration is a **discipline before it is a pipeline**: the team practice of integrating work into one mainline continuously, in
small increments, each validated fast enough that the mainline stays continuously integrable. The pipeline _concept_ CI — build-validation
and the BVT — is how that discipline is enforced mechanically, not a second, separate thing the word denotes. The discipline is primary; the
CI pipeline is its instrument.

- [CI is a discipline, the pipeline is its instrument](#ci-is-a-discipline-the-pipeline-is-its-instrument)

### Rule ADR-FLOW:2

The discipline's binding constraint is a **5–10 minute integration cycle, on a team basis**: getting a change _into_ main/master must clear
its build-validation inside that budget, because a gate slower than that stops being a gate and becomes a queue that stalls the whole team's
flow into the mainline. The CI pipeline concept confines pre-commit validation and the post-commit BVT to that budget
([pipeline-types](../pipelines/pipeline-types.md#rule-adr-pipetype4)); this rule is _why_.

- [The integration budget is a team constraint](#the-integration-budget-is-a-team-constraint)

### Rule ADR-FLOW:3

CI, CD, CDE, and DEPLOY are **separate pipeline domains keyed together by the tagged artifact**, not merged into one construct. Each is its
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
boundary between CD and DEPLOY is the automated/manual-governance line: CD owns the automated non-prod direction, DEPLOY owns the
human-gated step toward prod.

- [The boundary to prod is DEPLOY](#the-boundary-to-prod-is-deploy)

### Rule ADR-FLOW:7

CDE (Continuous Deployment) is a CD that **internalizes the prod promotion**: it runs the same CI component and the same non-prod direction
(ADR-FLOW:4–ADR-FLOW:5), then **automatically** rolls the locked commit's tagged artifact the rest of the way to production — the step CD
leaves to a separately-triggered DEPLOY (ADR-FLOW:6). Internal manual gates (an approval stage before production) may punctuate the roll,
but the **activity of advancing a locked commit-and-build toward prod is automatically determined**, not started by a human as a separate
pipeline. This is the Continuous **Delivery** vs Continuous **Deployment** line: **CD** stops at non-prod and hands prod to DEPLOY's
human-owned decision; **CDE** owns the whole path to prod as one automated flow. Build-once still holds — CDE consumes the same tagged
artifact CI stamped and never rebuilds; internalizing the prod step changes _who decides_, not _what ships_.

- [CDE internalizes the automated roll to prod](#cde-internalizes-the-automated-roll-to-prod)

## Context

[pipeline-types](../pipelines/pipeline-types.md) is the _taxonomy_ — it fixes what each of the six ADO artifact kinds **is**. This ADR is
the _design layer_ above it: it records that "CI" names a **discipline** before it names a pipeline, and that the pipeline kinds are not a
flat list but **domains that compose into a directional promotion flow**, keyed together by one shared object — the tagged artifact. The
taxonomy answers "what is a CD pipeline"; this answers "what is Continuous Integration as a practice, and how do CI, CD, and DEPLOY chain a
commit all the way to production without any of them rebuilding it."

Two of those kinds share the letters "CD" and must not be confused. **CD is Continuous _Delivery_**: the flow is automated through non-prod
and the artifact is left _ready_ for prod, with the production cutover handed to a separately-governed DEPLOY (ADR-FLOW:5–ADR-FLOW:6). **CDE
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
      ├─ deploy → on-demand environment → L3 E2E (vertical / horizontal)
      └─ deploy → always-on env tracking latest main   (main-UAT / DEV / TEST — org semantics)
      │
      ▼  same tagged artifact, now certified across non-prod — two governance postures to prod:
      │
      ├─ delivery (CD → DEPLOY):  a human triggers the governed prod cutover
      │     DEPLOY (pipeline — solo, human-governed)
      │        └─ promote → non-automated / manually-gated environment → … → prod
      │
      └─ deployment (CDE):  the CD internalized the prod roll — no separate trigger
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
([data-model](../azure/data-model.md)). Because the key is an immutable artifact and no domain rebuilds it — build-once, deploy-many — what
runs in production is byte-identical to what was certified in non-prod. The domains stay small and independently reasoned; the artifact
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

### CDE internalizes the automated roll to prod

The CD/DEPLOY split above is Continuous **Delivery**: the pipeline brings a change to a certified non-prod state automatically, and a human
then triggers a separately-governed DEPLOY to take it the rest of the way to prod. Continuous **Deployment** removes that hand-off — the
promotion to production is not a separate, human-initiated pipeline but an **automated continuation of the same flow**. That construct is
**CDE**.

What defines CDE is _where the promotion decision lives_, not whether a human ever approves anything:

- In **CD → DEPLOY**, the decision to roll to prod is **external**: a person starts a DEPLOY pipeline, which owns the prod step with its own
  trigger, governance, and history.
- In **CDE**, the decision is **internalized**: for a locked commit and its build, the pipeline itself advances toward prod automatically. A
  CDE may still **pause at an internal gate** — a required approval before the production stage — but that gate is a checkpoint _inside_ an
  automated promotion, not a separate pipeline someone must remember to go and start. The activity, "advance this locked artifact toward
  prod," is determined by the pipeline.

So CDE is **a CD that internalized DEPLOY**: the same CI component, the same non-prod direction, then the prod roll folded back in and
automated. A deployable unit is governed **either** as CD → DEPLOY (delivery — automated to non-prod, human-triggered to prod) **or** as CDE
(deployment — automated the whole way), never both; the choice is a per-unit governance posture. Build-once, deploy-many is untouched: CDE
promotes the same tagged artifact CI stamped, so automating the prod step changes _who decides_ to ship, not _what_ ships. This is the
Humble & Farley Delivery/Deployment distinction made a first-class pipeline kind, so a design conversation can name which posture a unit is
under instead of leaving "CD" to mean both.

## How this is enforced

- **The pipeline taxonomy carries the mechanics.** The 5–10 minute budget, the CI-engine sharing, and the DEPLOY governance rules are
  enforced through [pipeline-types](../pipelines/pipeline-types.md) (ADR-PIPETYPE:3, ADR-PIPETYPE:4, ADR-PIPETYPE:8–ADR-PIPETYPE:11) and the
  runner pattern. This ADR is the design rationale those rules point back to; it is enforced in **code review** of pipeline design, using
  the flow above as the reference shape.
- **Artifact identity is the checkable invariant.** A promotion that rebuilds — a CD, CDE, or DEPLOY that recompiles instead of consuming
  the CI component's tagged artifact — violates ADR-FLOW:3 and is caught in review: the same tag must flow from CI through the non-prod
  direction to the prod step (DEPLOY's, or CDE's internalized one), never re-derived.
- **Delivery vs deployment is a named posture.** Review checks that a unit that auto-rolls to prod is a **CDE** (ADR-FLOW:7) — the prod
  promotion internalized and automated, with any human step expressed as an _internal_ gate — and not a DEPLOY's human-owned cutover fused
  into a CD under the "CD" label. Which posture a unit is under is a deliberate, reviewable choice, not an accident of where a stage was
  placed.
- **The environment shape, not its name, is the contract.** Review checks that the always-on non-prod environment is auto-reconciled to
  latest main (ADR-FLOW:5), whatever the org names it — a manually-refreshed "UAT" that drifts from main is not the always-on mirror this
  flow requires.

## Consequences

- "CI" stops being ambiguous: the discipline (fast, continuous integration into one mainline) and the pipeline (the BVT that enforces it)
  are named as cause and instrument, so a design conversation can say which one it means.
- The pipeline kinds read as a **flow**, not a flat list: a solo CI produces the artifact, a CD carries it through non-prod, a DEPLOY
  promotes it to prod — one artifact keying three independently-governed domains.
- Build-once, deploy-many is structural: because the tagged artifact is the join key and no domain rebuilds, production runs exactly the
  bytes non-prod certified.
- The manual/automated line has a home: under **delivery**, everything automated lives in CD's non-prod direction and everything human-gated
  lives in DEPLOY, with the boundary explicit rather than an approval buried in an automated pipeline. Under **deployment (CDE)**, the prod
  roll is internalized and automated, and the boundary moves _inside_ the pipeline as an optional approval gate — still explicit, but now a
  checkpoint in an automated flow rather than a separately-triggered construct.
- "CD" stops meaning two things: Continuous **Delivery** (prod is a human-triggered DEPLOY) and Continuous **Deployment** (CDE — the prod
  roll is automated) are named apart, so a unit's promotion posture is stated, not inferred.
- The cost is that promotion is several keyed constructs rather than one monolith. That is the intended trade: separate domains with their
  own access, isolation, and history, held together by an immutable artifact — not a single pipeline that conflates a fast team gate, an
  automated non-prod rollout, and a governed production cutover.

## Related

- [pipeline-types](../pipelines/pipeline-types.md) — the taxonomy this ADR layers on (CRON / CI / CD / CDE / DEPLOY / INPUT).
- [pipeline-runner-pattern](../pipelines/pipeline-runner-pattern.md) — how every pipeline domain invokes automation.
- [test-automation](../automation/test-automation.md) — the L0–L3 tiers; L3 is the system-level E2E CD runs in its on-demand environment.
- [everything-as-code](../principles/everything-as-code.md), [reduce-waste](../principles/reduce-waste.md) — build-once/deploy-many and the
  version-aligned artifact are these principles applied to the flow.
- Notes: [shared-fate-ci](../../notes/shared-fate-ci.md) — the failure mode when a slow suite squats in the fast CI slot.
