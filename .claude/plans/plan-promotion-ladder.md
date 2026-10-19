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
slot (ADR-AZ-DATAMOD-STAGINGSLOT), the one deploy path (ADR-FLOW-CD-TYPE-ONEDEPLOYPATH, `.ado/pipelines/stages/deploy-unit.yaml`) and the
DEPLOY pipelines of shared, apex and nova are in the tree. Left: the main-uat environment name and the certifying record.

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

- The rungs registry landed (ADR-FLOW-CD-RUNGSREGISTRY): the ladder is declared once on `RungsConfig.DefaultRungs`, so the main-uat remap is
  a one-line edit there; `<unit>-<rung>` is derived for the rc and rbc rungs, and the prod tier stays explicit in
  `environment-approvals.yml` (ADO names it by deploy target, psub or prod).

## Open steps

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
- `plan-diagram-engine` moves `commit-lifecycle.md` to `docs/adr/flow/`; the `targets` above re-point when it lands.
