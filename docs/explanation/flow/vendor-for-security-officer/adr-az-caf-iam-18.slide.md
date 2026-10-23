---
catzc:
  config:
    pattern: fact
    deck: vendor-for-security-officer
    order: 18
    picture:
      mode: reduce
      source: ../../../../docs/drs/flow/.assets/commit-promotion-states.drawio.png
      scale: 0.4
      rotate: -4
  edges:
    cites:
      - ADR-AZ-CAF-IAM
---

# Azure CAF identity: least privilege through named groups the apply creates

## Eyebrow

18 / 30 · fact for the Security Officer · ADR-AZ-CAF-IAM

## Lead

For the Security Officer, who owns identity, policy and the audit trail: Approver groups and service connections are config; membership is exactly the list.

## Image

.assets/adr-az-caf-iam-18.png

## Caption

From the catalogue, reduced: commit promotion states.

## Notes

Check it: the record ADR-AZ-CAF-IAM in docs/drs/index.md, and the diagram docs/drs/flow/.assets/commit-promotion-states.drawio.png.
