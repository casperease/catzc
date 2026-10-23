---
catzc:
  config:
    pattern: fact
    deck: vendor-for-finance-controller
    order: 15
    picture:
      mode: reduce
      source: ../../automation/.assets/one-out-string-two-places.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
  edges:
    cites:
      - ADR-AZ-CLI
---

# Azure: the CLI is installed by the package manager rule and pinned

## Eyebrow

15 / 30 · fact for the Finance Controller · ADR-AZ-CLI

## Lead

For the Finance Controller, who pays for every environment and every wait: az_cli is the machine-scope holdout; everything else installs user-space.

## Image

.assets/adr-az-cli-15.png

## Caption

From the catalogue, reduced: one out string two places.

## Notes

Check it: the record ADR-AZ-CLI in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/one-out-string-two-places.drawio.png.
