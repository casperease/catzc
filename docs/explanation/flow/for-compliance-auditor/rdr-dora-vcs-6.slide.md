---
catzc:
  config:
    pattern: fact
    deck: for-compliance-auditor
    order: 6
    picture:
      mode: reduce
      source: ../../automation/.assets/one-rule-per-stage-and-two-gaps.drawio.png
      scale: 0.4
      rotate: -4
  edges:
    cites:
      - RDR-DORA-VCS
---

# Version control holds everything: code, config, pipelines, records and diagrams

## Eyebrow

6 / 30 · fact for the Compliance Auditor · RDR-DORA-VCS

## Lead

For the Compliance Auditor, who reads the history and the registry: Nothing delivery depends on lives outside the repository; history is git log, never a retained file.

## Image

.assets/rdr-dora-vcs-6.png

## Caption

From the catalogue, reduced: one rule per stage and two gaps.

## Notes

Check it: the record RDR-DORA-VCS in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/one-rule-per-stage-and-two-gaps.drawio.png.
