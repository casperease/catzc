---
catzc:
  config:
    pattern: fact
    deck: for-developer
    order: 23
    picture:
      mode: reduce
      source: ../../design/.assets/only-pwsh-compiles-its-aspects.drawio.png
      scale: 0.4
  edges:
    cites:
      - RDR-DORA-MAINTAIN
---

# Code maintainability: one function per file, one default declared once, one resolution order

## Eyebrow

23 / 30 · fact for the Developer · RDR-DORA-MAINTAIN

## Lead

For the Developer, who edits one file, runs one gate, pushes one topic: A gate counts the functions; a type holds the default; every consumer resolves the same way.

## Image

.assets/rdr-dora-maintain-23.png

## Caption

From the catalogue, reduced: only pwsh compiles its aspects.

## Notes

Check it: the record RDR-DORA-MAINTAIN in docs/drs/index.md, and the diagram docs/explanation/design/.assets/only-pwsh-compiles-its-aspects.drawio.png.
