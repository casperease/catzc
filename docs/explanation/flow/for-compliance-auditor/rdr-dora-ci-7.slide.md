---
catzc:
  config:
    pattern: fact
    deck: for-compliance-auditor
    order: 7
    picture:
      mode: reduce
      source: ../../design/.assets/10-commits-story.drawio.png
      scale: 0.4
  edges:
    cites:
      - RDR-DORA-CI
---

# Continuous integration with a five to ten minute budget, enforced as a gate

## Eyebrow

7 / 30 · fact for the Compliance Auditor · RDR-DORA-CI

## Lead

For the Compliance Auditor, who reads the history and the registry: BVT runs on every push to main; a run over its roof is a finding, and the roof is config.

## Image

.assets/rdr-dora-ci-7.png

## Caption

From the catalogue, reduced: 10 commits story.

## Notes

Check it: the record RDR-DORA-CI in docs/drs/index.md, and the diagram docs/explanation/design/.assets/10-commits-story.drawio.png.
