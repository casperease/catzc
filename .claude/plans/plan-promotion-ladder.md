---
plan:
  status: blocked
  value: high
  reviewed: 2026-10-18
  blocked_on: the open questions below; each shapes the pipelines before any YAML changes
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

## Open steps

- [ ] `pipelines/README.md`: name the ladder's environments and the pipeline that deploys each, as the answers below decide (check:
      Test-Links passes and the README matches the decisions).

## Open questions

- Q1. Where does main-uat live: a new ADO environment per unit (e.g. `shared-main-uat`), or the existing `nsub` targets renamed?
- Q2. What certifies RC and RBC: an ADO approval on the next environment, a manual DEPLOY-pipeline parameter, or a tag on the artifact?
- Q3. Is pre-prod a new environment and subscription, or a staging slot in the prod subscription that stays inactive until activated?
- Q4. Does DEPLOY take the artifact CI built (by run id or tag), and which pipeline kind owns the tag?

## Refs

- docs/adr/design/commit-lifecycle.md (ADR-DSGN-LIFE) and docs/adr/flow/cd-discipline-and-promotion-flow.md (ADR-FLOW-CD).
- The lifecycle articles under docs/explanation/design/ and docs/explanation/flow/ hold each gap in the reader's words.
