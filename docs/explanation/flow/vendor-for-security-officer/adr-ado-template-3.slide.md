---
catzc:
  config:
    pattern: fact
    deck: vendor-for-security-officer
    order: 3
    picture:
      mode: reduce
      source: ../../design/.assets/every-vendor-call-leaves-through-az.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-ADO-TEMPLATE
---

# Azure DevOps: a pipeline step only names a cats command; the template runs it

## Eyebrow

3 / 30 · fact for the Security Officer · ADR-ADO-TEMPLATE

## Lead

For the Security Officer, who owns identity, policy and the audit trail: The runner pattern keeps every pipeline a list of commands the same automation runs locally.

## Image

.assets/adr-ado-template-3.png

## Caption

From the catalogue, reduced: every vendor call leaves through az.

## Notes

Check it: the record ADR-ADO-TEMPLATE in docs/drs/index.md, and the diagram docs/explanation/design/.assets/every-vendor-call-leaves-through-az.drawio.png.
