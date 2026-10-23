---
catzc:
  config:
    pattern: fact
    deck: vendor-for-head-of-platform
    order: 2
    picture:
      mode: reduce
      source: ../../design/.assets/four-domains-promote-one-artifact.drawio.png
      scale: 0.4
      rotate: -4
  edges:
    cites:
      - ADR-ADO-NAME
---

# Azure DevOps: pipeline, environment and policy names come from one naming rule

## Eyebrow

2 / 30 · fact for the Head of Platform · ADR-ADO-NAME

## Lead

For the Head of Platform, who runs the platform other teams build on: A name is derived from the unit and the rung; nothing is typed in the portal.

## Image

.assets/adr-ado-name-2.png

## Caption

From the catalogue, reduced: four domains promote one artifact.

## Notes

Check it: the record ADR-ADO-NAME in docs/drs/index.md, and the diagram docs/explanation/design/.assets/four-domains-promote-one-artifact.drawio.png.
