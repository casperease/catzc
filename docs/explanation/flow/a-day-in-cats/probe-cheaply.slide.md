---
catzc:
  config:
    pattern: fact
    deck: a-day-in-cats
    order: 2
    picture:
      mode: reduce
      source: ../../automation/.assets/a-declared-allow-list-of-layers.drawio.png
      scale: 0.4
      rotate: -4
  edges:
    cites:
      - ADR-AUTO-FAILFAST
---

# A probe uses the cheapest runner: a file read before a shell, a shell before the importer

## Eyebrow

2 / 12 · fact · ADR-AUTO-FAILFAST

## Lead

The importer is dot-sourced and heavy; a question about state is answered by cat, ls, grep or git, read-only.

## Image

.assets/probe-cheaply.png

## Caption

From the catalogue, reduced: a declared allow list of layers.

## Notes

Check it: the record ADR-AUTO-FAILFAST in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/a-declared-allow-list-of-layers.drawio.png.
