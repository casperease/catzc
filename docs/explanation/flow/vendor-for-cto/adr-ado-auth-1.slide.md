---
catzc:
  config:
    pattern: fact
    deck: vendor-for-cto
    order: 1
    picture:
      mode: reduce
      source: ../../azure/.assets/add-an-environment-slot.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
  edges:
    cites:
      - ADR-ADO-AUTH
---

# Azure DevOps: a configured credential proves its organization before any call

## Eyebrow

1 / 30 · fact for the CTO · ADR-ADO-AUTH

## Lead

For the CTO, who owns the delivery system and its cost: The credential is checked against the org it claims; a mismatch stops discovery at the first call.

## Image

.assets/adr-ado-auth-1.png

## Caption

From the catalogue, reduced: add an environment slot.

## Notes

Check it: the record ADR-ADO-AUTH in docs/drs/index.md, and the diagram docs/explanation/azure/.assets/add-an-environment-slot.drawio.png.
