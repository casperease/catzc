---
catzc:
  config:
    pattern: fact
    deck: delivery-ladder
    order: 7
    picture:
      mode: reduce
      source: ../../design/.assets/sync-from-the-bvt-verified-head.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
---

# An environment holds one occupant and a history

## Eyebrow

7 / 12 · fact · FDR-LIFE

## Lead

main-UAT takes the BVT-verified head first; release-uat and pre-prod each hold one commit; production holds one and remembers the rest.

## Image

[one-occupant-per-env](.assets/one-occupant-per-env.png)

## Caption

From the catalogue, reduced: sync from the BVT verified head.

## Notes

Check it: the record FDR-LIFE in docs/drs/index.md, and the diagram
docs/explanation/design/.assets/sync-from-the-bvt-verified-head.drawio.png.
