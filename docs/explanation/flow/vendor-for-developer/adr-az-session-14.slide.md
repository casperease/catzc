---
catzc:
  config:
    pattern: fact
    deck: vendor-for-developer
    order: 14
    picture:
      mode: reduce
      source: ../../repository/.assets/five-keys-one-reader-twelve-primitives.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
  edges:
    cites:
      - ADR-AZ-SESSION
---

# Azure: a session is authenticated once and asserted before every command

## Eyebrow

14 / 30 · fact for the Developer · ADR-AZ-SESSION

## Lead

For the Developer, who edits one file, runs one gate, pushes one topic: A guard checks the session; a guard's verdict is never cached across a session.

## Image

.assets/adr-az-session-14.png

## Caption

From the catalogue, reduced: five keys one reader twelve primitives.

## Notes

Check it: the record ADR-AZ-SESSION in docs/drs/index.md, and the diagram docs/explanation/repository/.assets/five-keys-one-reader-twelve-primitives.drawio.png.
