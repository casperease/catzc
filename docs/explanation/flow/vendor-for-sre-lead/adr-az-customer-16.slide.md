---
catzc:
  config:
    pattern: fact
    deck: vendor-for-sre-lead
    order: 16
    picture:
      mode: reduce
      source: ../../azure/.assets/what-holds-the-azure-coordinate-rules.drawio.png
      scale: 0.4
---

# Azure: a customer is a slot in the data model, and a customer change is a config change

## Eyebrow

16 / 30 · fact for the SRE Lead · ADR-AZ-CUSTOMER

## Lead

For the SRE Lead, who owns reliability, monitoring and the switch: Adding a customer adds a coordinate; no code changes.

## Image

[adr-az-customer-16](.assets/adr-az-customer-16.png)

## Caption

From the catalogue, reduced: coordinate rules and their gates.

## Notes

Check it: the record ADR-AZ-CUSTOMER in docs/drs/index.md, and the diagram
docs/explanation/azure/.assets/what-holds-the-azure-coordinate-rules.drawio.png.
