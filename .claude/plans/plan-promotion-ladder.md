---
plan:
  status: active
  value: high
  reviewed: 2026-10-18
  targets: [pipelines, docs/adr/design/commit-lifecycle.md, docs/adr/flow/cd-discipline-and-promotion-flow.md]
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

## Open steps

- [ ] main-uat is `dev`: rename each unit's `<unit>-dev` ADO environment to `<unit>-main-uat` in the deploy lists and the ladder docs, so
      the rung has its own environment name (check: Test-Pipelines clean; the rename in Azure DevOps itself is the user's).
- [ ] The certifying record: no `certified-<rung>` build tag for now, since ADO records the deploying run in each environment's history;
      revisit after the user's CD proof run (plan-explanation-drift-gaps) (check: the plan names the record DEPLOY reads).

## Refs

- docs/adr/design/commit-lifecycle.md (ADR-DSGN-LIFE) and docs/adr/flow/cd-discipline-and-promotion-flow.md (ADR-FLOW-CD).
- The lifecycle articles under docs/explanation/design/ and docs/explanation/flow/ hold each gap in the reader's words.
