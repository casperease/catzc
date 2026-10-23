---
catzc:
  config:
    pattern: fact
    deck: vendor-for-compliance-auditor
    order: 16
    picture:
      mode: reduce
      source: ../../../../docs/drs/flow/.assets/commit-promotion-states.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
  edges:
    cites:
      - ADR-AZ-CUSTOMER
---

# Azure: a customer is a slot in the data model, and a customer change is a config change

## Eyebrow

16 / 30 · fact for the Compliance Auditor · ADR-AZ-CUSTOMER

## Lead

For the Compliance Auditor, who reads the history and the registry: Adding a customer adds a coordinate; no code changes.

## Image

.assets/adr-az-customer-16.png

## Caption

From the catalogue, reduced: commit promotion states.

## Notes

Check it: the record ADR-AZ-CUSTOMER in docs/drs/index.md, and the diagram docs/drs/flow/.assets/commit-promotion-states.drawio.png.
