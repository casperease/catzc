---
catzc:
  config:
    pattern: fact
    deck: vendor-for-qa-lead
    order: 14
    picture:
      mode: reduce
      source: ../../ado/.assets/configured-credential-proves-its-org.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-SESSION
---

# Azure: a session is authenticated once and asserted before every command

## Eyebrow

14 / 30 · fact for the QA Lead · ADR-AZ-SESSION

## Lead

For the QA Lead, who owns the test levels and their roofs: A guard checks the session; a guard's verdict is never cached across a session.

## Image

.assets/adr-az-session-14.png

## Caption

From the catalogue, reduced: configured credential proves its org.

## Notes

Check it: the record ADR-AZ-SESSION in docs/drs/index.md, and the diagram docs/explanation/ado/.assets/configured-credential-proves-its-org.drawio.png.
