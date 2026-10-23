---
catzc:
  config:
    pattern: fact
    deck: vendor-for-finance-controller
    order: 27
    picture:
      mode: reduce
      source: ../../automation/.assets/two-forms-never-a-third.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
  edges:
    cites:
      - ADR-AZ-WAF-RE
---

# Azure WAF reliability: pre-prod and production trade places blue-green, reversible by the same path

## Eyebrow

27 / 30 · fact for the Finance Controller · ADR-AZ-WAF-RE

## Lead

For the Finance Controller, who pays for every environment and every wait: The switch is automated, monitored and reversible; reliability is a rung, not a hope.

## Image

.assets/adr-az-waf-re-27.png

## Caption

From the catalogue, reduced: two forms never a third.

## Notes

Check it: the record ADR-AZ-WAF-RE in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/two-forms-never-a-third.drawio.png.
