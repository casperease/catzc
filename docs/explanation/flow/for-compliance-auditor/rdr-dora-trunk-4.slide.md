---
catzc:
  config:
    pattern: fact
    deck: for-compliance-auditor
    order: 4
    picture:
      mode: reduce
      source: ../../automation/.assets/one-out-string-two-places.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
  edges:
    cites:
      - RDR-DORA-TRUNK
---

# Trunk-based development: one main, short-lived topics, one squashed commit each

## Eyebrow

4 / 30 · fact for the Compliance Auditor · RDR-DORA-TRUNK

## Lead

For the Compliance Auditor, who reads the history and the registry: A topic rebases onto the sync point and lands as one commit; main is a readable list of small changes.

## Image

.assets/rdr-dora-trunk-4.png

## Caption

From the catalogue, reduced: one out string two places.

## Notes

Check it: the record RDR-DORA-TRUNK in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/one-out-string-two-places.drawio.png.
