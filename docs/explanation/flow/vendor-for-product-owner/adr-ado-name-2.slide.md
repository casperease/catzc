---
catzc:
  config:
    pattern: fact
    deck: vendor-for-product-owner
    order: 2
    picture:
      mode: reduce
      source: ../../flow/.assets/no-gate-checks-rules-one-and-four.drawio.png
      scale: 0.4
      rotate: -4
  edges:
    cites:
      - ADR-ADO-NAME
---

# Azure DevOps: pipeline, environment and policy names come from one naming rule

## Eyebrow

2 / 30 · fact for the Product Owner · ADR-ADO-NAME

## Lead

For the Product Owner, who wants small batches and visible work: A name is derived from the unit and the rung; nothing is typed in the portal.

## Image

.assets/adr-ado-name-2.png

## Caption

From the catalogue, reduced: no gate checks rules one and four.

## Notes

Check it: the record ADR-ADO-NAME in docs/drs/index.md, and the diagram docs/explanation/flow/.assets/no-gate-checks-rules-one-and-four.drawio.png.
