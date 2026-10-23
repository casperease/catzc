---
catzc:
  config:
    pattern: fact
    deck: vendor-for-product-owner
    order: 14
    picture:
      mode: reduce
      source: ../../design/.assets/state-changes.drawio.png
      scale: 0.4
      rotate: -4
  edges:
    cites:
      - ADR-AZ-SESSION
---

# Azure: a session is authenticated once and asserted before every command

## Eyebrow

14 / 30 · fact for the Product Owner · ADR-AZ-SESSION

## Lead

For the Product Owner, who wants small batches and visible work: A guard checks the session; a guard's verdict is never cached across a session.

## Image

.assets/adr-az-session-14.png

## Caption

From the catalogue, reduced: state changes.

## Notes

Check it: the record ADR-AZ-SESSION in docs/drs/index.md, and the diagram docs/explanation/design/.assets/state-changes.drawio.png.
