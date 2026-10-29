---
catzc:
  config:
    pattern: fact
    deck: setting-travels
    order: 7
    picture:
      mode: reduce
      source: ../../design/.assets/partition-integrity-runs-only-in-unit-tests.drawio.png
      scale: 0.4
---

# A module is a folder, and public or private is decided by location

## Eyebrow

7 / 12 · fact · ADR-PWSH-ONEFUNC

## Lead

A .ps1 at the module root is exported; one in private/ is loaded but not exported. The loader is one shared file every module is dot-sourced
by.

## Image

[module-is-a-folder](.assets/module-is-a-folder.png)

## Caption

From the catalogue, reduced: partition integrity runs only in unit tests.

## Notes

Check it: the record ADR-PWSH-ONEFUNC in docs/drs/index.md, and the diagram
docs/explanation/design/.assets/partition-integrity-runs-only-in-unit-tests.drawio.png.
