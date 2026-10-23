---
catzc:
  config:
    pattern: fact
    deck: vendor-for-head-of-platform
    order: 18
    picture:
      mode: reduce
      source: ../../../../docs/references/pwsh/.assets/az-cli-test-assert-share-one-state.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
  edges:
    cites:
      - ADR-AZ-CAF-IAM
---

# Azure CAF identity: least privilege through named groups the apply creates

## Eyebrow

18 / 30 · fact for the Head of Platform · ADR-AZ-CAF-IAM

## Lead

For the Head of Platform, who runs the platform other teams build on: Approver groups and service connections are config; membership is exactly the list.

## Image

.assets/adr-az-caf-iam-18.png

## Caption

From the catalogue, reduced: az cli test assert share one state.

## Notes

Check it: the record ADR-AZ-CAF-IAM in docs/drs/index.md, and the diagram docs/references/pwsh/.assets/az-cli-test-assert-share-one-state.drawio.png.
