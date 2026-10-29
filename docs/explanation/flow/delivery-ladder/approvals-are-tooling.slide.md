---
catzc:
  config:
    pattern: fact
    deck: delivery-ladder
    order: 11
    picture:
      mode: reduce
      source: ../../design/.assets/which-ladder-stretch-each-pipeline-runs.drawio.png
      scale: 0.4
---

# Approvals live in the engine's checks; the tooling ships and names no approver

## Eyebrow

11 / 12 · fact · FDR-CD

## Lead

One config declares the approver group and the environments; one command applies it to Azure DevOps; a team runs it against its own
organization.

## Image

[approvals-are-tooling](.assets/approvals-are-tooling.png)

## Caption

From the catalogue, reduced: state changes.

## Notes

Check it: the record FDR-CD in docs/drs/index.md, and the diagram docs/explanation/design/.assets/which-ladder-stretch-each-pipeline-runs.drawio.png.
