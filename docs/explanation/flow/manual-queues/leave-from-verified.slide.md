---
catzc:
  config:
    pattern: fact
    deck: manual-queues
    order: 10
    picture:
      mode: zoom
      source: ../../design/.assets/sync-point-rules-are-drs-only.drawio.png
      box: [250, 540, 700, 420]
      scale: 0.85
  edges:
    cites:
      - FDR-CD-LIFE-DIRTYHEADUNSAFE
      - FDR-CD-LIFE-FAILEDSTAYSUPSTREAM
---

# The next climb starts from the verified point, never from the dirty HEAD

## Eyebrow

10 / 10 · fact · FDR-CD-LIFE-DIRTYHEADUNSAFE

## Lead

Landing is not verifying. A commit that failed in main-UAT stays upstream and feeds nothing; the authoring queue's next clone leaves from
the last verified commit.

## Image

.assets/leave-from-verified.png

## Caption

Zoomed: the dirty HEAD under main-UAT, its failure path going up and stopping at the rung.

## Notes

Check it: docs/drs/flow/commit-lifecycle.md, rules DIRTYHEADUNSAFE and FAILEDSTAYSUPSTREAM.
