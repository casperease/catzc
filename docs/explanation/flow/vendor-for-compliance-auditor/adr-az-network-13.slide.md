---
catzc:
  config:
    pattern: fact
    deck: vendor-for-compliance-auditor
    order: 13
    picture:
      mode: reduce
      source: ../../design/.assets/one-door-in-one-stable-point-out.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-NETWORK
---

# Azure: network topology and connectivity are records with rules, applied by code

## Eyebrow

13 / 30 · fact for the Compliance Auditor · ADR-AZ-NETWORK

## Lead

For the Compliance Auditor, who reads the history and the registry: Hub, spokes and private connectivity are declared once and diffed against the live state.

## Image

.assets/adr-az-network-13.png

## Caption

From the catalogue, reduced: one door in one stable point out.

## Notes

Check it: the record ADR-AZ-NETWORK in docs/drs/index.md, and the diagram docs/explanation/design/.assets/one-door-in-one-stable-point-out.drawio.png.
