---
catzc:
  config:
    pattern: fact
    deck: vendor-for-product-owner
    order: 8
    picture:
      mode: reduce
      source: ../../design/.assets/engineer-merges-pipelines-do-the-rest.drawio.png
      scale: 0.4
      rotate: -4
  edges:
    cites:
      - ADR-AZ-DATAMOD
---

# Azure: one file, one subscription; the data model is a tree of named slots

## Eyebrow

8 / 30 · fact for the Product Owner · ADR-AZ-DATAMOD

## Lead

For the Product Owner, who wants small batches and visible work: A coordinate names a subscription, an environment and a slot; a bad coordinate stops discovery.

## Image

.assets/adr-az-datamod-8.png

## Caption

From the catalogue, reduced: engineer merges pipelines do the rest.

## Notes

Check it: the record ADR-AZ-DATAMOD in docs/drs/index.md, and the diagram docs/explanation/design/.assets/engineer-merges-pipelines-do-the-rest.drawio.png.
