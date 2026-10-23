---
catzc:
  config:
    pattern: fact
    deck: pairs-of-rules
    order: 4
    picture:
      mode: reduce
      source: ../../azure/.assets/lookup-form-check-render-in-order.drawio.png
      scale: 0.4
  edges:
    cites:
      - PDR-POKAYOKE
---

# Earliest detection needs a bounded wait: PDR-POKAYOKE and ADR-AUTO-FAILFAST are one idea

## Eyebrow

4 / 14 · fact · PDR-POKAYOKE

## Lead

A fault found at the first line that can see it is worthless if the run hangs before reporting it.

## Image

.assets/pokayoke-needs-failfast.png

## Caption

From the catalogue, reduced: lookup form check render in order.

## Notes

Check it: the record PDR-POKAYOKE in docs/drs/index.md, and the diagram docs/explanation/azure/.assets/lookup-form-check-render-in-order.drawio.png.
