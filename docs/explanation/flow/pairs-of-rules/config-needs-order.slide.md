---
catzc:
  config:
    pattern: fact
    deck: pairs-of-rules
    order: 3
---

# A default declared once is only useful with one resolution order: PDR-CONFIG needs ADR-AUTO-DEFAULT

## Eyebrow

3 / 14 · fact · PDR-CONFIG

## Lead

Caller's value, else config, else default. Without the order, the one declaration is read three ways.

## Notes

Check it: the record PDR-CONFIG in docs/drs/index.md.
