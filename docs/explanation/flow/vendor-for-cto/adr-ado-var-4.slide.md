---
catzc:
  config:
    pattern: fact
    deck: vendor-for-cto
    order: 4
    picture:
      mode: reduce
      source: ../../automation/.assets/one-commit-one-immutable-package.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-ADO-VAR
---

# Azure DevOps: variables are declared once and injected at deploy time

## Eyebrow

4 / 30 · fact for the CTO · ADR-ADO-VAR

## Lead

For the CTO, who owns the delivery system and its cost: Secrets and some state are injected only at deploy; the repository holds a template through BVT.

## Image

.assets/adr-ado-var-4.png

## Caption

From the catalogue, reduced: one commit one immutable package.

## Notes

Check it: the record ADR-ADO-VAR in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/one-commit-one-immutable-package.drawio.png.
