---
catzc:
  config:
    pattern: fact
    deck: vendor-for-finance-controller
    order: 4
    picture:
      mode: reduce
      source: ../../azure/.assets/read-the-session-guard-then-pick-slot.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-ADO-VAR
---

# Azure DevOps: variables are declared once and injected at deploy time

## Eyebrow

4 / 30 · fact for the Finance Controller · ADR-ADO-VAR

## Lead

For the Finance Controller, who pays for every environment and every wait: Secrets and some state are injected only at deploy; the repository holds a template through BVT.

## Image

.assets/adr-ado-var-4.png

## Caption

From the catalogue, reduced: read the session guard then pick slot.

## Notes

Check it: the record ADR-ADO-VAR in docs/drs/index.md, and the diagram docs/explanation/azure/.assets/read-the-session-guard-then-pick-slot.drawio.png.
