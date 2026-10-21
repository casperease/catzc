# Deploying a topic commit and integrating it share only the topic commit

```text
The deploy path and the integration path share only the topic commit; nothing on the deploy path feeds main.

1  topic commit          brown, off main; both paths start here
2  workflow / pipeline   deploys the topic commit; ADR-only, no code runs it
3  environment           the deploy target; its occupant stays brown
4  main                  landing on main is the integration; the commit turns grey
5  BVT                   produces the BVT-verified commit, yellow
6  the landing edge      the only link between the two paths is their start

Supports FDR-CD-LIFE-ONESTATEADVANCESONERUNG and FDR-CD-LIFE-TOPICDEPLOYSOUTOFBAND, and DDR-VISUAL-FIXEDCOMMITPALETTE and DDR-VISUAL-ENVIRONMENTISCONTAINER (architecture lens).
```

Cats keeps two events apart that are easy to blur: deploying a commit and integrating it. A commit on a topic branch can reach an
environment through a workflow or pipeline without ever reaching main, and that deploy is not an integration. Seen as architecture, the two
paths have exactly one part in common, the topic commit itself, and nothing on the deploy path feeds main, the BVT or the commit's place on
the promotion ladder.

![The deploy path and the integration path share only the topic commit](.assets/deploy-and-integrate-share-only-the-topic/diagram.drawio.png)

## Walkthrough

1. **Topic commit.** A commit that still lives on a topic branch. It is brown, the development colour, which is never an integrated mainline
   state. Both paths start here: it can land on main, and a workflow can read it to deploy.
2. **Workflow or pipeline.** The ADR allows a workflow or pipeline to deploy a topic commit directly, for a hotfix or an experiment. No
   pipeline or workflow in the repository does this today, so the workflow and both of its edges are ADR-only.
3. **Environment.** The deploy target. The environment is a neutral container, and the commit inside it is its occupant in its own state
   colour. After an out-of-band deploy the occupant stays brown: deployed, but not integrated. The ADR names no particular environment for
   this deploy.
4. **Main.** Landing on main is the integration. The commit turns grey, and only from here can it climb the ladder.
5. **BVT.** The BVT takes the landed commit and produces the BVT-verified commit, yellow, with an immutable versioned artifact. A commit
   climbs one rung at a time and never moves backward.
6. **The landing edge.** The only link between the two paths is the topic commit they start from. The landing edge passes over the
   out-of-band band without touching it, and no edge leads from the deploy path to main or the BVT.

## Why it holds

- A topic commit can be deployed out-of-band by a workflow without integrating into main; the deploy is not an integration and confers no
  promotion state on the mainline (FDR-CD-LIFE-TOPICDEPLOYSOUTOFBAND).
- A commit holds one lifecycle state at a time and advances one rung along the ladder, topic, landed on main, BVT-verified and onward, or
  leaves it (FDR-CD-LIFE-ONESTATEADVANCESONERUNG).
- The commit colours are fixed: brown is a development commit, grey is integrated onto main, and yellow is past the BVT with an immutable
  artifact (DDR-VISUAL-FIXEDCOMMITPALETTE).
- An environment box is a neutral container, and the commit inside it carries its own state colour (DDR-VISUAL-ENVIRONMENTISCONTAINER).

## Where the code and the decision record differ

- FDR-CD-LIFE-TOPICDEPLOYSOUTOFBAND allows a workflow or pipeline to deploy a topic commit, but no pipeline or workflow in cats does: every
  `Deploy_*` stage runs only when the source branch is `refs/heads/main`.
- DDR-VISUAL lets the BVT accept a brown commit as well as a grey one; the integration path here follows the commit after it lands.

## See also

- [The commit lifecycle](../../drs/flow/commit-lifecycle.md) — the decision this article explains.
- [Visual design](../../drs/design/visual-design.md) — the commit colours and the neutral environment.
- The other lenses on the same deploy: [meta](deploying-is-not-integrating.md), [implementation](every-deploy-stage-is-main-only.md),
  [operations](merging-to-main-is-what-deploys.md) and [governance](out-of-band-deploy-is-adr-only.md).
- [The design explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
