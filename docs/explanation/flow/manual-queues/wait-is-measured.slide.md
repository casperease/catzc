---
catzc:
  config:
    pattern: fact
    deck: manual-queues
    order: 7
    picture:
      mode: redraw
      source: ../.assets/manual-queues-1-where-a-person-stands.drawio.png
      variation: ladder-strip
      scale: 1
      rotate: -6
      words:
        {
          g-authoring: wait-1,
          c-main: main,
          g-bvt: BVT,
          e-main-uat: mainUAT,
          g-rc: wait-2,
          e-release-uat: rel-uat,
          g-rbc: wait-3,
          e-pre-prod: pre-prod,
          r-switch: switch,
          e-production: prod,
        }
      moves: [merge, test, deploy, signed, deploy, signed, deploy, swap, live]
---

# Every queue's wait is read from its store, arrival to recorded act

## Eyebrow

7 / 10 · fact · FDR-QUEUE-THREEQUEUES

## Lead

Authoring: from the first edit to the merge in the server's history. A signature: from the rung's test passing to the signature landing in
the registry. The store holds both ends, so the wait is a number, not a feeling.

## Image

[wait-is-measured](.assets/wait-is-measured.png)

## Caption

Redrawn and turned: wait-1, wait-2 and wait-3 are the three measured waits; everything between them runs on its own.

## Notes

Check it: docs/drs/flow/manual-queues.md, rule THREEQUEUES, "a measured wait".
