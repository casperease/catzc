---
catzc:
  config:
    pattern: fact
    deck: repository-shape
    order: 4
    picture:
      mode: reduce
      source: ../../design/.assets/where-partition-integrity-is-checked.drawio.png
      scale: 0.4
---

# Get-Foo.ps1 holds exactly function Get-Foo, and a module is its folder

## Eyebrow

4 / 14 · fact · ADR-PWSH-ONEFUNC

## Lead

Public at the root, private in private/, every file dot-sourced into the module by the one shared loader; the gate counts the mismatch.

## Image

[one-function-one-file](.assets/one-function-one-file.png)

## Caption

From the catalogue, reduced: partition integrity runs only in unit tests.

## Notes

Check it: the record ADR-PWSH-ONEFUNC in docs/drs/index.md, and the diagram
docs/explanation/design/.assets/where-partition-integrity-is-checked.drawio.png.
