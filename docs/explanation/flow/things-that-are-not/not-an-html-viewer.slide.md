---
catzc:
  config:
    pattern: fact
    deck: things-that-are-not
    order: 5
    picture:
      mode: reduce
      source: ../../design/.assets/deploy-bicep-delegates-to-az.drawio.png
      scale: 0.4
      rotate: -4
  edges:
    cites:
      - ADR-REPO-SLIDES
---

# A review bundle is a PDF or a PNG, never a local HTML page

## Eyebrow

5 / 12 · fact · ADR-REPO-SLIDES

## Lead

The gallery PDF and the slide render are what a person reads; the HTML project tree is what the artifact type takes, by hand.

## Image

.assets/not-an-html-viewer.png

## Caption

From the catalogue, reduced: deploy bicep delegates to az.

## Notes

Check it: the record ADR-REPO-SLIDES in docs/drs/index.md, and the diagram docs/explanation/design/.assets/deploy-bicep-delegates-to-az.drawio.png.
