---
catzc:
  config:
    pattern: fact
    deck: vendor-for-sre-lead
    order: 14
    picture:
      mode: reduce
      source: ../../flow/.assets/gates-check-source-and-trigger.drawio.png
      scale: 0.4
---

# Azure: a session is authenticated once and asserted before every command

## Eyebrow

14 / 30 · fact for the SRE Lead · ADR-AZ-SESSION

## Lead

For the SRE Lead, who owns reliability, monitoring and the switch: A guard checks the session; a guard's verdict is never cached across a
session.

## Image

.assets/adr-az-session-14.png

## Caption

From the catalogue, reduced: gates check source and trigger.

## Notes

Check it: the record ADR-AZ-SESSION in docs/drs/index.md, and the diagram
docs/explanation/flow/.assets/gates-check-source-and-trigger.drawio.png.
