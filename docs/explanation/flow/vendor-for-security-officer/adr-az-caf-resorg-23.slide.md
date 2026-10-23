---
catzc:
  config:
    pattern: fact
    deck: vendor-for-security-officer
    order: 23
    picture:
      mode: reduce
      source: ../../design/.assets/partition-integrity-runs-only-in-unit-tests.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-CAF-RESORG
---

# Azure CAF resource organization: subscriptions, groups and slots follow the data model

## Eyebrow

23 / 30 · fact for the Security Officer · ADR-AZ-CAF-RESORG

## Lead

For the Security Officer, who owns identity, policy and the audit trail: One file per subscription; a slot is inside its subscription, never beside it.

## Image

.assets/adr-az-caf-resorg-23.png

## Caption

From the catalogue, reduced: partition integrity runs only in unit tests.

## Notes

Check it: the record ADR-AZ-CAF-RESORG in docs/drs/index.md, and the diagram docs/explanation/design/.assets/partition-integrity-runs-only-in-unit-tests.drawio.png.
