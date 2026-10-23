---
catzc:
  config:
    pattern: fact
    deck: vendor-for-developer
    order: 13
    picture:
      mode: reduce
      source: ../../design/.assets/unit-to-pipeline-rule-is-review-only.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-NETWORK
---

# Azure: network topology and connectivity are records with rules, applied by code

## Eyebrow

13 / 30 · fact for the Developer · ADR-AZ-NETWORK

## Lead

For the Developer, who edits one file, runs one gate, pushes one topic: Hub, spokes and private connectivity are declared once and diffed against the live state.

## Image

.assets/adr-az-network-13.png

## Caption

From the catalogue, reduced: unit to pipeline rule is review only.

## Notes

Check it: the record ADR-AZ-NETWORK in docs/drs/index.md, and the diagram docs/explanation/design/.assets/unit-to-pipeline-rule-is-review-only.drawio.png.
