---
catzc:
  config:
    pattern: fact
    deck: vendor-for-release-manager
    order: 16
    picture:
      mode: reduce
      source: ../../configuration/.assets/strip-split-walk-every-wrong-turn-throws.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-CUSTOMER
---

# Azure: a customer is a slot in the data model, and a customer change is a config change

## Eyebrow

16 / 30 · fact for the Release Manager · ADR-AZ-CUSTOMER

## Lead

For the Release Manager, who serves the signatures and watches the ladder: Adding a customer adds a coordinate; no code changes.

## Image

.assets/adr-az-customer-16.png

## Caption

From the catalogue, reduced: strip split walk every wrong turn throws.

## Notes

Check it: the record ADR-AZ-CUSTOMER in docs/drs/index.md, and the diagram docs/explanation/configuration/.assets/strip-split-walk-every-wrong-turn-throws.drawio.png.
