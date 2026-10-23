---
catzc:
  config:
    pattern: fact
    deck: vendor-for-security-officer
    order: 8
    picture:
      mode: reduce
      source: ../../azure/.assets/change-one-configuration-slot.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
  edges:
    cites:
      - ADR-AZ-DATAMOD
---

# Azure: one file, one subscription; the data model is a tree of named slots

## Eyebrow

8 / 30 · fact for the Security Officer · ADR-AZ-DATAMOD

## Lead

For the Security Officer, who owns identity, policy and the audit trail: A coordinate names a subscription, an environment and a slot; a bad coordinate stops discovery.

## Image

.assets/adr-az-datamod-8.png

## Caption

From the catalogue, reduced: change one configuration slot.

## Notes

Check it: the record ADR-AZ-DATAMOD in docs/drs/index.md, and the diagram docs/explanation/azure/.assets/change-one-configuration-slot.drawio.png.
