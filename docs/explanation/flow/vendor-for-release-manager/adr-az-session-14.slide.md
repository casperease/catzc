---
catzc:
  config:
    pattern: fact
    deck: vendor-for-release-manager
    order: 14
    picture:
      mode: reduce
      source: ../../configuration/.assets/one-gate-guards-the-read-path.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-SESSION
---

# Azure: a session is authenticated once and asserted before every command

## Eyebrow

14 / 30 · fact for the Release Manager · ADR-AZ-SESSION

## Lead

For the Release Manager, who serves the signatures and watches the ladder: A guard checks the session; a guard's verdict is never cached across a session.

## Image

.assets/adr-az-session-14.png

## Caption

From the catalogue, reduced: one gate guards the read path.

## Notes

Check it: the record ADR-AZ-SESSION in docs/drs/index.md, and the diagram docs/explanation/configuration/.assets/one-gate-guards-the-read-path.drawio.png.
