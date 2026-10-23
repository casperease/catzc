---
catzc:
  config:
    pattern: fact
    deck: vendor-for-qa-lead
    order: 23
    picture:
      mode: reduce
      source: ../../repository/.assets/import-materialises-two-gates-name-the-fix.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
  edges:
    cites:
      - ADR-AZ-CAF-RESORG
---

# Azure CAF resource organization: subscriptions, groups and slots follow the data model

## Eyebrow

23 / 30 · fact for the QA Lead · ADR-AZ-CAF-RESORG

## Lead

For the QA Lead, who owns the test levels and their roofs: One file per subscription; a slot is inside its subscription, never beside it.

## Image

.assets/adr-az-caf-resorg-23.png

## Caption

From the catalogue, reduced: import materialises two gates name the fix.

## Notes

Check it: the record ADR-AZ-CAF-RESORG in docs/drs/index.md, and the diagram docs/explanation/repository/.assets/import-materialises-two-gates-name-the-fix.drawio.png.
