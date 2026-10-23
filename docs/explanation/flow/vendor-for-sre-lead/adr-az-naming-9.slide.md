---
catzc:
  config:
    pattern: fact
    deck: vendor-for-sre-lead
    order: 9
    picture:
      mode: reduce
      source: ../../flow/.assets/ci-budget-is-the-only-quality-gate.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
  edges:
    cites:
      - ADR-AZ-NAMING
---

# Azure: every resource name is built by one naming standard and is never truncated

## Eyebrow

9 / 30 · fact for the SRE Lead · ADR-AZ-NAMING

## Lead

For the SRE Lead, who owns reliability, monitoring and the switch: Each naming rule is held in one place; a name that would truncate is a finding, not a shorter name.

## Image

.assets/adr-az-naming-9.png

## Caption

From the catalogue, reduced: ci budget is the only quality gate.

## Notes

Check it: the record ADR-AZ-NAMING in docs/drs/index.md, and the diagram docs/explanation/flow/.assets/ci-budget-is-the-only-quality-gate.drawio.png.
