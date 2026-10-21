# Deploying a topic commit is not integrating it

```text
A topic commit can reach an environment without reaching main; only landing on main puts it on the ladder.

1  topic commit         a commit on a topic branch, brown, off main
2  out-of-band deploy   a workflow deploys the topic commit; DRS-only, no code runs it
3  environment          a neutral container; its occupant stays brown
4  main                 landing on main is the integration; the commit turns grey
5  BVT                  turns the landed commit into a BVT-verified one, yellow

Supports FDR-CD-LIFE-ONESTATEADVANCESONERUNG and FDR-CD-LIFE-TOPICDEPLOYSOUTOFBAND, and DDR-VISUAL-FIXEDCOMMITPALETTE and DDR-VISUAL-ENVIRONMENTISCONTAINER (meta lens).
```

Deploying a commit and integrating it are separate events: a commit can reach an environment without reaching main. The commit lifecycle
treats that honestly: an out-of-band deploy puts a topic commit into an environment, but only landing on main puts it on the promotion
ladder. Keeping the two events apart is what lets a commit's colour stay a true statement about where it stands.

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
