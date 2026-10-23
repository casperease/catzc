---
catzc:
  config:
    pattern: fact
    deck: vendor-for-cto
    order: 23
    picture:
      mode: reduce
      source: ../../repository/.assets/one-registry-one-writer-two-primitives.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
  edges:
    cites:
      - ADR-AZ-CAF-RESORG
---

# Azure CAF resource organization: subscriptions, groups and slots follow the data model

## Eyebrow

23 / 30 · fact for the CTO · ADR-AZ-CAF-RESORG

## Lead

For the CTO, who owns the delivery system and its cost: One file per subscription; a slot is inside its subscription, never beside it.

## Image

.assets/adr-az-caf-resorg-23.png

## Caption

From the catalogue, reduced: one registry one writer two primitives.

## Notes

Check it: the record ADR-AZ-CAF-RESORG in docs/drs/index.md, and the diagram docs/explanation/repository/.assets/one-registry-one-writer-two-primitives.drawio.png.
