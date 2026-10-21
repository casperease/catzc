# ado pipelines

The azure devops pipelines under `.ado/pipelines/` and the templates they include. Two ADRs govern this folder:

- [pipeline-types](../../drs/flow/pipeline-types.md) — the four types of pipeline.
- [pipeline-naming-and-placement](../../drs/ado/pipeline-naming-and-placement.md) — the layout and naming rules below.

## Layout

```text
.ado/pipelines/
  Invoke-AdoScript.ps1   # the runner (see pipeline-runner-pattern)
  <type>-<name>.yaml     # pipelines (flat in root; type ∈ cron|ci|cd|input)
  steps/     *.yaml      # step templates
  jobs/      *.yaml      # job templates
  stages/    *.yaml      # stage templates
  variables/ *.yaml      # variable templates
  extends/   *.yaml      # whole-pipeline (extends) templates — e.g. shared customer CD
```

Pipelines are flat in the root and named for their type. Templates live in the folder for their ADO kind
(`steps`/`jobs`/`stages`/`variables` are fragments; `extends` is a whole-pipeline template a thin pipeline extends). Executable YAML is
`.yaml`; config/data our code reads is `.yml`. Templates are the exception, not the default — see
[custom-template-discipline](../../drs/ado/custom-template-discipline.md).

## The six types

| Type   | What it is                                                                                                                       | Trigger / Deploy Targets in Scope                                     |
| ------ | -------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------- |
| INPUT  | Self-service input turned into a commit                                                                                          | Manual, with parameters                                               |
| CRON   | Automation job on a timer (not really a pipeline, can direct-affect live/prod)                                                   | `schedules:`                                                          |
| CI     | CI/ci - Continuous _Integration_ - The CI engine alone — build + verify, no artifact, no deploy                                  | PR build validation + post-commit `main` (BVT)                        |
| CD     | CD/cd - Continuous _Delivery_ - (CI engine + deploy + system test) (internal deploys for auto-tests + UAT, but not towards prod) | post-commit `main`                                                    |
| CDE    | CDE/CDe - Continuous _Deployment_                                                                                                | deployment to prod also, but can wait behind a manual gate downstream |
| DEPLOY | The Tail-end of a CD pipeline, detaches the live deploy from CDE pipeline                                                        | to prod but can wait behind a manual gate downstream                  |

## Pipelines here

Real:

- `ci-pwsh.yaml` — pure CI for the pwsh modules (`Test-Automation`); the CI exemplar.
- `ci-pwsh-expected-failures.yaml` — proves the CI guardrails fire (steps expected to go amber).

Infrastructure (foundation / discovery / expedition) — **reference shapes**, not yet registered. The CI build path runs as-is
(`az bicep build` is offline, no auth); the CD deploy paths need real service connections and a non-placeholder `azure.yml` (the shipped one
has placeholder subscription GUIDs; the `sc-…` names are illustrative). They wire the templates that the infra plan (`out/infra-plan.md`)
built, per the [pipeline-types](../../drs/flow/pipeline-types.md) and [naming-and-placement](../../drs/ado/pipeline-naming-and-placement.md)
ADRs:

- `ci-infrastructure.yaml` — CI engine for all three templates (`Assert-BicepTemplate` + `Build-Bicep`), no deploy. Registered on the
  infrastructure unit's native projection (`infrastructure/**`).
- `cd-shared.yaml` — CD for the shared platform (standalone): `-Shared` build of the configuration-root slots → deploy foundation
  (`nsub`/`psub`) → deploy discovery, the landing-zone hubs (`nsub`/`psub`) → deploy expedition (`dev`/`test`). Every deploy's target is the
  service connection's session, pinned with `-SubscriptionIdAssertIs`.
- `cd-apex.yaml`, `cd-nova.yaml`, `cd-flux.yaml` — thin per-customer CDs that `extends:` `extends/cd-customer.yaml`, passing the customer
  key + the env/slot/service-connection/assert map, exactly the configs that exist: apex deploys foundation and discovery at `nsub`/`psub`
  and expedition at `dev`, `dev-blu`, `prod`; nova deploys `nsub` and expedition `dev`; flux deploys `nsub` and no expedition.
- `extends/cd-customer.yaml` — the one shared customer-CD structure: CI build, then foundation → discovery → expedition deploys
  (`${{ each }}` over three flat lists), foundation first (it owns the per-subscription Key Vault). foundation and discovery deploy per
  subscription (`nsub`/`psub`); an expedition entry is an environment with an optional slot, and an empty expedition list skips its build
  and stage. Adding a spoke runs hub → spoke → hub again across `cd-shared` and the customer CD, by hand
  ([landing-zones](../../drs/azure/landing-zones.md)).
- `stages/deploy-unit.yaml` — the one deploy path of a unit (foundation → discovery → expedition), called by its CD and by its DEPLOY, so
  the two never fork; the artifact comes from the current run (CD) or from the certifying CD run by its id (DEPLOY).
- `deploy-shared.yaml`, `deploy-apex.yaml`, `deploy-nova.yaml` — DEPLOY, run by hand with the run id of the certifying CD run. Target
  `release-uat` rolls the artifact onto `test` (all three); apex's target `prod` stages it in pre-prod (`preprod`) and then activates it to
  `prod`. Each job waits on its environment's approval check. flux has no DEPLOY until it has an expedition.

There are no CRON or INPUT pipelines in the repo yet, and no per-type sample pipelines — the real `ci-*` / `cd-*` pipelines above are the
canonical shapes to copy.

## The promotion ladder

A commit climbs one rung at a time ([commit-lifecycle](../../drs/flow/commit-lifecycle.md),
[cd-discipline-and-promotion-flow](../../drs/flow/cd-discipline-and-promotion-flow.md)). Each always-on rung is its own Azure DevOps
environment per deployable-unit, with one occupant:

| Rung        | Environment                                          | Deployed by                     | Gate before it                             |
| ----------- | ---------------------------------------------------- | ------------------------------- | ------------------------------------------ |
| main-uat    | `<unit>-main-uat`                                    | the unit's CD (`cd-<unit>`)     | the CD's CI component and L3 run           |
| release-uat | `<unit>-release-uat`                                 | DEPLOY                          | RC: an approval check on this environment  |
| pre-prod    | `<unit>-pre-prod`, a staging slot in the prod sub    | DEPLOY                          | RBC: an approval check on this environment |
| production  | the prod-tier environments (`*-psub`, apex's `prod`) | DEPLOY, activating the pre-prod | the prod approval gate                     |

The approval checks are declared in `environment-approvals.yml` and applied by `Sync-AdoEnvironmentApprovals`
([apply-environment-approvals](../../how-to/automation/apply-environment-approvals.md)). DEPLOY takes the exact artifact CI built, by the CI
run id that the certifying CD run records, and never rebuilds it. The CD pipelines above deploy the non-prod and prod-tier targets of a
stage in one run; main-uat is the `dev` deploy of each CD, into the `<unit>-main-uat` environment.

## Adding a real pipeline

1. Create a `<type>-<name>.yaml` pointed at your real deployable unit (copy an existing one like `ci-infrastructure.yaml` or
   `cd-shared.yaml` as a starting point).
2. Set its `trigger:`/`pr:` path filters to the unit's native projection — `(Get-GlobSetTrigger -Name <globset>).AdoInclude`/`.AdoExclude`
   generates the exact `paths:` block from `globs.yml`; the drift quality gate keeps it honest (see
   [durable-sha-globs](../../drs/flow/durable-sha-globs.md#native-projection-the-no-start-trigger) and the
   [add-a-deployable-unit](../../how-to/getting-started/automation/add-a-deployable-unit.md) how-to).
3. Set real `ServiceConnection` names and ensure `azure.yml` has real subscription IDs.
4. Register it: `Register-AdoPipeline '<Name>' '.ado/pipelines/<type>-<name>.yaml'`.
5. For CI/CD, set it as the branch's build validation (the pre-commit half): `Register-AdoBuildValidation <globset>` sets the policy's path
   filter to the same native projection.

## INPUT: PR or direct push

`Open decision — INPUT: PR vs direct push`

How an INPUT pipeline lands its commit (open a PR vs push directly) is **not yet decided** — see
[pipeline-types](../../drs/flow/pipeline-types.md). Either way the output is a commit, and deployment happens only via CD against version
control.
