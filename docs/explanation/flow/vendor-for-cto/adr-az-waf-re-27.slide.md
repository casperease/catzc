---
catzc:
  config:
    pattern: fact
    deck: vendor-for-cto
    order: 27
    picture:
      mode: reduce
      source: ../../flow/.assets/two-declared-layers-one-derived.drawio.png
      scale: 0.4
      rotate: -4
  edges:
    cites:
      - ADR-AZ-WAF-RE
---

# Azure WAF reliability: pre-prod and production trade places blue-green, reversible by the same path

## Eyebrow

27 / 30 · fact for the CTO · ADR-AZ-WAF-RE

## Lead

For the CTO, who owns the delivery system and its cost: The switch is automated, monitored and reversible; reliability is a rung, not a hope.

## Image

.assets/adr-az-waf-re-27.png

## Caption

From the catalogue, reduced: two declared layers one derived.

## Notes

Check it: the record ADR-AZ-WAF-RE in docs/drs/index.md, and the diagram docs/explanation/flow/.assets/two-declared-layers-one-derived.drawio.png.
