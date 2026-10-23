---
catzc:
  config:
    pattern: fact
    deck: vendor-for-security-officer
    order: 9
    picture:
      mode: reduce
      source: ../../design/.assets/guard-and-policies-by-command.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-NAMING
---

# Azure: every resource name is built by one naming standard and is never truncated

## Eyebrow

9 / 30 · fact for the Security Officer · ADR-AZ-NAMING

## Lead

For the Security Officer, who owns identity, policy and the audit trail: Each naming rule is held in one place; a name that would truncate is a finding, not a shorter name.

## Image

.assets/adr-az-naming-9.png

## Caption

From the catalogue, reduced: guard and policies by command.

## Notes

Check it: the record ADR-AZ-NAMING in docs/drs/index.md, and the diagram docs/explanation/design/.assets/guard-and-policies-by-command.drawio.png.
