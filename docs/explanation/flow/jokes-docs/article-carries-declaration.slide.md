---
catzc:
  config:
    pattern: fact
    deck: jokes-docs
    order: 5
    picture:
      mode: reduce
      source: ../../design/.assets/merging-to-main-is-what-deploys.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-REPO-SLIDES
---

# A diagram's declaration lives in its article, directly above the image, like a caption that means it

## Eyebrow

5 / 10 · fact · ADR-REPO-SLIDES

## Lead

The article carrier is a yml drawio block above the image; the file carrier is a yml beside the png; drawio.yml records which.

## Image

.assets/article-carries-declaration.png

## Caption

From the catalogue, reduced: merging to main is what deploys.

## Notes

Check it: the record ADR-REPO-SLIDES in docs/drs/index.md, and the diagram docs/explanation/design/.assets/merging-to-main-is-what-deploys.drawio.png.
