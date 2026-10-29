---
catzc:
  config:
    pattern: fact
    deck: setting-travels
    order: 3
    picture:
      mode: reduce
      source: ../../automation/.assets/where-a-waits-limit-comes-from.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
---

# A setting resolves in one order: the caller's value, else the config, else the default

## Eyebrow

3 / 12 · fact · ADR-AUTO-DEFAULT

## Lead

Every resolver reads the same way, so a value is explained by where it came from and never by which consumer asked.

## Image

[one-resolution-order](.assets/one-resolution-order.png)

## Caption

From the catalogue, reduced: caller's value, else config, else default.

## Notes

Check it: the record ADR-AUTO-DEFAULT in docs/drs/index.md, and the diagram
docs/explanation/automation/.assets/where-a-waits-limit-comes-from.drawio.png.
