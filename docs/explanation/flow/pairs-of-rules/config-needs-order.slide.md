---
catzc:
  config:
    pattern: fact
    deck: pairs-of-rules
    order: 3
    picture:
      mode: reduce
      source: ../../design/.assets/manifest-and-aspects-from-one-folder.drawio.png
      scale: 0.4
  edges:
    cites:
      - PDR-CONFIG
---

# A default declared once is only useful with one resolution order: PDR-CONFIG needs ADR-AUTO-DEFAULT

## Eyebrow

3 / 14 · fact · PDR-CONFIG

## Lead

Caller's value, else config, else default. Without the order, the one declaration is read three ways.

## Image

.assets/config-needs-order.png

## Caption

From the catalogue, reduced: manifest and aspects from one folder.

## Notes

Check it: the record PDR-CONFIG in docs/drs/index.md, and the diagram docs/explanation/design/.assets/manifest-and-aspects-from-one-folder.drawio.png.
