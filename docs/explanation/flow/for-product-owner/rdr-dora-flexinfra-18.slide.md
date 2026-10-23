---
catzc:
  config:
    pattern: fact
    deck: for-product-owner
    order: 18
    picture:
      mode: reduce
      source: ../../design/.assets/which-run-mode-rules-have-a-gate.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
  edges:
    cites:
      - RDR-DORA-FLEXINFRA
---

# Flexible infrastructure: pre-prod is a slot inside production, hot-swappable blue-green

## Eyebrow

18 / 30 · fact for the Product Owner · RDR-DORA-FLEXINFRA

## Lead

For the Product Owner, who wants small batches and visible work: The staging slot is never a separate subscription; the switch is an automated procedure.

## Image

.assets/rdr-dora-flexinfra-18.png

## Caption

From the catalogue, reduced: which run mode rules have a gate.

## Notes

Check it: the record RDR-DORA-FLEXINFRA in docs/drs/index.md, and the diagram docs/explanation/design/.assets/which-run-mode-rules-have-a-gate.drawio.png.
