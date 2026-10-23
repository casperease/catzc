---
catzc:
  config:
    pattern: fact
    deck: vendor-for-finance-controller
    order: 8
    picture:
      mode: reduce
      source: ../../configuration/.assets/an-address-is-a-read-only-walk.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-DATAMOD
---

# Azure: one file, one subscription; the data model is a tree of named slots

## Eyebrow

8 / 30 · fact for the Finance Controller · ADR-AZ-DATAMOD

## Lead

For the Finance Controller, who pays for every environment and every wait: A coordinate names a subscription, an environment and a slot; a bad coordinate stops discovery.

## Image

.assets/adr-az-datamod-8.png

## Caption

From the catalogue, reduced: an address is a read only walk.

## Notes

Check it: the record ADR-AZ-DATAMOD in docs/drs/index.md, and the diagram docs/explanation/configuration/.assets/an-address-is-a-read-only-walk.drawio.png.
