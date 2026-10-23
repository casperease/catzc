---
catzc:
  config:
    pattern: fact
    deck: vendor-for-qa-lead
    order: 13
    picture:
      mode: reduce
      source: ../../repository/.assets/a-base-module-between-config-and-its-callers.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
  edges:
    cites:
      - ADR-AZ-NETWORK
---

# Azure: network topology and connectivity are records with rules, applied by code

## Eyebrow

13 / 30 · fact for the QA Lead · ADR-AZ-NETWORK

## Lead

For the QA Lead, who owns the test levels and their roofs: Hub, spokes and private connectivity are declared once and diffed against the live state.

## Image

.assets/adr-az-network-13.png

## Caption

From the catalogue, reduced: a base module between config and its callers.

## Notes

Check it: the record ADR-AZ-NETWORK in docs/drs/index.md, and the diagram docs/explanation/repository/.assets/a-base-module-between-config-and-its-callers.drawio.png.
