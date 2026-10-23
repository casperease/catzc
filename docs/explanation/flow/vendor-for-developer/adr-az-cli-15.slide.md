---
catzc:
  config:
    pattern: fact
    deck: vendor-for-developer
    order: 15
    picture:
      mode: reduce
      source: ../../design/.assets/what-keeps-the-platform-thin.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-CLI
---

# Azure: the CLI is installed by the package manager rule and pinned

## Eyebrow

15 / 30 · fact for the Developer · ADR-AZ-CLI

## Lead

For the Developer, who edits one file, runs one gate, pushes one topic: az_cli is the machine-scope holdout; everything else installs user-space.

## Image

.assets/adr-az-cli-15.png

## Caption

From the catalogue, reduced: what keeps the platform thin.

## Notes

Check it: the record ADR-AZ-CLI in docs/drs/index.md, and the diagram docs/explanation/design/.assets/what-keeps-the-platform-thin.drawio.png.
