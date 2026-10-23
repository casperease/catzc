---
catzc:
  config:
    pattern: fact
    deck: vendor-for-qa-lead
    order: 8
    picture:
      mode: reduce
      source: ../../flow/.assets/one-scan-program-feeds-three-roles.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-DATAMOD
---

# Azure: one file, one subscription; the data model is a tree of named slots

## Eyebrow

8 / 30 · fact for the QA Lead · ADR-AZ-DATAMOD

## Lead

For the QA Lead, who owns the test levels and their roofs: A coordinate names a subscription, an environment and a slot; a bad coordinate stops discovery.

## Image

.assets/adr-az-datamod-8.png

## Caption

From the catalogue, reduced: one scan program feeds three roles.

## Notes

Check it: the record ADR-AZ-DATAMOD in docs/drs/index.md, and the diagram docs/explanation/flow/.assets/one-scan-program-feeds-three-roles.drawio.png.
