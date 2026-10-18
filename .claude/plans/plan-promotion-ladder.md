---
plan:
  status: active
  value: high
  reviewed: 2026-10-18
  blocked_on: nothing; Q1 to Q4 decided 2026-10-18
  targets: [pipelines, docs/adr/design/commit-lifecycle.md, docs/adr/flow/cd-discipline-and-promotion-flow.md]
---

# The promotion ladder: from one CD run to main-uat, release-uat, pre-prod and DEPLOY

ADR-DSGN-LIFE and ADR-FLOW-CD describe a ladder a commit climbs one rung at a time: main-uat, then release-uat behind an RC (release
candidate) gate, then pre-prod staging behind an RBC gate, then production through a separate DEPLOY pipeline. The CD pipelines today deploy
a stage's non-prod and prod-tier targets in one run (`nsub` and `psub`, apex's `dev` and `prod`). The prod-tier environments now carry an
approval check (`Sync-AdoEnvironmentApprovals`, plan-explanation-drift-gaps Q3), which stops an unattended prod deploy; this plan builds the
rest of the ladder.

## Why its value is high

Until the ladder exists the ADRs' promotion rules are prose: no environment holds an occupant, nothing certifies RC or RBC, and pre-prod
staging and the DEPLOY pipeline have no code. Every explanation article on the lifecycle carries those gaps.

## Decided (2026-10-18, the user took every recommendation)

- Q1 main-uat: a new ADO environment per unit (e.g. `shared-main-uat`); each rung its own environment and occupant.
- Q2 RC and RBC: an approval check on the next environment, declared in config and applied by `Sync-AdoEnvironmentApprovals`.
- Q3 pre-prod: a staging slot in the prod subscription, inactive until activated; no new subscription.
- Q4 DEPLOY: takes the exact artifact CI built, by run id (immutable, never rebuilt); the CD run that certified it records the run id.

## Open steps

- [ ] The decisions as rules: ADR-DSGN-LIFE (`docs/adr/design/commit-lifecycle.md`) and ADR-FLOW-CD
      (`docs/adr/flow/cd-discipline-and-promotion-flow.md`) state Q1 to Q4, present tense, keeping today's rule numbers (ADR-REPO-PLANS#9)
      (check: Test-AdrRegistry and Test-Links clean on both).
- [ ] `pipelines/README.md`: name the ladder's environments and the pipeline that deploys each, as decided (check: Test-Links passes and
      Test-Pipelines passes; task-loose-ends step 5).
- [ ] The environments: the main-uat and release-uat environments per unit and their RC/RBC approval checks as config entries applied by
      `Sync-AdoEnvironmentApprovals` (check: its L0 tests pass; the apply itself is the user's run).
- [ ] Pre-prod: the staging slot in the prod subscription, declared in the azure config and inactive until activated (check: the
      resolver's L0 tests pass; Test-Contracts clean).
- [ ] The DEPLOY pipeline: takes a CI run id, resolves that run's artifact, deploys it to prod; the certifying CD run records the run id
      (check: Test-Pipelines and the pipeline contract check clean; the first real run is the user's).

## Open questions

- Q1. Where does main-uat live: a new ADO environment per unit (e.g. `shared-main-uat`), or the existing `nsub` targets renamed?
- Q2. What certifies RC and RBC: an ADO approval on the next environment, a manual DEPLOY-pipeline parameter, or a tag on the artifact?
- Q3. Is pre-prod a new environment and subscription, or a staging slot in the prod subscription that stays inactive until activated?
- Q4. Does DEPLOY take the artifact CI built (by run id or tag), and which pipeline kind owns the tag?

## Refs

- docs/adr/design/commit-lifecycle.md (ADR-DSGN-LIFE) and docs/adr/flow/cd-discipline-and-promotion-flow.md (ADR-FLOW-CD).
- The lifecycle articles under docs/explanation/design/ and docs/explanation/flow/ hold each gap in the reader's words.
