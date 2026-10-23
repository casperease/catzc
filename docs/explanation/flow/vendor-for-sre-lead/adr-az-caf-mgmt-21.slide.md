---
catzc:
  config:
    pattern: fact
    deck: vendor-for-sre-lead
    order: 21
    picture:
      mode: reduce
      source: ../../flow/.assets/one-artifact-climbs-unchanged.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
  edges:
    cites:
      - ADR-AZ-CAF-MGMT
---

# Azure CAF management: monitoring of the switch and the rungs is part of the deploy

## Eyebrow

21 / 30 · fact for the SRE Lead · ADR-AZ-CAF-MGMT

## Lead

For the SRE Lead, who owns reliability, monitoring and the switch: The slot switch is watched while it runs; the monitors decide the reversal.

## Image

.assets/adr-az-caf-mgmt-21.png

## Caption

From the catalogue, reduced: one artifact climbs unchanged.

## Notes

Check it: the record ADR-AZ-CAF-MGMT in docs/drs/index.md, and the diagram docs/explanation/flow/.assets/one-artifact-climbs-unchanged.drawio.png.
