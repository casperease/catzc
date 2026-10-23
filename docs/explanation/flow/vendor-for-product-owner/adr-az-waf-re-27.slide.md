---
catzc:
  config:
    pattern: fact
    deck: vendor-for-product-owner
    order: 27
    picture:
      mode: reduce
      source: ../../../../docs/references/pwsh/.assets/test-automation-one-run-pipeline.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-WAF-RE
---

# Azure WAF reliability: pre-prod and production trade places blue-green, reversible by the same path

## Eyebrow

27 / 30 · fact for the Product Owner · ADR-AZ-WAF-RE

## Lead

For the Product Owner, who wants small batches and visible work: The switch is automated, monitored and reversible; reliability is a rung, not a hope.

## Image

.assets/adr-az-waf-re-27.png

## Caption

From the catalogue, reduced: test automation one run pipeline.

## Notes

Check it: the record ADR-AZ-WAF-RE in docs/drs/index.md, and the diagram docs/references/pwsh/.assets/test-automation-one-run-pipeline.drawio.png.
