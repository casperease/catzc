---
catzc:
  config:
    pattern: fact
    deck: vendor-for-compliance-auditor
    order: 23
    picture:
      mode: reduce
      source: ../../design/.assets/shims-set-roots-mode-read-back.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-CAF-RESORG
---

# Azure CAF resource organization: subscriptions, groups and slots follow the data model

## Eyebrow

23 / 30 · fact for the Compliance Auditor · ADR-AZ-CAF-RESORG

## Lead

For the Compliance Auditor, who reads the history and the registry: One file per subscription; a slot is inside its subscription, never beside it.

## Image

.assets/adr-az-caf-resorg-23.png

## Caption

From the catalogue, reduced: shims set roots mode read back.

## Notes

Check it: the record ADR-AZ-CAF-RESORG in docs/drs/index.md, and the diagram docs/explanation/design/.assets/shims-set-roots-mode-read-back.drawio.png.
