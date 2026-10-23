---
catzc:
  config:
    pattern: fact
    deck: vendor-for-product-owner
    order: 9
    picture:
      mode: reduce
      source: ../../configuration/.assets/type-an-address-get-the-value.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-NAMING
---

# Azure: every resource name is built by one naming standard and is never truncated

## Eyebrow

9 / 30 · fact for the Product Owner · ADR-AZ-NAMING

## Lead

For the Product Owner, who wants small batches and visible work: Each naming rule is held in one place; a name that would truncate is a finding, not a shorter name.

## Image

.assets/adr-az-naming-9.png

## Caption

From the catalogue, reduced: type an address get the value.

## Notes

Check it: the record ADR-AZ-NAMING in docs/drs/index.md, and the diagram docs/explanation/configuration/.assets/type-an-address-get-the-value.drawio.png.
