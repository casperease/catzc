---
catzc:
  derived:
    path: docs/explanation/design/which-rung-gates-exist-in-code.md
    kind: explanation
    body_sha: "086277112b92"
    adrs:
      - ADR-AUTO-TEST#24
      - ADR-DSGN-LIFE#{1-6,8,9}
      - ADR-DSGN-VISUAL#4
      - ADR-FLOW-CD#{5,8,9,12}
    links:
      - docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.drawio.md
      - docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.drawio.png
      - docs/adr/automation/test-automation.md
      - docs/adr/design/commit-lifecycle.md
      - docs/adr/design/visual-design.md
      - docs/adr/flow/cd-discipline-and-promotion-flow.md
      - docs/explanation/design/code-wires-only-the-first-rungs.md
      - docs/explanation/design/engineer-merges-pipelines-do-the-rest.md
      - docs/explanation/design/four-domains-promote-one-artifact.md
      - docs/explanation/design/index.md
      - docs/explanation/design/one-way-climb-three-endings.md
      - docs/explanation/index.md#how-to-read-the-diagrams
---

# Only PR build validation, the BVT and the failure stop are checked in code

```text
Three rung checks run in code: PR build validation, the BVT and the failure stop; the rest are ADR-only.

1  PR build validation       the inner CI gate before a topic commit merges
2  landed                    the merged commit; an out-of-band topic deploy is not an integration
3  BVT                       discards automatically; checked in part
4  L3-vertical-AT            automated acceptance testing in an on-demand environment; ADR-only
5  RC on main-AT             the manual gate at main-uat; ADR-only
6  RBC on release-AT         the manual gate at release-uat; ADR-only
7  two-slot activation       stage inactive in pre-prod, then activate live; an actuation, ADR-only
8  failure stops downstream  each Deploy_* stage runs only when the stage before it succeeded

Supports ADR-DSGN-LIFE#1, #2, #3, #4, #5, #6, #8 and #9 (governance lens).
```

Every rung of the commit ladder has an ADR rule and a gate that decides whether a commit climbs it. Lined up in ladder order, with the
commit state each one grants beside it, the gates split cleanly into those a pipeline in cats actually runs and those that exist only in the
ADRs. Three checks exist in code: PR build validation, the BVT, and the stop that keeps a failed stage from reaching the next one. Every
gate from L3 up to production is stated by the ADRs and enforced by nothing yet.

![Only PR build validation, the BVT and the failure stop are checked in code](../../.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.drawio.png)

The diagram is described element by element in
[its asset description](../../.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.drawio.md).

## Walkthrough

1. **PR build validation.** The inner CI gate runs before a topic commit may merge. Every CI and CD pipeline runs on pull requests to
   `main`, and `build-validation.yml` binds six globsets (automation, infrastructure, shared, nova, apex, flux) as build validations on
   `main`, blocking by default.
2. **Landed.** The merged commit is grey. Its rule says an out-of-band deploy of a topic commit is not an integration; the CD deploys in
   code run only on `refs/heads/main`, so no out-of-band topic deploy path exists to check.
3. **BVT.** The BVT discards automatically. It is checked in part: `ci-automation` runs `Test-Automation -Level 2 -EnforceTimings` and
   `ci-infrastructure` runs `Test-Automation -Suite infrastructure`, but no pipeline runs `Test-BuildArtifact`, which the ADR makes part of
   the BVT.
4. **L3-vertical-AT.** The automated acceptance testing in an on-demand environment discards automatically when it fails. No pipeline runs
   it.
5. **RC on main-AT.** The manual gate at `main-uat` certifies its occupant, the stable point upstream integrators sync from.
6. **RBC on release-AT.** The manual gate at `release-uat` discards a commit by hand when it rejects it.
7. **Two-slot activation.** DEPLOY-Prod stages the artifact inactive in `pre-prod`, then activates it live. It is an actuation, not a gate,
   and the production occupant it replaces retires rather than being discarded.
8. **Failure stops downstream.** The one cross-rung rule that code checks: each CD `Deploy_*` stage depends on the stage before it and runs
   only when that stage succeeded. It holds between template stages, not between environment rungs, and nothing records the stopped commit
   as discarded.

## Why it holds

- A commit holds one state at a time and only climbs; a new attempt is a new commit (ADR-DSGN-LIFE#1).
- Discard is rejection at a named stage: BVT and L3 discard automatically, `release-uat` by hand at RBC (ADR-DSGN-LIFE#2).
- Retirement is a successful end of life, never a discard (ADR-DSGN-LIFE#3).
- Supersession abandons a still-valid commit without rejecting it, so no gate decides it (ADR-DSGN-LIFE#4).
- Each always-on environment holds one occupant, and no gate checks it (ADR-DSGN-LIFE#5).
- The `main-uat` occupant is the stable integration point (ADR-DSGN-LIFE#6).
- A commit that fails a stage cannot go downstream (ADR-DSGN-LIFE#8).
- An out-of-band deploy of a topic commit is not an integration (ADR-DSGN-LIFE#9).
- PR build validation is the inner CI gate (ADR-FLOW-CD#8); L3 runs in CD (ADR-FLOW-CD#5); RC and RBC are the manual gates (ADR-FLOW-CD#9);
  deploy-to-prod is a two-environment activation (ADR-FLOW-CD#12).
- The BVT includes the built-artifact checks of `Test-BuildArtifact` (ADR-AUTO-TEST#24).
- The commit colours are the locked palette (ADR-DSGN-VISUAL#4).

## Where the code and the ADR differ

- No pipeline runs `Test-BuildArtifact`, so the BVT in code is narrower than the ADR's.
- No pipeline runs L3, and no RC or RBC gate, no inactive staging in `pre-prod`, and no out-of-band topic deploy path exists.
- The failure stop holds only between template stages, and no code records a discard.

## See also

- [The commit lifecycle](../../adr/design/commit-lifecycle.md) — the decision this article explains.
- [The CI discipline and the promotion flow](../../adr/flow/cd-discipline-and-promotion-flow.md) ·
  [Test automation](../../adr/automation/test-automation.md) · [Visual design](../../adr/design/visual-design.md)
- The other lenses on the same lifecycle: [meta](one-way-climb-three-endings.md), [architecture](four-domains-promote-one-artifact.md),
  [implementation](code-wires-only-the-first-rungs.md) and [operations](engineer-merges-pipelines-do-the-rest.md).
- [The design explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
