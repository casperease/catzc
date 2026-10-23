---
catzc:
  config:
    pattern: fact
    deck: vendor-for-head-of-platform
    order: 10
    picture:
      mode: reduce
      source: ../../design/.assets/engineer-merges-pipelines-do-the-rest.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
  edges:
    cites:
      - ADR-AZ-NAMING-NEVERTRUNCATE
---

# Azure: a name that does not fit fails, it does not shrink

## Eyebrow

10 / 30 · fact for the Head of Platform · ADR-AZ-NAMING-NEVERTRUNCATE

## Lead

For the Head of Platform, who runs the platform other teams build on: The rule chooses an error over a silently shortened, colliding name.

## Image

.assets/adr-az-naming-nevertruncate-10.png

## Caption

From the catalogue, reduced: engineer merges pipelines do the rest.

## Notes

Check it: the record ADR-AZ-NAMING-NEVERTRUNCATE in docs/drs/index.md, and the diagram docs/explanation/design/.assets/engineer-merges-pipelines-do-the-rest.drawio.png.
