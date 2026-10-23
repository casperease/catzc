---
catzc:
  config:
    pattern: fact
    deck: vendor-for-product-owner
    order: 12
    picture:
      mode: reduce
      source: ../../configuration/.assets/callers-in-four-modules-share-one-resolver.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
  edges:
    cites:
      - ADR-AZ-LZ
---

# Azure: the landing zone is declared, not clicked

## Eyebrow

12 / 30 · fact for the Product Owner · ADR-AZ-LZ

## Lead

For the Product Owner, who wants small batches and visible work: Subscriptions, resource groups and policies are code that climbs the same ladder.

## Image

.assets/adr-az-lz-12.png

## Caption

From the catalogue, reduced: callers in four modules share one resolver.

## Notes

Check it: the record ADR-AZ-LZ in docs/drs/index.md, and the diagram docs/explanation/configuration/.assets/callers-in-four-modules-share-one-resolver.drawio.png.
