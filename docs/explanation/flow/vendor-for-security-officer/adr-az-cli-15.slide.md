---
catzc:
  config:
    pattern: fact
    deck: vendor-for-security-officer
    order: 15
    picture:
      mode: reduce
      source: ../../design/.assets/one-door-in-one-stable-point-out.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-CLI
---

# Azure: the CLI is installed by the package manager rule and pinned

## Eyebrow

15 / 30 · fact for the Security Officer · ADR-AZ-CLI

## Lead

For the Security Officer, who owns identity, policy and the audit trail: az_cli is the machine-scope holdout; everything else installs user-space.

## Image

.assets/adr-az-cli-15.png

## Caption

From the catalogue, reduced: one door in one stable point out.

## Notes

Check it: the record ADR-AZ-CLI in docs/drs/index.md, and the diagram docs/explanation/design/.assets/one-door-in-one-stable-point-out.drawio.png.
