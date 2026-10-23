---
catzc:
  config:
    pattern: fact
    deck: for-finance-controller
    order: 18
    picture:
      mode: reduce
      source: ../../flow/.assets/cd-builds-once-then-deploys-prod-itself.drawio.png
      scale: 0.4
  edges:
    cites:
      - RDR-DORA-FLEXINFRA
---

# Flexible infrastructure: pre-prod is a slot inside production, hot-swappable blue-green

## Eyebrow

18 / 30 · fact for the Finance Controller · RDR-DORA-FLEXINFRA

## Lead

For the Finance Controller, who pays for every environment and every wait: The staging slot is never a separate subscription; the switch is an automated procedure.

## Image

.assets/rdr-dora-flexinfra-18.png

## Caption

From the catalogue, reduced: cd builds once then deploys prod itself.

## Notes

Check it: the record RDR-DORA-FLEXINFRA in docs/drs/index.md, and the diagram docs/explanation/flow/.assets/cd-builds-once-then-deploys-prod-itself.drawio.png.
