---
catzc:
  config:
    pattern: fact
    deck: vendor-for-release-manager
    order: 2
    picture:
      mode: reduce
      source: ../../azure/.assets/names-are-pure-and-never-truncated.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-ADO-NAME
---

# Azure DevOps: pipeline, environment and policy names come from one naming rule

## Eyebrow

2 / 30 · fact for the Release Manager · ADR-ADO-NAME

## Lead

For the Release Manager, who serves the signatures and watches the ladder: A name is derived from the unit and the rung; nothing is typed in the portal.

## Image

.assets/adr-ado-name-2.png

## Caption

From the catalogue, reduced: names are pure and never truncated.

## Notes

Check it: the record ADR-ADO-NAME in docs/drs/index.md, and the diagram docs/explanation/azure/.assets/names-are-pure-and-never-truncated.drawio.png.
