---
catzc:
  config:
    pattern: fact
    deck: jokes-automation
    order: 6
    picture:
      mode: reduce
      source: ../../automation/.assets/callers-value-else-config-else-default.drawio.png
      scale: 0.4
---

# Pete from IT hardcoded a default in three callers; the type already had it, once

## Eyebrow

6 / 10 · fact · ADR-AUTO-DEFAULT

## Lead

A default is declared once on the config type; a resolver reads the caller's value, else the config, else that default.

## Image

[pete-finds-the-default](.assets/pete-finds-the-default.png)

## Caption

From the catalogue, reduced: the caller's value, else config, else default.

## Notes

Check it: the record ADR-AUTO-DEFAULT in docs/drs/index.md, and the diagram
docs/explanation/automation/.assets/callers-value-else-config-else-default.drawio.png.
