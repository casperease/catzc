---
catzc:
  config:
    pattern: fact
    deck: vendor-for-qa-lead
    order: 16
    picture:
      mode: reduce
      source: ../../automation/.assets/two-gates-check-the-layer-pins.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-CUSTOMER
---

# Azure: a customer is a slot in the data model, and a customer change is a config change

## Eyebrow

16 / 30 · fact for the QA Lead · ADR-AZ-CUSTOMER

## Lead

For the QA Lead, who owns the test levels and their roofs: Adding a customer adds a coordinate; no code changes.

## Image

.assets/adr-az-customer-16.png

## Caption

From the catalogue, reduced: two gates check the layer pins.

## Notes

Check it: the record ADR-AZ-CUSTOMER in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/two-gates-check-the-layer-pins.drawio.png.
