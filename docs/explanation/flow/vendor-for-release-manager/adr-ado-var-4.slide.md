---
catzc:
  config:
    pattern: fact
    deck: vendor-for-release-manager
    order: 4
    picture:
      mode: reduce
      source: ../../azure/.assets/one-reverse-lookup-feeds-every-module.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-ADO-VAR
---

# Azure DevOps: variables are declared once and injected at deploy time

## Eyebrow

4 / 30 · fact for the Release Manager · ADR-ADO-VAR

## Lead

For the Release Manager, who serves the signatures and watches the ladder: Secrets and some state are injected only at deploy; the repository holds a template through BVT.

## Image

.assets/adr-ado-var-4.png

## Caption

From the catalogue, reduced: one reverse lookup feeds every module.

## Notes

Check it: the record ADR-ADO-VAR in docs/drs/index.md, and the diagram docs/explanation/azure/.assets/one-reverse-lookup-feeds-every-module.drawio.png.
