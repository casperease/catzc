---
catzc:
  config:
    pattern: fact
    deck: truth-travels
    order: 13
---

# Varying behaviour is configuration, declared once with its default

## Eyebrow

13 / 15 · fact · PDR-CONFIG

## Lead

A new instance is a config change, never new code. The default is declared once, on the type, and a resolver reads the caller's value, then
the config, then the default.

## Notes

Check it: the record PDR-CONFIG in docs/drs/index.md.
