---
catzc:
  config:
    pattern: fact
    deck: delivery-ladder
    order: 8
    picture:
      mode: reduce
      source: ../../../drs/flow/.assets/sync-point.drawio.png
      scale: 0.4
---

# The dirty HEAD is never a source to sync from

## Eyebrow

8 / 12 · fact · FDR-LIFE

## Lead

Landing is not verifying: a commit that failed downstream stays upstream, and consumers leave from the last verified commit.

## Image

[dirty-head-unsafe](.assets/dirty-head-unsafe.png)

## Caption

From the catalogue, reduced: sync point.

## Notes

Check it: the record FDR-LIFE in docs/drs/index.md, and the diagram docs/drs/flow/.assets/sync-point.drawio.png.
