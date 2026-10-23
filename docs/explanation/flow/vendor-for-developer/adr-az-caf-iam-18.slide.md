---
catzc:
  config:
    pattern: fact
    deck: vendor-for-developer
    order: 18
    picture:
      mode: reduce
      source: ../../design/.assets/which-rung-gates-exist-in-code.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
  edges:
    cites:
      - ADR-AZ-CAF-IAM
---

# Azure CAF identity: least privilege through named groups the apply creates

## Eyebrow

18 / 30 · fact for the Developer · ADR-AZ-CAF-IAM

## Lead

For the Developer, who edits one file, runs one gate, pushes one topic: Approver groups and service connections are config; membership is exactly the list.

## Image

.assets/adr-az-caf-iam-18.png

## Caption

From the catalogue, reduced: which rung gates exist in code.

## Notes

Check it: the record ADR-AZ-CAF-IAM in docs/drs/index.md, and the diagram docs/explanation/design/.assets/which-rung-gates-exist-in-code.drawio.png.
