---
catzc:
  config:
    pattern: fact
    deck: for-sre-lead
    order: 7
    picture:
      mode: reduce
      source: ../../../../docs/drs/flow/.assets/commit-promotion-states.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
  edges:
    cites:
      - RDR-DORA-CI
---

# Continuous integration with a five to ten minute budget, enforced as a gate

## Eyebrow

7 / 30 · fact for the SRE Lead · RDR-DORA-CI

## Lead

For the SRE Lead, who owns reliability, monitoring and the switch: BVT runs on every push to main; a run over its roof is a finding, and the roof is config.

## Image

.assets/rdr-dora-ci-7.png

## Caption

From the catalogue, reduced: commit promotion states.

## Notes

Check it: the record RDR-DORA-CI in docs/drs/index.md, and the diagram docs/drs/flow/.assets/commit-promotion-states.drawio.png.
