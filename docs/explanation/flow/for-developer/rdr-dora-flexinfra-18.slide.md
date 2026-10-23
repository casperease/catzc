---
catzc:
  config:
    pattern: fact
    deck: for-developer
    order: 18
    picture:
      mode: reduce
      source: ../../azure/.assets/a-module-change-fans-out-to-its-templates.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
  edges:
    cites:
      - RDR-DORA-FLEXINFRA
---

# Flexible infrastructure: pre-prod is a slot inside production, hot-swappable blue-green

## Eyebrow

18 / 30 · fact for the Developer · RDR-DORA-FLEXINFRA

## Lead

For the Developer, who edits one file, runs one gate, pushes one topic: The staging slot is never a separate subscription; the switch is an automated procedure.

## Image

.assets/rdr-dora-flexinfra-18.png

## Caption

From the catalogue, reduced: a module change fans out to its templates.

## Notes

Check it: the record RDR-DORA-FLEXINFRA in docs/drs/index.md, and the diagram docs/explanation/azure/.assets/a-module-change-fans-out-to-its-templates.drawio.png.
