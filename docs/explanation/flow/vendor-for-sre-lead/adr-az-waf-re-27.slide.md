---
catzc:
  config:
    pattern: fact
    deck: vendor-for-sre-lead
    order: 27
    picture:
      mode: reduce
      source: ../../automation/.assets/what-gates-each-bundle-stage.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
  edges:
    cites:
      - ADR-AZ-WAF-RE
---

# Azure WAF reliability: pre-prod and production trade places blue-green, reversible by the same path

## Eyebrow

27 / 30 · fact for the SRE Lead · ADR-AZ-WAF-RE

## Lead

For the SRE Lead, who owns reliability, monitoring and the switch: The switch is automated, monitored and reversible; reliability is a rung, not a hope.

## Image

.assets/adr-az-waf-re-27.png

## Caption

From the catalogue, reduced: what gates each bundle stage.

## Notes

Check it: the record ADR-AZ-WAF-RE in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/what-gates-each-bundle-stage.drawio.png.
