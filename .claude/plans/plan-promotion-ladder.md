---
plan:
  status: active
  value: high
  reviewed: 2026-10-19
  waits_on: nothing; both steps are takeable
  targets: [.ado/pipelines, pwsh, docs/adr/design/commit-lifecycle.md, docs/adr/flow/cd-discipline-and-promotion-flow.md]
---

# The promotion ladder: from one CD run to main-uat, release-uat, pre-prod and DEPLOY

ADR-DSGN-LIFE and ADR-FLOW-CD describe a ladder a commit climbs one rung at a time: main-uat, then release-uat behind an RC gate, then
pre-prod staging behind an RBC gate, then production through a separate DEPLOY pipeline. Open: the main-uat environment name and the
certifying record.

## Why its value is high

Without its own environment name main-uat is not a rung in the code, and without the certifying check a DEPLOY run can ship a commit that
never stood on pre-prod.

## Decided (2026-10-18; the orchestrator on the user's delegation where noted)

- The rungs map to the environments: main-uat = dev, release-uat = test, pre-prod = preprod, prod = prod.
- flux waits for a workload, so it has no DEPLOY pipeline.
- The certifying record is the ADO environment's deployment history (the user, 2026-10-19): no `certified-<rung>` tag; a DEPLOY run checks
  that the commit deployed to `<unit>-pre-prod` through that history, and the ADR rule names this as the ado realisation of ADR-FLOW-CD's
  gate.
- The main-uat remap is a one-line edit on `RungsConfig.DefaultRungs` (ADR-FLOW-CD-RUNGSREGISTRY), and `<unit>-<rung>` derives from it.

## Open steps

- [ ] main-uat is `dev`: rename each unit's `<unit>-dev` ADO environment to `<unit>-main-uat` in the deploy lists and the ladder docs, so
      the rung has its own environment name, derived from the registry above (check: Test-Pipelines clean).
- [ ] The certifying check: the DEPLOY pipelines of shared, apex and nova read the `<unit>-pre-prod` environment's deployment history for
      the commit before deploying, and the rule in `docs/adr/flow/cd-discipline-and-promotion-flow.md` names the history as the record
      (check: Test-Pipelines and the ADR checks clean; a test of the check stops a commit absent from the pre-prod history).

## Refs

- docs/adr/design/commit-lifecycle.md (ADR-DSGN-LIFE) and docs/adr/flow/cd-discipline-and-promotion-flow.md (ADR-FLOW-CD).
- The lifecycle articles under docs/explanation/design/ and docs/explanation/flow/ hold each gap in the reader's words.
- `plan-diagram-engine` moves `commit-lifecycle.md` to `docs/adr/flow/`; the `targets` above re-point when it lands.
