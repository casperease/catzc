---
catzc:
  config:
    pattern: fact
    deck: vendor-for-sre-lead
    order: 15
    picture:
      mode: reduce
      source: ../../design/.assets/every-vendor-call-leaves-through-az.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
---

# Azure: the CLI is installed by the package manager rule and pinned

## Eyebrow

15 / 30 · fact for the SRE Lead · ADR-AZ-CLI

## Lead

For the SRE Lead, who owns reliability, monitoring and the switch: az_cli is the machine-scope holdout; everything else installs user-space.

## Image

[adr-az-cli-15](.assets/adr-az-cli-15.png)

## Caption

From the catalogue, reduced: every vendor call leaves through az.

## Notes

Check it: the record ADR-AZ-CLI in docs/drs/index.md, and the diagram
docs/explanation/design/.assets/every-vendor-call-leaves-through-az.drawio.png.
