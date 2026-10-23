---
catzc:
  config:
    pattern: fact
    deck: vendor-for-cto
    order: 15
    picture:
      mode: reduce
      source: ../../repository/.assets/a-base-module-between-config-and-its-callers.drawio.png
      scale: 0.4
      rotate: -4
  edges:
    cites:
      - ADR-AZ-CLI
---

# Azure: the CLI is installed by the package manager rule and pinned

## Eyebrow

15 / 30 · fact for the CTO · ADR-AZ-CLI

## Lead

For the CTO, who owns the delivery system and its cost: az_cli is the machine-scope holdout; everything else installs user-space.

## Image

.assets/adr-az-cli-15.png

## Caption

From the catalogue, reduced: a base module between config and its callers.

## Notes

Check it: the record ADR-AZ-CLI in docs/drs/index.md, and the diagram docs/explanation/repository/.assets/a-base-module-between-config-and-its-callers.drawio.png.
