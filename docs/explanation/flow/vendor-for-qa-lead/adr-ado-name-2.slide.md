---
catzc:
  config:
    pattern: fact
    deck: vendor-for-qa-lead
    order: 2
    picture:
      mode: reduce
      source: ../../automation/.assets/one-commit-one-immutable-package.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-ADO-NAME
---

# Azure DevOps: pipeline, environment and policy names come from one naming rule

## Eyebrow

2 / 30 · fact for the QA Lead · ADR-ADO-NAME

## Lead

For the QA Lead, who owns the test levels and their roofs: A name is derived from the unit and the rung; nothing is typed in the portal.

## Image

.assets/adr-ado-name-2.png

## Caption

From the catalogue, reduced: one commit one immutable package.

## Notes

Check it: the record ADR-ADO-NAME in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/one-commit-one-immutable-package.drawio.png.
