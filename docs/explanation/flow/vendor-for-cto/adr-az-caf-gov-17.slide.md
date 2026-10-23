---
catzc:
  config:
    pattern: fact
    deck: vendor-for-cto
    order: 17
    picture:
      mode: reduce
      source: ../../repository/.assets/one-source-one-writer-one-boolean.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
  edges:
    cites:
      - ADR-AZ-CAF-GOV
---

# Azure CAF governance: policies are declared in code and applied, never set by hand

## Eyebrow

17 / 30 · fact for the CTO · ADR-AZ-CAF-GOV

## Lead

For the CTO, who owns the delivery system and its cost: The cloud adoption framework's governance items are answered one by one in the records.

## Image

.assets/adr-az-caf-gov-17.png

## Caption

From the catalogue, reduced: one source one writer one boolean.

## Notes

Check it: the record ADR-AZ-CAF-GOV in docs/drs/index.md, and the diagram docs/explanation/repository/.assets/one-source-one-writer-one-boolean.drawio.png.
