---
catzc:
  config:
    pattern: fact
    deck: vendor-for-finance-controller
    order: 21
    picture:
      mode: reduce
      source: ../../automation/.assets/resolve-one-limit-in-code-order.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
  edges:
    cites:
      - ADR-AZ-CAF-MGMT
---

# Azure CAF management: monitoring of the switch and the rungs is part of the deploy

## Eyebrow

21 / 30 · fact for the Finance Controller · ADR-AZ-CAF-MGMT

## Lead

For the Finance Controller, who pays for every environment and every wait: The slot switch is watched while it runs; the monitors decide the reversal.

## Image

.assets/adr-az-caf-mgmt-21.png

## Caption

From the catalogue, reduced: resolve one limit in code order.

## Notes

Check it: the record ADR-AZ-CAF-MGMT in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/resolve-one-limit-in-code-order.drawio.png.
