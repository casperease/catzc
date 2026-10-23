---
catzc:
  config:
    pattern: fact
    deck: vendor-for-developer
    order: 27
    picture:
      mode: reduce
      source: ../../../../docs/references/pwsh/.assets/azure-identity-resolves-from-config.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-WAF-RE
---

# Azure WAF reliability: pre-prod and production trade places blue-green, reversible by the same path

## Eyebrow

27 / 30 · fact for the Developer · ADR-AZ-WAF-RE

## Lead

For the Developer, who edits one file, runs one gate, pushes one topic: The switch is automated, monitored and reversible; reliability is a rung, not a hope.

## Image

.assets/adr-az-waf-re-27.png

## Caption

From the catalogue, reduced: azure identity resolves from config.

## Notes

Check it: the record ADR-AZ-WAF-RE in docs/drs/index.md, and the diagram docs/references/pwsh/.assets/azure-identity-resolves-from-config.drawio.png.
