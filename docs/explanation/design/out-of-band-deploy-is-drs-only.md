# Which deploy rules have a gate

```text
Which deploy rules have a gate.

1  topic                a topic commit, brown and below the mainline; no gate checks either drawing rule
2  out-of-band deploy   the deploy the rule allows; DRS-only, no code runs or checks it
3  environment          a neutral container; its occupant keeps its own colour
4  main                 landing on main is the integration
5  main only            the gate in code: every Deploy_* stage needs refs/heads/main
6  BVT                  checked on main: Test-Automation and Test-BuildArtifact run

Supports FDR-LIFE-ONESTATEADVANCESONERUNG and FDR-LIFE-TOPICDEPLOYSOUTOFBAND, and DDR-VISUAL-BRANCHDIRECTIONISROLE,
DDR-VISUAL-FIXEDCOMMITPALETTE and DDR-VISUAL-ENVIRONMENTISCONTAINER (governance lens).
```

FDR-LIFE-TOPICDEPLOYSOUTOFBAND lets a workflow deploy a topic commit without integrating it. Looked at as governance, the rule stands alone:
no gate or checker in cats tests it, and nothing in the repository runs the deploy it allows. The one gate in code on the deploy side points
the other way, since every `Deploy_*` stage runs only from main. The drawing rules of DDR-VISUAL that colour these commits have no checker
either, and none is expected.

```yml drawio
description:
  The out-of-band deploy of a topic commit, which no gate checks, beside the one gate in code on deploys, main-only, and the climb from the
  topic commit through main and the BVT to a BVT-verified commit.
about:
  rules:
    - FDR-LIFE-ONESTATEADVANCESONERUNG
    - FDR-LIFE-TOPICDEPLOYSOUTOFBAND
    - DDR-VISUAL-BRANCHDIRECTIONISROLE
    - DDR-VISUAL-FIXEDCOMMITPALETTE
    - DDR-VISUAL-ENVIRONMENTISCONTAINER
  lens: governance
content:
  title: Which deploy rules have a gate
  kind: explanation
  flow: left-to-right
  relation: lands, then climbs
  states: true
  theme: dark
  bands:
    - { id: band-topic, label: TOPIC }
    - { id: band-out-of-band, label: OUT-OF-BAND }
    - { id: band-main, label: MAIN }
    - { id: band-after, label: AFTER LANDING }
  spans:
    - id: span-ci
      label: CI
      over: [band-main, band-after]
  glyphs:
    - { id: c-topic, kind: commit, label: topic, in: band-topic, state: topic }
    - { id: a-deploy, kind: drsonly, label: out-of-band deploy, in: band-out-of-band }
    - { id: e-environment, kind: env, label: environment, in: band-out-of-band }
    - { id: c-occupant, kind: commit, label: topic, in: e-environment, state: topic }
    - { id: c-main, kind: commit, label: main, in: band-main, state: landed }
    - { id: g-main-only, kind: gate, label: main only, in: band-main }
    - { id: g-bvt, kind: gate, label: BVT, in: band-after }
    - { id: c-verified, kind: commit, label: BVT-verified, in: band-after }
  edges:
    - { from: c-topic, to: c-main, kind: flow, label: "" }
    - from: c-topic
      to: a-deploy
      kind: record
      label: ""
      via:
        - [105, 312]
    - { from: a-deploy, to: e-environment, kind: record, label: "" }
    - { from: c-main, to: g-main-only, kind: flow, label: "" }
    - { from: c-main, to: g-bvt, kind: flow, label: "" }
    - { from: g-bvt, to: c-verified, kind: flow, label: "" }
  markers:
    - { at: c-topic, number: 1 }
    - { at: a-deploy, number: 2 }
    - { at: e-environment, number: 3 }
    - { at: c-main, number: 4 }
    - { at: g-main-only, number: 5 }
    - { at: g-bvt, number: 6 }
  chips:
    - { at: c-topic, kind: rule, rule: DDR-VISUAL-BRANCHDIRECTIONISROLE, gated: false }
    - { at: c-topic, kind: rule, rule: DDR-VISUAL-FIXEDCOMMITPALETTE, gated: false, corner: bottom-right }
    - { at: a-deploy, kind: rule, rule: FDR-LIFE-TOPICDEPLOYSOUTOFBAND, gated: false, corner: bottom-right }
    - { at: e-environment, kind: rule, rule: DDR-VISUAL-ENVIRONMENTISCONTAINER, gated: false }
    - { at: c-main, kind: rule, rule: FDR-LIFE-ONESTATEADVANCESONERUNG, gated: false, corner: bottom-right }
    - { at: c-verified, kind: rule, rule: DDR-VISUAL-FIXEDCOMMITPALETTE, gated: false }
  legend: auto
  minimaps: [code-locations, grid, axis]
layout:
  band-topic: { x: 20, y: 124, w: 170, h: 380 }
  band-out-of-band: { x: 210, y: 124, w: 420, h: 380 }
  band-main: { x: 650, y: 124, w: 200, h: 380 }
  band-after: { x: 870, y: 124, w: 410, h: 380 }
  c-topic: { x: 40, y: 186, w: 130, h: 44 }
  a-deploy: { x: 330, y: 290, w: 180, h: 44 }
  e-environment: { x: 300, y: 390, w: 240, h: 72 }
  c-occupant: { x: 460, y: 412, w: 64, h: 28 }
  c-main: { x: 700, y: 186, w: 100, h: 44 }
  g-main-only: { x: 700, y: 290, w: 100, h: 68 }
  g-bvt: { x: 930, y: 174, w: 100, h: 68 }
  c-verified: { x: 1090, y: 186, w: 150, h: 44 }
```

![Which deploy rules have a gate](.assets/out-of-band-deploy-is-drs-only.drawio.png)

## Walkthrough

1. **Topic.** A commit on a topic branch. Topic branches are drawn below the mainline, and a topic commit is brown, never grey. No gate
   checks either drawing rule.
2. **Out-of-band deploy.** A workflow or pipeline may deploy the topic commit for a hotfix or an experiment, and the deploy is not an
   integration. The rule is DRS-only: no code runs this deploy and no gate checks it.
3. **Environment.** The environment is a neutral container, and its occupant keeps its own colour, so a topic commit deployed out of band
   stays brown inside it.
4. **Main.** Landing on main is the integration, and from here a commit climbs one rung at a time.
5. **Main only.** The gate in code: every `Deploy_*` stage carries the condition that the source branch is `refs/heads/main`. A run from any
   other ref skips the deploy stages, so no topic commit is deployed today.
6. **BVT.** The BVT turns a landed commit into a BVT-verified one, yellow. The pipeline guide names the CI type's post-commit run on main
   the BVT; there the CI pipelines run `Test-Automation`, and `ci-pwsh` also runs `Test-BuildArtifact`.

## Why it holds

- A topic commit can be deployed out-of-band without integrating into main, and the deploy confers no promotion state on the mainline
  (FDR-LIFE-TOPICDEPLOYSOUTOFBAND).
- A commit holds one lifecycle state at a time and advances one rung along the ladder or leaves it (FDR-LIFE-ONESTATEADVANCESONERUNG).
- Topic branches render below the mainline and release branches above it (DDR-VISUAL-BRANCHDIRECTIONISROLE).
- The commit colours are fixed: a topic commit is brown and never grey, and yellow is past the BVT with an immutable artifact
  (DDR-VISUAL-FIXEDCOMMITPALETTE).
- An environment box is a neutral container whose occupant carries its own state colour (DDR-VISUAL-ENVIRONMENTISCONTAINER).

## Where the code and the decision record differ

- FDR-LIFE-TOPICDEPLOYSOUTOFBAND allows a workflow or pipeline to deploy a topic commit; no pipeline or workflow does, and every `Deploy_*`
  stage is main-only.
- The pipeline guide says the CI type produces no artifact, while DDR-VISUAL-FIXEDCOMMITPALETTE makes yellow carry an immutable versioned
  artifact.

## See also

- [The commit lifecycle](../../drs/flow/commit-lifecycle.md) — the decision this article explains.
- [Visual design](../../drs/design/visual-design.md) — the drawing rules behind the V chips.
- [Test automation](../../drs/automation/test-automation.md) — the BVT's built-artifact checks.
- The other lenses on the same deploy: [meta](deploying-is-not-integrating.md),
  [architecture](deploy-and-integrate-share-only-the-topic.md), [implementation](where-a-deploy-stage-may-run.md) and
  [operations](merging-to-main-is-what-deploys.md).
- [The design explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
