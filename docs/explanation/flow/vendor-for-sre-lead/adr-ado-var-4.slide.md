---
catzc:
  config:
    pattern: fact
    deck: vendor-for-sre-lead
    order: 4
---

# Azure DevOps: variables are declared once and injected at deploy time

## Eyebrow

4 / 30 · fact for the SRE Lead · ADR-ADO-VAR

## Lead

For the SRE Lead, who owns reliability, monitoring and the switch: Secrets and some state are injected only at deploy; the repository holds
a template through BVT.

## Notes

Check it: the record ADR-ADO-VAR in docs/drs/index.md.
