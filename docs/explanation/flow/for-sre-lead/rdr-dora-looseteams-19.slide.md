---
catzc:
  config:
    pattern: fact
    deck: for-sre-lead
    order: 19
    picture:
      mode: reduce
      source: ../../automation/.assets/build-verify-then-copy-the-folder.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
  edges:
    cites:
      - RDR-DORA-LOOSETEAMS
---

# Loosely coupled teams: every deployable unit versions and releases on its own

## Eyebrow

19 / 30 · fact for the SRE Lead · RDR-DORA-LOOSETEAMS

## Lead

For the SRE Lead, who owns reliability, monitoring and the switch: cats is a mono repo, not a monolith; there is no repo-wide freeze or release train.

## Image

.assets/rdr-dora-looseteams-19.png

## Caption

From the catalogue, reduced: build verify then copy the folder.

## Notes

Check it: the record RDR-DORA-LOOSETEAMS in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/build-verify-then-copy-the-folder.drawio.png.
