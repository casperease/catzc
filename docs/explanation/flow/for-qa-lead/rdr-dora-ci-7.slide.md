---
catzc:
  config:
    pattern: fact
    deck: for-qa-lead
    order: 7
    picture:
      mode: reduce
      source: ../../design/.assets/which-rung-gates-exist-in-code.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
  edges:
    cites:
      - RDR-DORA-CI
---

# Continuous integration with a five to ten minute budget, enforced as a gate

## Eyebrow

7 / 30 · fact for the QA Lead · RDR-DORA-CI

## Lead

For the QA Lead, who owns the test levels and their roofs: BVT runs on every push to main; a run over its roof is a finding, and the roof is config.

## Image

.assets/rdr-dora-ci-7.png

## Caption

From the catalogue, reduced: which rung gates exist in code.

## Notes

Check it: the record RDR-DORA-CI in docs/drs/index.md, and the diagram docs/explanation/design/.assets/which-rung-gates-exist-in-code.drawio.png.
