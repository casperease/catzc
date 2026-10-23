---
catzc:
  config:
    pattern: fact
    deck: vendor-for-qa-lead
    order: 10
    picture:
      mode: reduce
      source: ../../automation/.assets/dot-source-one-entry-script.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-NAMING-NEVERTRUNCATE
---

# Azure: a name that does not fit fails, it does not shrink

## Eyebrow

10 / 30 · fact for the QA Lead · ADR-AZ-NAMING-NEVERTRUNCATE

## Lead

For the QA Lead, who owns the test levels and their roofs: The rule chooses an error over a silently shortened, colliding name.

## Image

.assets/adr-az-naming-nevertruncate-10.png

## Caption

From the catalogue, reduced: dot source one entry script.

## Notes

Check it: the record ADR-AZ-NAMING-NEVERTRUNCATE in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/dot-source-one-entry-script.drawio.png.
