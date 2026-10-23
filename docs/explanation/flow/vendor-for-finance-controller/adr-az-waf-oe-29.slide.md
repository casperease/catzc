---
catzc:
  config:
    pattern: fact
    deck: vendor-for-finance-controller
    order: 29
    picture:
      mode: reduce
      source: ../../automation/.assets/two-sections-unioned-into-one-allow-set.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
  edges:
    cites:
      - ADR-AZ-WAF-OE
---

# Azure WAF operational excellence: one command per step, one gate per rule, one report per run

## Eyebrow

29 / 30 · fact for the Finance Controller · ADR-AZ-WAF-OE

## Lead

For the Finance Controller, who pays for every environment and every wait: Every pipeline step names a cats command; every gate writes its report; nothing is clicked.

## Image

.assets/adr-az-waf-oe-29.png

## Caption

From the catalogue, reduced: two sections unioned into one allow set.

## Notes

Check it: the record ADR-AZ-WAF-OE in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/two-sections-unioned-into-one-allow-set.drawio.png.
