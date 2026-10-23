---
catzc:
  config:
    pattern: fact
    deck: a-day-in-cats
    order: 12
    picture:
      mode: reduce
      source: ../../flow/.assets/a-merge-runs-cd-to-prod.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-REPO-SLIDES
---

# Every claim on a slide is checkable, and Test-Slides checks these twelve

## Eyebrow

12 / 12 · fact · ADR-REPO-SLIDES

## Lead

The verification slide: each cited code exists in the records index, each field's text is found in the render, and the order has no gap.

## Image

.assets/day-deck-is-checked.png

## Caption

From the catalogue, reduced: a merge runs cd to prod.

## Notes

Check it: the record ADR-REPO-SLIDES in docs/drs/index.md, and the diagram docs/explanation/flow/.assets/a-merge-runs-cd-to-prod.drawio.png.
