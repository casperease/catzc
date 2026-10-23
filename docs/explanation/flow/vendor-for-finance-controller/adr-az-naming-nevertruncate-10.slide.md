---
catzc:
  config:
    pattern: fact
    deck: vendor-for-finance-controller
    order: 10
    picture:
      mode: reduce
      source: ../../configuration/.assets/callers-depend-on-one-config-module.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-NAMING-NEVERTRUNCATE
---

# Azure: a name that does not fit fails, it does not shrink

## Eyebrow

10 / 30 · fact for the Finance Controller · ADR-AZ-NAMING-NEVERTRUNCATE

## Lead

For the Finance Controller, who pays for every environment and every wait: The rule chooses an error over a silently shortened, colliding name.

## Image

.assets/adr-az-naming-nevertruncate-10.png

## Caption

From the catalogue, reduced: callers depend on one config module.

## Notes

Check it: the record ADR-AZ-NAMING-NEVERTRUNCATE in docs/drs/index.md, and the diagram docs/explanation/configuration/.assets/callers-depend-on-one-config-module.drawio.png.
