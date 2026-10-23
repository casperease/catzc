---
catzc:
  config:
    pattern: fact
    deck: vendor-for-product-owner
    order: 21
    picture:
      mode: reduce
      source: ../../../../docs/references/pwsh/.assets/bicep-deploy-one-immutable-context.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-CAF-MGMT
---

# Azure CAF management: monitoring of the switch and the rungs is part of the deploy

## Eyebrow

21 / 30 · fact for the Product Owner · ADR-AZ-CAF-MGMT

## Lead

For the Product Owner, who wants small batches and visible work: The slot switch is watched while it runs; the monitors decide the reversal.

## Image

.assets/adr-az-caf-mgmt-21.png

## Caption

From the catalogue, reduced: bicep deploy one immutable context.

## Notes

Check it: the record ADR-AZ-CAF-MGMT in docs/drs/index.md, and the diagram docs/references/pwsh/.assets/bicep-deploy-one-immutable-context.drawio.png.
