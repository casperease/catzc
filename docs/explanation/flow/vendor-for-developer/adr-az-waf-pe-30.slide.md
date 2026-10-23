---
catzc:
  config:
    pattern: fact
    deck: vendor-for-developer
    order: 30
    picture:
      mode: reduce
      source: ../../azure/.assets/add-an-environment-slot.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
  edges:
    cites:
      - ADR-AZ-WAF-PE
---

# Azure WAF performance: the integration budget is five to ten minutes and the roofs are config

## Eyebrow

30 / 30 · fact for the Developer · ADR-AZ-WAF-PE

## Lead

For the Developer, who edits one file, runs one gate, pushes one topic: A run over its roof is a finding; the roof is raised by a person in timeouts.yml.

## Image

.assets/adr-az-waf-pe-30.png

## Caption

From the catalogue, reduced: add an environment slot.

## Notes

Check it: the record ADR-AZ-WAF-PE in docs/drs/index.md, and the diagram docs/explanation/azure/.assets/add-an-environment-slot.drawio.png.
