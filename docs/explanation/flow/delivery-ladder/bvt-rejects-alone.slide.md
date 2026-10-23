---
catzc:
  config:
    pattern: fact
    deck: delivery-ladder
    order: 6
    picture:
      mode: reduce
      source: ../../azure/.assets/a-bad-coordinate-stops-discovery.drawio.png
      scale: 0.4
  edges:
    cites:
      - FDR-CD-LIFE
---

# Discard is terminal: a commit BVT rejects never climbs

## Eyebrow

6 / 12 · fact · FDR-CD-LIFE

## Lead

The build verification test runs on every push to main; a failing commit is discarded on its own, and the next one starts from the verified point.

## Image

.assets/bvt-rejects-alone.png

## Caption

From the catalogue, reduced: a bad coordinate stops discovery.

## Notes

Check it: the record FDR-CD-LIFE in docs/drs/index.md, and the diagram docs/explanation/azure/.assets/a-bad-coordinate-stops-discovery.drawio.png.
