---
catzc:
  config:
    pattern: fact
    deck: vendor-for-sre-lead
    order: 16
    picture:
      mode: reduce
      source: ../../flow/.assets/globs-module-owns-config-and-types.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-CUSTOMER
---

# Azure: a customer is a slot in the data model, and a customer change is a config change

## Eyebrow

16 / 30 · fact for the SRE Lead · ADR-AZ-CUSTOMER

## Lead

For the SRE Lead, who owns reliability, monitoring and the switch: Adding a customer adds a coordinate; no code changes.

## Image

.assets/adr-az-customer-16.png

## Caption

From the catalogue, reduced: globs module owns config and types.

## Notes

Check it: the record ADR-AZ-CUSTOMER in docs/drs/index.md, and the diagram docs/explanation/flow/.assets/globs-module-owns-config-and-types.drawio.png.
