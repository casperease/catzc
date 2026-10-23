---
catzc:
  config:
    pattern: fact
    deck: for-developer
    order: 14
    picture:
      mode: reduce
      source: ../../automation/.assets/every-entry-runs-one-load-sequence.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
  edges:
    cites:
      - RDR-DORA-SECURITY
---

# Pervasive security: identity and branch policy are the server's, and the clone has none

## Eyebrow

14 / 30 · fact for the Developer · RDR-DORA-SECURITY

## Lead

For the Developer, who edits one file, runs one gate, pushes one topic: The pull request authenticates the author and merges the server's own topic HEAD; a bypass is authorized and recorded.

## Image

.assets/rdr-dora-security-14.png

## Caption

From the catalogue, reduced: every entry runs one load sequence.

## Notes

Check it: the record RDR-DORA-SECURITY in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/every-entry-runs-one-load-sequence.drawio.png.
