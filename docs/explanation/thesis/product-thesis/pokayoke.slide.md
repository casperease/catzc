---
catzc:
  config:
    pattern: table
    deck: product-thesis
    order: 14
---

# Poka-yoke, make mistakes impossible

## Eyebrow

Principle 5 of 6 · ADR-PRIN-POKAYOKE

## Rows

| Rule                                 | Says                                                                                       |
| ------------------------------------ | ------------------------------------------------------------------------------------------ |
| ADR-PRIN-POKAYOKE-PREVENTBYSTRUCTURE | Prefer structural prevention: derive behaviour from convention, nothing to register        |
| ADR-PRIN-POKAYOKE-DETECTEARLIEST     | Where prevention fails, detect at the earliest moment, never in production, never silently |
| ADR-PRIN-POKAYOKE-FAILFAST           | Fail fast: stop at the defect and fix it at source, jidoka                                 |
| ADR-PRIN-POKAYOKE-ZEROCEREMONY       | Zero ceremony: one action, no prerequisites, no follow-up                                  |
| ADR-PRIN-POKAYOKE-TWODESIGNQUESTIONS | Two questions for every design: can the author get this wrong, does this add ceremony      |

## Notes

The folder is the module, so there is nothing to register. An assert is the catzc spelling of jidoka.
