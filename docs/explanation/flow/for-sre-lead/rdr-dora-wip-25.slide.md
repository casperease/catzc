---
catzc:
  config:
    pattern: fact
    deck: for-sre-lead
    order: 25
    picture:
      mode: reduce
      source: ../../flow/.assets/a-merge-runs-cd-to-prod.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
  edges:
    cites:
      - RDR-DORA-WIP
---

# WIP limits: one occupant per environment, and the next commit waits on the rung below

## Eyebrow

25 / 30 · fact for the SRE Lead · RDR-DORA-WIP

## Lead

For the SRE Lead, who owns reliability, monitoring and the switch: An environment holds one commit plus a history; a second occupant is not a thing.

## Image

.assets/rdr-dora-wip-25.png

## Caption

From the catalogue, reduced: a merge runs cd to prod.

## Notes

Check it: the record RDR-DORA-WIP in docs/drs/index.md, and the diagram docs/explanation/flow/.assets/a-merge-runs-cd-to-prod.drawio.png.
