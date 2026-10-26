---
catzc:
  config:
    pattern: fact
    deck: vendor-for-sre-lead
    order: 29
    picture:
      mode: reduce
      source: ../../azure/.assets/a-module-change-fans-out-to-its-templates.drawio.png
      scale: 0.4
      rotate: -4
---

# Azure WAF operational excellence: one command per step, one gate per rule, one report per run

## Eyebrow

29 / 30 · fact for the SRE Lead · ADR-AZ-WAF-OE

## Lead

For the SRE Lead, who owns reliability, monitoring and the switch: Every pipeline step names a command; every gate writes its report;
nothing is clicked.

## Image

.assets/adr-az-waf-oe-29.png

## Caption

From the catalogue, reduced: a module change fans out to its templates.

## Notes

Check it: the record ADR-AZ-WAF-OE in docs/drs/index.md, and the diagram
docs/explanation/azure/.assets/a-module-change-fans-out-to-its-templates.drawio.png.
