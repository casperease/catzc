---
catzc:
  config:
    pattern: fact
    deck: vendor-for-compliance-auditor
    order: 9
    picture:
      mode: reduce
      source: ../../design/.assets/integrators-sync-from-the-bvt-verified-head.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-NAMING
---

# Azure: every resource name is built by one naming standard and is never truncated

## Eyebrow

9 / 30 · fact for the Compliance Auditor · ADR-AZ-NAMING

## Lead

For the Compliance Auditor, who reads the history and the registry: Each naming rule is held in one place; a name that would truncate is a finding, not a shorter name.

## Image

.assets/adr-az-naming-9.png

## Caption

From the catalogue, reduced: integrators sync from the bvt verified head.

## Notes

Check it: the record ADR-AZ-NAMING in docs/drs/index.md, and the diagram docs/explanation/design/.assets/integrators-sync-from-the-bvt-verified-head.drawio.png.
