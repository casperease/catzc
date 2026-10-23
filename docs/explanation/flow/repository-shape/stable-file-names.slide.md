---
catzc:
  config:
    pattern: fact
    deck: repository-shape
    order: 3
    picture:
      mode: reduce
      source: ../../configuration/.assets/two-test-files-check-the-address-rules.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-REPO-FOLDERS
---

# A file name is stable: order and state live in heads, never in a prefix

## Eyebrow

3 / 14 · fact · ADR-REPO-FOLDERS

## Lead

A slide's order is a head key; a numbered prefix in a name is a finding, because a rename to reorder breaks every link to it.

## Image

.assets/stable-file-names.png

## Caption

From the catalogue, reduced: two test files check the address rules.

## Notes

Check it: the record ADR-REPO-FOLDERS in docs/drs/index.md, and the diagram docs/explanation/configuration/.assets/two-test-files-check-the-address-rules.drawio.png.
