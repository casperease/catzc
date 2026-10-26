# Deploying a topic commit is not integrating it

```text
A topic commit can reach an environment without reaching main; only landing on main puts it on the ladder.

1  topic commit         a commit on a topic branch, brown, off main
2  out-of-band deploy   a workflow deploys the topic commit; DRS-only, no code runs it
3  environment          a neutral container; its occupant stays brown
4  main                 landing on main is the integration; the commit turns grey
5  BVT                  turns the landed commit into a BVT-verified one, yellow

Supports FDR-CD-LIFE-ONESTATEADVANCESONERUNG and FDR-CD-LIFE-TOPICDEPLOYSOUTOFBAND, and DDR-VISUAL-FIXEDCOMMITPALETTE
and DDR-VISUAL-ENVIRONMENTISCONTAINER (meta lens).
```

Deploying a commit and integrating it are separate events: a commit can reach an environment without reaching main. The commit lifecycle
treats that honestly: an out-of-band deploy puts a topic commit into an environment, but only landing on main puts it on the promotion
ladder. Keeping the two events apart is what lets a commit's colour stay a true statement about where it stands.

```yml drawio
description:
  A topic commit can reach an environment through an out-of-band deploy without reaching main; only landing on main puts it on the ladder
  toward the build validation verified commit.
about:
  adrs:
    - FDR-CD-LIFE-ONESTATEADVANCESONERUNG
    - FDR-CD-LIFE-TOPICDEPLOYSOUTOFBAND
    - DDR-VISUAL-FIXEDCOMMITPALETTE
    - DDR-VISUAL-ENVIRONMENTISCONTAINER
  lens: meta
content:
  title: Deploying a topic commit is not integrating it
  kind: explanation
  flow: left-to-right
  relation: lands, then climbs
  states: true
  theme: dark
  bands:
    - { id: band-topic, label: TOPIC }
    - { id: band-out-of-band, label: OUT-OF-BAND }
    - { id: band-main, label: MAIN }
    - { id: band-landing, label: AFTER LANDING }
  spans:
    - id: span-integration
      label: CI
      over: [band-main, band-landing]
  glyphs:
    - { id: c-topic, kind: commit, label: topic commit, in: band-topic, state: topic }
    - { id: a-deploy, kind: drsonly, label: out-of-band deploy, in: band-out-of-band }
    - { id: e-environment, kind: env, label: environment (occupant inside), in: band-out-of-band }
    - { id: c-main, kind: commit, label: main, in: band-main, state: landed }
    - { id: g-validation, kind: gate, label: BVT, in: band-landing }
    - { id: c-verified, kind: commit, label: BVT-verified, in: band-landing }
  edges:
    - { from: c-topic, to: a-deploy, kind: adr, label: "" }
    - { from: a-deploy, to: e-environment, kind: adr, label: "" }
    - { from: c-topic, to: c-main, kind: flow, label: "" }
    - { from: c-main, to: g-validation, kind: flow, label: "" }
    - { from: g-validation, to: c-verified, kind: flow, label: "" }
  markers:
    - { at: c-topic, number: 1 }
    - { at: a-deploy, number: 2 }
    - { at: e-environment, number: 3 }
    - { at: c-main, number: 4 }
    - { at: g-validation, number: 5 }
  legend: auto
  minimaps: [code-locations, grid, axis]
layout:
  band-topic: { x: 20, y: 108, w: 170, h: 380 }
  band-out-of-band: { x: 210, y: 108, w: 420, h: 380 }
  band-main: { x: 650, y: 108, w: 200, h: 380 }
  band-landing: { x: 870, y: 108, w: 410, h: 380 }
  c-topic: { x: 40, y: 170, w: 130, h: 44 }
  a-deploy: { x: 340, y: 270, w: 180, h: 44 }
  e-environment: { x: 310, y: 380, w: 240, h: 60 }
  c-main: { x: 700, y: 170, w: 100, h: 44 }
  g-validation: { x: 940, y: 154, w: 130, h: 72 }
  c-verified: { x: 1110, y: 170, w: 150, h: 44 }
```

![Deploying is not integrating](.assets/deploying-is-not-integrating.drawio.png)

## Walkthrough

1. **Topic commit.** A commit on a topic branch, off main. It is brown, the development colour, which is never an integrated mainline state.
   It has two ways forward.
2. **The out-of-band deploy.** A workflow or pipeline may deploy a topic commit directly, for a hotfix or an experiment. The deploy is
   explicitly not an integration and confers no promotion state, so no edge leads from it to main. The edge is DRS-only because nothing in
   the repository runs this deploy today.
3. **Environment.** The environment is a neutral container, and the commit inside it is its occupant, in that commit's own colour. After an
   out-of-band deploy the occupant stays brown: deployed, but not integrated.
4. **Main.** Landing on main is the integration, and the commit turns grey. The commit keeps its brown until it lands normally, and only
   then can it climb.
5. **BVT.** The BVT turns the landed commit into a BVT-verified one, yellow, with an immutable versioned artifact. A commit climbs one rung
   at a time and never moves backward.

## Why it holds

- A topic commit can be deployed out-of-band without integrating into main; the deploy confers no promotion state on the mainline
  (FDR-CD-LIFE-TOPICDEPLOYSOUTOFBAND).
- A commit advances one rung along the ladder at a time, or leaves it, and never moves backward (FDR-CD-LIFE-ONESTATEADVANCESONERUNG).
- Brown is a development commit and never an integrated mainline state; grey is integrated onto main; yellow is past the BVT
  (DDR-VISUAL-FIXEDCOMMITPALETTE).
- An environment box is neutral, and its occupant carries its own state colour (DDR-VISUAL-ENVIRONMENTISCONTAINER).

## Where the code and the decision record differ

FDR-CD-LIFE-TOPICDEPLOYSOUTOFBAND allows the out-of-band deploy, but no pipeline or workflow in cats runs one: every `Deploy_*` stage runs
only from main.

## See also

- [The commit lifecycle](../../drs/flow/commit-lifecycle.md) — the decision this article explains.
- [Visual design](../../drs/design/visual-design.md) — the commit colours and the neutral environment.
- The other lenses on the same deploy: [architecture](deploy-and-integrate-share-only-the-topic.md),
  [implementation](every-deploy-stage-is-main-only.md), [operations](merging-to-main-is-what-deploys.md) and
  [governance](out-of-band-deploy-is-drs-only.md).
- [The design explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
