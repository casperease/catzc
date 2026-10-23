---
catzc:
  config:
    pattern: fact
    deck: for-cto
    order: 4
    picture:
      mode: reduce
      source: ../../design/.assets/unit-to-pipeline-rule-is-review-only.drawio.png
      scale: 0.4
  edges:
    cites:
      - RDR-DORA-TRUNK
---

# Trunk-based development: one main, short-lived topics, one squashed commit each

## Eyebrow

4 / 30 · fact for the CTO · RDR-DORA-TRUNK

## Lead

For the CTO, who owns the delivery system and its cost: A topic rebases onto the sync point and lands as one commit; main is a readable list of small changes.

## Image

.assets/rdr-dora-trunk-4.png

## Caption

From the catalogue, reduced: unit to pipeline rule is review only.

## Notes

Check it: the record RDR-DORA-TRUNK in docs/drs/index.md, and the diagram docs/explanation/design/.assets/unit-to-pipeline-rule-is-review-only.drawio.png.
