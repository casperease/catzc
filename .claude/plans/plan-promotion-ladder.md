---
plan:
  status: active
  value: high
  reviewed: 2026-10-19
  waits_on:
    the rename and the certifying check wait on the user's CD proof run (task-user-runs-and-commits step 2); the registry step is takeable
  targets: [.ado/pipelines, pwsh, docs/adr/design/commit-lifecycle.md, docs/adr/flow/cd-discipline-and-promotion-flow.md]
---

# The promotion ladder: from one CD run to main-uat, release-uat, pre-prod and DEPLOY

ADR-DSGN-LIFE and ADR-FLOW-CD describe a ladder a commit climbs one rung at a time: main-uat, then release-uat behind an RC gate, then
pre-prod staging behind an RBC gate, then production through a separate DEPLOY pipeline. The rules, the approval environments, the staging
slot (ADR-AZ-DATAMOD-STAGINGSLOT), the one deploy path (ADR-FLOW-CD-TYPE-ONEDEPLOYPATH, `pipelines/stages/deploy-unit.yaml`) and the DEPLOY
pipelines of shared, apex and nova are in the tree. Left: the main-uat environment name and the certifying record.

## Why its value is high

Until the ladder runs, the ADRs' promotion rules are proven by no real run, and every explanation article on the lifecycle carries the gap.

## Decided (2026-10-18; the orchestrator on the user's delegation where noted)

- The rungs map to the environments: main-uat = dev, release-uat = test, pre-prod = preprod, prod = prod.
- The approval apply's `environments` list is the checked list: `<unit>-release-uat` (RC) and `<unit>-pre-prod` (RBC) for all four units,
  approved by the same group; the apply creates a missing environment (reported Created, skipped under -DryRun); main-uat needs no entry, a
  unit's CD creates it on its first deploy (delegated).
- `approver_group.members` holds the simulated `prod-approver@example.com`, at the user's word; a live apply needs a real approver listed.
- flux waits for a workload, so it has no DEPLOY pipeline.
- The certifying record is the ADO environment's deployment history (the user, 2026-10-19): no `certified-<rung>` tag; a DEPLOY run checks
  that the commit deployed to `<unit>-pre-prod` through that history, and the ADR rule names this as the ado realisation of ADR-FLOW-CD's
  gate.

## Open steps

- [x] Declare the rungs registry (`Catzc.Base.Flow`: `rungs.yml`, `RungsConfig` with the ladder on `DefaultRungs`, `Rung`, `Get-Rung`), read
      by `Catzc.Azure.DevOps` (rule ADR-FLOW-CD-RUNGSREGISTRY) — verdict: a fresh full import loads; `Get-Config -Config rungs` is
      `RungsConfig` (main-uat=dev/none, release-uat=test/rc, pre-prod=preprod/rbc, prod=prod/prod-approval);
      `EnvironmentApprovalsConfig.Environments(rungs)` gives the same 11 names, in the same order, as the old hand list; `Invoke-TestFile`
      Passed for RungsConfig, Get-Rung, EnvironmentApprovalsConfig and Sync-AdoEnvironmentApprovals; Test-ModuleDependency adds no issue
      (its 2 issues, Execution -> python and Timeouts -> bash, are not this step's).
- Decided for step 1 by the orchestrator on the user's delegation, 2026-10-19 (designed by catzc-08):
  - The ladder is declared once, on `RungsConfig.DefaultRungs`; `rungs.yml` is comment-only, so step 2's main-uat remap is a one-line edit
    there.
  - Each rung names the gate that guards its entry: none, rc, rbc or prod-approval.
  - `environment-approvals.yml` lists `units` and `prod_environments`, and `<unit>-<rung>` is derived for the rc and rbc rungs. The prod
    tier stays explicit, because ADO names it by deploy target (psub, prod), not by rung; deriving `<unit>-prod` would create three new ADO
    environments.
- [ ] main-uat is `dev`: rename each unit's `<unit>-dev` ADO environment to `<unit>-main-uat` in the deploy lists and the ladder docs, so
      the rung has its own environment name, derived from the registry above (check: Test-Pipelines clean; the rename in Azure DevOps itself
      is the user's).
- [ ] The certifying check: the DEPLOY pipelines of shared, apex and nova read the `<unit>-pre-prod` environment's deployment history for
      the commit before deploying, and the rule in `docs/adr/flow/cd-discipline-and-promotion-flow.md` names the history as the record
      (check: Test-Pipelines and Test-Adr clean; a DEPLOY run of a commit never deployed to pre-prod stops at that check on the user's proof
      run).

## Refs

- docs/adr/design/commit-lifecycle.md (ADR-DSGN-LIFE) and docs/adr/flow/cd-discipline-and-promotion-flow.md (ADR-FLOW-CD).
- The lifecycle articles under docs/explanation/design/ and docs/explanation/flow/ hold each gap in the reader's words.
- Two other plans move this plan's targets: `plan-ado-and-cicd-docs` moves `pipelines/` to `.ado/pipelines/`, and `plan-diagram-engine`
  moves `commit-lifecycle.md` to `docs/adr/flow/`; the `targets` above re-point when either lands.
