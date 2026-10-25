---
catzc:
  config:
    pattern: fact
    deck: repository-shape
    order: 4
    picture:
      mode: reduce
      source: ../../automation/.assets/one-rule-per-stage-and-two-gaps.drawio.png
      scale: 0.4
---

# Get-Foo.ps1 holds exactly function Get-Foo, and a module is its folder

## Eyebrow

4 / 14 · fact · ADR-PWSH-ONEFUNC

## Lead

Public at the root, private in private/, every file dot-sourced into the module by the one shared loader; the gate counts the mismatch.

## Image

.assets/one-function-one-file.png

## Caption

From the catalogue, reduced: one rule per stage and two gaps.

## Notes

Check it: the record ADR-PWSH-ONEFUNC in docs/drs/index.md, and the diagram
docs/explanation/automation/.assets/one-rule-per-stage-and-two-gaps.drawio.png.
