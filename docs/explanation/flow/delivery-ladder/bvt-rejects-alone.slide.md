---
catzc:
  config:
    pattern: fact
    deck: delivery-ladder
    order: 6
    picture:
      mode: reduce
      source: ../../design/.assets/where-a-deploy-stage-may-run.drawio.png
      scale: 0.4
---

# Discard is terminal: a commit BVT rejects never climbs

## Eyebrow

6 / 12 · fact · FDR-LIFE

## Lead

The build verification test runs on every push to main; a failing commit is discarded on its own, and the next one starts from the verified
point.

## Image

[bvt-rejects-alone](.assets/bvt-rejects-alone.png)

## Caption

From the catalogue, reduced: every deploy stage is main only.

## Notes

Check it: the record FDR-LIFE in docs/drs/index.md, and the diagram
docs/explanation/design/.assets/where-a-deploy-stage-may-run.drawio.png.
