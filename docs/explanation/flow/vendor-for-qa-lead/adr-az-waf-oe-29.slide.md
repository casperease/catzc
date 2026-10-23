---
catzc:
  config:
    pattern: fact
    deck: vendor-for-qa-lead
    order: 29
    picture:
      mode: reduce
      source: ../../design/.assets/which-run-mode-rules-have-a-gate.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
  edges:
    cites:
      - ADR-AZ-WAF-OE
---

# Azure WAF operational excellence: one command per step, one gate per rule, one report per run

## Eyebrow

29 / 30 · fact for the QA Lead · ADR-AZ-WAF-OE

## Lead

For the QA Lead, who owns the test levels and their roofs: Every pipeline step names a cats command; every gate writes its report; nothing is clicked.

## Image

.assets/adr-az-waf-oe-29.png

## Caption

From the catalogue, reduced: which run mode rules have a gate.

## Notes

Check it: the record ADR-AZ-WAF-OE in docs/drs/index.md, and the diagram docs/explanation/design/.assets/which-run-mode-rules-have-a-gate.drawio.png.
