---
catzc:
  config:
    pattern: fact
    deck: vendor-for-release-manager
    order: 13
    picture:
      mode: reduce
      source: ../../automation/.assets/hook-compiles-module-verdict-and-limits.drawio.png
      scale: 0.4
      rotate: -4
  edges:
    cites:
      - ADR-AZ-NETWORK
---

# Azure: network topology and connectivity are records with rules, applied by code

## Eyebrow

13 / 30 · fact for the Release Manager · ADR-AZ-NETWORK

## Lead

For the Release Manager, who serves the signatures and watches the ladder: Hub, spokes and private connectivity are declared once and diffed against the live state.

## Image

.assets/adr-az-network-13.png

## Caption

From the catalogue, reduced: hook compiles module verdict and limits.

## Notes

Check it: the record ADR-AZ-NETWORK in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/hook-compiles-module-verdict-and-limits.drawio.png.
