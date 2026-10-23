---
catzc:
  config:
    pattern: fact
    deck: vendor-for-cto
    order: 16
    picture:
      mode: reduce
      source: ../../ado/.assets/configured-credential-proves-its-org.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-CUSTOMER
---

# Azure: a customer is a slot in the data model, and a customer change is a config change

## Eyebrow

16 / 30 · fact for the CTO · ADR-AZ-CUSTOMER

## Lead

For the CTO, who owns the delivery system and its cost: Adding a customer adds a coordinate; no code changes.

## Image

.assets/adr-az-customer-16.png

## Caption

From the catalogue, reduced: configured credential proves its org.

## Notes

Check it: the record ADR-AZ-CUSTOMER in docs/drs/index.md, and the diagram docs/explanation/ado/.assets/configured-credential-proves-its-org.drawio.png.
