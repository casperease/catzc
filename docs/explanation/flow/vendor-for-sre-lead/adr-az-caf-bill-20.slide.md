---
catzc:
  config:
    pattern: fact
    deck: vendor-for-sre-lead
    order: 20
    picture:
      mode: reduce
      source: ../../design/.assets/get-aspect-feeds-globs-and-maps.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-CAF-BILL
---

# Azure CAF billing: every environment is a named slot with a known owner and a known cost

## Eyebrow

20 / 30 · fact for the SRE Lead · ADR-AZ-CAF-BILL

## Lead

For the SRE Lead, who owns reliability, monitoring and the switch: One occupant per environment keeps the bill a list of named rungs.

## Image

.assets/adr-az-caf-bill-20.png

## Caption

From the catalogue, reduced: get aspect feeds globs and maps.

## Notes

Check it: the record ADR-AZ-CAF-BILL in docs/drs/index.md, and the diagram docs/explanation/design/.assets/get-aspect-feeds-globs-and-maps.drawio.png.
