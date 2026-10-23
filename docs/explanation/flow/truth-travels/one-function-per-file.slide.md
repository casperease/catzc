---
catzc:
  config:
    pattern: fact
    deck: truth-travels
    order: 7
    picture:
      mode: reduce
      source: ../../azure/.assets/change-one-configuration-slot.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-PWSH-ONEFUNC
---

# One function per file: Get-Foo.ps1 holds exactly function Get-Foo

## Eyebrow

7 / 15 · fact · ADR-PWSH-ONEFUNC

## Lead

Down into implementation: a module is a folder, a public function is a file at its root, a private one sits in private/. A gate counts them.

## Image

.assets/one-function-per-file.png

## Caption

From the catalogue, reduced: change one configuration slot.

## Notes

Check it: the record ADR-PWSH-ONEFUNC in docs/drs/index.md, and the diagram docs/explanation/azure/.assets/change-one-configuration-slot.drawio.png.
