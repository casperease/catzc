---
catzc:
  config:
    pattern: fact
    deck: vendor-for-sre-lead
    order: 4
    picture:
      mode: reduce
      source: ../../design/.assets/a-push-fires-only-touched-pipelines.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-ADO-VAR
---

# Azure DevOps: variables are declared once and injected at deploy time

## Eyebrow

4 / 30 · fact for the SRE Lead · ADR-ADO-VAR

## Lead

For the SRE Lead, who owns reliability, monitoring and the switch: Secrets and some state are injected only at deploy; the repository holds a template through BVT.

## Image

.assets/adr-ado-var-4.png

## Caption

From the catalogue, reduced: a push fires only touched pipelines.

## Notes

Check it: the record ADR-ADO-VAR in docs/drs/index.md, and the diagram docs/explanation/design/.assets/a-push-fires-only-touched-pipelines.drawio.png.
