# No gate checks the out-of-band deploy rule, and the only gate on deploys in code is main-only

```text
FDR-CD-LIFE-TOPICDEPLOYSOUTOFBAND is ADR-only, and the one gate on deploys in code allows main alone.

1  topic                a topic commit, brown and below the mainline; no gate checks either drawing rule
2  out-of-band deploy   the deploy the rule allows; ADR-only, no code runs or checks it
3  environment          a neutral container; its occupant keeps its own colour
4  main                 landing on main is the integration
5  main only            the gate in code: every Deploy_* stage needs refs/heads/main
6  BVT                  checked on main: Test-Automation and Test-BuildArtifact run

Supports FDR-CD-LIFE-ONESTATEADVANCESONERUNG and FDR-CD-LIFE-TOPICDEPLOYSOUTOFBAND, and DDR-VISUAL-BRANCHDIRECTIONISROLE, DDR-VISUAL-FIXEDCOMMITPALETTE and DDR-VISUAL-ENVIRONMENTISCONTAINER (governance lens).
```

FDR-CD-LIFE-TOPICDEPLOYSOUTOFBAND lets a workflow deploy a topic commit without integrating it. Looked at as governance, the rule stands
alone: no gate or checker in cats tests it, and nothing in the repository runs the deploy it allows. The one gate in code on the deploy side
points the other way, since every `Deploy_*` stage runs only from main. The drawing rules of DDR-VISUAL that colour these commits have no
checker either, and none is expected.

![FDR-CD-LIFE-TOPICDEPLOYSOUTOFBAND is ADR-only and every Deploy stage is main-only](.assets/out-of-band-deploy-is-adr-only/diagram.drawio.png)

## Walkthrough

1. **Topic.** A commit on a topic branch. Topic branches are drawn below the mainline, and a topic commit is brown, never grey. No gate
   checks either drawing rule.
2. **Out-of-band deploy.** A workflow or pipeline may deploy the topic commit for a hotfix or an experiment, and the deploy is not an
   integration. The rule is ADR-only: no code runs this deploy and no gate checks it.
3. **Environment.** The environment is a neutral container, and its occupant keeps its own colour, so a topic commit deployed out of band
   stays brown inside it.
4. **Main.** Landing on main is the integration, and from here a commit climbs one rung at a time.
5. **Main only.** The gate in code: every `Deploy_*` stage carries the condition that the source branch is `refs/heads/main`. A run from any
   other ref skips the deploy stages, so no topic commit is deployed today.
6. **BVT.** The BVT turns a landed commit into a BVT-verified one, yellow. The pipeline guide names the CI type's post-commit run on main
   the BVT; there the CI pipelines run `Test-Automation`, and `ci-pwsh` also runs `Test-BuildArtifact`.

## Why it holds

- A topic commit can be deployed out-of-band without integrating into main, and the deploy confers no promotion state on the mainline
  (FDR-CD-LIFE-TOPICDEPLOYSOUTOFBAND).
- A commit holds one lifecycle state at a time and advances one rung along the ladder or leaves it (FDR-CD-LIFE-ONESTATEADVANCESONERUNG).
- Topic branches render below the mainline and release branches above it (DDR-VISUAL-BRANCHDIRECTIONISROLE).
- The commit colours are fixed: a topic commit is brown and never grey, and yellow is past the BVT with an immutable artifact
  (DDR-VISUAL-FIXEDCOMMITPALETTE).
- An environment box is a neutral container whose occupant carries its own state colour (DDR-VISUAL-ENVIRONMENTISCONTAINER).

## Where the code and the decision record differ

- FDR-CD-LIFE-TOPICDEPLOYSOUTOFBAND allows a workflow or pipeline to deploy a topic commit; no pipeline or workflow does, and every
  `Deploy_*` stage is main-only.
- The pipeline guide says the CI type produces no artifact, while DDR-VISUAL-FIXEDCOMMITPALETTE makes yellow carry an immutable versioned
  artifact.

## See also

- [The commit lifecycle](../../drs/flow/commit-lifecycle.md) — the decision this article explains.
- [Visual design](../../drs/design/visual-design.md) — the drawing rules behind the V chips.
- [Test automation](../../drs/automation/test-automation.md) — the BVT's built-artifact checks.
- The other lenses on the same deploy: [meta](deploying-is-not-integrating.md),
  [architecture](deploy-and-integrate-share-only-the-topic.md), [implementation](every-deploy-stage-is-main-only.md) and
  [operations](merging-to-main-is-what-deploys.md).
- [The design explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
