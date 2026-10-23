---
catzc:
  config:
    pattern: fact
    deck: vendor-for-product-owner
    order: 15
    picture:
      mode: reduce
      source: ../../automation/.assets/one-resolver-every-consumer-but-the-hook.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-CLI
---

# Azure: the CLI is installed by the package manager rule and pinned

## Eyebrow

15 / 30 · fact for the Product Owner · ADR-AZ-CLI

## Lead

For the Product Owner, who wants small batches and visible work: az_cli is the machine-scope holdout; everything else installs user-space.

## Image

.assets/adr-az-cli-15.png

## Caption

From the catalogue, reduced: one resolver every consumer but the hook.

## Notes

Check it: the record ADR-AZ-CLI in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/one-resolver-every-consumer-but-the-hook.drawio.png.
