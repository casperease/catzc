---
catzc:
  config:
    pattern: fact
    deck: vendor-for-cto
    order: 14
    picture:
      mode: reduce
      source: ../../flow/.assets/one-program-two-vendor-dialects.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-SESSION
---

# Azure: a session is authenticated once and asserted before every command

## Eyebrow

14 / 30 · fact for the CTO · ADR-AZ-SESSION

## Lead

For the CTO, who owns the delivery system and its cost: A guard checks the session; a guard's verdict is never cached across a session.

## Image

.assets/adr-az-session-14.png

## Caption

From the catalogue, reduced: one program two vendor dialects.

## Notes

Check it: the record ADR-AZ-SESSION in docs/drs/index.md, and the diagram docs/explanation/flow/.assets/one-program-two-vendor-dialects.drawio.png.
