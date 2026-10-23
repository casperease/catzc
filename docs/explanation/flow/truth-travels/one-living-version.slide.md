---
catzc:
  config:
    pattern: fact
    deck: truth-travels
    order: 2
    picture:
      mode: reduce
      source: ../../automation/.assets/one-commit-one-immutable-package.drawio.png
      scale: 0.4
  edges:
    cites:
      - PDR-ONELIVE
---

# The repository carries exactly one living version of every behaviour

## Eyebrow

2 / 15 · fact · PDR-ONELIVE

## Lead

No shims, no deprecated aliases, no legacy folders. A contract changes with every in-tree caller in the same change, and history lives in git, never in retained files.

## Image

.assets/one-living-version.png

## Caption

From the catalogue, reduced: one commit one immutable package.

## Notes

Check it: the record PDR-ONELIVE in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/one-commit-one-immutable-package.drawio.png.
