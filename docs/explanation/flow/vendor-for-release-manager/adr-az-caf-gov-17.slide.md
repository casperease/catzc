---
catzc:
  config:
    pattern: fact
    deck: vendor-for-release-manager
    order: 17
    picture:
      mode: reduce
      source: ../../automation/.assets/one-out-string-two-places.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
  edges:
    cites:
      - ADR-AZ-CAF-GOV
---

# Azure CAF governance: policies are declared in code and applied, never set by hand

## Eyebrow

17 / 30 · fact for the Release Manager · ADR-AZ-CAF-GOV

## Lead

For the Release Manager, who serves the signatures and watches the ladder: The cloud adoption framework's governance items are answered one by one in the records.

## Image

.assets/adr-az-caf-gov-17.png

## Caption

From the catalogue, reduced: one out string two places.

## Notes

Check it: the record ADR-AZ-CAF-GOV in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/one-out-string-two-places.drawio.png.
