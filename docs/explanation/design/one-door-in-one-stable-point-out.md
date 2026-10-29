# How changes enter and consumers build

```text
How changes enter and consumers build.

1  local clone      a working copy that bridges to the server remote; no authority of its own
2  pull request     the one door into the server's main: authenticates, runs the merge gates, merges
3  HEAD             the tip of main; provisional, it may be unverified or failed downstream
4  verified point   the last commit the server proved verified; it never moves
5  consumer clones  every consumer builds on the verified point, never on HEAD

Supports DDR-REMOTE-SERVERREMOTEISTRUTH, DDR-REMOTE-INTEGRATEFROMVERIFIED, DDR-REMOTE-INTEGRATEFROMVERIFIED
and DDR-REMOTE-PULLREQUESTISINGRESS (meta lens).
```

The mainline of cats lives on an audited server git remote, and every developer box and CI agent is a client that bridges to it. Work
crosses that boundary in two directions, and each direction has one rule: a change comes in only through a pull request, and a consumer
reads out only the last verified commit, never the raw tip. Together the two rules keep the mainline trustworthy to build on and honest
about its history.

```yml drawio
description:
  A change enters the server's main only through a pull request, and consumers build on the last verified commit, a point that never moves,
  never on the provisional HEAD.
about:
  rules:
    [DDR-REMOTE-SERVERREMOTEISTRUTH, DDR-REMOTE-INTEGRATEFROMVERIFIED, DDR-REMOTE-INTEGRATEFROMVERIFIED, DDR-REMOTE-PULLREQUESTISINGRESS]
  lens: meta
content:
  title: How changes enter and consumers build
  kind: explanation
  flow: top-to-bottom
  relation: a commit moves to
  states: true
  theme: dark
  bands:
    - { id: band-in, label: IN }
    - { id: band-server, label: SERVER REMOTE }
    - { id: band-out, label: OUT }
  glyphs:
    - { id: g-local-clone, kind: store, label: local clone, in: band-in }
    - { id: g-pull-request, kind: gate, label: pull request, in: band-in }
    - { id: g-head, kind: commit, label: HEAD, in: band-server, state: landed }
    - { id: g-verified, kind: commit, label: verified point, in: band-server }
    - { id: g-consumers, kind: store, label: consumer clones, in: band-out }
  edges:
    - { from: g-local-clone, to: g-pull-request, kind: record, label: "" }
    - { from: g-pull-request, to: g-head, kind: flow, label: "" }
    - { from: g-verified, to: g-consumers, kind: record, label: "" }
  markers:
    - { at: g-local-clone, number: 1 }
    - { at: g-pull-request, number: 2 }
    - { at: g-head, number: 3 }
    - { at: g-verified, number: 4 }
    - { at: g-consumers, number: 5 }
  legend: auto
  minimaps: [code-locations, grid, axis]
layout:
  band-in: { x: 20, y: 84, w: 1260, h: 130 }
  band-server: { x: 20, y: 234, w: 1260, h: 130 }
  band-out: { x: 20, y: 384, w: 1260, h: 130 }
  g-local-clone: { x: 300, y: 128, w: 200, h: 64 }
  g-pull-request: { x: 800, y: 112, w: 220, h: 96 }
  g-head: { x: 800, y: 290, w: 220, h: 44 }
  g-verified: { x: 300, y: 290, w: 220, h: 44 }
  g-consumers: { x: 300, y: 430, w: 200, h: 64 }
```

![How changes enter and consumers build](.assets/one-door-in-one-stable-point-out.drawio.png)

## Walkthrough

1. **Local clone.** A developer's working copy is a bridge to the server remote, not a second truth. It pushes toward the pull request, and
   nothing on it counts as "on main" until the server holds it. No code in cats performs that push, so the edge is dashed.
2. **Pull request.** The pull request is the one door into the server's `main` / `master`. It authenticates the author, runs the merge gates
   and performs the merge itself. The solo `main-direct` mode is the deliberate single-author exception, where the door collapses to a
   direct commit.
3. **HEAD.** The merge lands the commit at the tip of main. HEAD is provisional: it may still be unverified, or verified and then failed
   downstream, and it can be fixed forward, superseded or cut back.
4. **Verified point.** The last commit the server proved verified is stable. The verified history only grows, so nothing that happens at
   HEAD moves this point.
5. **Consumer clones.** Every consumer, whether a developer starting work, a downstream unit or an upstream integrator, builds on the
   verified point. Nothing in cats resolves that point yet, so this edge is dashed too.

## Why it holds

- The audited server remote is the single source of truth, and local and CI clones are bridges to it (DDR-REMOTE-SERVERREMOTEISTRUTH).
- A consumer integrates from the last remote-verified commit, never from the current remote HEAD (DDR-REMOTE-INTEGRATEFROMVERIFIED).
- Because the verified point never moves, a consumer never has to reconcile a tip that is later rewritten or superseded
  (DDR-REMOTE-INTEGRATEFROMVERIFIED).
- The pull request is the authenticated ingress, and closing every other door is what makes the `git log` audit trail complete
  (DDR-REMOTE-PULLREQUESTISINGRESS).

## Where the code and the decision record differ

- The DDR tells every consumer to integrate from the last verified commit, but no function or pipeline in cats resolves that commit, and the
  pipelines trigger on `main`.
- The DDR closes every door but the pull request, but no code in cats denies a direct push to the protected branch.

## See also

- [The audited server git remote](../../drs/design/server-remote-integration.md) — the decision this article explains.
- The other lenses on the same decision: [architecture](clients-bridge-to-one-server.md),
  [implementation](how-ingress-is-guarded-locally-and-on-the-server.md),
  [operations](how-the-guard-and-the-server-policies-are-turned-on.md) and [governance](which-ingress-rules-have-a-gate.md).
- [The design explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
