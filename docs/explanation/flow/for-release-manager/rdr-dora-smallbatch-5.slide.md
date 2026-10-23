---
catzc:
  config:
    pattern: fact
    deck: for-release-manager
    order: 5
    picture:
      mode: reduce
      source: ../../design/.assets/state-changes.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
  edges:
    cites:
      - RDR-DORA-SMALLBATCH
---

# Working in small batches: one change, one commit, one artifact

## Eyebrow

5 / 30 · fact for the Release Manager · RDR-DORA-SMALLBATCH

## Lead

For the Release Manager, who serves the signatures and watches the ladder: The batch is the unit the mainline records, judges, promotes and reverts.

## Image

.assets/rdr-dora-smallbatch-5.png

## Caption

From the catalogue, reduced: state changes.

## Notes

Check it: the record RDR-DORA-SMALLBATCH in docs/drs/index.md, and the diagram docs/explanation/design/.assets/state-changes.drawio.png.
