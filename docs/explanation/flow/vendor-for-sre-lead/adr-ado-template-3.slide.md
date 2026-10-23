---
catzc:
  config:
    pattern: fact
    deck: vendor-for-sre-lead
    order: 3
    picture:
      mode: reduce
      source: ../../../../docs/drs/flow/.assets/sync-point.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
  edges:
    cites:
      - ADR-ADO-TEMPLATE
---

# Azure DevOps: a pipeline step only names a cats command; the template runs it

## Eyebrow

3 / 30 · fact for the SRE Lead · ADR-ADO-TEMPLATE

## Lead

For the SRE Lead, who owns reliability, monitoring and the switch: The runner pattern keeps every pipeline a list of commands the same automation runs locally.

## Image

.assets/adr-ado-template-3.png

## Caption

From the catalogue, reduced: sync point.

## Notes

Check it: the record ADR-ADO-TEMPLATE in docs/drs/index.md, and the diagram docs/drs/flow/.assets/sync-point.drawio.png.
