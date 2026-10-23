---
catzc:
  config:
    pattern: fact
    deck: for-head-of-platform
    order: 4
    picture:
      mode: reduce
      source: ../../repository/.assets/a-base-module-between-config-and-its-callers.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
  edges:
    cites:
      - RDR-DORA-TRUNK
---

# Trunk-based development: one main, short-lived topics, one squashed commit each

## Eyebrow

4 / 30 · fact for the Head of Platform · RDR-DORA-TRUNK

## Lead

For the Head of Platform, who runs the platform other teams build on: A topic rebases onto the sync point and lands as one commit; main is a readable list of small changes.

## Image

.assets/rdr-dora-trunk-4.png

## Caption

From the catalogue, reduced: a base module between config and its callers.

## Notes

Check it: the record RDR-DORA-TRUNK in docs/drs/index.md, and the diagram docs/explanation/repository/.assets/a-base-module-between-config-and-its-callers.drawio.png.
