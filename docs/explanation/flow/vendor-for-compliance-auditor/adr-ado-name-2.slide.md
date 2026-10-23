---
catzc:
  config:
    pattern: fact
    deck: vendor-for-compliance-auditor
    order: 2
    picture:
      mode: reduce
      source: ../../azure/.assets/a-bad-coordinate-stops-discovery.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
  edges:
    cites:
      - ADR-ADO-NAME
---

# Azure DevOps: pipeline, environment and policy names come from one naming rule

## Eyebrow

2 / 30 · fact for the Compliance Auditor · ADR-ADO-NAME

## Lead

For the Compliance Auditor, who reads the history and the registry: A name is derived from the unit and the rung; nothing is typed in the portal.

## Image

.assets/adr-ado-name-2.png

## Caption

From the catalogue, reduced: a bad coordinate stops discovery.

## Notes

Check it: the record ADR-ADO-NAME in docs/drs/index.md, and the diagram docs/explanation/azure/.assets/a-bad-coordinate-stops-discovery.drawio.png.
