---
catzc:
  config:
    pattern: fact
    deck: vendor-for-cto
    order: 11
    picture:
      mode: reduce
      source: ../../flow/.assets/independence-check-groups-by-layer.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
  edges:
    cites:
      - ADR-AZ-IACKIND
---

# Azure: infrastructure as code comes in three kinds, templates, configs and modules

## Eyebrow

11 / 30 · fact for the CTO · ADR-AZ-IACKIND

## Lead

For the CTO, who owns the delivery system and its cost: A kind says where a file lives and what reads it; a template is filled by a config slot.

## Image

.assets/adr-az-iackind-11.png

## Caption

From the catalogue, reduced: independence check groups by layer.

## Notes

Check it: the record ADR-AZ-IACKIND in docs/drs/index.md, and the diagram docs/explanation/flow/.assets/independence-check-groups-by-layer.drawio.png.
