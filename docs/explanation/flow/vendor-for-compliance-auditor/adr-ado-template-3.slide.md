---
catzc:
  config:
    pattern: fact
    deck: vendor-for-compliance-auditor
    order: 3
    picture:
      mode: reduce
      source: ../../design/.assets/gate-checks-order-not-liveness.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-ADO-TEMPLATE
---

# Azure DevOps: a pipeline step only names a cats command; the template runs it

## Eyebrow

3 / 30 · fact for the Compliance Auditor · ADR-ADO-TEMPLATE

## Lead

For the Compliance Auditor, who reads the history and the registry: The runner pattern keeps every pipeline a list of commands the same automation runs locally.

## Image

.assets/adr-ado-template-3.png

## Caption

From the catalogue, reduced: gate checks order not liveness.

## Notes

Check it: the record ADR-ADO-TEMPLATE in docs/drs/index.md, and the diagram docs/explanation/design/.assets/gate-checks-order-not-liveness.drawio.png.
