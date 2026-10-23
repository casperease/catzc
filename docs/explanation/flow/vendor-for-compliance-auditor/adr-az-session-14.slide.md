---
catzc:
  config:
    pattern: fact
    deck: vendor-for-compliance-auditor
    order: 14
    picture:
      mode: reduce
      source: ../../../../docs/drs/automation/BCL/.assets/bcl-language.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
  edges:
    cites:
      - ADR-AZ-SESSION
---

# Azure: a session is authenticated once and asserted before every command

## Eyebrow

14 / 30 · fact for the Compliance Auditor · ADR-AZ-SESSION

## Lead

For the Compliance Auditor, who reads the history and the registry: A guard checks the session; a guard's verdict is never cached across a session.

## Image

.assets/adr-az-session-14.png

## Caption

From the catalogue, reduced: bcl language.

## Notes

Check it: the record ADR-AZ-SESSION in docs/drs/index.md, and the diagram docs/drs/automation/BCL/.assets/bcl-language.drawio.png.
