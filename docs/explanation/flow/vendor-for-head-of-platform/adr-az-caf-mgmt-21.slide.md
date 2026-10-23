---
catzc:
  config:
    pattern: fact
    deck: vendor-for-head-of-platform
    order: 21
    picture:
      mode: reduce
      source: ../../azure/.assets/how-each-naming-rule-is-held.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-CAF-MGMT
---

# Azure CAF management: monitoring of the switch and the rungs is part of the deploy

## Eyebrow

21 / 30 · fact for the Head of Platform · ADR-AZ-CAF-MGMT

## Lead

For the Head of Platform, who runs the platform other teams build on: The slot switch is watched while it runs; the monitors decide the reversal.

## Image

.assets/adr-az-caf-mgmt-21.png

## Caption

From the catalogue, reduced: how each naming rule is held.

## Notes

Check it: the record ADR-AZ-CAF-MGMT in docs/drs/index.md, and the diagram docs/explanation/azure/.assets/how-each-naming-rule-is-held.drawio.png.
