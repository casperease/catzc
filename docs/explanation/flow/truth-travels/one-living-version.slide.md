---
catzc:
  config:
    pattern: fact
    deck: truth-travels
    order: 2
    picture:
      mode: reduce
      source: ../../design/.assets/a-sibling-is-an-idea-never-a-reference.drawio.png
      scale: 0.4
---

# The repository carries exactly one living version of every behaviour

## Eyebrow

2 / 15 · fact · PDR-ONELIVE

## Lead

No shims, no deprecated aliases, no legacy folders. A contract changes with every in-tree caller in the same change, and history lives in
git, never in retained files.

## Image

[one-living-version](.assets/one-living-version.png)

## Caption

From the catalogue, reduced: a sibling is an idea never a reference.

## Notes

Check it: the record PDR-ONELIVE in docs/drs/index.md, and the diagram
docs/explanation/design/.assets/a-sibling-is-an-idea-never-a-reference.drawio.png.
