---
catzc:
  config:
    pattern: fact
    deck: vendor-for-product-owner
    order: 10
    picture:
      mode: reduce
      source: ../../flow/.assets/globs-asks-loader-for-context-and-git-for-diff.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
  edges:
    cites:
      - ADR-AZ-NAMING-NEVERTRUNCATE
---

# Azure: a name that does not fit fails, it does not shrink

## Eyebrow

10 / 30 · fact for the Product Owner · ADR-AZ-NAMING-NEVERTRUNCATE

## Lead

For the Product Owner, who wants small batches and visible work: The rule chooses an error over a silently shortened, colliding name.

## Image

.assets/adr-az-naming-nevertruncate-10.png

## Caption

From the catalogue, reduced: globs asks loader for context and git for diff.

## Notes

Check it: the record ADR-AZ-NAMING-NEVERTRUNCATE in docs/drs/index.md, and the diagram docs/explanation/flow/.assets/globs-asks-loader-for-context-and-git-for-diff.drawio.png.
