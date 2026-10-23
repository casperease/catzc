---
catzc:
  config:
    pattern: fact
    deck: vendor-for-product-owner
    order: 4
    picture:
      mode: reduce
      source: ../../repository/.assets/build-diagrams-runs-five-stages.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
  edges:
    cites:
      - ADR-ADO-VAR
---

# Azure DevOps: variables are declared once and injected at deploy time

## Eyebrow

4 / 30 · fact for the Product Owner · ADR-ADO-VAR

## Lead

For the Product Owner, who wants small batches and visible work: Secrets and some state are injected only at deploy; the repository holds a template through BVT.

## Image

.assets/adr-ado-var-4.png

## Caption

From the catalogue, reduced: build diagrams runs five stages.

## Notes

Check it: the record ADR-ADO-VAR in docs/drs/index.md, and the diagram docs/explanation/repository/.assets/build-diagrams-runs-five-stages.drawio.png.
