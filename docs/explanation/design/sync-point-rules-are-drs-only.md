# Only BVT has a gate in code; the sync-point rules are DRS-only

```text
Only the BVT rung has a gate in code; every sync-point rule is DRS-only.

1   ci-pwsh              the first rung and the one gate code enforces: BVT, which rejects a failing commit
2   on-demand (L3)       where CD runs the L3 tests; no pipeline defines it
3   main-UAT             holds commit 6, the sync point it took first
4   RC                   the manual gate on main-AT; no code runs it
5   release-uat          holds commit 5
6   RBC                  the manual gate on release-AT; no code runs it
7   pre-prod             the staged rung between release-uat and production
8   production           the top rung; holds one occupant, commit 4, plus a history; not recorded
9   upstream integrator  syncs from the BVT-verified head, never from the dirty HEAD; no check
10  dirty HEAD           commit 10, failed in main-UAT; nothing syncs from it

Supports FDR-LIFE-DISCARDISTERMINAL, FDR-LIFE-ONECOMMITPERENVIRONMENT, FDR-LIFE-SYNCFROMVERIFIEDHEAD,
FDR-LIFE-DIRTYHEADUNSAFE and FDR-LIFE-DIRTYHEADUNSAFE, FDR-CD-CDSTAYSINNONPROD, FDR-CD-TWORELEASEGATES
and FDR-CD-PREPRODRUNG (governance lens).
```

The sync point is the BVT-verified server head: upstream integrators take it, never the tip of main. The same commit goes into `main-UAT`
first, so when it is deployed it is the `main-UAT` occupant. Of the rules that govern the rungs of the promotion ladder around it, only one
has a gate in cats: the BVT rung, checked by the `ci-pwsh` pipeline. Every rule about occupants, the sync point and the dirty HEAD is
DRS-only, so "sync from the BVT-verified head" is a convention that no code checks.

```yml drawio
description:
  Of the rules around the sync point only the BVT rung has a gate in code, the ci-pwsh pipeline; every rule about occupants, the sync point,
  the manual release gates and the dirty HEAD is DRS-only.
about:
  adrs:
    - FDR-LIFE-DISCARDISTERMINAL
    - FDR-LIFE-ONECOMMITPERENVIRONMENT
    - FDR-LIFE-SYNCFROMVERIFIEDHEAD
    - FDR-LIFE-DIRTYHEADUNSAFE
    - FDR-LIFE-DIRTYHEADUNSAFE
    - FDR-CD-CDSTAYSINNONPROD
    - FDR-CD-TWORELEASEGATES
    - FDR-CD-PREPRODRUNG
  lens: governance
content:
  title: Only BVT has a gate in code; the sync-point rules are DRS-only
  kind: explanation
  flow: top-to-bottom
  relation: a commit climbs to
  states: true
  theme: dark
  bands:
    - { id: band-external, label: EXTERNAL }
    - { id: band-ladder, label: PROMOTION LADDER }
    - { id: band-tip, label: TIP OF MAIN }
  glyphs:
    - { id: g-integrator, kind: drsonly, label: upstream integrator, in: band-external }
    - { id: g-ci-automation, kind: gate, label: ci-pwsh, in: band-ladder }
    - { id: g-on-demand, kind: env, label: "on-demand\n(L3)", in: band-ladder }
    - { id: g-main-uat, kind: env, label: "main-UAT\ncommit 6", in: band-ladder }
    - { id: g-rc, kind: gate, label: "RC\nmanual", in: band-ladder }
    - { id: g-release-uat, kind: env, label: "release-uat\ncommit 5", in: band-ladder }
    - { id: g-rbc, kind: gate, label: "RBC\nmanual", in: band-ladder }
    - { id: g-pre-prod, kind: env, label: pre-prod, in: band-ladder }
    - { id: g-production, kind: env, label: "production\ncommit 4", in: band-ladder }
    - { id: f-dirty-head, kind: failure, label: "dirty HEAD: commit 10", in: band-tip }
  ladders:
    - { band: band-ladder, rise: 60, w: 140, h: 80 }
  edges:
    - { from: g-ci-automation, to: g-on-demand, kind: adr, label: "" }
    - { from: g-on-demand, to: g-main-uat, kind: adr, label: "" }
    - { from: g-main-uat, to: g-rc, kind: adr, label: "" }
    - { from: g-rc, to: g-release-uat, kind: adr, label: "" }
    - { from: g-release-uat, to: g-rbc, kind: adr, label: "" }
    - { from: g-rbc, to: g-pre-prod, kind: adr, label: "" }
    - { from: g-pre-prod, to: g-production, kind: adr, label: "" }
    - { from: g-main-uat, to: g-integrator, kind: adr, label: "" }
    - { from: f-dirty-head, to: g-main-uat, kind: fail, label: "" }
  markers:
    - { at: g-ci-automation, number: 1 }
    - { at: g-on-demand, number: 2, corner: top-left }
    - { at: g-main-uat, number: 3, corner: top-left }
    - { at: g-rc, number: 4, corner: top-left }
    - { at: g-release-uat, number: 5, corner: top-left }
    - { at: g-rbc, number: 6, corner: top-left }
    - { at: g-pre-prod, number: 7, corner: top-left }
    - { at: g-production, number: 8, corner: top-left }
    - { at: g-integrator, number: 9 }
    - { at: f-dirty-head, number: 10 }
  chips:
    - { at: g-integrator, kind: rule, rule: FDR-LIFE-SYNCFROMVERIFIEDHEAD, gated: false }
    - { at: g-integrator, kind: rule, rule: FDR-LIFE-DIRTYHEADUNSAFE, gated: false }
    - { at: g-production, kind: rule, rule: FDR-LIFE-ONECOMMITPERENVIRONMENT, gated: false }
    - { at: g-pre-prod, kind: rule, rule: FDR-CD-PREPRODRUNG, gated: false }
    - { at: g-rc, kind: rule, rule: FDR-CD-TWORELEASEGATES, gated: false }
    - { at: g-rbc, kind: rule, rule: FDR-CD-TWORELEASEGATES, gated: false }
    - { at: g-main-uat, kind: rule, rule: FDR-LIFE-SYNCFROMVERIFIEDHEAD, gated: false }
    - { at: g-on-demand, kind: rule, rule: FDR-CD-CDSTAYSINNONPROD, gated: false }
    - { at: g-ci-automation, kind: rule, rule: FDR-LIFE-DISCARDISTERMINAL }
    - { at: f-dirty-head, kind: rule, rule: FDR-LIFE-DIRTYHEADUNSAFE, gated: false }
    - { at: f-dirty-head, kind: rule, rule: FDR-LIFE-DIRTYHEADUNSAFE, gated: false }
  legend: auto
  minimaps: [code-locations, grid, axis]
layout:
  g-integrator: { x: 299, y: 140, w: 240, h: 52 }
  f-dirty-head: { x: 299, y: 864, w: 240, h: 52 }
```

![Only BVT has a gate in code; the sync-point rules are DRS-only](.assets/sync-point-rules-are-drs-only.drawio.png)

## Walkthrough

1. **ci-pwsh.** The first rung, and the one gate on the ladder that code enforces: BVT. It runs on every push to main and on pull requests
   to main that touch `pwsh/**`, in Azure DevOps and in GitHub Actions, and it runs `Test-Automation -Level 2`. A failing run rejects the
   commit automatically, as BVT should (FDR-LIFE-DISCARDISTERMINAL).
2. **On-demand (L3).** The on-demand environment where CD runs the L3 system-level end-to-end tests before it rolls the artifact onto the
   always-on environment (FDR-CD-CDSTAYSINNONPROD). No pipeline defines it.
3. **main-UAT.** Holds commit 6, the BVT-verified head it took first, so the sync point and the occupant are one commit
   (FDR-LIFE-SYNCFROMVERIFIEDHEAD).
4. **RC.** The manual gate on main-AT that a commit climbs through on its way out of main-UAT (FDR-CD-TWORELEASEGATES). No code runs RC, so
   the gate is drawn and its rule chip is dashed.
5. **Release-uat.** Holds commit 5.
6. **RBC.** The manual gate on release-AT that a commit climbs through on its way out of release-uat (FDR-CD-TWORELEASEGATES). No code runs
   RBC.
7. **Pre-prod.** The staged rung between release-uat and production (FDR-CD-PREPRODRUNG). It holds one green commit with no worked-example
   number.
8. **Production.** The top rung. Holds one occupant, commit 4, plus a history (FDR-LIFE-ONECOMMITPERENVIRONMENT). No pipeline records which
   commit that is.
9. **Upstream integrator.** Takes its commit from the BVT-verified head in main-UAT (FDR-LIFE-SYNCFROMVERIFIEDHEAD) and never from the dirty
   HEAD (FDR-LIFE-DIRTYHEADUNSAFE). Nothing in code checks either.
10. **Dirty HEAD.** Commit 10, the tip of main, which entered `main-UAT` and failed there. Nothing syncs from it (FDR-LIFE-DIRTYHEADUNSAFE),
    and it feeds nothing downstream (FDR-LIFE-DIRTYHEADUNSAFE). It keeps the blue of the state it carried into `main-UAT`.

## Why it holds

- BVT discards automatically, at a named stage (FDR-LIFE-DISCARDISTERMINAL); `ci-pwsh` is that gate.
- Each always-on environment hosts exactly one occupant plus a history (FDR-LIFE-ONECOMMITPERENVIRONMENT). The glossary defines "occupant"
  as `prose-only`, so `Test-Glossary` checks only its phrasing ("current occupant", "resident commit") and exempts it from the enforcement
  check.
- Integrators sync from the BVT-verified head, which `main-UAT` takes first, never from HEAD (FDR-LIFE-SYNCFROMVERIFIEDHEAD,
  FDR-LIFE-DIRTYHEADUNSAFE), and a failed commit goes nowhere downstream (FDR-LIFE-DIRTYHEADUNSAFE).
- RC and RBC are manual gates at `main-UAT` and release-uat (FDR-CD-TWORELEASEGATES); the tail runs through pre-prod (FDR-CD-PREPRODRUNG);
  L3 runs in an on-demand environment (FDR-CD-CDSTAYSINNONPROD).

## Where the code and the decision record differ

The decision records describe `main-UAT`, release-uat and pre-prod as always-on environments with occupants and RC and RBC gates. The CD
pipelines define none of them: a main commit that passes its CI stage is deployed to every non-prod target of a stage at once (`nsub`, or
the expedition's `dev`), and the prod subscription is reached only by the manual `deploy-apex.yaml` and `deploy-shared.yaml`. The approval
check on a prod-tier environment is the engine's, configured by the adopting team's apply of the shipped `environment-approvals.yml`
through `Sync-AdoEnvironmentApprovals`; this repository runs none. FDR-LIFE-DIRTYHEADUNSAFE holds in code only between pipeline stages, through `succeeded()` conditions, not between
environment rungs. No pipeline defines the on-demand L3 environment. The decision records also spell the environment `main-UAT` in the
commit lifecycle and `main-uat` in the promotion flow.

## See also

- [The commit lifecycle](../../drs/flow/commit-lifecycle.md) — the decision this article explains.
- [CD discipline and promotion flow](../../drs/flow/cd-discipline-and-promotion-flow.md) — RC, RBC, L3 and the pre-prod rung.
- The other lenses on the same sync point: [meta](sync-from-the-bvt-verified-head.md) and
  [architecture](integrators-sync-from-the-bvt-verified-head.md).
- [The design explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
