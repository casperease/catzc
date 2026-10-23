---
catzc:
  config:
    pattern: fact
    deck: vendor-for-developer
    order: 2
    picture:
      mode: reduce
      source: ../../flow/.assets/the-analyzer-names-the-raw-read.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
  edges:
    cites:
      - ADR-ADO-NAME
---

# Azure DevOps: pipeline, environment and policy names come from one naming rule

## Eyebrow

2 / 30 · fact for the Developer · ADR-ADO-NAME

## Lead

For the Developer, who edits one file, runs one gate, pushes one topic: A name is derived from the unit and the rung; nothing is typed in the portal.

## Image

.assets/adr-ado-name-2.png

## Caption

From the catalogue, reduced: the analyzer names the raw read.

## Notes

Check it: the record ADR-ADO-NAME in docs/drs/index.md, and the diagram docs/explanation/flow/.assets/the-analyzer-names-the-raw-read.drawio.png.
