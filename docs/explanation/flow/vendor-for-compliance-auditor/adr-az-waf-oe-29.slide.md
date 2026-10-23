---
catzc:
  config:
    pattern: fact
    deck: vendor-for-compliance-auditor
    order: 29
    picture:
      mode: reduce
      source: ../../design/.assets/units-not-tracks-own-the-pipelines.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-WAF-OE
---

# Azure WAF operational excellence: one command per step, one gate per rule, one report per run

## Eyebrow

29 / 30 · fact for the Compliance Auditor · ADR-AZ-WAF-OE

## Lead

For the Compliance Auditor, who reads the history and the registry: Every pipeline step names a cats command; every gate writes its report; nothing is clicked.

## Image

.assets/adr-az-waf-oe-29.png

## Caption

From the catalogue, reduced: units not tracks own the pipelines.

## Notes

Check it: the record ADR-AZ-WAF-OE in docs/drs/index.md, and the diagram docs/explanation/design/.assets/units-not-tracks-own-the-pipelines.drawio.png.
