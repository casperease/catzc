---
catzc:
  config:
    pattern: fact
    deck: manual-queues
    order: 1
    picture:
      mode: redraw
      source: ../.assets/manual-queues-1-where-a-person-stands.drawio.png
      variation: ladder-strip
      scale: 1
      words:
        {
          g-authoring: author,
          c-main: main,
          g-bvt: BVT,
          e-main-uat: mainUAT,
          g-rc: RC-sign,
          e-release-uat: rel-uat,
          g-rbc: RBC-sign,
          e-pre-prod: pre-prod,
          r-switch: switch,
          e-production: prod,
        }
      moves: [merge, test, deploy, sign, deploy, sign, deploy, swap, live]
---

# A commit waits for a person in exactly three places on the ladder

## Eyebrow

1 / 10 · fact · FDR-CD-QUEUE-THREEQUEUES

## Lead

Authoring before main, one signature after main-UAT, one signature after release-uat. Every other climb runs on its own. Each queue has a
named server, a named store and a measured wait.

## Image

.assets/three-queues.png

## Caption

The ten rungs redrawn as a strip: diamonds are gates (author, RC-sign and RBC-sign the manual ones, BVT the code one), hexagons are
environments, the rounded rung is the automated switch; each climb carries its move.

## Notes

Check it: docs/drs/flow/manual-queues.md, rule THREEQUEUES. Count the diamonds marked manual on the ladder diagram: three.
