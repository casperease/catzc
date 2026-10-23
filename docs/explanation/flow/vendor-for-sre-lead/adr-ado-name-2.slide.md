---
catzc:
  config:
    pattern: fact
    deck: vendor-for-sre-lead
    order: 2
    picture:
      mode: reduce
      source: ../../design/.assets/where-code-loads-from-decides-the-mode.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-ADO-NAME
---

# Azure DevOps: pipeline, environment and policy names come from one naming rule

## Eyebrow

2 / 30 · fact for the SRE Lead · ADR-ADO-NAME

## Lead

For the SRE Lead, who owns reliability, monitoring and the switch: A name is derived from the unit and the rung; nothing is typed in the portal.

## Image

.assets/adr-ado-name-2.png

## Caption

From the catalogue, reduced: where code loads from decides the mode.

## Notes

Check it: the record ADR-ADO-NAME in docs/drs/index.md, and the diagram docs/explanation/design/.assets/where-code-loads-from-decides-the-mode.drawio.png.
