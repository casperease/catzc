---
catzc:
  config:
    pattern: tiles
    deck: product-thesis
    order: 15
---

# One living version

## Eyebrow

Principle 6 of 6 · ADR-PRIN-ONELIVE

## Body

No legacy, no back-compat, history in git: the thesis's only-HEAD rule seen from inside the trunk. Eight rules, one per tile, numbered as
the ADR numbers them.

## Tiles

- 1 One version of every behaviour
- 2 No back-compat shims
- 3 Dead code is deleted
- 4 Trunk-based development
- 5 History lives in git
- 6 Docs read present-tense
- 7 Versioned contracts are legitimate
- 8 Branch by abstraction, bounded

## Notes

Rule seven keeps pins and owned schema versions legitimate: every supported version is equally live. Rule eight is the one bounded exception
to rule two, a seam deleted on cutover.
