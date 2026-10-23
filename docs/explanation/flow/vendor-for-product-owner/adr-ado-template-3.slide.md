---
catzc:
  config:
    pattern: fact
    deck: vendor-for-product-owner
    order: 3
    picture:
      mode: reduce
      source: ../../repository/.assets/three-gates-check-registry-drift-membership.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-ADO-TEMPLATE
---

# Azure DevOps: a pipeline step only names a cats command; the template runs it

## Eyebrow

3 / 30 · fact for the Product Owner · ADR-ADO-TEMPLATE

## Lead

For the Product Owner, who wants small batches and visible work: The runner pattern keeps every pipeline a list of commands the same automation runs locally.

## Image

.assets/adr-ado-template-3.png

## Caption

From the catalogue, reduced: three gates check registry drift membership.

## Notes

Check it: the record ADR-ADO-TEMPLATE in docs/drs/index.md, and the diagram docs/explanation/repository/.assets/three-gates-check-registry-drift-membership.drawio.png.
