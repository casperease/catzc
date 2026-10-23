---
catzc:
  config:
    pattern: fact
    deck: vendor-for-developer
    order: 29
    picture:
      mode: reduce
      source: ../../../../docs/references/pwsh/.assets/bicep-template-is-a-folder.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-WAF-OE
---

# Azure WAF operational excellence: one command per step, one gate per rule, one report per run

## Eyebrow

29 / 30 · fact for the Developer · ADR-AZ-WAF-OE

## Lead

For the Developer, who edits one file, runs one gate, pushes one topic: Every pipeline step names a cats command; every gate writes its report; nothing is clicked.

## Image

.assets/adr-az-waf-oe-29.png

## Caption

From the catalogue, reduced: bicep template is a folder.

## Notes

Check it: the record ADR-AZ-WAF-OE in docs/drs/index.md, and the diagram docs/references/pwsh/.assets/bicep-template-is-a-folder.drawio.png.
