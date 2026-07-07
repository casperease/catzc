# ADR: Pipeline types — the six kinds of ADO artifact, named

## Rules: ADR-PIPETYPE

### Rule ADR-PIPETYPE:1

Every ADO artifact is exactly one of the six types — CRON, CI, CD, CDE, DEPLOY, or INPUT. An artifact that does not fit is a design problem
to resolve, not a seventh type to invent.

- [Decision](#decision)

### Rule ADR-PIPETYPE:2

All six types invoke automation through the runner (`Invoke-AdoScript.ps1`); YAML stays declarative and logic lives in `automation/`. (One
sanctioned exception: the `ci-automation-expected-failures` guardrail pipeline.)

- [Decision](#decision)

### Rule ADR-PIPETYPE:3

CI and CD share one CI engine — the pre-commit build validation and the post-commit build-and-verify on master are the same component; do
not fork a second build path for CD.

- [CD — CI, then deploy and verify](#cd--ci-then-deploy-and-verify)

### Rule ADR-PIPETYPE:4

The pre-commit budget is 5–10 minutes; anything slower belongs post-commit, in a CD pipeline's deploy path, not in pre-commit validation.

- [CI — build and verify, no deploy](#ci--build-and-verify-no-deploy)

### Rule ADR-PIPETYPE:5

CRON is a scheduler, not a pipeline — a schedule plus a `RunCommand` invoking an idempotent automation function; no build, artifact, or
deploy in the YAML.

- [CRON — automation jobs on a timer](#cron--automation-jobs-on-a-timer)

### Rule ADR-PIPETYPE:6

Config parameters that reach the cloud are confined to INPUT reaching git main somehow — CRON has none to limited set with
automatic-defaults (meaning the control ex. "going to production, for a certificate etc"), and CI/CD are functions of version control, not
button-press input. DEPLOY is human-triggered, but its parameters are version-control meta-selection (which committed artifact, which
governed target), never config: the config it deploys is already git-resident, and the artifact it deploys is the immutable, tagged output
that CD's CI engine already built and published.

- [INPUT — self-service input, turned into a commit](#input--self-service-input-turned-into-a-commit)
- [DEPLOY — the governed deploy tail, extracted](#deploy--the-governed-deploy-tail-extracted)

### Rule ADR-PIPETYPE:7

INPUT produces commits, never deployments — its terminal output is a version-controlled change; deploying that change is CD's or DEPLOY's
job.

- [INPUT — self-service input, turned into a commit](#input--self-service-input-turned-into-a-commit)

### Rule ADR-PIPETYPE:8

DEPLOY is the deploy-and-verify tail of CD, extracted into its own human-governed pipeline. It consumes an immutable artifact built
elsewhere (the CI engine's build-once output) pinned to an explicit commit, trust that it have been processed by an L3 gate (system test) -
and drives it into an environment whose gate is manual and organizational — a standard operating procedure, an ITSM change-management
approval, a human sign-off. It builds nothing and re-runs no CI engine.

- [DEPLOY — the governed deploy tail, extracted](#deploy--the-governed-deploy-tail-extracted)

### Rule ADR-PIPETYPE:9

DEPLOY and CD share one deploy-and-verify path — the same deploy orchestration and the same system tests. Extracting the deploy into a
DEPLOY pipeline must never fork a second deploy implementation, exactly as CI and CD share one CI engine (ADR-PIPETYPE:3).

- [DEPLOY — the governed deploy tail, extracted](#deploy--the-governed-deploy-tail-extracted)

### Rule ADR-PIPETYPE:10

DEPLOY is pinned and deterministic — it deploys the artifact of one chosen commit, so the same commit deploys the same bytes on every run,
which is what makes a locked release commit certifiable. It never deploys from a floating `latest` and never renders config at deploy time.

- [DEPLOY — the governed deploy tail, extracted](#deploy--the-governed-deploy-tail-extracted)

### Rule ADR-PIPETYPE:11

DEPLOY exists to make an environment's governance a first-class pipeline construct — one place for access control, isolation, and audit
history over a manually-gated environment. Its two canonical targets are a release-branch certification environment locked to a commit for
stabilization, and an automated pre-prod rollover chained to a manual prod-approval gate.

- [DEPLOY — the governed deploy tail, extracted](#deploy--the-governed-deploy-tail-extracted)

### Rule ADR-PIPETYPE:12

CDE (Continuous Deployment) is a CD that **internalizes and automates the roll to production**. It runs the same CI engine and the same
deploy-and-verify path as CD (ADR-PIPETYPE:3, ADR-PIPETYPE:9), builds nothing new, and drives the CI engine's tagged, commit-pinned artifact
all the way to prod. Its defining trait: the promotion of a locked commit-and-build to production is an **automated activity of the
pipeline**, not a separately-triggered DEPLOY.

- [CDE — Continuous Deployment, the prod roll internalized](#cde--continuous-deployment-the-prod-roll-internalized)

### Rule ADR-PIPETYPE:13

A CDE may contain **internal** manual gates — an approval before the production stage — but they are checkpoints _inside_ an automated
promotion. Such a gate does not make it a DEPLOY: what separates CDE (deployment) from CD → DEPLOY (delivery) is that the roll-to-prod
activity is automatically determined, not human-initiated.

- [CDE — Continuous Deployment, the prod roll internalized](#cde--continuous-deployment-the-prod-roll-internalized)

### Rule ADR-PIPETYPE:14

CDE shares the one deploy-and-verify path with CD and DEPLOY (ADR-PIPETYPE:9) — never a second deploy implementation. A deployable unit's
production promotion is governed as **either** CD → DEPLOY (delivery, human-governed prod) **or** CDE (deployment, automated prod), never
both; the choice is a per-unit governance posture.

- [CDE — Continuous Deployment, the prod roll internalized](#cde--continuous-deployment-the-prod-roll-internalized)

## Context

In Azure DevOps, every YAML-defined, agent-executed artifact is called a "pipeline." The word covers structurally different things: a
timer-driven automation job, a build-and-test gate, a full deploy, a manually-governed deploy of a locked commit, and a user-facing form.
When one noun covers all of them, the organisation loses the language it needs to distinguish their failure modes — the exact diagnosis made
in [shared-fate-ci](../../notes/shared-fate-ci.md) (a "pipeline" that is really a release-candidate suite hung in the pre-commit slot) and
[ado-as-self-service-layer](../../notes/ado-as-self-service-layer.md) (a "pipeline" that is really a parameterised RPC call wearing
continuous delivery's name).

The repair those notes prescribe is not a new mechanism. It is **precise naming**: call each artifact what it is, give each its own trigger
model and contract, and make the differences visible. This ADR establishes a **closed set of six pipeline types**. Every ADO artifact in
this platform is exactly one of them. Anything that does not fit is a design smell to resolve, not a seventh type to invent quietly.

This ADR is taxonomy only. It fixes what the six types _are_ — their triggers, their components, and the contract each must honour. It does
not specify the deploy orchestration, the INPUT translator internals, or the YAML shapes.

### The CI engine — shared by three of the six types

Three of the six types (CI, CD, CDE) are built from the same component, so it is named once here and referenced by all three: the **CI
engine**.

The CI engine is **build-and-verify**, run in two trigger contexts on the same code:

1. **Pre-commit** — runs as an **ADO build validation** on the PR branch, before merge. Its job is to build the unit and verify the build.
   It is bound by a hard budget of **5–10 minutes** (Farley's pre-commit figure; DORA's ten-minute working number — see
   [shared-fate-ci](../../notes/shared-fate-ci.md)). A gate slower than that stops being a gate and becomes a queue.
2. **Post-commit on master** — the _same_ build-and-verify, re-run on the actual merged commit. The pre-commit validation proved the PR
   branch was green; the post-commit run proves the _merge result_ is green and produces the verified state of master.

It is one component, run twice, against two refs. "Build" means whatever building the unit means: for a deployable unit it yields the
immutable artifact the deploy stages consume (build-once, deploy-many); for a unit with nothing to deploy it is load-and-verify with nothing
to publish (see CI-automation below).

## Decision

There are exactly six pipeline types: **CRON**, **CI**, **CD**, **CDE**, **DEPLOY**, and **INPUT**.

| Type       | What it actually is                            | Trigger                                  | Components                                   | Produces                                    |
| ---------- | ---------------------------------------------- | ---------------------------------------- | -------------------------------------------- | ------------------------------------------- |
| **CRON**   | Automation job on a timer (not a pipeline)     | Schedule                                 | One automation invocation                    | A side effect (e.g. rotated cert)           |
| **CI**     | A CD pipeline with the deploy removed          | PR build validation + post-commit master | The CI engine only                           | A pass/fail signal (no artifact, no deploy) |
| **CD**     | CI + CD: the CI engine, then deploy + verify   | PR build validation + post-commit master | The CI engine, then deploy & system tests    | A verified artifact, then a deployment      |
| **CDE**    | CD with the prod roll internalized & automated | PR build validation + post-commit master | The CI engine, then deploy + verify to prod  | An automated production deployment          |
| **DEPLOY** | CD's deploy tail, extracted and human-governed | Manual/chained, pinned to a commit       | Deploy & system tests over a pinned artifact | A governed, audited deployment              |
| **INPUT**  | Self-service input turned into a config change | Manual, with ADO pipeline parameters     | Param intake → checkout → write config files | A version-controlled change (a commit)      |

CDE is the fullest — the CI engine, then deploy-and-verify across non-prod and prod, automated end to end; CD is CDE with the production
roll left to a separately-governed step; CI is CD with the deploy and system-test stages amputated; and DEPLOY is exactly those amputated
stages given their own human-governed pipeline. CI, CD, and CDE share **one** CI engine; CD, CDE, and DEPLOY share **one** deploy path.

### CRON — automation jobs on a timer

A CRON pipeline is, same as INPUT, **not really a pipeline**. It is the ADO pipeline mechanism used as a _scheduler_: a timer that runs an
automation job (e.g. certificate rotation, scheduled cleanup, drift checks). It does not build, does not test a unit, produces no artifact,
and deploys nothing. It invokes one automation function on a clock.

- **Trigger:** a schedule.
- **Contract:** it is a thin scheduled invocation of an automation-layer function through the runner (see
  [pipeline-runner-pattern](pipeline-runner-pattern.md)). The logic lives in an idempotent `automation/` function (see
  [idempotent-state-functions](../automation/idempotent-state-functions.md)), not in YAML. The pipeline names a `RunCommand` and a schedule;
  nothing more.

### CI — build and verify, no deploy

A CI pipeline is a CD pipeline with the deployment removed. It is the **CI engine and nothing else**: pre-commit build validation (5–10 min)
plus the same build-and-verify post-commit on master. It produces a pass/fail signal — no artifact, no deployment — because there is no
deployable unit downstream of it.

This is "the CI pipeline" and, identically, "the CI part of the CD pipeline."

- **Trigger:** ADO build validation on the PR branch (pre-commit) and a master trigger (post-commit), registered on the trigger file of the
  unit it verifies ([durable-sha-globs](durable-sha-globs.md#rule-adr-globs1)) — never path-filtered on source paths directly.
- **Example — CI-automation:** "builds" by running `importer.ps1` and "tests" via `Test-Automation` (see
  [test-automation](../automation/test-automation.md)). It produces no artifact; it simply verifies that the automation layer loads and is
  green. It registers on the automation unit's trigger file, so it runs exactly when that unit's durable SHA changes.
- **Contract:** unit-scoped and fast. The pre-commit budget is 5–10 minutes. A CI pipeline never deploys and never publishes a deployable
  artifact; if it needs to, it is a CD pipeline.

### CD — CI, then deploy and verify

A CD pipeline is **CI + CD**. It runs the same CI engine — pre-commit build validation and post-commit build-and-verify on master — and
_then_, once that is green, it orchestrates **deployment** of the deployable unit and **system-level testing** of what it deployed.

- **Trigger:** the CI engine triggers exactly as for a CI pipeline (PR build validation + post-commit master); the deploy and system-test
  stages run after the post-commit build succeeds.
- **Components:** the CI engine (producing the verified, immutable artifact), then deploy stages, then system-level / integration tests
  against the deployed unit. The artifact built once is what flows to each environment — build-once, deploy-many (Humble & Farley; see the
  Tier 2 shape in [one-config-to-rule-them-all](../../notes/one-config-to-rule-them-all.md)).
- **Contract:** one CD pipeline per deployable unit. Deploys run against version control — the artifact and config are functions of the
  repository, not of runtime input (see [ado-as-self-service-layer](../../notes/ado-as-self-service-layer.md)). The system-level tests that
  are too slow for the 5–10 min pre-commit budget live _here_, post-commit, on the way to production — not in the pre-commit slot. When a
  target environment is governed by manual, organizational gates rather than continuous delivery, CD's deploy tail is **extracted** into a
  separate DEPLOY pipeline (below) instead of chaining automatically after the post-commit build.

### DEPLOY — the governed deploy tail, extracted

A DEPLOY pipeline is **CD's deploy-and-verify tail lifted out into its own pipeline**. Where a CD pipeline chains its deploy automatically
after the post-commit build, a DEPLOY pipeline is triggered on its own — usually by a human — and drives an already-built, already-verified
artifact into an environment whose gate is **manual and organizational**: a standard operating procedure, an ITSM change-management
approval, a human sign-off. It runs the same deploy orchestration and system tests as CD (ADR-PIPETYPE:9) — it simply owns them as a
separate construct — and it **builds nothing** (ADR-PIPETYPE:8): the artifact it deploys was built once by a CI engine and is pinned to an
explicit commit.

The reason to extract it is that the environment's governance is itself the thing being modelled. Folding a manually-gated production or
certification deploy into a continuous CD pipeline buries the gate inside a pipeline whose whole point is to run automatically; pulling it
out makes the governance a first-class pipeline construct (ADR-PIPETYPE:11), which buys four concrete things:

- **Access control.** Who may deploy to the governed environment is a permission on one pipeline, not a stage condition tangled into the CD
  definition.
- **Isolation.** The deploy is decoupled from build/test triggers — it fires when a human (or an upstream signal) says so, against a commit
  they choose, not on every merge.
- **History.** Every deployment to the governed environment is one auditable pipeline's run history: which commit, who ran it, when, which
  approval cleared it — the record an SOP/ITSM regime requires.
- **Determinism.** It deploys the artifact of one chosen commit (ADR-PIPETYPE:10), so a locked release commit deploys the same bytes every
  time — the precondition for certifying it.

Concretely:

- **Trigger:** manual, or chained from an upstream pipeline, but always **pinned to an explicit commit** (a release-branch head, a specific
  `main` commit) — never a floating `latest`. Its parameters select _which commit_ and _which governed target_ (ADR-PIPETYPE:6); they are
  version-control meta-selection, not config.
- **Components:** the deploy stages and the system-level tests, over the immutable artifact the CI engine built once — build-once,
  deploy-many, the same artifact CD flows.
- **Contract:** it deploys and verifies; it does not build, does not re-run the CI engine, and does not render config (that is git-resident
  already). Its defining trait versus CD is that its **primary gate is manual organizational governance**, not continuous delivery.

**Two canonical targets:**

1. **Release-branch certification environment.** Locked to a specific commit — a release-branch head or a `main` commit — so the environment
   holds **stable** while a release variant is certified against exactly that commit. Because DEPLOY is deterministic (ADR-PIPETYPE:10),
   re-running it re-materialises the same artifact, which is what "certified at commit X" means. This is the deploy half of release-branch
   stabilization.
2. **Pre-prod rollover, then a manual prod gate.** The pipeline **automatically** rolls pre-prod over to the pinned artifact and runs its L3
   / end-to-end system tests there, then **chains to a manual approval gate** before deploy-to-prod. The automated pre-prod rollover and its
   green L3 run are the evidence that gates the human production approval; the production cutover itself is human-approved. One pipeline
   construct carries the whole promotion — automated where it can be, human where the organization requires it.

### CDE — Continuous Deployment, the prod roll internalized

A CDE pipeline is a **CD pipeline that internalizes and automates the roll to production**. Where a CD pipeline stops at non-prod and hands
the production cutover to a separately-triggered, human-governed DEPLOY — Continuous _Delivery_ — a CDE pipeline continues past non-prod and
drives the same tagged artifact into production **automatically** — Continuous _Deployment_. It runs the same CI engine (ADR-PIPETYPE:3) and
the same deploy-and-verify path (ADR-PIPETYPE:9, ADR-PIPETYPE:14) as CD and DEPLOY — it forks neither — and it **builds nothing** new: the
artifact it rolls to prod is the CI engine's build-once output, pinned to the locked commit.

What makes it CDE rather than CD → DEPLOY is **where the promotion decision lives**. In CD → DEPLOY the decision to go to prod is external —
a human starts, or approves the cutover inside, a DEPLOY pipeline (ADR-PIPETYPE:8). In CDE the decision is internalized: for a locked commit
and its verified build, the pipeline advances to prod **automatically**. A CDE may still pause at an **internal** approval gate before its
production stage, but that gate is a checkpoint _inside_ an automated promotion, not a separate construct someone must trigger; the activity
— "roll this locked artifact to prod" — is determined by the pipeline.

This is the sharp line against DEPLOY's second canonical target (the automated pre-prod rollover chained to a manual prod gate): there, the
production cutover is **required** to be human-approved — that gate is the pipeline's _primary_ governance, and it is Delivery. In a CDE, a
prod gate is optional and, when present, _internal_ to an otherwise automated roll — the promotion is Deployment.

- **Trigger:** the CI engine triggers as for CD (PR build validation + post-commit master); the non-prod deploy, the production roll, and
  any internal gate run as automated continuations once the post-commit build is green.
- **Components:** the CI engine, then the shared deploy-and-verify path across non-prod and prod, over the one immutable tagged artifact —
  build-once, deploy-many.
- **Contract:** one CDE pipeline per deployable unit whose production promotion is automated. It deploys and verifies; it does not build,
  re-run the CI engine, or render config (git-resident already). Its defining trait versus CD is that **the production roll is an automated
  activity of the pipeline**, not a human-triggered DEPLOY; versus DEPLOY, that any prod gate is an _internal_ approval in an automated
  flow, not the pipeline's _primary_ manual governance.

### INPUT — self-service input, turned into a commit

INPUT is the self-service primitive: it accepts user parameters and turns them into a **version-controlled change**. User input becomes
git-resident config, not a runtime merge into a hidden config program on its way to the cloud — the anti-pattern dissected in
[ado-as-self-service-layer](../../notes/ado-as-self-service-layer.md) and
[one-config-to-rule-them-all](../../notes/one-config-to-rule-them-all.md).

An INPUT pipeline:

1. Takes user input via **ADO pipeline parameters**.
2. Checks out the repo.
3. **Creates or edits infrastructure template config files** (under `infrastructure/templates/<name>/configuration/…`, see
   [the data model](../azure/data-model.md)) to merge in the user's configuration parameters.

Its output is a change to the source of truth — a commit — not a deployment. The user's parameters become git-resident config that the
normal CI/CD path then carries to the cloud. The invariant: self-service belongs _above_ the pipeline, feeding the source of truth —
**inputs become commits, not run parameters.**

- **Trigger:** manual, with parameters. INPUT is the **one** legitimate home for runtime ADO parameters, precisely because those parameters
  never reach the cloud directly — they are written into version control first, where the PR gate and CD can see them.
- **How the commit lands:** an INPUT pipeline may open a **PR** (reviewed, or policy-auto-merged) or commit **directly** to a branch. The PR
  form preserves the change-approval gate that DORA's research identifies as the effective one (see
  [classic-cmdb-vs-version-controlled-change](../../notes/classic-cmdb-vs-version-controlled-change.md)); the direct form is lower-ceremony
  for pre-approved, bounded changes. Either way the invariant holds: **the output is a commit, and deployment happens only through CD
  against version control** — never from the INPUT pipeline itself.
- **Contract:** an INPUT pipeline writes config and stops. It does **not** deploy, does **not** call cloud APIs to change infrastructure,
  and does **not** render the final config. It produces the same kind of diff a human would have hand-written.

## How this is enforced

- **The taxonomy is the review checklist.** A new ADO artifact is classified as CRON / CI / CD / CDE / DEPLOY / INPUT at review. An artifact
  that cannot be cleanly classified does not merge until it can.
- **The pipelines in `pipelines/`** are the canonical shape for each type — the patterns new pipelines copy, the way the exemplars work
  elsewhere in this codebase.
- **Naming.** Pipeline definitions name their type so the artifact's category is visible at a glance, not inferred from its YAML.

## Consequences

- The four failure modes the notes catalogue become nameable and therefore preventable: a release-candidate suite cannot hide in the CI slot
  (it is CD's post-commit system test), and a self-service RPC cannot masquerade as CD (it is an INPUT pipeline that produces a commit).
- A manually-governed deploy has a name and a home: it is a DEPLOY pipeline, so a production or certification cutover under SOP/ITSM gates
  is a separate, access-controlled, auditable construct — not an approval stage buried inside a CD pipeline built to run automatically. CD
  and DEPLOY still share one deploy path, so the extraction costs no duplicated deploy logic.
- Continuous Deployment is named apart from Delivery: a unit that auto-rolls to prod is a **CDE**, a unit that leaves prod to a
  human-governed cutover is **CD → DEPLOY**. The promotion posture is stated, not inferred from whether a stage happens to be automated —
  and CDE reuses the one CI engine and the one deploy path, so it too costs no forked build or deploy logic.
- CI and CD stay coherent because they are the same engine plus or minus a deploy — there is one definition of "build and verify," used
  twice.
- The pre-commit gate stays fast (5–10 min) because slow system-level tests have a named home: the CD post-commit deploy path.
- Self-service is preserved but relocated: INPUT pipelines give users a form, and the form's output is a reviewable git diff, not an
  unreviewed runtime mutation of the cloud.
- One decision is deliberately left open: whether INPUT pipelines land their commit via PR or directly. The invariant (input → commit → CD)
  holds regardless; the choice is recorded here so it is made on purpose, not by default.

## Related

- [ci-discipline-and-promotion-flow](../design/ci-discipline-and-promotion-flow.md) — the design layer above this taxonomy: CI as a
  discipline, and how CI / CD / CDE / DEPLOY key together into a promotion flow via the tagged artifact.
- [pipeline-runner-pattern](pipeline-runner-pattern.md) — how all six invoke PowerShell.
- [custom-template-discipline](custom-template-discipline.md) — YAML carries ADO concerns only.
- [pipeline-detection](pipeline-detection.md), [pipeline-variables](pipeline-variables.md), [dual-authentication](dual-authentication.md) —
  mechanics every type relies on.
- [durable-sha-globs](durable-sha-globs.md) — the trigger files every unit-scoped trigger registers on.
- [test-automation](../automation/test-automation.md) — the L2/L3 tiers the CI engine runs.
- Notes: [shared-fate-ci](../../notes/shared-fate-ci.md), [ado-as-self-service-layer](../../notes/ado-as-self-service-layer.md),
  [one-config-to-rule-them-all](../../notes/one-config-to-rule-them-all.md),
  [classic-cmdb-vs-version-controlled-change](../../notes/classic-cmdb-vs-version-controlled-change.md).

## Dora explains:

DORA's research distinguishes Continuous Delivery (human-gated production changes) from Continuous Deployment (automated prod roll), and
links explicit deployment governance to faster cycle times and lower failure rates. This ADR's taxonomy makes these distinctions explicit
and nameable, preventing anti-patterns from hiding behind overloaded terminology and enabling each pipeline type to carry its proper
governance contract and trigger model.

- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — CD pattern with explicit build-once-deploy-many and
  human-gated production.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — DEPLOY and CDE have named, first-class deployment
  constructs.
- [Trunk-based development](https://dora.dev/capabilities/trunk-based-development/) — CI/CD both run post-commit on master, the single
  source of truth.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
