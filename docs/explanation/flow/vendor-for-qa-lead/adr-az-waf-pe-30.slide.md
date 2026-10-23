---
catzc:
  config:
    pattern: fact
    deck: vendor-for-qa-lead
    order: 30
    picture:
      mode: reduce
      source: ../../design/.assets/merging-to-main-is-what-deploys.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-WAF-PE
---

# Azure WAF performance: the integration budget is five to ten minutes and the roofs are config

## Eyebrow

30 / 30 · fact for the QA Lead · ADR-AZ-WAF-PE

## Lead

For the QA Lead, who owns the test levels and their roofs: A run over its roof is a finding; the roof is raised by a person in timeouts.yml.

## Image

.assets/adr-az-waf-pe-30.png

## Caption

From the catalogue, reduced: merging to main is what deploys.

## Notes

Check it: the record ADR-AZ-WAF-PE in docs/drs/index.md, and the diagram docs/explanation/design/.assets/merging-to-main-is-what-deploys.drawio.png.
