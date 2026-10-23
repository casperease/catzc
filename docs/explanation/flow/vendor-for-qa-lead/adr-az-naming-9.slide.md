---
catzc:
  config:
    pattern: fact
    deck: vendor-for-qa-lead
    order: 9
    picture:
      mode: reduce
      source: ../../flow/.assets/independence-check-groups-by-layer.drawio.png
      scale: 0.4
      rotate: -4
  edges:
    cites:
      - ADR-AZ-NAMING
---

# Azure: every resource name is built by one naming standard and is never truncated

## Eyebrow

9 / 30 · fact for the QA Lead · ADR-AZ-NAMING

## Lead

For the QA Lead, who owns the test levels and their roofs: Each naming rule is held in one place; a name that would truncate is a finding, not a shorter name.

## Image

.assets/adr-az-naming-9.png

## Caption

From the catalogue, reduced: independence check groups by layer.

## Notes

Check it: the record ADR-AZ-NAMING in docs/drs/index.md, and the diagram docs/explanation/flow/.assets/independence-check-groups-by-layer.drawio.png.
