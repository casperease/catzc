---
catzc:
  config:
    pattern: fact
    deck: vendor-for-sre-lead
    order: 11
    picture:
      mode: reduce
      source: ../../../../docs/drs/azure/.assets/azure-name-assembly.drawio.png
      scale: 0.4
      rotate: -4
  edges:
    cites:
      - ADR-AZ-IACKIND
---

# Azure: infrastructure as code comes in three kinds, templates, configs and modules

## Eyebrow

11 / 30 · fact for the SRE Lead · ADR-AZ-IACKIND

## Lead

For the SRE Lead, who owns reliability, monitoring and the switch: A kind says where a file lives and what reads it; a template is filled by a config slot.

## Image

.assets/adr-az-iackind-11.png

## Caption

From the catalogue, reduced: azure name assembly.

## Notes

Check it: the record ADR-AZ-IACKIND in docs/drs/index.md, and the diagram docs/drs/azure/.assets/azure-name-assembly.drawio.png.
