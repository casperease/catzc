---
catzc:
  config:
    pattern: fact
    deck: vendor-for-security-officer
    order: 17
    picture:
      mode: reduce
      source: ../../design/.assets/one-folder-two-independent-readers.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-CAF-GOV
---

# Azure CAF governance: policies are declared in code and applied, never set by hand

## Eyebrow

17 / 30 · fact for the Security Officer · ADR-AZ-CAF-GOV

## Lead

For the Security Officer, who owns identity, policy and the audit trail: The cloud adoption framework's governance items are answered one by one in the records.

## Image

.assets/adr-az-caf-gov-17.png

## Caption

From the catalogue, reduced: one folder two independent readers.

## Notes

Check it: the record ADR-AZ-CAF-GOV in docs/drs/index.md, and the diagram docs/explanation/design/.assets/one-folder-two-independent-readers.drawio.png.
