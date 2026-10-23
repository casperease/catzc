---
catzc:
  config:
    pattern: fact
    deck: vendor-for-finance-controller
    order: 22
    picture:
      mode: reduce
      source: ../../design/.assets/clients-bridge-to-one-server.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-CAF-NAME
---

# Azure CAF naming: one standard, one builder, one gate

## Eyebrow

22 / 30 · fact for the Finance Controller · ADR-AZ-CAF-NAME

## Lead

For the Finance Controller, who pays for every environment and every wait: The naming standard is a record; the builder is code; a gate checks every name.

## Image

.assets/adr-az-caf-name-22.png

## Caption

From the catalogue, reduced: clients bridge to one server.

## Notes

Check it: the record ADR-AZ-CAF-NAME in docs/drs/index.md, and the diagram docs/explanation/design/.assets/clients-bridge-to-one-server.drawio.png.
