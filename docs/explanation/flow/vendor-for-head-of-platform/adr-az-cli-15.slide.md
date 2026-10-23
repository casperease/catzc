---
catzc:
  config:
    pattern: fact
    deck: vendor-for-head-of-platform
    order: 15
    picture:
      mode: reduce
      source: ../../../../docs/references/pwsh/.assets/get-config-merge-seal-type.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-CLI
---

# Azure: the CLI is installed by the package manager rule and pinned

## Eyebrow

15 / 30 · fact for the Head of Platform · ADR-AZ-CLI

## Lead

For the Head of Platform, who runs the platform other teams build on: az_cli is the machine-scope holdout; everything else installs user-space.

## Image

.assets/adr-az-cli-15.png

## Caption

From the catalogue, reduced: get config merge seal type.

## Notes

Check it: the record ADR-AZ-CLI in docs/drs/index.md, and the diagram docs/references/pwsh/.assets/get-config-merge-seal-type.drawio.png.
