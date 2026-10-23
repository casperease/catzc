---
catzc:
  config:
    pattern: fact
    deck: vendor-for-release-manager
    order: 12
    picture:
      mode: reduce
      source: ../../configuration/.assets/callers-depend-on-one-config-module.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-LZ
---

# Azure: the landing zone is declared, not clicked

## Eyebrow

12 / 30 · fact for the Release Manager · ADR-AZ-LZ

## Lead

For the Release Manager, who serves the signatures and watches the ladder: Subscriptions, resource groups and policies are code that climbs the same ladder.

## Image

.assets/adr-az-lz-12.png

## Caption

From the catalogue, reduced: callers depend on one config module.

## Notes

Check it: the record ADR-AZ-LZ in docs/drs/index.md, and the diagram docs/explanation/configuration/.assets/callers-depend-on-one-config-module.drawio.png.
