---
catzc:
  config:
    pattern: fact
    deck: vendor-for-finance-controller
    order: 14
    picture:
      mode: reduce
      source: ../../configuration/.assets/strip-split-walk-every-wrong-turn-throws.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-SESSION
---

# Azure: a session is authenticated once and asserted before every command

## Eyebrow

14 / 30 · fact for the Finance Controller · ADR-AZ-SESSION

## Lead

For the Finance Controller, who pays for every environment and every wait: A guard checks the session; a guard's verdict is never cached across a session.

## Image

.assets/adr-az-session-14.png

## Caption

From the catalogue, reduced: strip split walk every wrong turn throws.

## Notes

Check it: the record ADR-AZ-SESSION in docs/drs/index.md, and the diagram docs/explanation/configuration/.assets/strip-split-walk-every-wrong-turn-throws.drawio.png.
