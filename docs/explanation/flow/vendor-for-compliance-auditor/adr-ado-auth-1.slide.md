---
catzc:
  config:
    pattern: fact
    deck: vendor-for-compliance-auditor
    order: 1
    picture:
      mode: reduce
      source: ../../design/.assets/every-vendor-call-leaves-through-az.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-ADO-AUTH
---

# Azure DevOps: a configured credential proves its organization before any call

## Eyebrow

1 / 30 · fact for the Compliance Auditor · ADR-ADO-AUTH

## Lead

For the Compliance Auditor, who reads the history and the registry: The credential is checked against the org it claims; a mismatch stops discovery at the first call.

## Image

.assets/adr-ado-auth-1.png

## Caption

From the catalogue, reduced: every vendor call leaves through az.

## Notes

Check it: the record ADR-ADO-AUTH in docs/drs/index.md, and the diagram docs/explanation/design/.assets/every-vendor-call-leaves-through-az.drawio.png.
