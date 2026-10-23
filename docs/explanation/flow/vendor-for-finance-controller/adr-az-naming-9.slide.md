---
catzc:
  config:
    pattern: fact
    deck: vendor-for-finance-controller
    order: 9
    picture:
      mode: reduce
      source: ../../automation/.assets/every-code-root-is-a-copy.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
  edges:
    cites:
      - ADR-AZ-NAMING
---

# Azure: every resource name is built by one naming standard and is never truncated

## Eyebrow

9 / 30 · fact for the Finance Controller · ADR-AZ-NAMING

## Lead

For the Finance Controller, who pays for every environment and every wait: Each naming rule is held in one place; a name that would truncate is a finding, not a shorter name.

## Image

.assets/adr-az-naming-9.png

## Caption

From the catalogue, reduced: every code root is a copy.

## Notes

Check it: the record ADR-AZ-NAMING in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/every-code-root-is-a-copy.drawio.png.
