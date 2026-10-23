---
catzc:
  config:
    pattern: fact
    deck: vendor-for-head-of-platform
    order: 3
    picture:
      mode: reduce
      source: ../../../../docs/references/pwsh/.assets/listen-mode-flow.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-ADO-TEMPLATE
---

# Azure DevOps: a pipeline step only names a cats command; the template runs it

## Eyebrow

3 / 30 · fact for the Head of Platform · ADR-ADO-TEMPLATE

## Lead

For the Head of Platform, who runs the platform other teams build on: The runner pattern keeps every pipeline a list of commands the same automation runs locally.

## Image

.assets/adr-ado-template-3.png

## Caption

From the catalogue, reduced: listen mode flow.

## Notes

Check it: the record ADR-ADO-TEMPLATE in docs/drs/index.md, and the diagram docs/references/pwsh/.assets/listen-mode-flow.drawio.png.
