# Flow: The CI discipline and the promotion flow — pipeline kinds keyed by the tagged artifact

## Rules: FDR-CD

### Rule FDR-CD-DISCIPLINEBEFOREPIPELINE

_Continuous Integration_ is a **discipline before it is a pipeline**: the team practice of _integrating work into one mainline
continuously_, _in small increments, each validated fast enough that the mainline stays continuously integrable_. The pipeline _concept_ CI
— build-validation and the BVT — is how that discipline is enforced mechanically, not a second, separate thing the word denotes. The
discipline is primary; the CI pipeline is its instrument.

- [CI as a discipline](#ci-as-a-discipline)

### Rule FDR-CD-SHORTINTEGRATIONCYCLE

The discipline's binding constraint is a **5–10 minute integration cycle, on a team basis**: getting a change _into_ main/master must clear
its build-validation inside that budget, because a gate slower than that stops being a gate and becomes a queue that stalls the whole team's
flow into the mainline. The CI pipeline concept confines pre-commit validation and the post-commit BVT to that budget
([pipeline-types](pipeline-types.md#rule-fdr-cd-type-precommitbudget)); this rule is _why_. The budget binds the **inner** CI gate only —
the slower system-test **outer loop** (CI+, FDR-CD-INNERANDOUTERLOOP) is deliberately exempt and runs post-commit, where its cost is
affordable.

- [The integration budget](#the-integration-budget)

### Rule FDR-CD-SEPARATEPIPELINEKINDS

CI, CD, CDe, and DEPLOY are **separate pipeline kinds keyed together by the tagged artifact**, not merged into one construct. Each is its
own ADO pipeline with its own trigger, governance, and history (see [pipeline-types](pipeline-types.md)); they compose into a promotion flow
because they share one key — the immutable, **tagged** artifact a CI component produces and every downstream kind consumes unchanged.
Build-once, deploy-many: nothing downstream rebuilds, so what reaches prod is byte-identical to what was certified in non-prod.

- [Separate kinds, one key](#separate-kinds-one-key)

### Rule FDR-CD-CDCONTAINSCI

A **CD pipeline always contains a CI component; a solo CI pipeline contains only it.** The CI component is the same build-and-verify in both
— one CI engine ([FDR-CD-TYPE-ONECIENGINE](pipeline-types.md#rule-fdr-cd-type-oneciengine)). A solo CI's terminal output is a pass/fail
signal and nothing to deploy ([pipeline-types](pipeline-types.md#ci)); the **tagged artifact** is what the CI component produces when it
runs as the front of a CD, which then takes the artifact in a direction (FDR-CD-CDSTAYSINNONPROD). "CD includes CI" is not duplication — it
is the one engine run as the front of a longer pipeline.

- [A CD is a CI that keeps going](#a-cd-is-a-ci-that-keeps-going)

### Rule FDR-CD-CDSTAYSINNONPROD

**CD takes the tagged artifact in a direction, entirely within non-prod.** After its CI component a CD pipeline (a) deploys the artifact to
an **on-demand environment** and runs **L3 system-level end-to-end tests** there — vertical (one slice through all layers) or horizontal
(broad across a layer) — then (b) rolls the same artifact onto an **always-on, hands-off non-prod environment that tracks latest
main/master** (`main-UAT` / `DEV` / `TEST`, whichever the organization's semantics name it). The environment _shape_ — always-on,
automatically reconciled to latest main — is fixed here; its _name_ is org semantics.

- [CD's direction through non-prod](#cds-direction-through-non-prod)

### Rule FDR-CD-PRODPROGRESSIONISDEPLOY

**Progression toward prod leaves the automated flow and enters DEPLOY.** From non-prod, the same tagged artifact is promoted toward
production via **DEPLOY** activities — a solo, manually-governed DEPLOY pipeline that drives the artifact into a **non-automated**
environment behind a manual gate ([FDR-CD-TYPE-DEPLOYISCDTAIL–FDR-CD-TYPE-DEPLOYCARRIESGOVERNANCE](pipeline-types.md#deploy)). The boundary
between CD and DEPLOY is the automated/manual-governance line: CD owns the automated non-prod direction; the human certification is a manual
gate — **RC** at main-UAT or **RBC** at release-uat (FDR-CD-TWORELEASEGATES) — and **DEPLOY** is the pipeline that actuates the roll to prod
once that gate clears. RC/RBC decide _whether_ to proceed; DEPLOY performs the advance. DEPLOY takes the exact artifact CI built, named by
the **run id** of the CI run that built it, and never rebuilds it; the CD run that certified the artifact records that run id, so the
artifact DEPLOY ships is the one the gates cleared.

- [The boundary to prod is DEPLOY](#the-boundary-to-prod-is-deploy)

### Rule FDR-CD-CDEINTERNALIZESPROMOTION

CDe (Continuous Deployment) is a CD that **internalizes the prod promotion**: it runs the same CI component and the same non-prod direction
(FDR-CD-CDCONTAINSCI–FDR-CD-CDSTAYSINNONPROD), then **automatically** rolls the locked commit's tagged artifact the rest of the way to
production — the step CD leaves to a separately-triggered DEPLOY (FDR-CD-PRODPROGRESSIONISDEPLOY). Internal manual gates (an approval stage
before production) may punctuate the roll, but the **activity of advancing a locked commit-and-build toward prod is automatically
determined**, not started by a human as a separate pipeline. This is the Continuous **Delivery** vs Continuous **Deployment** line: **CD**
stops at non-prod and hands prod to DEPLOY's human-owned decision; **CDe** owns the whole path to prod as one automated flow. Build-once
still holds — CDe consumes the same tagged artifact CI stamped and never rebuilds; internalizing the prod step changes _who decides_, not
_what ships_.

- [CDe](#cde)

### Rule FDR-CD-INNERANDOUTERLOOP

**The CI discipline has an inner loop and an outer loop, and integration is not complete until the outer loop returns.** The **inner CI
loop** is the CI gate, the fast build-validation bound by the 5–10 minute budget (FDR-CD-SHORTINTEGRATIONCYCLE) — L0–L2 and the BVT —
proving at machine speed that the merge is integrable. The **outer CI+ loop** adds the post-commit **system tests** (the L3-vertical run of
FDR-CD-CDSTAYSINNONPROD) and is deliberately **not** bound by that budget: it can take an hour or two. A green inner CI is necessary but not
sufficient — from the contributor's view the change is not truly integrated until the CI+ outer loop reports back — so CI+ is where the slow
verification the inner CI gate cannot afford is allowed to live. CI+ is a part of the CI discipline, not a separate pipeline kind
(FDR-CD-SEPARATEPIPELINEKINDS); mechanically its L3 leg runs in the CD pipeline's post-commit path.

- [The outer CI+ loop](#the-outer-ci-loop)

### Rule FDR-CD-TWORELEASEGATES

**RC and RBC are the two hands-on release gates, and each is a gate, not a pipeline.** A promotion toward production stops at a **manual
gate**, a human-owned certification, on an always-on environment: **RC** (Release Certification) is the gate at **main-UAT**, and **RBC**
(Release Branch Certification) is the gate at **release-uat**. Each clears when its **acceptance testing (AT)** is verified — RC on
**main-AT** (AT against the `main-uat` environment), RBC on **release-AT** (AT against `release-uat`), the automated and manual tests a
commit must pass there (FDR-CD-ACCEPTANCETESTINGISNOTUAT) — with a human certifying the environment's occupant
(FDR-CD-LIFE-ONECOMMITPERENVIRONMENT) before it may advance. The gate is distinct from the **DEPLOY** pipeline that actuates the advance
once the gate clears (FDR-CD-PRODPROGRESSIONISDEPLOY): RC/RBC decide _whether_ to proceed, DEPLOY performs the roll. Each gate is an
**approval check on the next environment**: RC on the unit's `release-uat` environment, RBC on its `pre-prod` environment, so a run
promoting the occupant waits there for the certifier. The checks are configuration, applied like the prod approval gate
(FDR-CD-PRODAPPROVALGATE). Clearing a gate is a promotion; failing it holds or discards the occupant. Whether a human owns the gate
(delivery) or the pipeline advances past it automatically (deployment) is the CD-vs-CDe posture of
FDR-CD-PRODPROGRESSIONISDEPLOY/FDR-CD-CDEINTERNALIZESPROMOTION.

- [RC and RBC](#rc-and-rbc)

### Rule FDR-CD-ACCEPTANCETESTINGISNOTUAT

**Acceptance testing (AT) is the verification; a UAT is the environment it runs in — two distinct concepts, not one renamed to the other.**
A **UAT** (User Acceptance Testing environment) is a running deployment a user-mimic can interact with — `main-uat` (tracking main) and
`release-uat` (the release branch). **AT** (Acceptance Testing) is the verification _activity_: the **automated and manual** acceptance
tests a commit must pass in that environment to be release-verified. So a stage's `-AT` name marks the testing and a `-uat` name marks the
environment: **`L3-vertical-AT`** is the automated AT run in an on-demand environment — in a pipeline it is the AT gate; on a devbox it is a
fast run that reports the assumptions it makes, not a gate; **`main-AT`** is the AT against `main-uat` (the manual RC gate,
FDR-CD-TWORELEASEGATES); **`release-AT`** is the AT against `release-uat` (the manual RBC gate). A commit state
`release-at-verified (main-uat)` reads "passed AT, in the main-uat environment" — the `-AT` is the testing, the `(…-uat)` is where.

- [AT and UAT](#at-and-uat)

### Rule FDR-CD-PREPRODRUNG

**The prod tail adds a pre-prod rung, and DEPLOY splits by target into non-prod and prod.** Past the RBC gate the artifact is promoted
through a **pre-prod** environment (staged, not yet live) before **production**, so the promotion ladder's tail is
`release-uat → pre-prod → production` (FDR-CD-LIFE-ONESTATEADVANCESONERUNG). The DEPLOY activity (FDR-CD-PRODPROGRESSIONISDEPLOY) is
correspondingly two-part on the same build-once artifact: **DEPLOY-Non-Prod** drives it into the non-prod AT environments (the on-demand
environments, `main-uat`, `release-uat`), and **DEPLOY-Prod** drives the RBC-cleared artifact through `pre-prod` into `production`. Only the
target and its governance differ; the tagged artifact is identical across both.

- [Pre-prod and the DEPLOY split](#pre-prod-and-the-deploy-split)

### Rule FDR-CD-TWOENVIRONMENTACTIVATION

**Deploy-to-prod is a two-environment activation: stage the artifact _inactive_ in pre-prod, validate the exact bytes, then activate it
_live_ to production.** DEPLOY-Prod never deploys straight into the serving environment. It first deploys the RBC-cleared artifact to
**pre-prod** — a production-grade environment that is **not serving live traffic** (the "inactive" environment) — where the identical bytes
get a final rehearsal against production-shaped dependencies. Pre-prod is a **staging slot in the production subscription**, declared in the
azure config and inactive until activated, not a subscription of its own. Only then is that same artifact **activated to live production**
(the inactive → live cutover). The go-live is therefore a **promotion of already-validated bytes, not a fresh untested deploy**, which is
what keeps the production cutover low-risk. When the new version goes live, the previous production occupant is superseded and steps down
(FDR-CD-LIFE-RETIREMENTISNOTDISCARD/FDR-CD-LIFE-SUPERSESSIONABANDONSOVERTAKEN). Build-once holds throughout: pre-prod and production receive
the identical tagged artifact (FDR-CD-SEPARATEPIPELINEKINDS).

- [Deploy to prod](#deploy-to-prod)

### Rule FDR-CD-GATEDEFINED

A **gate** is a check whose verdict decides whether work may proceed past a point in the flow: it clears or holds, never half. A gate gives
its verdict either by machine — a quality gate, run inside the inner CI gate and its integration budget (FDR-CD-SHORTINTEGRATIONCYCLE) — or
by human certification, as a manual gate — RC and RBC (FDR-CD-TWORELEASEGATES). A gate decides; the pipeline that acts once a gate clears
(DEPLOY, FDR-CD-PRODPROGRESSIONISDEPLOY) is not a gate.

- [RC and RBC](#rc-and-rbc)

### Rule FDR-CD-RELEASECANDIDATE

A **release candidate** is the immutable, tagged artifact a CI component builds from one commit of a deployable-unit
(FDR-CD-SEPARATEPIPELINEKINDS): versioned, never rebuilt, and promotable toward production. Every gate it clears promotes the same bytes,
and the environment it is deployed to has the commit it was built from as its occupant (FDR-CD-LIFE-ONECOMMITPERENVIRONMENT). Its
verification beyond the fast CI gate is a release-candidate test run — CD's post-commit system test (FDR-CD-CDSTAYSINNONPROD,
FDR-CD-INNERANDOUTERLOOP).

- [RC and RBC](#rc-and-rbc)

### Rule FDR-CD-PRODAPPROVALGATE

Every prod-tier environment a pipeline deploys to carries an **approval gate**: an Approval check by one named approver group, so a run that
reaches it waits for a person. The gate is configuration, never a portal setting: `environment-approvals.yml` declares the approver group,
its members, the timeout, the units and the prod-tier environments, and one deterministic apply, `Sync-AdoEnvironmentApprovals`, makes the
organization match it. An environment a pipeline deploys the prod tier to is listed there; the RC and RBC checks of FDR-CD-TWORELEASEGATES
on each unit's `release-uat` and `pre-prod` environments are derived from the rungs registry (FDR-CD-RUNGSREGISTRY).

- [The prod approval gate](#the-prod-approval-gate)

### Rule FDR-CD-RUNGSREGISTRY

The promotion ladder's **rungs** are declared once, in climbing order, by the rungs registry: each rung names the gate a commit clears to
enter it, the configuration environment it deploys, and the rule codes that define it, so a file that cites one of them, or the decision
record that holds it, concerns that rung. A unit's ADO environment for a rung is `<unit>-<rung>`, so every environment name, approval check
and diagram that refers to a rung reads it from the registry, and remapping a rung to another environment is one edit there. The registry is
`rungs.yml` in `Catzc.Base.Flow`, with its ladder declared on `RungsConfig`.

- [The rungs registry](#the-rungs-registry)

### Rule FDR-CD-CERTIFYINGRECORD

**A rung's certifying record is its environment's deployment history.** Before a DEPLOY run deploys a prod target, it checks that the commit
it ships stood on pre-prod: the history of the unit's `<unit>-pre-prod` environment holds a successful deployment of that commit, or the run
stops before it deploys. The record is the execution engine's own history of the environment, never a tag or a file a pipeline writes, so it
cannot say a commit stood where it did not. In Azure DevOps the record is the environment's deployment history, and the check is a step of
every deploy job of the prod target.

- [The certifying record](#the-certifying-record)

## Context

[pipeline-types](pipeline-types.md) is the _taxonomy_ — it fixes what each of the six ADO artifact kinds **is**. This FDR is the _design
layer_ above it: it records that "CI" names a **discipline** before it names a pipeline, and that the pipeline kinds are not a flat list:
they **compose into a directional promotion flow**, keyed together by one shared object — the tagged artifact. The taxonomy answers "what is
a CD pipeline"; this answers "what is Continuous Integration as a practice, and how do CI, CD, and DEPLOY chain a commit all the way to
production without any of them rebuilding it."

Two of those kinds share the letters "CD" and must not be confused. **CD is Continuous _Delivery_**: the flow is automated through non-prod
and the artifact is left _ready_ for prod, with the production cutover handed to a separately-governed DEPLOY
(FDR-CD-CDSTAYSINNONPROD–FDR-CD-PRODPROGRESSIONISDEPLOY). **CDe is Continuous _Deployment_**: the same flow with the prod roll internalized
and automated, so a locked commit reaches production without a human starting a separate pipeline (FDR-CD-CDEINTERNALIZESPROMOTION).
Delivery makes prod a human decision; deployment makes it an automated activity of the pipeline.

The word "CI" carries both meanings, and conflating them is the mistake this FDR guards against. Read as a pipeline only, "CI" shrinks to a
YAML file that compiles something. Read as a discipline, it is the team-scale practice — small, frequent integrations into one mainline,
each proven fast — that the pipeline exists to _serve_. The 5–10 minute budget, the always-on environment that mirrors main, and the
build-once artifact that flows to prod are all consequences of taking the discipline as primary. The complement is
[continuous integration](../research/continuous-integration.md), whose CI-gate budget is what a slow release-candidate test run breaks when
it squats in the fast CI budget.

## Decision

CI is a discipline; the CI, CD, and DEPLOY pipeline kinds are keyed together by the tagged artifact into a directional promotion flow from
main to prod. The flow, end to end:

```text
CI (discipline)   keep every integration into main/master ≤ 5–10 min  ──  team-wide
      │
      ▼  the CI pipeline concept produces
CI (pipeline)  ──►  tagged artifact   (build-once — the key every kind shares)
      │
      ▼  a CD is that same CI, then a direction (all non-prod, automated)
CD (pipeline = CI component + direction)
      ├─ deploy → on-demand environment → L3 E2E (vertical / horizontal)   ── the CI+ outer loop (FDR-CD-INNERANDOUTERLOOP)
      └─ deploy → always-on env tracking latest main   (main-UAT / DEV / TEST — org semantics)
      │
      ▼  same tagged artifact, now certified across non-prod — two governance postures to prod:
      │
      ├─ delivery (CD → RC/RBC gate → DEPLOY):  a human certifies (RC @ main-UAT / RBC @ release-uat), then DEPLOY rolls to prod
      │     DEPLOY (pipeline — solo, the actuator once the gate clears)
      │        └─ promote → non-automated environment behind a manual gate → … → prod
      │
      └─ deployment (CDe):  the CD internalized the prod roll — no separate trigger
            └─ automatically advance the locked artifact → [optional internal approval] → prod
```

### CI as a discipline

`CI is a discipline, the pipeline is its instrument`

Continuous Integration is first a way a team works: everyone integrates into one mainline continuously, in small increments, and every
increment is validated before it is allowed to define the new state of main. The **pipeline** named CI — the pre-commit build validation and
the post-commit Build Verification Test — is the mechanism that makes the discipline hold at machine speed and team scale. Naming the
pipeline "CI" is correct, but it is the instrument, not the idea. When a design choice trades off between "make the pipeline do more" and
"keep the integration cycle fast and continuous," the discipline wins, because the pipeline exists to serve it.

### The integration budget

`The integration budget is a team constraint`

The discipline only works if integrating _into_ main is cheap and fast for the whole team at once. That is the 5–10 minute figure (Farley's
pre-commit budget; DORA's ten-minute working number). It is a **team** constraint, not an individual one: one contributor waiting fifteen
minutes is an annoyance, but a gate that takes fifteen minutes on every merge across a team is a standing queue, and a queue is the opposite
of _continuous_ integration. So the budget is a hard design constraint on the CI pipeline concept, enforced there
([FDR-CD-TYPE-PRECOMMITBUDGET](pipeline-types.md#rule-fdr-cd-type-precommitbudget)); this FDR records that the reason is the discipline, not
the pipeline's convenience. Work too slow for the budget is pushed right — into the CD deploy path or a DEPLOY step — never into the
pre-commit gate.

### Separate kinds, one key

CI, CD, and DEPLOY are deliberately **separate ADO constructs** — separate triggers, separate governance, separate run histories — because
they answer to different owners and cadences (build-and-verify on every change; automated non-prod promotion; production cutover behind a
manual gate). What keeps them from being three disconnected things is that they are **keyed together by one shared object**: the immutable,
tagged artifact. A CI component stamps it once; CD consumes exactly that tag; DEPLOY promotes exactly that tag to prod. The tag (and its
commit) is the join key across the kinds, the same way one name joins two configuration layers. Because the key is an immutable artifact and
no kind rebuilds it — build-once, deploy-many — what runs in production is byte-identical to what was certified in non-prod. The kinds stay
small and independently reasoned; the artifact carries the continuity.

### A CD is a CI that keeps going

There is exactly one CI component, and both a solo CI pipeline and a CD pipeline run it — the same build-and-verify engine
([FDR-CD-TYPE-ONECIENGINE](pipeline-types.md#rule-fdr-cd-type-oneciengine)). The difference is only what happens _after_ it:

- A **solo CI pipeline** stops at the verdict. Its terminal output is a pass/fail signal — the build was green (or not). It publishes no
  deployable artifact and deploys nothing; a unit with an artifact to carry forward is a CD ([pipeline-types](pipeline-types.md#ci)).
- A **CD pipeline** runs that same CI component and then takes the artifact in a direction (below). "CD contains CI" therefore costs no
  duplicated build logic: it is the one engine, run as the front of a longer pipeline, followed by the deploy-and-verify tail.

This is why the taxonomy calls CI "a CD pipeline with the deploy removed" — the two are the same engine, plus or minus a direction.

### CD's direction through non-prod

A CD pipeline's job, after the build, is to move the artifact through non-prod in a fixed direction:

1. **On-demand environment + L3 E2E.** Deploy the tagged artifact to a throwaway, on-demand environment and run **L3 system-level
   end-to-end** tests against it (the L3 test tier). E2E here is either **vertical** — one thin slice exercised through every layer — or
   **horizontal** — broad coverage across a layer. This is the artifact proving itself against real cloud dependencies, in an environment
   that exists only for the run.
2. **The always-on mirror of main.** Then roll the same artifact onto an **always-on, hands-off non-prod environment that continuously
   matches latest main/master** — reconciled automatically by the post-commit run, so it is always a live reflection of the mainline.
   Whether an organization calls this `main-UAT`, `DEV`, or `TEST` is its own semantics; the **shape** is what this FDR fixes: always up, no
   manual step to refresh it, tracking the head of main.

All of this is automated and lives entirely in non-prod. CD never touches production.

### The boundary to prod is DEPLOY

The step from non-prod to production is where automation stops and organizational governance begins, and that is exactly the CD/DEPLOY
boundary. From the certified non-prod state, the **same tagged artifact** is promoted toward prod through **DEPLOY** activities: a solo,
manually-governed DEPLOY pipeline that drives the artifact into a **non-automated** environment behind a manual gate
([FDR-CD-TYPE-DEPLOYISCDTAIL–FDR-CD-TYPE-DEPLOYCARRIESGOVERNANCE](pipeline-types.md#deploy)). A DEPLOY pipeline is where a certification
environment locked to a release commit, or a production cutover behind an approval gate, lives. The line is clean: **CD is the automated
non-prod direction; DEPLOY is the human-governed step toward prod** — two kinds, one artifact, keyed together at the boundary rather than
fused into a single pipeline that would bury the manual gate inside an automated flow.

### CDe

`CDe internalizes the automated roll to prod`

The CD/DEPLOY split above is Continuous **Delivery**: the pipeline brings a change to a certified non-prod state automatically, and a human
then triggers a separately-governed DEPLOY to take it the rest of the way to prod. Continuous **Deployment** removes that hand-off — the
promotion to production is not a separate, human-initiated pipeline but an **automated continuation of the same flow**. That construct is
**CDe**.

What defines CDe is _where the promotion decision lives_, not whether a human ever approves anything:

- In **CD → DEPLOY**, the decision to roll to prod is **external**: a person starts a DEPLOY pipeline, which owns the prod step with its own
  trigger, governance, and history.
- In **CDe**, the decision is **internalized**: for a locked commit and its build, the pipeline itself advances toward prod automatically. A
  CDe may still **pause at an approval gate** — a required approval before the production stage — but that gate is a checkpoint _inside_ an
  automated promotion, not a separate pipeline someone must remember to go and start. The activity, "advance this locked artifact toward
  prod," is determined by the pipeline.

So CDe is **a CD that internalized DEPLOY**: the same CI component, the same non-prod direction, then the prod roll folded back in and
automated. A deployable unit is governed **either** as CD → DEPLOY (delivery — automated to non-prod, human-triggered to prod) **or** as CDe
(deployment — automated the whole way), never both; the choice is a per-unit governance posture. Build-once, deploy-many is untouched: CDe
promotes the same tagged artifact CI stamped, so automating the prod step changes _who decides_ to ship, not _what_ ships. This is the
Humble & Farley Delivery/Deployment distinction made a first-class pipeline kind, so a design conversation can name which posture a unit is
under instead of leaving "CD" to mean both.

### The outer CI+ loop

`The outer CI+ loop closes integration`

Continuous Integration as a discipline (FDR-CD-DISCIPLINEBEFOREPIPELINE) asks that every change be validated fast enough that the mainline
stays continuously integrable. In practice that validation runs at two speeds, and conflating them is the mistake. The **inner loop** — the
CI gate — must clear in 5–10 minutes (FDR-CD-SHORTINTEGRATIONCYCLE) or it stops being a gate and becomes a queue; it runs the fast, hermetic
checks (L0–L2) and the BVT. The **outer loop** — CI+ — runs the system-level tests that exercise the built artifact against real boundaries
(the L3-vertical run of FDR-CD-CDSTAYSINNONPROD), and those cannot be made to fit the inner budget: they take an hour or two, and forcing
them into the pre-commit stage is exactly the shared-fate failure the budget rule exists to prevent.

The discipline's honesty depends on naming this. A green inner CI proves the merge builds and passes the fast checks; it does not prove the
system works. Integration, as the contributor experiences it, is not finished until the CI+ outer loop returns — that feedback, not the CI
gate, is what closes the loop. So CI+ is not a weaker or optional CI: it is the part of the discipline the CI gate deliberately defers, run
post-commit where its cost is affordable, and a change is "integrated" only once it is green. Because CI+ is discipline, not a pipeline
kind, it adds no ADO pipeline kind (FDR-CD-SEPARATEPIPELINEKINDS) — its L3 leg is the CD pipeline's on-demand system test, named as the
outer loop rather than forked into a second pipeline.

### RC and RBC

`RC and RBC: the two hands-on release gates`

The automated flow (FDR-CD-CDSTAYSINNONPROD) carries the artifact through non-prod on its own. Progression toward production, by contrast,
passes through **human certification** — at two manual gates, one per always-on release environment, each a deliberate hands-on stop rather
than an automated check:

- **RC — Release Certification**, at **main-UAT**. The always-on environment that tracks latest main holds one occupant
  (FDR-CD-LIFE-ONECOMMITPERENVIRONMENT); RC is the human decision to certify the main-UAT occupant for onward release. It is the gate a
  Continuous **Delivery** posture stops at, handing the production step to DEPLOY.
- **RBC — Release Branch Certification**, at **release-uat**. When a release variant is stabilized on a release branch, RBC is the human
  certification of the release-uat occupant before it is cut to production.

Each is a **gate, not a pipeline**. The gate is the human decision; the **DEPLOY** pipeline (FDR-CD-PRODPROGRESSIONISDEPLOY) is the actuator
that rolls the certified artifact onward once the gate clears. Keeping them distinct is what lets one DEPLOY mechanism serve either gate,
and lets a Continuous **Deployment** (CDe) posture internalize the roll (FDR-CD-CDEINTERNALIZESPROMOTION) by automating past the point where
RC/RBC would otherwise stop it. Which gates a unit passes through — and whether a human or the pipeline owns the decision to advance — is
the delivery-vs-deployment posture of FDR-CD-PRODPROGRESSIONISDEPLOY/FDR-CD-CDEINTERNALIZESPROMOTION.

RC and RBC are the manual gates. A gate a machine decides is a quality gate, which is a gate in this sense.

### AT and UAT

`AT is the verification, UAT is the environment`

The value chain names two layers that are easy to conflate. A **UAT** is a _place_ — a running environment where the built artifact is
deployed and a human (or an automated user-mimic) can exercise it; the diagram's env lane labels these `main-uat` and `release-uat`. **AT**
is what happens there — the acceptance testing, automated and manual, that a commit must pass before it is release-verified. Keeping the two
apart is what lets one environment host successive commits' testing over time (the UAT persists; each commit's AT is a fresh verification),
and lets the same verification idea span an automated slice (`L3-vertical-AT`) and manual slices (`main-AT`, `release-AT`).

The `-AT` / `-uat` suffixes are a deliberate two-word grammar, not redundancy: `main-AT` is the acceptance testing performed against the
`main-uat` environment, and clearing it is the RC gate; `release-AT` is the acceptance testing against `release-uat`, and clearing it is the
RBC gate. A commit labelled `release-at-verified (main-uat)` has passed its AT in the main-uat environment. The environment is durable and
shared; the AT is per-commit and is what the gate certifies.

### Pre-prod and the DEPLOY split

`Pre-prod, and DEPLOY split non-prod / prod`

The promotion tail is longer than "non-prod, then prod." After the RBC gate the artifact lands first in a **pre-prod** environment — staged
and inactive, a last rehearsal of the exact bytes before they go live — and only then in **production**. So the ladder gains a rung,
`release-uat → pre-prod → production` (FDR-CD-LIFE-ONESTATEADVANCESONERUNG), and pre-prod is a single-occupant environment like the others
(FDR-CD-LIFE-ONECOMMITPERENVIRONMENT).

Because the deploy activity spans several environments with different governance, it reads as two named halves of one build-once flow.
**DEPLOY-Non-Prod** is the deploy into the non-prod AT environments — the on-demand L3 environments, `main-uat`, and `release-uat` — the
targets CD's automated direction covers (FDR-CD-CDSTAYSINNONPROD). **DEPLOY-Prod** is the governed deploy of the RBC-cleared artifact
through `pre-prod` into `production` (FDR-CD-PRODPROGRESSIONISDEPLOY, and
[FDR-CD-TYPE-DEPLOYCARRIESGOVERNANCE](pipeline-types.md#rule-fdr-cd-type-deploycarriesgovernance)). The split is by _target and governance_,
not by artifact: the same tagged build flows through both, so build-once / deploy-many holds end to end.

### Deploy to prod

`Deploy-to-prod: stage inactive, then activate live`

Going to production is not one step of "push the bytes at the live environment." It is two, and separating them is the point. First,
**DEPLOY-Prod deploys the RBC-cleared artifact into `pre-prod` — a production-grade environment that is _inactive_** (staged, not serving
live traffic). This is the last place the _exact_ bytes that will go live are exercised against production-shaped dependencies, with real
production configuration, before any user sees them. Second, once pre-prod is good, **the same artifact is _activated_ to
`live / production`** — the inactive environment becomes the serving one. The two boxes in the diagram, `inactive / pre-prod` and
`live / production`, are precisely these two states of the prod deploy: staged-but-dark, then live.

The reason to split them is risk. Because the live cutover is the **activation of bytes already validated in a prod-identical environment**,
not a fresh deploy of something only ever seen in non-prod, the moment of going live carries almost no new risk — nothing is compiled,
rendered, or first-run at cutover (build-once, FDR-CD-SEPARATEPIPELINEKINDS). What flips is _which environment serves traffic_, not _what
the bytes are_. When the new version goes live, the previous production occupant is superseded and steps down
(FDR-CD-LIFE-SUPERSESSIONABANDONSOVERTAKEN) — the diagram shows the new version occupying both `pre-prod` and `production` at the moment of
cutover, and the version it replaced leaving. Whether that activation is a human-triggered DEPLOY (delivery) or an automated continuation
(CDe, deployment) is the posture of FDR-CD-PRODPROGRESSIONISDEPLOY/FDR-CD-CDEINTERNALIZESPROMOTION; either way the mechanic — stage
inactive, validate, activate live — is the same.

### The prod approval gate

`Prod waits for a person, and the config says who`

Whatever posture a unit is under, a run must not reach a prod-tier environment unattended. Azure DevOps holds that stop as an Approval check
on the environment, and a check set by hand in the portal drifts: nobody can review it, rebuild it or see who may approve. So the gate is
configuration. `environment-approvals.yml` (in `Catzc.Azure.DevOps`) names the approver group and its members, the timeout a pending
approval waits, the units whose release-gate rungs carry the RC and RBC checks, and the prod-tier environments, which are named by their
deploy target rather than by a rung; its config type declares the defaults once (`Prod Approvers`, 24 hours). One apply,
`Sync-AdoEnvironmentApprovals`, makes the organization match the file in a fixed order — the group, then exactly its configured members,
then one check per environment — and reports each step, so a second run changes nothing. The procedure is the how-to "Apply the prod-tier
approvals" (`docs/how-to/automation/apply-environment-approvals.md`).

The gate is the stop the promotion ladder does not yet have rungs for: until main-uat, RC, RBC and DEPLOY exist in code, it is what stands
between a merge and production. It stays when the ladder lands, as the CDe's internal approval gate (FDR-CD-CDEINTERNALIZESPROMOTION) or
DEPLOY's.

### The rungs registry

`One ladder, named once`

The ladder's rung names travel: into ADO environment names, approval checks, deploy lists, the lifecycle diagrams. Written out in each, they
drift, and a rung that moves to another environment becomes a search through every file that names it. The registry states the ladder once.
Each rung carries the gate that guards its entry (none for main-uat, which CD deploys on merge; RC for release-uat; RBC for pre-prod; the
prod approval gate for prod) and the configuration environment it deploys, and everything else derives from it: the approval apply builds
`<unit>-<rung>` for the rungs behind RC and RBC. The prod tier is the exception on purpose. Its environments are named by the deploy target,
a subscription or a configuration slot, not by the rung, so `environment-approvals.yml` lists them.

### The certifying record

`Prod ships only what stood on pre-prod`

The RBC gate and the two-environment activation (FDR-CD-TWOENVIRONMENTACTIVATION) both assume that what goes live is what stood on pre-prod.
A DEPLOY run is started by hand with a CI run id, so nothing in its parameters proves that assumption: a rerun of the prod stage, or a run
id typed wrong, can name an artifact that pre-prod never held. The proof is the environment's deployment history. The execution engine
writes it as a side effect of every deploy job, so no pipeline can forge it, and it names the run behind each deployment, from which the
commit follows. A record the pipeline writes itself, such as a `certified-<rung>` tag, would be a second store of the same fact that can
drift from the first, so the history is the only record.

The check runs inside each deploy job of the prod target, before the job downloads the artifact. It resolves the commit of the CI run the
DEPLOY run names and looks for a successful pre-prod deployment of that commit; a deployment made by a DEPLOY run counts for the commit of
the CI run that run named. A unit whose DEPLOY has no prod target has nothing to certify, and takes the check when it gains one.

## How this is enforced

- **The pipeline taxonomy carries the mechanics.** The 5–10 minute budget, the CI-engine sharing, and the DEPLOY governance rules are
  enforced through [pipeline-types](pipeline-types.md) (FDR-CD-TYPE-ONECIENGINE, FDR-CD-TYPE-PRECOMMITBUDGET,
  FDR-CD-TYPE-DEPLOYISCDTAIL–FDR-CD-TYPE-DEPLOYCARRIESGOVERNANCE) and the runner pattern. This FDR is the design rationale those rules point
  back to; it is enforced in **code review** of pipeline design, using the flow above as the reference shape.
- **Artifact identity is the checkable invariant.** A promotion that rebuilds — a CD, CDe, or DEPLOY that recompiles instead of consuming
  the CI component's tagged artifact — violates FDR-CD-SEPARATEPIPELINEKINDS and is caught in review: the same tag must flow from CI through
  the non-prod direction to the prod step (DEPLOY's, or CDe's internalized one), never re-derived.
- **Delivery vs deployment is a named posture.** Review checks that a unit that auto-rolls to prod is a **CDe**
  (FDR-CD-CDEINTERNALIZESPROMOTION) — the prod promotion internalized and automated, with any human step expressed as an _internal_ approval
  gate — and not a DEPLOY's human-owned cutover fused into a CD under the "CD" label. Which posture a unit is under is a deliberate,
  reviewable choice, not an accident of where a stage was placed.
- **The environment shape, not its name, is the contract.** Review checks that the always-on non-prod environment is auto-reconciled to
  latest main (FDR-CD-CDSTAYSINNONPROD), whatever the org names it — a manually-refreshed "UAT" that drifts from main is not the always-on
  mirror this flow requires.
- **CI+ and the release gates are review-checked.** Review confirms the slow system tests live in the CI+ outer loop, never the inner CI
  gate (FDR-CD-SHORTINTEGRATIONCYCLE/FDR-CD-INNERANDOUTERLOOP), and that a promotion to prod passes a named manual gate — RC at main-UAT or
  RBC at release-uat (FDR-CD-TWORELEASEGATES) — with DEPLOY as the actuator, not a human cutover fused into CD under another label.
- **The prod approval gate is applied, not hand-set.** `EnvironmentApprovalsConfig` validates `environment-approvals.yml` when it loads, an
  integrity test loads the shipped file, and `Sync-AdoEnvironmentApprovals` applies it; review checks that a pipeline deploying a new
  prod-tier environment lists it there (FDR-CD-PRODAPPROVALGATE).
- **The certifying record is checked in the run.** A DEPLOY pipeline names the pre-prod environment as its prod stage's `CertifiedBy`, and
  each deploy job of that stage first runs `Assert-AdoDeploymentHistory`, which throws when the history lacks the commit; an L0 test stops a
  commit absent from the history (FDR-CD-CERTIFYINGRECORD).

## Consequences

- "CI" stops being ambiguous: the discipline (fast, continuous integration into one mainline) and the pipeline (the BVT that enforces it)
  are named as cause and instrument, so a design conversation can say which one it means.
- The pipeline kinds read as a **flow**, not a flat list: a solo CI produces the artifact, a CD carries it through non-prod, a DEPLOY
  promotes it to prod — one artifact keying three independently-governed pipeline kinds.
- Build-once, deploy-many is structural: because the tagged artifact is the join key and no kind rebuilds, production runs exactly the bytes
  non-prod certified.
- The manual/automated line has a home: under **delivery**, everything automated lives in CD's non-prod direction and everything behind a
  manual gate lives in DEPLOY, with the boundary explicit rather than an approval buried in an automated pipeline. Under **deployment
  (CDe)**, the prod roll is internalized and automated, and the boundary moves _inside_ the pipeline as an optional approval gate — still
  explicit, but now a checkpoint in an automated flow rather than a separately-triggered construct.
- "CD" stops meaning two things: Continuous **Delivery** (prod is a human-triggered DEPLOY) and Continuous **Deployment** (CDe — the prod
  roll is automated) are named apart, so a unit's promotion posture is stated, not inferred.
- The cost is that promotion is several keyed constructs rather than one monolith. That is the intended trade: separate pipeline kinds with
  their own access, isolation, and history, held together by an immutable artifact — not a single pipeline that conflates the team's CI
  gate, an automated non-prod rollout, and a governed production cutover.

## Related

- [pipeline-types](pipeline-types.md) — the taxonomy this FDR builds on (CRON / CI / CD / CDe / DEPLOY / INPUT).
- [pipeline-runner-pattern](pipeline-runner-pattern.md) — how every pipeline kind invokes automation.
- The L0–L3 test tiers — L3 is the system-level E2E CD runs in its on-demand environment, and the outer CI+ loop (FDR-CD-INNERANDOUTERLOOP).
- The `git_workspace` variant — the PR-vs-Direct integration mode the value-chain diagrams prefix a flow with.
- [everything-as-code](../principles/everything-as-code.md), [reduce-waste](../principles/reduce-waste.md) — build-once/deploy-many and the
  version-aligned artifact are these principles applied to the flow.
- DORA: [continuous integration](../../references/dora/capabilities.md#continuous-integration) — the fast-feedback budget a slow test run in
  the fast CI budget breaks.
