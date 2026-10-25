---
catzc:
  config:
    pattern: fact
    deck: delivery-ladder
    order: 1
    picture:
      mode: reduce
      source: ../../design/.assets/each-track-picks-its-catch-all.drawio.png
      scale: 0.4
---

# A topic takes upstream changes by rebasing onto the sync point, never by merging main into it

## Eyebrow

1 / 12 · fact · FDR-GIT

## Lead

A rebase keeps the topic a straight line of its own commits on one server commit; a merge of main in brings other people's changes along.

## Image

.assets/topic-syncs-by-rebase.png

## Caption

From the catalogue, reduced: each track picks its catch all.

## Notes

Check it: the record FDR-GIT in docs/drs/index.md, and the diagram
docs/explanation/design/.assets/each-track-picks-its-catch-all.drawio.png.
