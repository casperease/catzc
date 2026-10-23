---
catzc:
  config:
    pattern: fact
    deck: jokes-config
    order: 4
    picture:
      mode: reduce
      source: ../../flow/.assets/the-step-is-named-after-its-command.drawio.png
      scale: 0.4
      rotate: -4
  edges:
    cites:
      - ADR-AUTO-DEFAULT
---

# John Doe passed a value, the config had another, the type had a third; the order picked John's, as it always does

## Eyebrow

4 / 10 · fact · ADR-AUTO-DEFAULT

## Lead

Caller's value, else config, else default: one resolution order for every setting.

## Image

.assets/resolution-order-john.png

## Caption

From the catalogue, reduced: the step is named after its command.

## Notes

Check it: the record ADR-AUTO-DEFAULT in docs/drs/index.md, and the diagram docs/explanation/flow/.assets/the-step-is-named-after-its-command.drawio.png.
