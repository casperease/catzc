---
catzc:
  config:
    pattern: fact
    deck: vendor-for-head-of-platform
    order: 4
    picture:
      mode: reduce
      source: ../../flow/.assets/no-gate-checks-rules-one-and-four.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
  edges:
    cites:
      - ADR-ADO-VAR
---

# Azure DevOps: variables are declared once and injected at deploy time

## Eyebrow

4 / 30 · fact for the Head of Platform · ADR-ADO-VAR

## Lead

For the Head of Platform, who runs the platform other teams build on: Secrets and some state are injected only at deploy; the repository holds a template through BVT.

## Image

.assets/adr-ado-var-4.png

## Caption

From the catalogue, reduced: no gate checks rules one and four.

## Notes

Check it: the record ADR-ADO-VAR in docs/drs/index.md, and the diagram docs/explanation/flow/.assets/no-gate-checks-rules-one-and-four.drawio.png.
