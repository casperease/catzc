---
catzc:
  config:
    pattern: fact
    deck: vendor-for-compliance-auditor
    order: 22
    picture:
      mode: reduce
      source: ../../ado/.assets/what-you-set-decides-the-credential.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
  edges:
    cites:
      - ADR-AZ-CAF-NAME
---

# Azure CAF naming: one standard, one builder, one gate

## Eyebrow

22 / 30 · fact for the Compliance Auditor · ADR-AZ-CAF-NAME

## Lead

For the Compliance Auditor, who reads the history and the registry: The naming standard is a record; the builder is code; a gate checks every name.

## Image

.assets/adr-az-caf-name-22.png

## Caption

From the catalogue, reduced: what you set decides the credential.

## Notes

Check it: the record ADR-AZ-CAF-NAME in docs/drs/index.md, and the diagram docs/explanation/ado/.assets/what-you-set-decides-the-credential.drawio.png.
