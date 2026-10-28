---
catzc:
  config:
    pattern: fact
    deck: manual-queues
    order: 5
    picture:
      mode: redraw
      source: ../.assets/manual-queues-1-where-a-person-stands.drawio.png
      variation: ladder-strip
      scale: 1
      tilt: { y: 0.7, shear: 0.2 }
      words:
        {
          g-authoring: author,
          c-main: main,
          g-bvt: BVT,
          e-main-uat: mainUAT,
          g-rc: SIGN-1,
          e-release-uat: rel-uat,
          g-rbc: SIGN-2,
          e-pre-prod: pre-prod,
          r-switch: switch,
          e-production: prod,
        }
      moves: [merge, test, deploy, passed, deploy, passed, deploy, swap, live]
---

# RC and RBC are each one signature, after the test proved the service loads

## Eyebrow

5 / 10 · fact · FDR-QUEUE-SIGNATUREISTHEGATE

## Lead

The post-deployment test runs on its own and is the evidence. A user with access then enters one signature in the appointed security
registry: "main-UAT passed its check", then "release-uat passed its check".

## Image

[signature-is-the-gate](.assets/signature-is-the-gate.png)

## Caption

Redrawn and tilted: SIGN-1 and SIGN-2 are the two signatures; the climb into each is marked passed, the test that came first.

## Notes

Check it: docs/drs/flow/manual-queues.md, rule SIGNATUREISTHEGATE.
