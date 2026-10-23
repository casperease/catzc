---
catzc:
  config:
    pattern: fact
    deck: vendor-for-developer
    order: 20
    picture:
      mode: reduce
      source: ../../flow/.assets/a-step-only-names-a-command.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
  edges:
    cites:
      - ADR-AZ-CAF-BILL
---

# Azure CAF billing: every environment is a named slot with a known owner and a known cost

## Eyebrow

20 / 30 · fact for the Developer · ADR-AZ-CAF-BILL

## Lead

For the Developer, who edits one file, runs one gate, pushes one topic: One occupant per environment keeps the bill a list of named rungs.

## Image

.assets/adr-az-caf-bill-20.png

## Caption

From the catalogue, reduced: a step only names a command.

## Notes

Check it: the record ADR-AZ-CAF-BILL in docs/drs/index.md, and the diagram docs/explanation/flow/.assets/a-step-only-names-a-command.drawio.png.
