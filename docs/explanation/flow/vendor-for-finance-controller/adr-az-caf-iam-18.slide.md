---
catzc:
  config:
    pattern: fact
    deck: vendor-for-finance-controller
    order: 18
    picture:
      mode: reduce
      source: ../../design/.assets/10-commits-story.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-CAF-IAM
---

# Azure CAF identity: least privilege through named groups the apply creates

## Eyebrow

18 / 30 · fact for the Finance Controller · ADR-AZ-CAF-IAM

## Lead

For the Finance Controller, who pays for every environment and every wait: Approver groups and service connections are config; membership is exactly the list.

## Image

.assets/adr-az-caf-iam-18.png

## Caption

From the catalogue, reduced: 10 commits story.

## Notes

Check it: the record ADR-AZ-CAF-IAM in docs/drs/index.md, and the diagram docs/explanation/design/.assets/10-commits-story.drawio.png.
