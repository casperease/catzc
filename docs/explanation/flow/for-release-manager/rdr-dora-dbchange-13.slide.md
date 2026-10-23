---
catzc:
  config:
    pattern: fact
    deck: for-release-manager
    order: 13
    picture:
      mode: reduce
      source: ../../flow/.assets/peers-in-a-layer-never-overlap.drawio.png
      scale: 0.4
      rotate: -4
  edges:
    cites:
      - RDR-DORA-DBCHANGE
---

# Database and config change travel in the same commit as the code

## Eyebrow

13 / 30 · fact for the Release Manager · RDR-DORA-DBCHANGE

## Lead

For the Release Manager, who serves the signatures and watches the ladder: A config entry is a catalogue item; it climbs the same ladder, in the same artifact.

## Image

.assets/rdr-dora-dbchange-13.png

## Caption

From the catalogue, reduced: peers in a layer never overlap.

## Notes

Check it: the record RDR-DORA-DBCHANGE in docs/drs/index.md, and the diagram docs/explanation/flow/.assets/peers-in-a-layer-never-overlap.drawio.png.
