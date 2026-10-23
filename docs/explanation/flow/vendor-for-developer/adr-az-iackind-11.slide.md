---
catzc:
  config:
    pattern: fact
    deck: vendor-for-developer
    order: 11
    picture:
      mode: reduce
      source: ../../repository/.assets/an-edit-lands-at-the-next-import.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-IACKIND
---

# Azure: infrastructure as code comes in three kinds, templates, configs and modules

## Eyebrow

11 / 30 · fact for the Developer · ADR-AZ-IACKIND

## Lead

For the Developer, who edits one file, runs one gate, pushes one topic: A kind says where a file lives and what reads it; a template is filled by a config slot.

## Image

.assets/adr-az-iackind-11.png

## Caption

From the catalogue, reduced: an edit lands at the next import.

## Notes

Check it: the record ADR-AZ-IACKIND in docs/drs/index.md, and the diagram docs/explanation/repository/.assets/an-edit-lands-at-the-next-import.drawio.png.
