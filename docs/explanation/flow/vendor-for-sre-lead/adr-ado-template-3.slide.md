---
catzc:
  config:
    pattern: fact
    deck: vendor-for-sre-lead
    order: 3
    picture:
      mode: reduce
      source: ../.assets/a-step-only-names-a-command.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
---

# Azure DevOps: a pipeline step only names a command; the template runs it

## Eyebrow

3 / 30 · fact for the SRE Lead · ADR-ADO-TEMPLATE

## Lead

For the SRE Lead, who owns reliability, monitoring and the switch: The runner pattern keeps every pipeline a list of commands the same
automation runs locally.

## Image

[adr-ado-template-3](.assets/adr-ado-template-3.png)

## Caption

From the catalogue, reduced: a step only names a command.

## Notes

Check it: the record ADR-ADO-TEMPLATE in docs/drs/index.md, and the diagram
docs/explanation/flow/.assets/a-step-only-names-a-command.drawio.png.
