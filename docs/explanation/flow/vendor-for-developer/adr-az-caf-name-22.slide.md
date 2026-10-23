---
catzc:
  config:
    pattern: fact
    deck: vendor-for-developer
    order: 22
    picture:
      mode: reduce
      source: ../../azure/.assets/pipeline-pins-devbox-picks-the-target.drawio.png
      scale: 0.4
      rotate: -4
  edges:
    cites:
      - ADR-AZ-CAF-NAME
---

# Azure CAF naming: one standard, one builder, one gate

## Eyebrow

22 / 30 · fact for the Developer · ADR-AZ-CAF-NAME

## Lead

For the Developer, who edits one file, runs one gate, pushes one topic: The naming standard is a record; the builder is code; a gate checks every name.

## Image

.assets/adr-az-caf-name-22.png

## Caption

From the catalogue, reduced: pipeline pins devbox picks the target.

## Notes

Check it: the record ADR-AZ-CAF-NAME in docs/drs/index.md, and the diagram docs/explanation/azure/.assets/pipeline-pins-devbox-picks-the-target.drawio.png.
