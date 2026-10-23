---
catzc:
  config:
    pattern: fact
    deck: vendor-for-head-of-platform
    order: 14
    picture:
      mode: reduce
      source: ../../configuration/.assets/callers-in-four-modules-share-one-resolver.drawio.png
      scale: 0.4
      rotate: -4
  edges:
    cites:
      - ADR-AZ-SESSION
---

# Azure: a session is authenticated once and asserted before every command

## Eyebrow

14 / 30 · fact for the Head of Platform · ADR-AZ-SESSION

## Lead

For the Head of Platform, who runs the platform other teams build on: A guard checks the session; a guard's verdict is never cached across a session.

## Image

.assets/adr-az-session-14.png

## Caption

From the catalogue, reduced: callers in four modules share one resolver.

## Notes

Check it: the record ADR-AZ-SESSION in docs/drs/index.md, and the diagram docs/explanation/configuration/.assets/callers-in-four-modules-share-one-resolver.drawio.png.
