---
catzc:
  config:
    pattern: fact
    deck: vendor-for-release-manager
    order: 3
    picture:
      mode: reduce
      source: ../../automation/.assets/a-shell-call-carries-its-limit-or-is-denied.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
  edges:
    cites:
      - ADR-ADO-TEMPLATE
---

# Azure DevOps: a pipeline step only names a cats command; the template runs it

## Eyebrow

3 / 30 · fact for the Release Manager · ADR-ADO-TEMPLATE

## Lead

For the Release Manager, who serves the signatures and watches the ladder: The runner pattern keeps every pipeline a list of commands the same automation runs locally.

## Image

.assets/adr-ado-template-3.png

## Caption

From the catalogue, reduced: a shell call carries its limit or is denied.

## Notes

Check it: the record ADR-ADO-TEMPLATE in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/a-shell-call-carries-its-limit-or-is-denied.drawio.png.
