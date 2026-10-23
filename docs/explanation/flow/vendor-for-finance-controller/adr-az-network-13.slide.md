---
catzc:
  config:
    pattern: fact
    deck: vendor-for-finance-controller
    order: 13
    picture:
      mode: reduce
      source: ../../automation/.assets/one-command-lays-out-the-python-workspace.drawio.png
      scale: 0.4
      rotate: -4
  edges:
    cites:
      - ADR-AZ-NETWORK
---

# Azure: network topology and connectivity are records with rules, applied by code

## Eyebrow

13 / 30 · fact for the Finance Controller · ADR-AZ-NETWORK

## Lead

For the Finance Controller, who pays for every environment and every wait: Hub, spokes and private connectivity are declared once and diffed against the live state.

## Image

.assets/adr-az-network-13.png

## Caption

From the catalogue, reduced: one command lays out the python workspace.

## Notes

Check it: the record ADR-AZ-NETWORK in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/one-command-lays-out-the-python-workspace.drawio.png.
