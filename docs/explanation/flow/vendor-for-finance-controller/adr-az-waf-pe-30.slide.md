---
catzc:
  config:
    pattern: fact
    deck: vendor-for-finance-controller
    order: 30
    picture:
      mode: reduce
      source: ../../design/.assets/every-deploy-stage-is-main-only.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-WAF-PE
---

# Azure WAF performance: the integration budget is five to ten minutes and the roofs are config

## Eyebrow

30 / 30 · fact for the Finance Controller · ADR-AZ-WAF-PE

## Lead

For the Finance Controller, who pays for every environment and every wait: A run over its roof is a finding; the roof is raised by a person in timeouts.yml.

## Image

.assets/adr-az-waf-pe-30.png

## Caption

From the catalogue, reduced: every deploy stage is main only.

## Notes

Check it: the record ADR-AZ-WAF-PE in docs/drs/index.md, and the diagram docs/explanation/design/.assets/every-deploy-stage-is-main-only.drawio.png.
