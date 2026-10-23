---
catzc:
  config:
    pattern: fact
    deck: vendor-for-product-owner
    order: 16
    picture:
      mode: reduce
      source: ../../../../docs/references/pwsh/.assets/az-cli-test-assert-share-one-state.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
  edges:
    cites:
      - ADR-AZ-CUSTOMER
---

# Azure: a customer is a slot in the data model, and a customer change is a config change

## Eyebrow

16 / 30 · fact for the Product Owner · ADR-AZ-CUSTOMER

## Lead

For the Product Owner, who wants small batches and visible work: Adding a customer adds a coordinate; no code changes.

## Image

.assets/adr-az-customer-16.png

## Caption

From the catalogue, reduced: az cli test assert share one state.

## Notes

Check it: the record ADR-AZ-CUSTOMER in docs/drs/index.md, and the diagram docs/references/pwsh/.assets/az-cli-test-assert-share-one-state.drawio.png.
