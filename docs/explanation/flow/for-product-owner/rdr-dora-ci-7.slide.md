---
catzc:
  config:
    pattern: fact
    deck: for-product-owner
    order: 7
    picture:
      mode: reduce
      source: ../../design/.assets/every-file-in-exactly-one-aspect.drawio.png
      scale: 0.4
  edges:
    cites:
      - RDR-DORA-CI
---

# Continuous integration with a five to ten minute budget, enforced as a gate

## Eyebrow

7 / 30 · fact for the Product Owner · RDR-DORA-CI

## Lead

For the Product Owner, who wants small batches and visible work: BVT runs on every push to main; a run over its roof is a finding, and the roof is config.

## Image

.assets/rdr-dora-ci-7.png

## Caption

From the catalogue, reduced: every file in exactly one aspect.

## Notes

Check it: the record RDR-DORA-CI in docs/drs/index.md, and the diagram docs/explanation/design/.assets/every-file-in-exactly-one-aspect.drawio.png.
