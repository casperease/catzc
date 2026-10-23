---
catzc:
  config:
    pattern: fact
    deck: vendor-for-compliance-auditor
    order: 27
    picture:
      mode: reduce
      source: ../../design/.assets/two-roots-one-importer-same-modules.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-WAF-RE
---

# Azure WAF reliability: pre-prod and production trade places blue-green, reversible by the same path

## Eyebrow

27 / 30 · fact for the Compliance Auditor · ADR-AZ-WAF-RE

## Lead

For the Compliance Auditor, who reads the history and the registry: The switch is automated, monitored and reversible; reliability is a rung, not a hope.

## Image

.assets/adr-az-waf-re-27.png

## Caption

From the catalogue, reduced: two roots one importer same modules.

## Notes

Check it: the record ADR-AZ-WAF-RE in docs/drs/index.md, and the diagram docs/explanation/design/.assets/two-roots-one-importer-same-modules.drawio.png.
