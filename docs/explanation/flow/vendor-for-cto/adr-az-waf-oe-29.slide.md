---
catzc:
  config:
    pattern: fact
    deck: vendor-for-cto
    order: 29
    picture:
      mode: reduce
      source: ../../azure/.assets/the-session-is-the-deploy-target.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
  edges:
    cites:
      - ADR-AZ-WAF-OE
---

# Azure WAF operational excellence: one command per step, one gate per rule, one report per run

## Eyebrow

29 / 30 · fact for the CTO · ADR-AZ-WAF-OE

## Lead

For the CTO, who owns the delivery system and its cost: Every pipeline step names a cats command; every gate writes its report; nothing is clicked.

## Image

.assets/adr-az-waf-oe-29.png

## Caption

From the catalogue, reduced: the session is the deploy target.

## Notes

Check it: the record ADR-AZ-WAF-OE in docs/drs/index.md, and the diagram docs/explanation/azure/.assets/the-session-is-the-deploy-target.drawio.png.
