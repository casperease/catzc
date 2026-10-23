---
catzc:
  config:
    pattern: fact
    deck: vendor-for-compliance-auditor
    order: 18
    picture:
      mode: reduce
      source: ../../.assets/glyphs.drawio.png
      scale: 0.4
      rotate: -4
  edges:
    cites:
      - ADR-AZ-CAF-IAM
---

# Azure CAF identity: least privilege through named groups the apply creates

## Eyebrow

18 / 30 · fact for the Compliance Auditor · ADR-AZ-CAF-IAM

## Lead

For the Compliance Auditor, who reads the history and the registry: Approver groups and service connections are config; membership is exactly the list.

## Image

.assets/adr-az-caf-iam-18.png

## Caption

From the catalogue, reduced: glyphs.

## Notes

Check it: the record ADR-AZ-CAF-IAM in docs/drs/index.md, and the diagram docs/explanation/.assets/glyphs.drawio.png.
