---
catzc:
  config:
    pattern: fact
    deck: vendor-for-compliance-auditor
    order: 20
    picture:
      mode: reduce
      source: ../../ado/.assets/one-header-function-owns-precedence.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
  edges:
    cites:
      - ADR-AZ-CAF-BILL
---

# Azure CAF billing: every environment is a named slot with a known owner and a known cost

## Eyebrow

20 / 30 · fact for the Compliance Auditor · ADR-AZ-CAF-BILL

## Lead

For the Compliance Auditor, who reads the history and the registry: One occupant per environment keeps the bill a list of named rungs.

## Image

.assets/adr-az-caf-bill-20.png

## Caption

From the catalogue, reduced: one header function owns precedence.

## Notes

Check it: the record ADR-AZ-CAF-BILL in docs/drs/index.md, and the diagram docs/explanation/ado/.assets/one-header-function-owns-precedence.drawio.png.
