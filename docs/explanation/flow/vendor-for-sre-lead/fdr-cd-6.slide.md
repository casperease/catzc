---
catzc:
  config:
    pattern: fact
    deck: vendor-for-sre-lead
    order: 6
    picture:
      mode: reduce
      source: ../../flow/.assets/how-the-customer-cd-pipeline-builds-and-deploys.drawio.png
      scale: 0.4
---

# Azure DevOps: environment approvals are one config and one apply command

## Eyebrow

6 / 30 · fact for the SRE Lead · FDR-CD

## Lead

For the SRE Lead, who owns reliability, monitoring and the switch: The approver group and the prod-tier environments are declared once; the
apply makes the org match.

## Image

[fdr-cd-6](.assets/fdr-cd-6.png)

## Caption

From the catalogue, reduced: cd builds once then deploys non-prod.

## Notes

Check it: the record FDR-CD in docs/drs/index.md, and the diagram
docs/explanation/flow/.assets/how-the-customer-cd-pipeline-builds-and-deploys.drawio.png.
