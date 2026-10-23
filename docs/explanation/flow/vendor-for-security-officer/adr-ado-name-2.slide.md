---
catzc:
  config:
    pattern: fact
    deck: vendor-for-security-officer
    order: 2
    picture:
      mode: reduce
      source: ../../automation/.assets/undeclared-edge-fails-with-one-line.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
  edges:
    cites:
      - ADR-ADO-NAME
---

# Azure DevOps: pipeline, environment and policy names come from one naming rule

## Eyebrow

2 / 30 · fact for the Security Officer · ADR-ADO-NAME

## Lead

For the Security Officer, who owns identity, policy and the audit trail: A name is derived from the unit and the rung; nothing is typed in the portal.

## Image

.assets/adr-ado-name-2.png

## Caption

From the catalogue, reduced: undeclared edge fails with one line.

## Notes

Check it: the record ADR-ADO-NAME in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/undeclared-edge-fails-with-one-line.drawio.png.
