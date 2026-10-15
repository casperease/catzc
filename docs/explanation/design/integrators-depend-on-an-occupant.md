---
catzc:
  derived:
    path: docs/explanation/design/integrators-depend-on-an-occupant.md
    kind: explanation
    body_sha: e9b85c942879
    adrs:
      - ADR-DSGN-LIFE#{5-8}
      - ADR-DSGN-VISUAL#13
      - ADR-FLOW-CD#{9,11}
    links:
      - docs/.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.drawio.md
      - docs/.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.drawio.png
      - docs/adr/design/commit-lifecycle.md
      - docs/adr/flow/cd-discipline-and-promotion-flow.md
      - docs/explanation/design/index.md
      - docs/explanation/design/sync-from-the-last-certified-commit.md
      - docs/explanation/design/sync-point-rules-are-adr-only.md
      - docs/explanation/index.md#how-to-read-the-diagrams
---

# Upstream integrators depend on the main-UAT occupant, never on the tip of main

```text
Every environment and every upstream integrator takes an occupant, never the tip of main.

1  upstream integrator  builds on cats from outside; takes commit 6, the main-UAT occupant
2  production           holds commit 4; takes its commit from pre-prod
3  pre-prod             the staged rung before production; takes its commit from release-uat
4  release-uat          holds commit 5, the release candidate; takes its commit from main-UAT
5  main-UAT             holds commit 6, past every machine gate: the stable sync point
6  dirty HEAD           commit 10, the newest commit on main, which failed in main-UAT

Supports ADR-DSGN-LIFE#5, #6, #7 and #8, ADR-FLOW-CD#9 and #11 (architecture lens).
```

Each always-on environment in cats holds one commit, its occupant, and anyone outside the repository who needs a stable base takes the
commit that `main-UAT` holds, not the tip of main. Every environment on the promotion ladder likewise takes its commit from the rung before
it, so the whole chain rests on occupants, never on HEAD. Keeping "what is newest" apart from "what is safe to build on" is what stops one
broken commit from spreading. All of this is stated by the ADRs; no pipeline in the repository runs it yet.

![Upstream integrators depend on the main-UAT occupant, never on the tip of main](../../.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.drawio.png)

The diagram is described element by element in
[its asset description](../../.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.drawio.md).

## Walkthrough

1. **Upstream integrator.** An external or upstream consumer that builds on cats. It takes commit 6, the `main-UAT` occupant, and never the
   tip of main.
2. **Production.** An always-on environment that holds exactly one commit plus a history. Its occupant is commit 4, which rolled over commit
   3 and shipped. It takes its commit from pre-prod.
3. **Pre-prod.** The staged rung before production, not yet live. It holds one green commit; none of the worked examples sits there, so the
   commit carries no number. It takes its commit from release-uat once the RBC gate clears.
4. **Release-uat.** Holds commit 5, the release candidate under test. It takes its commit from `main-UAT` once the RC gate clears; RC and
   RBC are the two manual release gates.
5. **main-UAT.** Holds commit 6, the latest commit certified onto the always-on non-prod environment. That commit has cleared every gate a
   machine decides, which is why it is the stable sync point.
6. **Dirty HEAD.** Commit 10 is the newest commit on main. It entered `main-UAT` and failed there, so it is not a source for sync and it
   cannot be promoted. It keeps the blue of the L3-verified state it carried into `main-UAT`.

## Why it holds

- Each always-on environment hosts exactly one commit, its occupant, plus a history; an environment box is neutral and the occupant carries
  the state colour (ADR-DSGN-LIFE#5, ADR-DSGN-VISUAL#13).
- The stable integration point is the `main-UAT` occupant, and upstream integrators sync from it, never from HEAD (ADR-DSGN-LIFE#6).
- The dirty HEAD is the latest commit on main and is not safe to sync or promote from (ADR-DSGN-LIFE#7).
- A commit that fails a stage cannot go downstream, neither by promotion nor by consumption (ADR-DSGN-LIFE#8).
- RC at `main-UAT` and RBC at release-uat are the manual gates, and the prod tail runs release-uat, pre-prod, production (ADR-FLOW-CD#9,
  ADR-FLOW-CD#11).

## Where the code and the ADR differ

The ADRs describe `main-UAT`, release-uat and pre-prod as always-on environments with one occupant each, joined by the RC and RBC gates. The
CD pipelines define no `main-uat` or release-uat environment and record no occupant: once a main commit passes its CI stage, CD deploys it
to every target of a stage at once, non-prod and prod tier side by side (`nsub` and `psub`, or the expedition's `dev` and `prod`), with no
gate between them. In code, every environment therefore takes the tip of main. The ADRs also spell the environment two ways: `main-UAT` in
the commit lifecycle and `main-uat` in the promotion flow.

## See also

- [The commit lifecycle](../../adr/design/commit-lifecycle.md) — the decision this article explains.
- [CD discipline and promotion flow](../../adr/flow/cd-discipline-and-promotion-flow.md) — the RC and RBC gates and the pre-prod rung.
- The other lenses on the same sync point: [meta](sync-from-the-last-certified-commit.md) and
  [governance](sync-point-rules-are-adr-only.md).
- [The design explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
