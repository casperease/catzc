---
catzc:
  config:
    pattern: fact
    deck: vendor-for-finance-controller
    order: 16
    picture:
      mode: reduce
      source: ../../configuration/.assets/two-test-files-check-the-address-rules.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-CUSTOMER
---

# Azure: a customer is a slot in the data model, and a customer change is a config change

## Eyebrow

16 / 30 · fact for the Finance Controller · ADR-AZ-CUSTOMER

## Lead

For the Finance Controller, who pays for every environment and every wait: Adding a customer adds a coordinate; no code changes.

## Image

.assets/adr-az-customer-16.png

## Caption

From the catalogue, reduced: two test files check the address rules.

## Notes

Check it: the record ADR-AZ-CUSTOMER in docs/drs/index.md, and the diagram docs/explanation/configuration/.assets/two-test-files-check-the-address-rules.drawio.png.
