---
catzc:
  config:
    pattern: fact
    deck: vendor-for-finance-controller
    order: 2
    picture:
      mode: reduce
      source: ../../azure/.assets/one-reverse-lookup-feeds-every-module.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-ADO-NAME
---

# Azure DevOps: pipeline, environment and policy names come from one naming rule

## Eyebrow

2 / 30 · fact for the Finance Controller · ADR-ADO-NAME

## Lead

For the Finance Controller, who pays for every environment and every wait: A name is derived from the unit and the rung; nothing is typed in the portal.

## Image

.assets/adr-ado-name-2.png

## Caption

From the catalogue, reduced: one reverse lookup feeds every module.

## Notes

Check it: the record ADR-ADO-NAME in docs/drs/index.md, and the diagram docs/explanation/azure/.assets/one-reverse-lookup-feeds-every-module.drawio.png.
