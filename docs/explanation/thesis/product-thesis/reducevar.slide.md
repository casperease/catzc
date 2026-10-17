---
catzc:
  edges:
    cites:
      - ADR-PRIN-REDUCEVAR#1
      - ADR-PRIN-REDUCEVAR#2
      - ADR-PRIN-REDUCEVAR#3
  config:
    pattern: table
    deck: product-thesis
    order: 12
---

# Reduce variability

## Eyebrow

Principle 3 of 6 · ADR-PRIN-REDUCEVAR

## Rows

| Rule                 | Says                                                                           |
| -------------------- | ------------------------------------------------------------------------------ |
| ADR-PRIN-REDUCEVAR#1 | Same steps, tools, versions and artifact structure, so deviations stand out    |
| ADR-PRIN-REDUCEVAR#2 | Standardise the process and tooling, not the design space                      |
| ADR-PRIN-REDUCEVAR#3 | Remove accidental differences, make essential ones explicit; one way over many |

## Body

Uniformity in how work is delivered never constrains architectural or creative judgment.

## Notes

When everything is the same, the thing that is different is easy to see. Convention over configuration, derived behaviour over manual
registration.
