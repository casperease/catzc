---
catzc:
  config:
    pattern: fact
    deck: for-security-officer
    order: 25
    picture:
      mode: reduce
      source: ../../design/.assets/gate-checks-order-not-liveness.drawio.png
      scale: 0.4
  edges:
    cites:
      - RDR-DORA-WIP
---

# WIP limits: one occupant per environment, and the next commit waits on the rung below

## Eyebrow

25 / 30 · fact for the Security Officer · RDR-DORA-WIP

## Lead

For the Security Officer, who owns identity, policy and the audit trail: An environment holds one commit plus a history; a second occupant is not a thing.

## Image

.assets/rdr-dora-wip-25.png

## Caption

From the catalogue, reduced: gate checks order not liveness.

## Notes

Check it: the record RDR-DORA-WIP in docs/drs/index.md, and the diagram docs/explanation/design/.assets/gate-checks-order-not-liveness.drawio.png.
