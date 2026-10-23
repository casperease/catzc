---
catzc:
  config:
    pattern: fact
    deck: vendor-for-product-owner
    order: 22
    picture:
      mode: reduce
      source: ../../flow/.assets/peers-in-a-layer-never-overlap.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
  edges:
    cites:
      - ADR-AZ-CAF-NAME
---

# Azure CAF naming: one standard, one builder, one gate

## Eyebrow

22 / 30 · fact for the Product Owner · ADR-AZ-CAF-NAME

## Lead

For the Product Owner, who wants small batches and visible work: The naming standard is a record; the builder is code; a gate checks every name.

## Image

.assets/adr-az-caf-name-22.png

## Caption

From the catalogue, reduced: peers in a layer never overlap.

## Notes

Check it: the record ADR-AZ-CAF-NAME in docs/drs/index.md, and the diagram docs/explanation/flow/.assets/peers-in-a-layer-never-overlap.drawio.png.
