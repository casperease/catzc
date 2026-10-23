---
catzc:
  config:
    pattern: fact
    deck: things-that-are-not
    order: 12
    picture:
      mode: reduce
      source: ../../automation/.assets/rule-and-gate-per-load-stage.drawio.png
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

.assets/not-deck-is-checked.png

## Caption

From the catalogue, reduced: rule and gate per load stage.

## Notes

Check it: the record ADR-REPO-SLIDES in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/rule-and-gate-per-load-stage.drawio.png.
