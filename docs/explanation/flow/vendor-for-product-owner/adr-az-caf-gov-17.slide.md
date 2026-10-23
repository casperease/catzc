---
catzc:
  config:
    pattern: fact
    deck: vendor-for-product-owner
    order: 17
    picture:
      mode: reduce
      source: ../../../../docs/references/pwsh/.assets/module-graph-declared-vs-observed.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-CAF-GOV
---

# Azure CAF governance: policies are declared in code and applied, never set by hand

## Eyebrow

17 / 30 · fact for the Product Owner · ADR-AZ-CAF-GOV

## Lead

For the Product Owner, who wants small batches and visible work: The cloud adoption framework's governance items are answered one by one in the records.

## Image

.assets/adr-az-caf-gov-17.png

## Caption

From the catalogue, reduced: module graph declared vs observed.

## Notes

Check it: the record ADR-AZ-CAF-GOV in docs/drs/index.md, and the diagram docs/references/pwsh/.assets/module-graph-declared-vs-observed.drawio.png.
