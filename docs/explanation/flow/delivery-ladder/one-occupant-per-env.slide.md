---
catzc:
  config:
    pattern: fact
    deck: delivery-ladder
    order: 7
    picture:
      mode: reduce
      source: ../../design/.assets/gate-checks-order-not-liveness.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
---

# An environment holds one occupant and a history

## Eyebrow

7 / 12 · fact · FDR-CD-LIFE

## Lead

main-UAT takes the BVT-verified head first; release-uat and pre-prod each hold one commit; production holds one and remembers the rest.

## Image

.assets/one-occupant-per-env.png

## Caption

From the catalogue, reduced: gate checks order not liveness.

## Notes

Check it: the record FDR-CD-LIFE in docs/drs/index.md, and the diagram
docs/explanation/design/.assets/gate-checks-order-not-liveness.drawio.png.
