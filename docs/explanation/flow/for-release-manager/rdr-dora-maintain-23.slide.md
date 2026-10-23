---
catzc:
  config:
    pattern: fact
    deck: for-release-manager
    order: 23
    picture:
      mode: reduce
      source: ../../automation/.assets/a-shell-call-carries-its-limit-or-is-denied.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
  edges:
    cites:
      - RDR-DORA-MAINTAIN
---

# Code maintainability: one function per file, one default declared once, one resolution order

## Eyebrow

23 / 30 · fact for the Release Manager · RDR-DORA-MAINTAIN

## Lead

For the Release Manager, who serves the signatures and watches the ladder: A gate counts the functions; a type holds the default; every consumer resolves the same way.

## Image

.assets/rdr-dora-maintain-23.png

## Caption

From the catalogue, reduced: a shell call carries its limit or is denied.

## Notes

Check it: the record RDR-DORA-MAINTAIN in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/a-shell-call-carries-its-limit-or-is-denied.drawio.png.
