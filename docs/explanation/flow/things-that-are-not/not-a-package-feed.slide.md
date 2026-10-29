---
catzc:
  config:
    pattern: fact
    deck: things-that-are-not
    order: 7
    picture:
      mode: reduce
      source: ../../../references/pwsh/.assets/how-a-devbox-tool-gets-installed.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
---

# Nothing in the tree contacts a package feed outside the tooling

## Eyebrow

7 / 12 · fact · ADR-AUTO-PKGMGR

## Lead

Dependencies are the base class library or vendored under .vendor; an offline guard config is generated, not hand-kept.

## Image

[not-a-package-feed](.assets/not-a-package-feed.png)

## Caption

From the catalogue, reduced: tools yml install dispatch.

## Notes

Check it: the record ADR-AUTO-PKGMGR in docs/drs/index.md, and the diagram
docs/references/pwsh/.assets/how-a-devbox-tool-gets-installed.drawio.png.
