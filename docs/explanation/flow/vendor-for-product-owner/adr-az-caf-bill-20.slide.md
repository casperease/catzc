---
catzc:
  config:
    pattern: fact
    deck: vendor-for-product-owner
    order: 20
    picture:
      mode: reduce
      source: ../../../../docs/references/pwsh/.assets/invoke-executable-two-paths-one-bounded.drawio.png
      scale: 0.4
      rotate: -4
  edges:
    cites:
      - ADR-AZ-CAF-BILL
---

# Azure CAF billing: every environment is a named slot with a known owner and a known cost

## Eyebrow

20 / 30 · fact for the Product Owner · ADR-AZ-CAF-BILL

## Lead

For the Product Owner, who wants small batches and visible work: One occupant per environment keeps the bill a list of named rungs.

## Image

.assets/adr-az-caf-bill-20.png

## Caption

From the catalogue, reduced: invoke executable two paths one bounded.

## Notes

Check it: the record ADR-AZ-CAF-BILL in docs/drs/index.md, and the diagram docs/references/pwsh/.assets/invoke-executable-two-paths-one-bounded.drawio.png.
