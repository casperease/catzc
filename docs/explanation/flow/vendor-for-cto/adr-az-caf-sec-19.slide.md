---
catzc:
  config:
    pattern: fact
    deck: vendor-for-cto
    order: 19
    picture:
      mode: reduce
      source: ../../flow/.assets/the-loader-holds-the-one-detector.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
  edges:
    cites:
      - ADR-AZ-CAF-SEC
---

# Azure CAF security: secrets are injected at deploy time and never stored in the tree

## Eyebrow

19 / 30 · fact for the CTO · ADR-AZ-CAF-SEC

## Lead

For the CTO, who owns the delivery system and its cost: The repository holds a template through BVT; the value arrives only at deploy.

## Image

.assets/adr-az-caf-sec-19.png

## Caption

From the catalogue, reduced: the loader holds the one detector.

## Notes

Check it: the record ADR-AZ-CAF-SEC in docs/drs/index.md, and the diagram docs/explanation/flow/.assets/the-loader-holds-the-one-detector.drawio.png.
