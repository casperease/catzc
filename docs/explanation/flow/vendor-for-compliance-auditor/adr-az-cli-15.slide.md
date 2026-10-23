---
catzc:
  config:
    pattern: fact
    deck: vendor-for-compliance-auditor
    order: 15
    picture:
      mode: reduce
      source: ../../design/.assets/one-folder-two-independent-readers.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-CLI
---

# Azure: the CLI is installed by the package manager rule and pinned

## Eyebrow

15 / 30 · fact for the Compliance Auditor · ADR-AZ-CLI

## Lead

For the Compliance Auditor, who reads the history and the registry: az_cli is the machine-scope holdout; everything else installs user-space.

## Image

.assets/adr-az-cli-15.png

## Caption

From the catalogue, reduced: one folder two independent readers.

## Notes

Check it: the record ADR-AZ-CLI in docs/drs/index.md, and the diagram docs/explanation/design/.assets/one-folder-two-independent-readers.drawio.png.
