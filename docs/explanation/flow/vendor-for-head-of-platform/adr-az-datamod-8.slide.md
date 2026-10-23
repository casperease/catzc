---
catzc:
  config:
    pattern: fact
    deck: vendor-for-head-of-platform
    order: 8
    picture:
      mode: reduce
      source: ../../thesis/.assets/where-truth-comes-from.drawio.png
      scale: 0.4
      rotate: -4
  edges:
    cites:
      - ADR-AZ-DATAMOD
---

# Azure: one file, one subscription; the data model is a tree of named slots

## Eyebrow

8 / 30 · fact for the Head of Platform · ADR-AZ-DATAMOD

## Lead

For the Head of Platform, who runs the platform other teams build on: A coordinate names a subscription, an environment and a slot; a bad coordinate stops discovery.

## Image

.assets/adr-az-datamod-8.png

## Caption

From the catalogue, reduced: where truth comes from.

## Notes

Check it: the record ADR-AZ-DATAMOD in docs/drs/index.md, and the diagram docs/explanation/thesis/.assets/where-truth-comes-from.drawio.png.
