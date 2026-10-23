---
catzc:
  config:
    pattern: fact
    deck: a-day-in-cats
    order: 1
    picture:
      mode: reduce
      source: ../../design/.assets/shims-set-roots-mode-read-back.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-REPO-AI
---

# A session starts by reading the records index, then the records that govern its files

## Eyebrow

1 / 12 · fact · ADR-REPO-AI

## Lead

The corpus is larger than a context window; the index names every code; a task reads only the records its files cite.

## Image

.assets/read-the-index-first.png

## Caption

From the catalogue, reduced: shims set roots mode read back.

## Notes

Check it: the record ADR-REPO-AI in docs/drs/index.md, and the diagram docs/explanation/design/.assets/shims-set-roots-mode-read-back.drawio.png.
