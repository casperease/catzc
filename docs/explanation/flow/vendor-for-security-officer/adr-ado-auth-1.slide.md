---
catzc:
  config:
    pattern: fact
    deck: vendor-for-security-officer
    order: 1
    picture:
      mode: reduce
      source: ../../design/.assets/every-deploy-stage-is-main-only.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-ADO-AUTH
---

# Azure DevOps: a configured credential proves its organization before any call

## Eyebrow

1 / 30 · fact for the Security Officer · ADR-ADO-AUTH

## Lead

For the Security Officer, who owns identity, policy and the audit trail: The credential is checked against the org it claims; a mismatch stops discovery at the first call.

## Image

.assets/adr-ado-auth-1.png

## Caption

From the catalogue, reduced: every deploy stage is main only.

## Notes

Check it: the record ADR-ADO-AUTH in docs/drs/index.md, and the diagram docs/explanation/design/.assets/every-deploy-stage-is-main-only.drawio.png.
