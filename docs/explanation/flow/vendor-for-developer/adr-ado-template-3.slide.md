---
catzc:
  config:
    pattern: fact
    deck: vendor-for-developer
    order: 3
    picture:
      mode: reduce
      source: ../../design/.assets/only-pwsh-compiles-its-aspects.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-ADO-TEMPLATE
---

# Azure DevOps: a pipeline step only names a cats command; the template runs it

## Eyebrow

3 / 30 · fact for the Developer · ADR-ADO-TEMPLATE

## Lead

For the Developer, who edits one file, runs one gate, pushes one topic: The runner pattern keeps every pipeline a list of commands the same automation runs locally.

## Image

.assets/adr-ado-template-3.png

## Caption

From the catalogue, reduced: only pwsh compiles its aspects.

## Notes

Check it: the record ADR-ADO-TEMPLATE in docs/drs/index.md, and the diagram docs/explanation/design/.assets/only-pwsh-compiles-its-aspects.drawio.png.
