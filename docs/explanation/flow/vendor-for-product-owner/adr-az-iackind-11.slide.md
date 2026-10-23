---
catzc:
  config:
    pattern: fact
    deck: vendor-for-product-owner
    order: 11
    picture:
      mode: reduce
      source: ../../flow/.assets/tests-pin-the-throw-and-fail-open-cd-calls-it.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-IACKIND
---

# Azure: infrastructure as code comes in three kinds, templates, configs and modules

## Eyebrow

11 / 30 · fact for the Product Owner · ADR-AZ-IACKIND

## Lead

For the Product Owner, who wants small batches and visible work: A kind says where a file lives and what reads it; a template is filled by a config slot.

## Image

.assets/adr-az-iackind-11.png

## Caption

From the catalogue, reduced: tests pin the throw and fail open cd calls it.

## Notes

Check it: the record ADR-AZ-IACKIND in docs/drs/index.md, and the diagram docs/explanation/flow/.assets/tests-pin-the-throw-and-fail-open-cd-calls-it.drawio.png.
