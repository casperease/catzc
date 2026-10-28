---
catzc:
  config:
    pattern: fact
    deck: vendor-for-sre-lead
    order: 14
---

# Azure: a session is authenticated once and asserted before every command

## Eyebrow

14 / 30 · fact for the SRE Lead · ADR-AZ-SESSION

## Lead

For the SRE Lead, who owns reliability, monitoring and the switch: A guard checks the session; a guard's verdict is never cached across a
session.

## Notes

Check it: the record ADR-AZ-SESSION in docs/drs/index.md.
