---
catzc:
  config:
    pattern: fact
    deck: vendor-for-developer
    order: 4
    picture:
      mode: reduce
      source: ../../flow/.assets/the-runner-is-the-only-seam.drawio.png
      scale: 0.4
      rotate: -4
  edges:
    cites:
      - ADR-ADO-VAR
---

# Azure DevOps: variables are declared once and injected at deploy time

## Eyebrow

4 / 30 · fact for the Developer · ADR-ADO-VAR

## Lead

For the Developer, who edits one file, runs one gate, pushes one topic: Secrets and some state are injected only at deploy; the repository holds a template through BVT.

## Image

.assets/adr-ado-var-4.png

## Caption

From the catalogue, reduced: the runner is the only seam.

## Notes

Check it: the record ADR-ADO-VAR in docs/drs/index.md, and the diagram docs/explanation/flow/.assets/the-runner-is-the-only-seam.drawio.png.
