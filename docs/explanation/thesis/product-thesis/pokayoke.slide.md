---
catzc:
  config:
    pattern: table
    deck: product-thesis
    order: 15
---

# Poka-yoke, make mistakes impossible

## Eyebrow

Principle 5 of 6 · PDR-POKAYOKE

## Rows

| Rule                            | Says                                                                                       |
| ------------------------------- | ------------------------------------------------------------------------------------------ |
| PDR-POKAYOKE-PREVENTBYSTRUCTURE | Prefer structural prevention: derive behaviour from convention, nothing to register        |
| PDR-POKAYOKE-DETECTEARLIEST     | Where prevention fails, detect at the earliest moment, never in production, never silently |
| PDR-POKAYOKE-FAILFAST           | Fail fast: stop at the defect and fix it at source, jidoka                                 |
| PDR-POKAYOKE-ZEROCEREMONY       | Zero ceremony: one action, no prerequisites, no follow-up                                  |
| PDR-POKAYOKE-TWODESIGNQUESTIONS | Two questions for every design: can the author get this wrong, does this add ceremony      |

## Notes

The folder is the module, so there is nothing to register. An assert is the catzc spelling of jidoka.
