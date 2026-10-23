---
catzc:
  config:
    pattern: fact
    deck: for-qa-lead
    order: 4
    picture:
      mode: reduce
      source: ../../design/.assets/what-keeps-the-platform-thin.drawio.png
      scale: 0.4
  edges:
    cites:
      - RDR-DORA-TRUNK
---

# Trunk-based development: one main, short-lived topics, one squashed commit each

## Eyebrow

4 / 30 · fact for the QA Lead · RDR-DORA-TRUNK

## Lead

For the QA Lead, who owns the test levels and their roofs: A topic rebases onto the sync point and lands as one commit; main is a readable list of small changes.

## Image

.assets/rdr-dora-trunk-4.png

## Caption

From the catalogue, reduced: what keeps the platform thin.

## Notes

Check it: the record RDR-DORA-TRUNK in docs/drs/index.md, and the diagram docs/explanation/design/.assets/what-keeps-the-platform-thin.drawio.png.
