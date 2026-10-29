---
catzc:
  config:
    pattern: fact
    deck: truth-travels
    order: 7
    picture:
      mode: reduce
      source: ../../design/.assets/where-partition-integrity-is-checked.drawio.png
      scale: 0.4
---

# One function per file: Get-Foo.ps1 holds exactly function Get-Foo

## Eyebrow

7 / 15 · fact · ADR-PWSH-ONEFUNC

## Lead

Down into implementation: a module is a folder, a public function is a file at its root, a private one sits in private/. A gate counts them.

## Image

[one-function-per-file](.assets/one-function-per-file.png)

## Caption

From the catalogue, reduced: partition integrity runs only in unit tests.

## Notes

Check it: the record ADR-PWSH-ONEFUNC in docs/drs/index.md, and the diagram
docs/explanation/design/.assets/where-partition-integrity-is-checked.drawio.png.
