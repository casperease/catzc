---
catzc:
  config:
    pattern: fact
    deck: vendor-for-developer
    order: 16
    picture:
      mode: reduce
      source: ../../repository/.assets/one-home-one-read-path-one-vocabulary.drawio.png
      scale: 0.4
      rotate: -4
  edges:
    cites:
      - ADR-AZ-CUSTOMER
---

# Azure: a customer is a slot in the data model, and a customer change is a config change

## Eyebrow

16 / 30 · fact for the Developer · ADR-AZ-CUSTOMER

## Lead

For the Developer, who edits one file, runs one gate, pushes one topic: Adding a customer adds a coordinate; no code changes.

## Image

.assets/adr-az-customer-16.png

## Caption

From the catalogue, reduced: one home one read path one vocabulary.

## Notes

Check it: the record ADR-AZ-CUSTOMER in docs/drs/index.md, and the diagram docs/explanation/repository/.assets/one-home-one-read-path-one-vocabulary.drawio.png.
