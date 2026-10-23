---
catzc:
  config:
    pattern: fact
    deck: vendor-for-developer
    order: 21
    picture:
      mode: reduce
      source: ../../repository/.assets/values-and-edges-gated-reads-reviewed.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-CAF-MGMT
---

# Azure CAF management: monitoring of the switch and the rungs is part of the deploy

## Eyebrow

21 / 30 · fact for the Developer · ADR-AZ-CAF-MGMT

## Lead

For the Developer, who edits one file, runs one gate, pushes one topic: The slot switch is watched while it runs; the monitors decide the reversal.

## Image

.assets/adr-az-caf-mgmt-21.png

## Caption

From the catalogue, reduced: values and edges gated reads reviewed.

## Notes

Check it: the record ADR-AZ-CAF-MGMT in docs/drs/index.md, and the diagram docs/explanation/repository/.assets/values-and-edges-gated-reads-reviewed.drawio.png.
