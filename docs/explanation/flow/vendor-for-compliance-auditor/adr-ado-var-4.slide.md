---
catzc:
  config:
    pattern: fact
    deck: vendor-for-compliance-auditor
    order: 4
    picture:
      mode: reduce
      source: ../../azure/.assets/add-a-template.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
  edges:
    cites:
      - ADR-ADO-VAR
---

# Azure DevOps: variables are declared once and injected at deploy time

## Eyebrow

4 / 30 · fact for the Compliance Auditor · ADR-ADO-VAR

## Lead

For the Compliance Auditor, who reads the history and the registry: Secrets and some state are injected only at deploy; the repository holds a template through BVT.

## Image

.assets/adr-ado-var-4.png

## Caption

From the catalogue, reduced: add a template.

## Notes

Check it: the record ADR-ADO-VAR in docs/drs/index.md, and the diagram docs/explanation/azure/.assets/add-a-template.drawio.png.
