---
catzc:
  config:
    pattern: fact
    deck: for-finance-controller
    order: 4
    picture:
      mode: reduce
      source: ../../automation/.assets/one-resolver-every-consumer-but-the-hook.drawio.png
      scale: 0.4
  edges:
    cites:
      - RDR-DORA-TRUNK
---

# Trunk-based development: one main, short-lived topics, one squashed commit each

## Eyebrow

4 / 30 · fact for the Finance Controller · RDR-DORA-TRUNK

## Lead

For the Finance Controller, who pays for every environment and every wait: A topic rebases onto the sync point and lands as one commit; main is a readable list of small changes.

## Image

.assets/rdr-dora-trunk-4.png

## Caption

From the catalogue, reduced: one resolver every consumer but the hook.

## Notes

Check it: the record RDR-DORA-TRUNK in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/one-resolver-every-consumer-but-the-hook.drawio.png.
