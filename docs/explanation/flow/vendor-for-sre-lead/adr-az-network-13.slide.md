---
catzc:
  config:
    pattern: fact
    deck: vendor-for-sre-lead
    order: 13
    picture:
      mode: reduce
      source: ../../automation/.assets/output-root-first-then-repo-root.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
  edges:
    cites:
      - ADR-AZ-NETWORK
---

# Azure: network topology and connectivity are records with rules, applied by code

## Eyebrow

13 / 30 · fact for the SRE Lead · ADR-AZ-NETWORK

## Lead

For the SRE Lead, who owns reliability, monitoring and the switch: Hub, spokes and private connectivity are declared once and diffed against the live state.

## Image

.assets/adr-az-network-13.png

## Caption

From the catalogue, reduced: output root first then repo root.

## Notes

Check it: the record ADR-AZ-NETWORK in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/output-root-first-then-repo-root.drawio.png.
