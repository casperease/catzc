---
catzc:
  config:
    pattern: fact
    deck: vendor-for-sre-lead
    order: 15
    picture:
      mode: reduce
      source: ../../automation/.assets/reading-an-accosted-file-writes-nothing.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
---

# Azure: the CLI is installed by the package manager rule and pinned

## Eyebrow

15 / 30 · fact for the SRE Lead · ADR-AZ-CLI

## Lead

For the SRE Lead, who owns reliability, monitoring and the switch: az_cli is the machine-scope holdout; everything else installs user-space.

## Image

.assets/adr-az-cli-15.png

## Caption

From the catalogue, reduced: reading an accosted file writes nothing.

## Notes

Check it: the record ADR-AZ-CLI in docs/drs/index.md, and the diagram
docs/explanation/automation/.assets/reading-an-accosted-file-writes-nothing.drawio.png.
