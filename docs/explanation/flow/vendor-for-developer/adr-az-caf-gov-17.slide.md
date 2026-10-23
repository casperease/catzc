---
catzc:
  config:
    pattern: fact
    deck: vendor-for-developer
    order: 17
    picture:
      mode: reduce
      source: ../../design/.assets/same-deploy-bicep-on-both-sides.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-CAF-GOV
---

# Azure CAF governance: policies are declared in code and applied, never set by hand

## Eyebrow

17 / 30 · fact for the Developer · ADR-AZ-CAF-GOV

## Lead

For the Developer, who edits one file, runs one gate, pushes one topic: The cloud adoption framework's governance items are answered one by one in the records.

## Image

.assets/adr-az-caf-gov-17.png

## Caption

From the catalogue, reduced: same deploy bicep on both sides.

## Notes

Check it: the record ADR-AZ-CAF-GOV in docs/drs/index.md, and the diagram docs/explanation/design/.assets/same-deploy-bicep-on-both-sides.drawio.png.
