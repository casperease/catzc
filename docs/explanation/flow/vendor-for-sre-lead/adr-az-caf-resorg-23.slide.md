---
catzc:
  config:
    pattern: fact
    deck: vendor-for-sre-lead
    order: 23
    picture:
      mode: reduce
      source: ../../flow/.assets/one-gate-checks-the-raw-read-rule.drawio.png
      scale: 0.4
      rotate: -4
---

# Azure CAF resource organization: subscriptions, groups and slots follow the data model

## Eyebrow

23 / 30 · fact for the SRE Lead · EDR-AZ-CAF-RESORG

## Lead

For the SRE Lead, who owns reliability, monitoring and the switch: One file per subscription; a slot is inside its subscription, never
beside it.

## Image

.assets/adr-az-caf-resorg-23.png

## Caption

From the catalogue, reduced: one gate checks the raw read rule.

## Notes

Check it: the record EDR-AZ-CAF-RESORG in docs/drs/index.md, and the diagram
docs/explanation/flow/.assets/one-gate-checks-the-raw-read-rule.drawio.png.
