---
catzc:
  config:
    pattern: fact
    deck: jokes-git
    order: 7
    picture:
      mode: reduce
      source: ../../flow/.assets/one-program-two-vendor-dialects.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
  edges:
    cites:
      - ADR-REPO-AI
---

# Status, log, diff and blame are read-only; the robot runs them the way Mildred from Finance reads receipts

## Eyebrow

7 / 10 · fact · ADR-REPO-AI

## Lead

Git is a read-only probe of the tree for every robot; nothing a robot runs changes the index or the history.

## Image

.assets/read-only-probes.png

## Caption

From the catalogue, reduced: one program two vendor dialects.

## Notes

Check it: the record ADR-REPO-AI in docs/drs/index.md, and the diagram docs/explanation/flow/.assets/one-program-two-vendor-dialects.drawio.png.
