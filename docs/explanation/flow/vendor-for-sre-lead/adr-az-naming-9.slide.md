---
catzc:
  config:
    pattern: fact
    deck: vendor-for-sre-lead
    order: 9
    picture:
      mode: reduce
      source: ../../../../docs/drs/azure/.assets/azure-name-assembly.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
---

# Azure: every resource name is built by one naming standard and is never truncated

## Eyebrow

9 / 30 · fact for the SRE Lead · ADR-AZ-NAMING

## Lead

For the SRE Lead, who owns reliability, monitoring and the switch: Each naming rule is held in one place; a name that would truncate is a
finding, not a shorter name.

## Image

[adr-az-naming-9](.assets/adr-az-naming-9.png)

## Caption

From the catalogue, reduced: azure name assembly.

## Notes

Check it: the record ADR-AZ-NAMING in docs/drs/index.md, and the diagram docs/drs/azure/.assets/azure-name-assembly.drawio.png.
