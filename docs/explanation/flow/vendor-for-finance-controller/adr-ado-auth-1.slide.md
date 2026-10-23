---
catzc:
  config:
    pattern: fact
    deck: vendor-for-finance-controller
    order: 1
    picture:
      mode: reduce
      source: ../../automation/.assets/a-shell-call-carries-its-limit-or-is-denied.drawio.png
      scale: 0.4
      rotate: -4
  edges:
    cites:
      - ADR-ADO-AUTH
---

# Azure DevOps: a configured credential proves its organization before any call

## Eyebrow

1 / 30 · fact for the Finance Controller · ADR-ADO-AUTH

## Lead

For the Finance Controller, who pays for every environment and every wait: The credential is checked against the org it claims; a mismatch stops discovery at the first call.

## Image

.assets/adr-ado-auth-1.png

## Caption

From the catalogue, reduced: a shell call carries its limit or is denied.

## Notes

Check it: the record ADR-ADO-AUTH in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/a-shell-call-carries-its-limit-or-is-denied.drawio.png.
