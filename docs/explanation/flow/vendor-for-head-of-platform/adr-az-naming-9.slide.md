---
catzc:
  config:
    pattern: fact
    deck: vendor-for-head-of-platform
    order: 9
    picture:
      mode: reduce
      source: ../../flow/.assets/print-projection-then-drift-names-the-filter.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-NAMING
---

# Azure: every resource name is built by one naming standard and is never truncated

## Eyebrow

9 / 30 · fact for the Head of Platform · ADR-AZ-NAMING

## Lead

For the Head of Platform, who runs the platform other teams build on: Each naming rule is held in one place; a name that would truncate is a finding, not a shorter name.

## Image

.assets/adr-az-naming-9.png

## Caption

From the catalogue, reduced: print projection then drift names the filter.

## Notes

Check it: the record ADR-AZ-NAMING in docs/drs/index.md, and the diagram docs/explanation/flow/.assets/print-projection-then-drift-names-the-filter.drawio.png.
