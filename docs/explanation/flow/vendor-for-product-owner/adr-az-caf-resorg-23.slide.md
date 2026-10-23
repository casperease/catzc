---
catzc:
  config:
    pattern: fact
    deck: vendor-for-product-owner
    order: 23
    picture:
      mode: reduce
      source: ../../flow/.assets/three-tasks-one-guard-one-runner.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-CAF-RESORG
---

# Azure CAF resource organization: subscriptions, groups and slots follow the data model

## Eyebrow

23 / 30 · fact for the Product Owner · ADR-AZ-CAF-RESORG

## Lead

For the Product Owner, who wants small batches and visible work: One file per subscription; a slot is inside its subscription, never beside it.

## Image

.assets/adr-az-caf-resorg-23.png

## Caption

From the catalogue, reduced: three tasks one guard one runner.

## Notes

Check it: the record ADR-AZ-CAF-RESORG in docs/drs/index.md, and the diagram docs/explanation/flow/.assets/three-tasks-one-guard-one-runner.drawio.png.
