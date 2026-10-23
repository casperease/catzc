---
catzc:
  config:
    pattern: fact
    deck: vendor-for-release-manager
    order: 11
    picture:
      mode: reduce
      source: ../../automation/.assets/every-code-root-is-a-copy.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
  edges:
    cites:
      - ADR-AZ-IACKIND
---

# Azure: infrastructure as code comes in three kinds, templates, configs and modules

## Eyebrow

11 / 30 · fact for the Release Manager · ADR-AZ-IACKIND

## Lead

For the Release Manager, who serves the signatures and watches the ladder: A kind says where a file lives and what reads it; a template is filled by a config slot.

## Image

.assets/adr-az-iackind-11.png

## Caption

From the catalogue, reduced: every code root is a copy.

## Notes

Check it: the record ADR-AZ-IACKIND in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/every-code-root-is-a-copy.drawio.png.
