---
catzc:
  immutable:
    repo_status: clean
    path: docs/explanation/thesis/product-thesis/config.slide.md
    folder: docs/explanation/thesis/product-thesis
    name: config-slide
    filetype: md
    role: slide
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    cites:
      - ADR-PRIN-CONFIG
  config:
    pattern: table
    deck: product-thesis
    order: 11
---

# Configure, don't program

## Eyebrow

Principle 2 of 6 · ADR-PRIN-CONFIG

## Rows

| Rule              | Says                                                                                    |
| ----------------- | --------------------------------------------------------------------------------------- |
| ADR-PRIN-CONFIG#1 | Behaviour that varies by instance is a config entry; code is one mechanism per kind     |
| ADR-PRIN-CONFIG#2 | Adding an instance is a config change; new code means the mechanism is missing or wrong |
| ADR-PRIN-CONFIG#3 | Every setting has a sensible default, declared once on its config type                  |
| ADR-PRIN-CONFIG#4 | An exception is a declared config entry with its reason, never a branch in code         |
| ADR-PRIN-CONFIG#5 | A question about one instance is answered by the default; ask only about the default    |

## Notes

One mechanism per kind, one config entry per instance. Rule five saves meetings: supporting an instance costs one line of config, so nobody
asks whether it is worth supporting.
