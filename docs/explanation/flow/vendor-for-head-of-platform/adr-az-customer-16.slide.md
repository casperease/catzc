---
catzc:
  config:
    pattern: fact
    deck: vendor-for-head-of-platform
    order: 16
    picture:
      mode: reduce
      source: ../../design/.assets/state-changes.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
  edges:
    cites:
      - ADR-AZ-CUSTOMER
---

# Azure: a customer is a slot in the data model, and a customer change is a config change

## Eyebrow

16 / 30 · fact for the Head of Platform · ADR-AZ-CUSTOMER

## Lead

For the Head of Platform, who runs the platform other teams build on: Adding a customer adds a coordinate; no code changes.

## Image

.assets/adr-az-customer-16.png

## Caption

From the catalogue, reduced: state changes.

## Notes

Check it: the record ADR-AZ-CUSTOMER in docs/drs/index.md, and the diagram docs/explanation/design/.assets/state-changes.drawio.png.
