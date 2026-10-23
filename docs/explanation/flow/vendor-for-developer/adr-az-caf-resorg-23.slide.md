---
catzc:
  config:
    pattern: fact
    deck: vendor-for-developer
    order: 23
    picture:
      mode: reduce
      source: ../../ado/.assets/which-auth-rungs-have-a-gate.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-CAF-RESORG
---

# Azure CAF resource organization: subscriptions, groups and slots follow the data model

## Eyebrow

23 / 30 · fact for the Developer · ADR-AZ-CAF-RESORG

## Lead

For the Developer, who edits one file, runs one gate, pushes one topic: One file per subscription; a slot is inside its subscription, never beside it.

## Image

.assets/adr-az-caf-resorg-23.png

## Caption

From the catalogue, reduced: which auth rungs have a gate.

## Notes

Check it: the record ADR-AZ-CAF-RESORG in docs/drs/index.md, and the diagram docs/explanation/ado/.assets/which-auth-rungs-have-a-gate.drawio.png.
