---
catzc:
  config:
    pattern: fact
    deck: jokes-config
    order: 3
    picture:
      mode: reduce
      source: ../../design/.assets/every-file-in-exactly-one-aspect.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-REPO-SLIDES
---

# The slide kit has no magic numbers, only slides.yml, which is magic in the lawful sense

## Eyebrow

3 / 10 · fact · ADR-REPO-SLIDES

## Lead

Tones, faces, the type scale, the layout and the picture sizes are declared once in the kit; the renderer reads them.

## Image

.assets/slides-yml-no-magic.png

## Caption

From the catalogue, reduced: every file in exactly one aspect.

## Notes

Check it: the record ADR-REPO-SLIDES in docs/drs/index.md, and the diagram docs/explanation/design/.assets/every-file-in-exactly-one-aspect.drawio.png.
