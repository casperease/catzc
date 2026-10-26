# Only PR build validation, the BVT and the failure stop are checked in code

```text
Three rung checks run in code: PR build validation, the BVT and the failure stop; the rest are DRS-only.

1  PR build validation       the inner CI gate before a topic commit merges
2  landed                    the merged commit; an out-of-band topic deploy is not an integration
3  BVT                       discards automatically; checked on main, the built artifact included
4  L3-vertical-AT            automated acceptance testing in an on-demand environment; DRS-only
5  RC on main-AT             the manual gate at main-uat; DRS-only
6  RBC on release-AT         the manual gate at release-uat; DRS-only
7  two-slot activation       stage inactive in pre-prod, then activate live; an actuation, DRS-only
8  failure stops downstream  each Deploy_* stage runs only when the stage before it succeeded

Supports FDR-CD-LIFE-ONESTATEADVANCESONERUNG, FDR-CD-LIFE-DISCARDISTERMINAL, FDR-CD-LIFE-RETIREMENTISNOTDISCARD,
FDR-CD-LIFE-SUPERSESSIONABANDONSOVERTAKEN, FDR-CD-LIFE-ONECOMMITPERENVIRONMENT, FDR-CD-LIFE-SYNCFROMVERIFIEDHEAD,
FDR-CD-LIFE-FAILEDSTAYSUPSTREAM, FDR-CD-LIFE-TOPICDEPLOYSOUTOFBAND, FDR-CD-INNERANDOUTERLOOP, FDR-CD-CDSTAYSINNONPROD,
FDR-CD-TWORELEASEGATES, FDR-CD-TWOENVIRONMENTACTIVATION, ADR-AUTO-TEST-BUILDVERIFICATIONTEST
and DDR-VISUAL-FIXEDCOMMITPALETTE (governance lens).
```

Every rung of the commit ladder has a DRS rule and a gate that decides whether a commit climbs it. Lined up in ladder order, with the commit
state each one grants beside it, the gates split cleanly into those a pipeline in cats actually runs and those that exist only in the
decision records. Three checks exist in code: PR build validation, the BVT, and the stop that keeps a failed stage from reaching the next
one. Every gate from L3 up to production is stated by the decision records and enforced by nothing yet.

```yml drawio
description:
  "The rungs of the commit ladder from a topic commit to production, each with its gate: only PR build validation, the BVT and the failure
  stop are checked in code, and every gate from L3 up to production is stated by the ADRs and enforced by nothing yet."
about:
  adrs:
    - FDR-CD-LIFE-ONESTATEADVANCESONERUNG
    - FDR-CD-LIFE-DISCARDISTERMINAL
    - FDR-CD-LIFE-RETIREMENTISNOTDISCARD
    - FDR-CD-LIFE-SUPERSESSIONABANDONSOVERTAKEN
    - FDR-CD-LIFE-ONECOMMITPERENVIRONMENT
    - FDR-CD-LIFE-SYNCFROMVERIFIEDHEAD
    - FDR-CD-LIFE-FAILEDSTAYSUPSTREAM
    - FDR-CD-LIFE-TOPICDEPLOYSOUTOFBAND
    - FDR-CD-INNERANDOUTERLOOP
    - FDR-CD-CDSTAYSINNONPROD
    - FDR-CD-TWORELEASEGATES
    - FDR-CD-TWOENVIRONMENTACTIVATION
    - ADR-AUTO-TEST-BUILDVERIFICATIONTEST
    - DDR-VISUAL-FIXEDCOMMITPALETTE
  lens: governance
content:
  title: Only PR build validation, the BVT and the failure stop are checked in code
  kind: explanation
  flow: left-to-right
  relation: next rung
  states: true
  theme: dark
  bands:
    - { id: band-all, label: ALL RUNGS }
    - { id: band-ci, label: CI }
    - { id: band-cd, label: CD }
    - { id: band-deploy, label: DEPLOY }
  glyphs:
    - { id: g-failure-stop, kind: gate, label: failure stops downstream, in: band-all }
    - { id: c-discarded, kind: commit, label: discarded, in: band-all, state: discarded }
    - { id: c-topic, kind: commit, label: topic, in: band-ci, state: topic }
    - { id: g-pr-validation, kind: gate, label: PR build validation, in: band-ci }
    - { id: c-landed, kind: commit, label: landed, in: band-ci, state: landed }
    - { id: g-bvt, kind: gate, label: BVT, in: band-ci }
    - { id: c-verified, kind: commit, label: BVT-verified, in: band-ci }
    - { id: a-l3-at, kind: drsonly, label: L3-vertical-AT, in: band-cd }
    - { id: c-l3, kind: commit, label: L3, in: band-cd, state: l3 }
    - { id: a-rc, kind: drsonly, label: RC on main-AT, in: band-cd }
    - { id: c-main-uat, kind: commit, label: main-UAT, in: band-cd, state: main-uat }
    - { id: a-rbc, kind: drsonly, label: RBC on release-AT, in: band-cd }
    - { id: c-release-uat, kind: commit, label: release-UAT, in: band-cd, state: release-uat }
    - { id: a-two-slot, kind: drsonly, label: two-slot activation, in: band-deploy }
    - { id: c-production, kind: commit, label: production, in: band-deploy, state: prod }
  edges:
    - { from: c-topic, to: g-pr-validation, kind: flow, label: "" }
    - { from: g-pr-validation, to: c-landed, kind: flow, label: "" }
    - { from: c-landed, to: g-bvt, kind: flow, label: "" }
    - { from: g-bvt, to: c-verified, kind: flow, label: "" }
    - { from: c-verified, to: a-l3-at, kind: adr, label: "" }
    - { from: a-l3-at, to: c-l3, kind: adr, label: "" }
    - { from: c-l3, to: a-rc, kind: adr, label: "" }
    - { from: a-rc, to: c-main-uat, kind: adr, label: "" }
    - { from: c-main-uat, to: a-rbc, kind: adr, label: "" }
    - { from: a-rbc, to: c-release-uat, kind: adr, label: "" }
    - { from: c-release-uat, to: a-two-slot, kind: adr, label: "" }
    - { from: a-two-slot, to: c-production, kind: adr, label: "" }
    - { from: g-bvt, to: g-failure-stop, kind: fail, label: "" }
    - { from: g-failure-stop, to: c-discarded, kind: fail, label: "" }
  markers:
    - { at: g-pr-validation, number: 1 }
    - { at: c-landed, number: 2 }
    - { at: g-bvt, number: 3 }
    - { at: a-l3-at, number: 4 }
    - { at: a-rc, number: 5 }
    - { at: a-rbc, number: 6 }
    - { at: a-two-slot, number: 7 }
    - { at: g-failure-stop, number: 8 }
  chips:
    - { at: c-topic, kind: rule, rule: FDR-CD-LIFE-ONESTATEADVANCESONERUNG, gated: false }
    - { at: g-pr-validation, kind: rule, rule: FDR-CD-INNERANDOUTERLOOP, corner: bottom-right }
    - { at: c-landed, kind: rule, rule: FDR-CD-LIFE-TOPICDEPLOYSOUTOFBAND, gated: false, corner: bottom-right }
    - { at: g-bvt, kind: rule, rule: ADR-AUTO-TEST-BUILDVERIFICATIONTEST, corner: bottom-right }
    - { at: a-l3-at, kind: rule, rule: FDR-CD-CDSTAYSINNONPROD, gated: false, corner: bottom-right }
    - { at: c-main-uat, kind: rule, rule: FDR-CD-LIFE-SYNCFROMVERIFIEDHEAD, gated: false }
    - { at: a-rc, kind: rule, rule: FDR-CD-TWORELEASEGATES, gated: false, corner: bottom-right }
    - { at: a-rbc, kind: rule, rule: FDR-CD-TWORELEASEGATES, gated: false, corner: bottom-right }
    - { at: a-rbc, kind: rule, rule: FDR-CD-LIFE-DISCARDISTERMINAL, gated: false, corner: bottom-left }
    - { at: a-two-slot, kind: rule, rule: FDR-CD-TWOENVIRONMENTACTIVATION, gated: false, corner: bottom-right }
    - { at: c-production, kind: rule, rule: FDR-CD-LIFE-RETIREMENTISNOTDISCARD, gated: false }
    - { at: g-failure-stop, kind: rule, rule: FDR-CD-LIFE-FAILEDSTAYSUPSTREAM, corner: bottom-right }
  legend: auto
  minimaps: [code-locations, grid, axis]
layout:
  band-all: { x: 20, y: 114, w: 1260, h: 124 }
  band-ci: { x: 20, y: 254, w: 1260, h: 124 }
  band-cd: { x: 20, y: 394, w: 1260, h: 124 }
  band-deploy: { x: 20, y: 534, w: 1260, h: 124 }
  g-failure-stop: { x: 400, y: 154, w: 220, h: 72 }
  c-discarded: { x: 690, y: 168, w: 110, h: 44 }
  c-topic: { x: 30, y: 308, w: 80, h: 44 }
  g-pr-validation: { x: 140, y: 296, w: 140, h: 68 }
  c-landed: { x: 310, y: 308, w: 80, h: 44 }
  g-bvt: { x: 420, y: 296, w: 90, h: 68 }
  c-verified: { x: 540, y: 308, w: 130, h: 44 }
  a-l3-at: { x: 530, y: 448, w: 120, h: 44 }
  c-l3: { x: 665, y: 448, w: 60, h: 44 }
  a-rc: { x: 740, y: 448, w: 120, h: 44 }
  c-main-uat: { x: 875, y: 448, w: 80, h: 44 }
  a-rbc: { x: 970, y: 448, w: 120, h: 44 }
  c-release-uat: { x: 1105, y: 448, w: 100, h: 44 }
  a-two-slot: { x: 960, y: 588, w: 170, h: 44 }
  c-production: { x: 1150, y: 588, w: 100, h: 44 }
```

![Only PR build validation, the BVT and the failure stop are checked in code](.assets/which-rung-gates-exist-in-code.drawio.png)

## Walkthrough

1. **PR build validation.** The inner CI gate runs before a topic commit may merge. Every CI and CD pipeline runs on pull requests to
   `main`, and `build-validation.yml` binds six globsets (automation, infrastructure, shared, nova, apex, flux) as build validations on
   `main`, blocking by default.
2. **Landed.** The merged commit is grey. Its rule says an out-of-band deploy of a topic commit is not an integration; the CD deploys in
   code run only on `refs/heads/main`, so no out-of-band topic deploy path exists to check.
3. **BVT.** The BVT discards automatically. `ci-pwsh` runs `Test-Automation -Level 2 -EnforceTimings` and, on main, `Test-BuildArtifact`,
   the built-artifact check the FDR makes part of the BVT; `ci-infrastructure` runs `Test-Automation -Suite infrastructure`.
4. **L3-vertical-AT.** The automated acceptance testing in an on-demand environment discards automatically when it fails. No pipeline runs
   it.
5. **RC on main-AT.** The manual gate at `main-uat` certifies its occupant, the commit that was the BVT-verified head when it went in, which
   is the stable point upstream integrators sync from.
6. **RBC on release-AT.** The manual gate at `release-uat` discards a commit by hand when it rejects it.
7. **Two-slot activation.** DEPLOY-Prod stages the artifact inactive in `pre-prod`, then activates it live. It is an actuation, not a gate,
   and the production occupant it replaces retires rather than being discarded.
8. **Failure stops downstream.** The one cross-rung rule that code checks: each CD `Deploy_*` stage depends on the stage before it and runs
   only when that stage succeeded. It holds between template stages, not between environment rungs, and nothing records the stopped commit
   as discarded.

## Why it holds

- A commit holds one state at a time and only climbs; a new attempt is a new commit (FDR-CD-LIFE-ONESTATEADVANCESONERUNG).
- Discard is rejection at a named stage: BVT and L3 discard automatically, `release-uat` by hand at RBC (FDR-CD-LIFE-DISCARDISTERMINAL).
- Retirement is a successful end of life, never a discard (FDR-CD-LIFE-RETIREMENTISNOTDISCARD).
- Supersession abandons a still-valid commit without rejecting it, so no gate decides it (FDR-CD-LIFE-SUPERSESSIONABANDONSOVERTAKEN).
- Each always-on environment holds one occupant, and no gate checks it (FDR-CD-LIFE-ONECOMMITPERENVIRONMENT).
- The BVT-verified server head is the stable integration point, and the same commit goes into `main-uat` first
  (FDR-CD-LIFE-SYNCFROMVERIFIEDHEAD).
- A commit that fails a stage cannot go downstream (FDR-CD-LIFE-FAILEDSTAYSUPSTREAM).
- An out-of-band deploy of a topic commit is not an integration (FDR-CD-LIFE-TOPICDEPLOYSOUTOFBAND).
- PR build validation is the inner CI gate (FDR-CD-INNERANDOUTERLOOP); L3 runs in CD (FDR-CD-CDSTAYSINNONPROD); RC and RBC are the manual
  gates (FDR-CD-TWORELEASEGATES); deploy-to-prod is a two-environment activation (FDR-CD-TWOENVIRONMENTACTIVATION).
- The BVT includes the built-artifact checks of `Test-BuildArtifact` (ADR-AUTO-TEST-BUILDVERIFICATIONTEST).
- The commit colours are the locked palette (DDR-VISUAL-FIXEDCOMMITPALETTE).

## Where the code and the decision record differ

- No pipeline runs L3, and no RC or RBC gate, no inactive staging in `pre-prod`, and no out-of-band topic deploy path exists.
- The failure stop holds only between template stages, and no code records a discard.

## See also

- [The commit lifecycle](../../drs/flow/commit-lifecycle.md) — the decision this article explains.
- [The CI discipline and the promotion flow](../../drs/flow/cd-discipline-and-promotion-flow.md) ·
  [Test automation](../../drs/automation/test-automation.md) · [Visual design](../../drs/design/visual-design.md)
- The other lenses on the same lifecycle: [meta](one-way-climb-three-endings.md), [architecture](four-domains-promote-one-artifact.md),
  [implementation](code-wires-only-the-first-rungs.md) and [operations](engineer-merges-pipelines-do-the-rest.md).
- [The design explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
