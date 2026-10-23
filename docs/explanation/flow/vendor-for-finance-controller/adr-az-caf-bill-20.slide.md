---
catzc:
  config:
    pattern: fact
    deck: vendor-for-finance-controller
    order: 20
    picture:
      mode: reduce
      source: ../../design/.assets/a-sibling-is-an-idea-never-a-reference.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-CAF-BILL
---

# Azure CAF billing: every environment is a named slot with a known owner and a known cost

## Eyebrow

20 / 30 · fact for the Finance Controller · ADR-AZ-CAF-BILL

## Lead

For the Finance Controller, who pays for every environment and every wait: One occupant per environment keeps the bill a list of named rungs.

## Image

.assets/adr-az-caf-bill-20.png

## Caption

From the catalogue, reduced: a sibling is an idea never a reference.

## Notes

Check it: the record ADR-AZ-CAF-BILL in docs/drs/index.md, and the diagram docs/explanation/design/.assets/a-sibling-is-an-idea-never-a-reference.drawio.png.
