---
catzc:
  config:
    pattern: fact
    deck: vendor-for-compliance-auditor
    order: 21
    picture:
      mode: reduce
      source: ../../design/.assets/partition-integrity-runs-only-in-unit-tests.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-CAF-MGMT
---

# Azure CAF management: monitoring of the switch and the rungs is part of the deploy

## Eyebrow

21 / 30 · fact for the Compliance Auditor · ADR-AZ-CAF-MGMT

## Lead

For the Compliance Auditor, who reads the history and the registry: The slot switch is watched while it runs; the monitors decide the reversal.

## Image

.assets/adr-az-caf-mgmt-21.png

## Caption

From the catalogue, reduced: partition integrity runs only in unit tests.

## Notes

Check it: the record ADR-AZ-CAF-MGMT in docs/drs/index.md, and the diagram docs/explanation/design/.assets/partition-integrity-runs-only-in-unit-tests.drawio.png.
