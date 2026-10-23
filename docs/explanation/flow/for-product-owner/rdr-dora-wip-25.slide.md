---
catzc:
  config:
    pattern: fact
    deck: for-product-owner
    order: 25
    picture:
      mode: reduce
      source: ../../azure/.assets/coordinate-rules-and-their-gates.drawio.png
      scale: 0.4
  edges:
    cites:
      - RDR-DORA-WIP
---

# WIP limits: one occupant per environment, and the next commit waits on the rung below

## Eyebrow

25 / 30 · fact for the Product Owner · RDR-DORA-WIP

## Lead

For the Product Owner, who wants small batches and visible work: An environment holds one commit plus a history; a second occupant is not a thing.

## Image

.assets/rdr-dora-wip-25.png

## Caption

From the catalogue, reduced: coordinate rules and their gates.

## Notes

Check it: the record RDR-DORA-WIP in docs/drs/index.md, and the diagram docs/explanation/azure/.assets/coordinate-rules-and-their-gates.drawio.png.
