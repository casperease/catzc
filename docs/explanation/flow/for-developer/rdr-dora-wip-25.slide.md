---
catzc:
  config:
    pattern: fact
    deck: for-developer
    order: 25
    picture:
      mode: reduce
      source: ../../design/.assets/out-of-band-deploy-is-drs-only.drawio.png
      scale: 0.4
  edges:
    cites:
      - RDR-DORA-WIP
---

# WIP limits: one occupant per environment, and the next commit waits on the rung below

## Eyebrow

25 / 30 · fact for the Developer · RDR-DORA-WIP

## Lead

For the Developer, who edits one file, runs one gate, pushes one topic: An environment holds one commit plus a history; a second occupant is not a thing.

## Image

.assets/rdr-dora-wip-25.png

## Caption

From the catalogue, reduced: out of band deploy is drs only.

## Notes

Check it: the record RDR-DORA-WIP in docs/drs/index.md, and the diagram docs/explanation/design/.assets/out-of-band-deploy-is-drs-only.drawio.png.
