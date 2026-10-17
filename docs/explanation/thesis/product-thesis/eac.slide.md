---
catzc:
  immutable:
    repo_status: clean
    path: docs/explanation/thesis/product-thesis/eac.slide.md
    folder: docs/explanation/thesis/product-thesis
    name: eac-slide
    filetype: md
    kind: slide
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    cites:
      - ADR-PRIN-EAC
  config:
    pattern: table
    deck: product-thesis
    order: 10
---

# Everything as code

## Eyebrow

Principle 1 of 6 · ADR-PRIN-EAC

## Rows

| Rule           | Says                                                                                       |
| -------------- | ------------------------------------------------------------------------------------------ |
| ADR-PRIN-EAC#1 | Every artifact that builds, tests, deploys or operates the system lives in version control |
| ADR-PRIN-EAC#2 | If it can be diffed, reviewed and rolled back, it belongs in version control               |
| ADR-PRIN-EAC#3 | No configuration or operational state outside version control; it drifts silently          |

## Body

These three rules are the mechanics of the thesis's configuration record.

## Notes

Prefer tools that keep their configuration as files over UIs, databases and proprietary formats. Silently is the dangerous word in rule
three.
