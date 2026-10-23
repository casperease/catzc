---
catzc:
  config:
    pattern: fact
    deck: vendor-for-head-of-platform
    order: 23
    picture:
      mode: reduce
      source: ../../../../docs/references/pwsh/.assets/bicep-deploy-one-immutable-context.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-CAF-RESORG
---

# Azure CAF resource organization: subscriptions, groups and slots follow the data model

## Eyebrow

23 / 30 · fact for the Head of Platform · ADR-AZ-CAF-RESORG

## Lead

For the Head of Platform, who runs the platform other teams build on: One file per subscription; a slot is inside its subscription, never beside it.

## Image

.assets/adr-az-caf-resorg-23.png

## Caption

From the catalogue, reduced: bicep deploy one immutable context.

## Notes

Check it: the record ADR-AZ-CAF-RESORG in docs/drs/index.md, and the diagram docs/references/pwsh/.assets/bicep-deploy-one-immutable-context.drawio.png.
