---
catzc:
  config:
    pattern: fact
    deck: setting-travels
    order: 8
    picture:
      mode: reduce
      source: ../../repository/.assets/how-the-contract-reference-is-built.drawio.png
      scale: 0.4
---

# The contract is the published shape of a command; the code follows it

## Eyebrow

8 / 12 · fact · ADR-REPO-CONTRACT

## Lead

Parameters, defaults and promises live in the contract; the reference pages are built from it; a gate reports the drift between contract and
code.

## Image

[contract-is-the-shape](.assets/contract-is-the-shape.png)

## Caption

From the catalogue, reduced: building the contract reference writes one page per unit.

## Notes

Check it: the record ADR-REPO-CONTRACT in docs/drs/index.md, and the diagram
docs/explanation/repository/.assets/how-the-contract-reference-is-built.drawio.png.
