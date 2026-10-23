---
catzc:
  config:
    pattern: fact
    deck: vendor-for-developer
    order: 8
    picture:
      mode: reduce
      source: ../../azure/.assets/names-are-derived-never-typed.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
  edges:
    cites:
      - ADR-AZ-DATAMOD
---

# Azure: one file, one subscription; the data model is a tree of named slots

## Eyebrow

8 / 30 · fact for the Developer · ADR-AZ-DATAMOD

## Lead

For the Developer, who edits one file, runs one gate, pushes one topic: A coordinate names a subscription, an environment and a slot; a bad coordinate stops discovery.

## Image

.assets/adr-az-datamod-8.png

## Caption

From the catalogue, reduced: names are derived never typed.

## Notes

Check it: the record ADR-AZ-DATAMOD in docs/drs/index.md, and the diagram docs/explanation/azure/.assets/names-are-derived-never-typed.drawio.png.
