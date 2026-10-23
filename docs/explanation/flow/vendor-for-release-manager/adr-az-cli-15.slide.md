---
catzc:
  config:
    pattern: fact
    deck: vendor-for-release-manager
    order: 15
    picture:
      mode: reduce
      source: ../../automation/.assets/one-command-lays-out-the-python-workspace.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
  edges:
    cites:
      - ADR-AZ-CLI
---

# Azure: the CLI is installed by the package manager rule and pinned

## Eyebrow

15 / 30 · fact for the Release Manager · ADR-AZ-CLI

## Lead

For the Release Manager, who serves the signatures and watches the ladder: az_cli is the machine-scope holdout; everything else installs user-space.

## Image

.assets/adr-az-cli-15.png

## Caption

From the catalogue, reduced: one command lays out the python workspace.

## Notes

Check it: the record ADR-AZ-CLI in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/one-command-lays-out-the-python-workspace.drawio.png.
