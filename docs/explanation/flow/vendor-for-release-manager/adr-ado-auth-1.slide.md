---
catzc:
  config:
    pattern: fact
    deck: vendor-for-release-manager
    order: 1
    picture:
      mode: reduce
      source: ../../design/.assets/local-guard-and-server-policies.drawio.png
      scale: 0.4
      rotate: -4
  edges:
    cites:
      - ADR-ADO-AUTH
---

# Azure DevOps: a configured credential proves its organization before any call

## Eyebrow

1 / 30 · fact for the Release Manager · ADR-ADO-AUTH

## Lead

For the Release Manager, who serves the signatures and watches the ladder: The credential is checked against the org it claims; a mismatch stops discovery at the first call.

## Image

.assets/adr-ado-auth-1.png

## Caption

From the catalogue, reduced: local guard and server policies.

## Notes

Check it: the record ADR-ADO-AUTH in docs/drs/index.md, and the diagram docs/explanation/design/.assets/local-guard-and-server-policies.drawio.png.
