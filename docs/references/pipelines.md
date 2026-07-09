# pipelines

Azure DevOps pipelines and the templates they include. Two ADRs govern this folder:

- [pipeline-types](../adr/flow/pipeline-types.md) — the four types of pipeline.
- [pipeline-naming-and-placement](../adr/pipelines/pipeline-naming-and-placement.md) — the layout and naming rules below.

## Layout

```text
pipelines/
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
[custom-template-discipline](../adr/pipelines/custom-template-discipline.md).

## The six types

| Type   | What it is                                                                                                                       | Trigger / Deploy Targets in Scope                             |
| ------ | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------- |
| INPUT  | Self-service input turned into a commit                                                                                          | Manual, with parameters                                       |
| CRON   | Automation job on a timer (not really a pipeline, can direct-affect live/prod)                                                   | `schedules:`                                                  |
| CI     | CI/ci - Continuous _Integration_ - The CI engine alone — build + verify, no artifact, no deploy                                  | PR build validation + post-commit `main` (BVT)                |
| CD     | CD/cd - Continuous _Delivery_ - (CI engine + deploy + system test) (internal deploys for auto-tests + UAT, but not towards prod) | post-commit `main`                                            |
| CDE    | CDE/CDe - Continuous _Deployment_                                                                                                | deployment to prod also, but can be manually gated downstream |
| DEPLOY | The Tail-end of a CD pipeline, detaches the live deploy from CDE pipeline                                                        | to prod but can be manually gated downstream                  |

## Pipelines here

Real:

- `ci-automation.yaml` — pure CI for the automation layer (`Test-Automation`); the CI exemplar.
- `ci-automation-expected-failures.yaml` — proves the CI guardrails fire (steps expected to go amber).

Infrastructure (foundation / discovery / expedition) — **reference shapes**, not yet registered. The CI build path runs as-is
(`az bicep build` is offline, no auth); the CD deploy paths need real service connections and a non-placeholder `azure.yml` (the shipped one
has placeholder subscription GUIDs; the `sc-…` names are illustrative). They wire the templates built in the infra phase
(`out/infra-plan.md`) per the [pipeline-types](../adr/flow/pipeline-types.md) and
[naming-and-placement](../adr/pipelines/pipeline-naming-and-placement.md) ADRs:

- `ci-infrastructure.yaml` — CI engine for all three templates (`Assert-BicepTemplate` + `Build-Bicep`), no deploy. Registered on the
  infrastructure unit's native projection (`infrastructure/**`).
- `cd-shared.yaml` — CD for the shared platform (standalone): `-Shared` build of the configuration-root slots → deploy foundation
  (`nsub`/`psub`) → deploy discovery (`dev`/`test`/`preprod`/`prod`). No expedition (customer-only). Every deploy's target is the service
  connection's session, pinned with `-SubscriptionIdAssertIs`.
- `cd-apex.yaml`, `cd-nova.yaml`, `cd-flux.yaml` — thin per-customer CDs that `extends:` `extends/cd-customer.yaml`, passing the customer
  key + the env/slot/service-connection/assert map. apex has both tiers; nova/flux are dev-only.
- `extends/cd-customer.yaml` — the one shared customer-CD structure: CI build, then foundation → discovery → expedition deploys
  (`${{ each }}` over three flat lists), foundation first (it owns the per-subscription Key Vault).

There are no CRON or INPUT pipelines in the repo yet, and no per-type sample pipelines — the real `ci-*` / `cd-*` pipelines above are the
canonical shapes to copy.

## Adding a real pipeline

1. Create a `<type>-<name>.yaml` pointed at your real deployable unit (copy an existing one like `ci-infrastructure.yaml` or
   `cd-shared.yaml` as a starting point).
2. Set its `trigger:`/`pr:` path filters to the unit's native projection — `(Get-GlobSetTrigger -Name <globset>).AdoInclude`/`.AdoExclude`
   generates the exact `paths:` block from `globs.yml`; the drift gate keeps it honest (see
   [durable-sha-globs](../adr/flow/durable-sha-globs.md#native-projection-the-no-start-trigger) and the
   [add-a-deployable-unit](../how-to/getting-started/automation/add-a-deployable-unit.md) how-to).
3. Set real `ServiceConnection` names and ensure `azure.yml` has real subscription IDs.
4. Register it: `Register-AdoPipeline '<Name>' 'pipelines/<type>-<name>.yaml'`.
5. For CI/CD, set it as the branch's build validation (the pre-commit half): `Register-AdoBuildValidation <globset>` sets the policy's path
   filter to the same native projection.

## Open decision — INPUT: PR vs direct push

How an INPUT pipeline lands its commit (open a PR vs push directly) is **not yet decided** — see
[pipeline-types](../adr/flow/pipeline-types.md). Either way the output is a commit, and deployment happens only via CD against version
control.
