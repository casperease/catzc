---
catzc:
  config:
    pattern: fact
    deck: vendor-for-cto
    order: 9
    picture:
      mode: reduce
      source: ../../automation/.assets/three-tests-prove-the-hook.drawio.png
      scale: 0.4
      rotate: -4
  edges:
    cites:
      - ADR-AZ-NAMING
---

# Azure: every resource name is built by one naming standard and is never truncated

## Eyebrow

9 / 30 · fact for the CTO · ADR-AZ-NAMING

## Lead

For the CTO, who owns the delivery system and its cost: Each naming rule is held in one place; a name that would truncate is a finding, not a shorter name.

## Image

.assets/adr-az-naming-9.png

## Caption

From the catalogue, reduced: three tests prove the hook.

## Notes

Check it: the record ADR-AZ-NAMING in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/three-tests-prove-the-hook.drawio.png.
