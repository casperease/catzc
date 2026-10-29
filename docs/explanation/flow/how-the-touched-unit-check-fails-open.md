# How the touched-unit check fails open

```text
How the touched-unit check fails open.

1  git at real refs       the two commits the question is asked between, as they exist after the merge
2  is this unit touched?  the check a deployable unit's pipeline stage asks before it does any work
3  stop                   the one answer that lets the stage return: confirmed untouched
4  proceed                touched, or any doubt about the range or the diff
5  a typo throws          an undeclared unit name is a programming error, never a silent skip

Supports FDR-GLOBS-CHANGECOMPUTEDFROMGIT (meta lens).
```

A deployable unit's pipeline stage has one question to ask before it does any work: did this change touch my area-of-control? In cats the
answer is never read from a hash committed beside the unit. It is computed from git, between two commits that really exist after the merge,
so a squash merge or a concurrent merge can never make it stale. And the answer is shaped by what a wrong answer costs: a redundant run is
safe, a wrong skip is an un-deployed change, so every doubt proceeds.

```yml drawio
description:
  Whether a change touches a deployable unit is asked of git between two commits that exist after the merge; only a confirmed untouched unit
  stops the stage, every doubt proceeds, and an undeclared unit name throws.
about:
  rules: [FDR-GLOBS-CHANGECOMPUTEDFROMGIT]
  lens: meta
content:
  title: How the touched-unit check fails open
  kind: explanation
  flow: left-to-right
  theme: dark
  bands:
    - { id: band-git, label: GIT }
    - { id: band-check, label: THE CHECK }
    - { id: band-answer, label: THE ANSWER }
  glyphs:
    - { id: s-git, kind: store, label: git at real refs, in: band-git }
    - { id: g-touched, kind: gate, label: "is this unit touched?", in: band-check }
    - { id: f-typo, kind: failure, label: a typo throws, in: band-check }
    - { id: r-stop, kind: result, label: stop, in: band-answer }
    - { id: r-proceed, kind: result, label: proceed, in: band-answer }
  edges:
    - { from: s-git, to: g-touched, kind: flow, label: "" }
    - { from: g-touched, to: r-stop, kind: flow, label: "" }
    - { from: g-touched, to: r-proceed, kind: flow, label: "" }
    - { from: g-touched, to: f-typo, kind: fail, label: "" }
  markers:
    - { at: s-git, number: 1 }
    - { at: g-touched, number: 2 }
    - { at: r-stop, number: 3 }
    - { at: r-proceed, number: 4 }
    - { at: f-typo, number: 5 }
  legend: auto
  minimaps: [code-locations, module-neighbourhood, axis]
layout:
  band-git: { x: 20, y: 84, w: 1260, h: 130 }
  band-check: { x: 20, y: 234, w: 1260, h: 130 }
  band-answer: { x: 20, y: 384, w: 1260, h: 130 }
  s-git: { x: 585, y: 114, w: 130, h: 80 }
  g-touched: { x: 540, y: 254, w: 220, h: 90 }
  f-typo: { x: 900, y: 277, w: 160, h: 44 }
  r-stop: { x: 480, y: 430, w: 160, h: 44 }
  r-proceed: { x: 660, y: 430, w: 160, h: 44 }
```

![How the touched-unit check fails open](.assets/how-the-touched-unit-check-fails-open.drawio.png)

## Walkthrough

1. **Git at real refs.** The question is asked between a reference commit and the commit being built, both read from the repository as it is
   at run time. Nothing per unit is committed, so there is no whole-set hash to go stale.
2. **Is this unit touched?** The check diffs the two commits, matches the changed paths against the globset registry, and reports whether
   the named unit is among the globsets the change touches. A rename is split into both of its paths, so a file moving into or out of a unit
   counts as a change.
3. **Stop.** The check answers that the unit is untouched only when it has positively confirmed it over a range it could resolve. That is
   the one answer that lets a stage return early.
4. **Proceed.** The unit is touched, or the check is in doubt: the reference commit cannot be resolved, or git cannot compute the diff. Both
   proceed, because running a stage that had nothing to do is safe and skipping one that had work is a deploy that never happens.
5. **A typo throws.** A unit name that is not a declared globset is a programming error, not a runtime doubt, so the check throws rather
   than reporting "not affected" and skipping the stage.

## Why it holds

- Whether a change touches a unit is computed from git at real refs, never from a committed hash, and the check fails open on any doubt so a
  wrong skip can never drop a deploy (FDR-GLOBS-CHANGECOMPUTEDFROMGIT).
- The check returns false only when it has positively confirmed the unit is untouched, and throws on an undeclared unit name so a typo never
  silently skips (FDR-GLOBS-CHANGECOMPUTEDFROMGIT).

## See also

- [Globset triggers](../../drs/flow/durable-sha-globs.md) — the decision this article explains.
- The other lenses on the same check: [architecture](where-the-globs-check-gets-its-context-and-diff.md),
  [implementation](how-the-touched-unit-check-picks-its-git-range.md), [operations](when-a-pipeline-stage-stops.md) and
  [governance](what-tests-pin-the-fail-open-check.md).
- [The flow explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
