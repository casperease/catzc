---
catzc:
  config:
    pattern: fact
    deck: vendor-for-qa-lead
    order: 4
    picture:
      mode: reduce
      source: ../../../../docs/references/pwsh/.assets/protected-module-skip-by-hash.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-ADO-VAR
---

# Azure DevOps: variables are declared once and injected at deploy time

## Eyebrow

4 / 30 · fact for the QA Lead · ADR-ADO-VAR

## Lead

For the QA Lead, who owns the test levels and their roofs: Secrets and some state are injected only at deploy; the repository holds a template through BVT.

## Image

.assets/adr-ado-var-4.png

## Caption

From the catalogue, reduced: protected module skip by hash.

## Notes

Check it: the record ADR-ADO-VAR in docs/drs/index.md, and the diagram docs/references/pwsh/.assets/protected-module-skip-by-hash.drawio.png.
