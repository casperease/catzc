---
catzc:
  config:
    pattern: fact
    deck: vendor-for-product-owner
    order: 30
    picture:
      mode: reduce
      source: ../../design/.assets/local-guard-and-server-policies.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
  edges:
    cites:
      - ADR-AZ-WAF-PE
---

# Azure WAF performance: the integration budget is five to ten minutes and the roofs are config

## Eyebrow

30 / 30 · fact for the Product Owner · ADR-AZ-WAF-PE

## Lead

For the Product Owner, who wants small batches and visible work: A run over its roof is a finding; the roof is raised by a person in timeouts.yml.

## Image

.assets/adr-az-waf-pe-30.png

## Caption

From the catalogue, reduced: local guard and server policies.

## Notes

Check it: the record ADR-AZ-WAF-PE in docs/drs/index.md, and the diagram docs/explanation/design/.assets/local-guard-and-server-policies.drawio.png.
