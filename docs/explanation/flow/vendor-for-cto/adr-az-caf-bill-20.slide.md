---
catzc:
  config:
    pattern: fact
    deck: vendor-for-cto
    order: 20
    picture:
      mode: reduce
      source: ../../design/.assets/every-file-in-exactly-one-aspect.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-CAF-BILL
---

# Azure CAF billing: every environment is a named slot with a known owner and a known cost

## Eyebrow

20 / 30 · fact for the CTO · ADR-AZ-CAF-BILL

## Lead

For the CTO, who owns the delivery system and its cost: One occupant per environment keeps the bill a list of named rungs.

## Image

.assets/adr-az-caf-bill-20.png

## Caption

From the catalogue, reduced: every file in exactly one aspect.

## Notes

Check it: the record ADR-AZ-CAF-BILL in docs/drs/index.md, and the diagram docs/explanation/design/.assets/every-file-in-exactly-one-aspect.drawio.png.
