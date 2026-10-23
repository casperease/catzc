---
catzc:
  config:
    pattern: fact
    deck: vendor-for-security-officer
    order: 22
    picture:
      mode: reduce
      source: ../../ado/.assets/one-header-function-owns-precedence.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
  edges:
    cites:
      - ADR-AZ-CAF-NAME
---

# Azure CAF naming: one standard, one builder, one gate

## Eyebrow

22 / 30 · fact for the Security Officer · ADR-AZ-CAF-NAME

## Lead

For the Security Officer, who owns identity, policy and the audit trail: The naming standard is a record; the builder is code; a gate checks every name.

## Image

.assets/adr-az-caf-name-22.png

## Caption

From the catalogue, reduced: one header function owns precedence.

## Notes

Check it: the record ADR-AZ-CAF-NAME in docs/drs/index.md, and the diagram docs/explanation/ado/.assets/one-header-function-owns-precedence.drawio.png.
