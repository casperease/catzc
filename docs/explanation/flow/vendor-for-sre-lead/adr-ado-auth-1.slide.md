---
catzc:
  config:
    pattern: fact
    deck: vendor-for-sre-lead
    order: 1
    picture:
      mode: reduce
      source: ../../ado/.assets/configured-credential-proves-its-org.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
---

# Azure DevOps: a configured credential proves its organization before any call

## Eyebrow

1 / 30 · fact for the SRE Lead · ADR-ADO-AUTH

## Lead

For the SRE Lead, who owns reliability, monitoring and the switch: The credential is checked against the org it claims; a mismatch stops
discovery at the first call.

## Image

[adr-ado-auth-1](.assets/adr-ado-auth-1.png)

## Caption

From the catalogue, reduced: configured credential proves its org.

## Notes

Check it: the record ADR-ADO-AUTH in docs/drs/index.md, and the diagram
docs/explanation/ado/.assets/configured-credential-proves-its-org.drawio.png.
