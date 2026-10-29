---
catzc:
  config:
    pattern: fact
    deck: manual-queues
    order: 10
    picture:
      mode: reduce
      source: ../../design/.assets/which-commit-a-sync-starts-from.drawio.png
      scale: 0.4
---

# The next climb starts from the verified point, never from the dirty HEAD

## Eyebrow

10 / 10 · fact · FDR-LIFE-DIRTYHEADUNSAFE

## Lead

Landing is not verifying. A commit that failed in main-UAT stays upstream and feeds nothing; the authoring queue's next clone leaves from
the last verified commit.

## Image

[leave-from-verified](.assets/leave-from-verified.png)

## Caption

Reduced: the integrator takes its commit from the BVT-verified head, also the main-UAT occupant, never from the dirty HEAD that failed
there.

## Notes

Check it: docs/drs/flow/commit-lifecycle.md, rules FDR-LIFE-DIRTYHEADUNSAFE and FDR-LIFE-LANDEDUNTILFAILED.
