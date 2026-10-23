---
catzc:
  config:
    pattern: fact
    deck: vendor-for-cto
    order: 13
    picture:
      mode: reduce
      source: ../../ado/.assets/three-guarded-early-returns.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
  edges:
    cites:
      - ADR-AZ-NETWORK
---

# Azure: network topology and connectivity are records with rules, applied by code

## Eyebrow

13 / 30 · fact for the CTO · ADR-AZ-NETWORK

## Lead

For the CTO, who owns the delivery system and its cost: Hub, spokes and private connectivity are declared once and diffed against the live state.

## Image

.assets/adr-az-network-13.png

## Caption

From the catalogue, reduced: three guarded early returns.

## Notes

Check it: the record ADR-AZ-NETWORK in docs/drs/index.md, and the diagram docs/explanation/ado/.assets/three-guarded-early-returns.drawio.png.
