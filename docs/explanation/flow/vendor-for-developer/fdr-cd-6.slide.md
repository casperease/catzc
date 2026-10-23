---
catzc:
  config:
    pattern: fact
    deck: vendor-for-developer
    order: 6
    picture:
      mode: reduce
      source: ../../automation/.assets/invoke-importer-in-code-order.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
  edges:
    cites:
      - FDR-CD
---

# Azure DevOps: environment approvals are one config and one apply command

## Eyebrow

6 / 30 · fact for the Developer · FDR-CD

## Lead

For the Developer, who edits one file, runs one gate, pushes one topic: The approver group and the prod-tier environments are declared once; the apply makes the org match.

## Image

.assets/fdr-cd-6.png

## Caption

From the catalogue, reduced: invoke importer in code order.

## Notes

Check it: the record FDR-CD in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/invoke-importer-in-code-order.drawio.png.
