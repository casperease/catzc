---
catzc:
  config:
    pattern: fact
    deck: gates-and-robots
    order: 13
    picture:
      mode: reduce
      source: ../../configuration/.assets/one-gate-guards-the-read-path.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
---

# Heavy runs serialise on one run lock, taken before the import

## Eyebrow

13 / 14 · fact · ADR-AUTO-FAILFAST

## Lead

There is no turn-taking queue between sessions; the lock keeps two full imports from colliding, and momentum stays with whoever holds it.

## Image

.assets/run-lock-serialises.png

## Caption

From the catalogue, reduced: one gate guards the read path.

## Notes

Check it: the record ADR-AUTO-FAILFAST in docs/drs/index.md, and the diagram
docs/explanation/configuration/.assets/one-gate-guards-the-read-path.drawio.png.
