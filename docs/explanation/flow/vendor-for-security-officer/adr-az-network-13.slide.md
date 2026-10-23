---
catzc:
  config:
    pattern: fact
    deck: vendor-for-security-officer
    order: 13
    picture:
      mode: reduce
      source: ../../design/.assets/manifest-and-aspects-from-one-folder.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-NETWORK
---

# Azure: network topology and connectivity are records with rules, applied by code

## Eyebrow

13 / 30 · fact for the Security Officer · ADR-AZ-NETWORK

## Lead

For the Security Officer, who owns identity, policy and the audit trail: Hub, spokes and private connectivity are declared once and diffed against the live state.

## Image

.assets/adr-az-network-13.png

## Caption

From the catalogue, reduced: manifest and aspects from one folder.

## Notes

Check it: the record ADR-AZ-NETWORK in docs/drs/index.md, and the diagram docs/explanation/design/.assets/manifest-and-aspects-from-one-folder.drawio.png.
