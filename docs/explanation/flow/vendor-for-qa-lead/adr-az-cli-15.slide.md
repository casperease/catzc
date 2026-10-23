---
catzc:
  config:
    pattern: fact
    deck: vendor-for-qa-lead
    order: 15
    picture:
      mode: reduce
      source: ../../repository/.assets/one-source-one-writer-one-boolean.drawio.png
      scale: 0.4
      rotate: -4
  edges:
    cites:
      - ADR-AZ-CLI
---

# Azure: the CLI is installed by the package manager rule and pinned

## Eyebrow

15 / 30 · fact for the QA Lead · ADR-AZ-CLI

## Lead

For the QA Lead, who owns the test levels and their roofs: az_cli is the machine-scope holdout; everything else installs user-space.

## Image

.assets/adr-az-cli-15.png

## Caption

From the catalogue, reduced: one source one writer one boolean.

## Notes

Check it: the record ADR-AZ-CLI in docs/drs/index.md, and the diagram docs/explanation/repository/.assets/one-source-one-writer-one-boolean.drawio.png.
