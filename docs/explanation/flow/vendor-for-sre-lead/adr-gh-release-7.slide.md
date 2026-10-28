---
catzc:
  config:
    pattern: fact
    deck: vendor-for-sre-lead
    order: 7
---

# GitHub: the same CI gate runs there as in Azure DevOps, on the same paths

## Eyebrow

7 / 30 · fact for the SRE Lead · ADR-GH-RELEASE

## Lead

For the SRE Lead, who owns reliability, monitoring and the switch: ci-pwsh runs on pushes and pull requests that touch pwsh/**, in both
engines, running the same test level.

## Notes

Check it: the record ADR-GH-RELEASE in docs/drs/index.md.
