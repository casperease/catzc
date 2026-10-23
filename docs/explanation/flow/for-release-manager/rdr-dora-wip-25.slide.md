---
catzc:
  config:
    pattern: fact
    deck: for-release-manager
    order: 25
    picture:
      mode: reduce
      source: ../../automation/.assets/build-then-place-with-one-command.drawio.png
      scale: 0.4
      rotate: -4
  edges:
    cites:
      - RDR-DORA-WIP
---

# WIP limits: one occupant per environment, and the next commit waits on the rung below

## Eyebrow

25 / 30 · fact for the Release Manager · RDR-DORA-WIP

## Lead

For the Release Manager, who serves the signatures and watches the ladder: An environment holds one commit plus a history; a second occupant is not a thing.

## Image

.assets/rdr-dora-wip-25.png

## Caption

From the catalogue, reduced: build then place with one command.

## Notes

Check it: the record RDR-DORA-WIP in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/build-then-place-with-one-command.drawio.png.
