---
catzc:
  config:
    pattern: fact
    deck: vendor-for-developer
    order: 25
    picture:
      mode: reduce
      source: ../../flow/.assets/drift-is-gated-generation-is-drs-only.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-CAF-NETTOP
---

# Azure CAF network topology: declared as a record and applied as code

## Eyebrow

25 / 30 · fact for the Developer · ADR-AZ-CAF-NETTOP

## Lead

For the Developer, who edits one file, runs one gate, pushes one topic: Hub and spoke are coordinates in the model, not drawings in a wiki.

## Image

.assets/adr-az-caf-nettop-25.png

## Caption

From the catalogue, reduced: drift is gated generation is drs only.

## Notes

Check it: the record ADR-AZ-CAF-NETTOP in docs/drs/index.md, and the diagram docs/explanation/flow/.assets/drift-is-gated-generation-is-drs-only.drawio.png.
