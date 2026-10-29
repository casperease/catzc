---
catzc:
  config:
    pattern: fact
    deck: gates-and-robots
    order: 13
    picture:
      mode: reduce
      source: ../../automation/.assets/what-a-run-stopped-by-its-limit-reports.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
---

# Heavy runs serialise on one run lock, taken before the import

## Eyebrow

13 / 14 · fact · ADR-AUTO-FAILFAST

## Lead

There is no turn-taking queue between sessions; the lock keeps two full imports from colliding, and momentum stays with whoever holds it.

## Image

[run-lock-serialises](.assets/run-lock-serialises.png)

## Caption

From the catalogue, reduced: a stopped run names its limit.

## Notes

Check it: the record ADR-AUTO-FAILFAST in docs/drs/index.md, and the diagram
docs/explanation/automation/.assets/what-a-run-stopped-by-its-limit-reports.drawio.png.
