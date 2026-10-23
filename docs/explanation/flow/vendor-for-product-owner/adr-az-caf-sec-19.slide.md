---
catzc:
  config:
    pattern: fact
    deck: vendor-for-product-owner
    order: 19
    picture:
      mode: reduce
      source: ../../azure/.assets/how-each-naming-rule-is-held.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-CAF-SEC
---

# Azure CAF security: secrets are injected at deploy time and never stored in the tree

## Eyebrow

19 / 30 · fact for the Product Owner · ADR-AZ-CAF-SEC

## Lead

For the Product Owner, who wants small batches and visible work: The repository holds a template through BVT; the value arrives only at deploy.

## Image

.assets/adr-az-caf-sec-19.png

## Caption

From the catalogue, reduced: how each naming rule is held.

## Notes

Check it: the record ADR-AZ-CAF-SEC in docs/drs/index.md, and the diagram docs/explanation/azure/.assets/how-each-naming-rule-is-held.drawio.png.
