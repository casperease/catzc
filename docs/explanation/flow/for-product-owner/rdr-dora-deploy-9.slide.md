---
catzc:
  config:
    pattern: fact
    deck: for-product-owner
    order: 9
    picture:
      mode: reduce
      source: ../../design/.assets/one-entry-script-per-mode.drawio.png
      scale: 0.4
  edges:
    cites:
      - RDR-DORA-DEPLOY
---

# Deployment automation: one artifact built once climbs every rung by pipeline

## Eyebrow

9 / 30 · fact for the Product Owner · RDR-DORA-DEPLOY

## Lead

For the Product Owner, who wants small batches and visible work: CD rolls the same tagged artifact onto each environment; the slot switch is automated and monitored.

## Image

.assets/rdr-dora-deploy-9.png

## Caption

From the catalogue, reduced: one entry script per mode.

## Notes

Check it: the record RDR-DORA-DEPLOY in docs/drs/index.md, and the diagram docs/explanation/design/.assets/one-entry-script-per-mode.drawio.png.
