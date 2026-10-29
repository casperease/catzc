---
catzc:
  config:
    pattern: fact
    deck: truth-travels
    order: 9
    picture:
      mode: reduce
      source: ../../repository/.assets/how-the-contract-reference-is-built.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
---

# A command is public only through a contract

## Eyebrow

9 / 15 · fact · ADR-REPO-CONTRACT

## Lead

The contract names the command, its parameters and its promise; the reference pages are built from it, and a drift between contract and code
is a gate finding.

## Image

[public-by-contract](.assets/public-by-contract.png)

## Caption

From the catalogue, reduced: building the contract reference writes one page per unit.

## Notes

Check it: the record ADR-REPO-CONTRACT in docs/drs/index.md, and the diagram
docs/explanation/repository/.assets/how-the-contract-reference-is-built.drawio.png.
