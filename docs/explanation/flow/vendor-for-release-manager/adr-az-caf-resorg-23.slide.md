---
catzc:
  config:
    pattern: fact
    deck: vendor-for-release-manager
    order: 23
    picture:
      mode: reduce
      source: ../../automation/.assets/resolve-one-limit-in-code-order.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
  edges:
    cites:
      - ADR-AZ-CAF-RESORG
---

# Azure CAF resource organization: subscriptions, groups and slots follow the data model

## Eyebrow

23 / 30 · fact for the Release Manager · ADR-AZ-CAF-RESORG

## Lead

For the Release Manager, who serves the signatures and watches the ladder: One file per subscription; a slot is inside its subscription, never beside it.

## Image

.assets/adr-az-caf-resorg-23.png

## Caption

From the catalogue, reduced: resolve one limit in code order.

## Notes

Check it: the record ADR-AZ-CAF-RESORG in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/resolve-one-limit-in-code-order.drawio.png.
