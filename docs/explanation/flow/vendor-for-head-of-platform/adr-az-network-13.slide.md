---
catzc:
  config:
    pattern: fact
    deck: vendor-for-head-of-platform
    order: 13
    picture:
      mode: reduce
      source: ../../flow/.assets/tests-pin-the-throw-and-fail-open-cd-calls-it.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-NETWORK
---

# Azure: network topology and connectivity are records with rules, applied by code

## Eyebrow

13 / 30 · fact for the Head of Platform · ADR-AZ-NETWORK

## Lead

For the Head of Platform, who runs the platform other teams build on: Hub, spokes and private connectivity are declared once and diffed against the live state.

## Image

.assets/adr-az-network-13.png

## Caption

From the catalogue, reduced: tests pin the throw and fail open cd calls it.

## Notes

Check it: the record ADR-AZ-NETWORK in docs/drs/index.md, and the diagram docs/explanation/flow/.assets/tests-pin-the-throw-and-fail-open-cd-calls-it.drawio.png.
