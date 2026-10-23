---
catzc:
  config:
    pattern: fact
    deck: vendor-for-product-owner
    order: 13
    picture:
      mode: reduce
      source: ../../../../docs/references/pwsh/.assets/get-config-merge-seal-type.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-NETWORK
---

# Azure: network topology and connectivity are records with rules, applied by code

## Eyebrow

13 / 30 · fact for the Product Owner · ADR-AZ-NETWORK

## Lead

For the Product Owner, who wants small batches and visible work: Hub, spokes and private connectivity are declared once and diffed against the live state.

## Image

.assets/adr-az-network-13.png

## Caption

From the catalogue, reduced: get config merge seal type.

## Notes

Check it: the record ADR-AZ-NETWORK in docs/drs/index.md, and the diagram docs/references/pwsh/.assets/get-config-merge-seal-type.drawio.png.
