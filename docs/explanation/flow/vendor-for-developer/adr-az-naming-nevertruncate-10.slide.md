---
catzc:
  config:
    pattern: fact
    deck: vendor-for-developer
    order: 10
    picture:
      mode: reduce
      source: ../../azure/.assets/one-namer-assembles-every-name.drawio.png
      scale: 0.4
      rotate: -4
  edges:
    cites:
      - ADR-AZ-NAMING-NEVERTRUNCATE
---

# Azure: a name that does not fit fails, it does not shrink

## Eyebrow

10 / 30 · fact for the Developer · ADR-AZ-NAMING-NEVERTRUNCATE

## Lead

For the Developer, who edits one file, runs one gate, pushes one topic: The rule chooses an error over a silently shortened, colliding name.

## Image

.assets/adr-az-naming-nevertruncate-10.png

## Caption

From the catalogue, reduced: one namer assembles every name.

## Notes

Check it: the record ADR-AZ-NAMING-NEVERTRUNCATE in docs/drs/index.md, and the diagram docs/explanation/azure/.assets/one-namer-assembles-every-name.drawio.png.
