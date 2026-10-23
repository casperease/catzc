---
catzc:
  config:
    pattern: fact
    deck: vendor-for-finance-controller
    order: 11
    picture:
      mode: reduce
      source: ../../automation/.assets/hook-compiles-module-verdict-and-limits.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
  edges:
    cites:
      - ADR-AZ-IACKIND
---

# Azure: infrastructure as code comes in three kinds, templates, configs and modules

## Eyebrow

11 / 30 · fact for the Finance Controller · ADR-AZ-IACKIND

## Lead

For the Finance Controller, who pays for every environment and every wait: A kind says where a file lives and what reads it; a template is filled by a config slot.

## Image

.assets/adr-az-iackind-11.png

## Caption

From the catalogue, reduced: hook compiles module verdict and limits.

## Notes

Check it: the record ADR-AZ-IACKIND in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/hook-compiles-module-verdict-and-limits.drawio.png.
