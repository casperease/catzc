---
catzc:
  config:
    pattern: fact
    deck: things-that-are-not
    order: 7
    picture:
      mode: reduce
      source: ../../flow/.assets/edit-globs-yml-then-read-the-output.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
  edges:
    cites:
      - ADR-AUTO-PKGMGR
---

# Nothing in the tree contacts a package feed outside the tooling

## Eyebrow

7 / 12 · fact · ADR-AUTO-PKGMGR

## Lead

Dependencies are the base class library or vendored under .vendor; an offline guard config is generated, not hand-kept.

## Image

.assets/not-a-package-feed.png

## Caption

From the catalogue, reduced: edit globs yml then read the output.

## Notes

Check it: the record ADR-AUTO-PKGMGR in docs/drs/index.md, and the diagram docs/explanation/flow/.assets/edit-globs-yml-then-read-the-output.drawio.png.
