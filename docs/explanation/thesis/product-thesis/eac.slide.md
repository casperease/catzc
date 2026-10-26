---
catzc:
  config:
    pattern: table
    deck: product-thesis
    order: 11
---

# Everything as code

## Eyebrow

Principle 1 of 6 · PDR-EAC

## Rows

| Rule                        | Says                                                                                       |
| --------------------------- | ------------------------------------------------------------------------------------------ |
| PDR-EAC-EVERYTHINGCOMMITTED | Every artifact that builds, tests, deploys or operates the system lives in version control |
| PDR-EAC-DIFFABLEISVERSIONED | If it can be diffed, reviewed and rolled back, it belongs in version control               |
| PDR-EAC-NOUNVERSIONEDSTATE  | No configuration or operational state outside version control; it drifts silently          |

## Body

These three rules are the mechanics of the thesis's configuration record.

## Notes

Prefer tools that keep their configuration as files over UIs, databases and proprietary formats. Silently is the dangerous word in rule
three.
