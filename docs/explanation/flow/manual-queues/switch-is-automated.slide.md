---
catzc:
  config:
    pattern: fact
    deck: manual-queues
    order: 8
    picture:
      mode: zoom
      source: ../.assets/manual-queues-1-where-a-person-stands.drawio.png
      box: [880, 100, 400, 240]
      scale: 1
  edges:
    cites:
      - FDR-CD-QUEUE-SLOTSWITCHISAUTOMATED
---

# Pre-prod and production trade places by an automated, monitored switch

## Eyebrow

8 / 10 · fact · FDR-CD-QUEUE-SLOTSWITCHISAUTOMATED

## Lead

Blue-green wherever possible: no person approves the switch, triggers it by hand or checks it on the way. It is watched while it runs and
reverses by the same automated path.

## Image

.assets/switch-is-automated.png

## Caption

Zoomed: the last three rungs, pre-prod, the switch and production; the switch is the rounded one, marked automated.

## Notes

Check it: docs/drs/flow/manual-queues.md, rule SLOTSWITCHISAUTOMATED.
