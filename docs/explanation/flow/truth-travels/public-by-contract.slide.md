---
catzc:
  config:
    pattern: fact
    deck: truth-travels
    order: 9
    picture:
      mode: reduce
      source: ../../automation/.assets/build-verify-then-copy-the-folder.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
  edges:
    cites:
      - ADR-REPO-CONTRACT
---

# A command is public only through a contract

## Eyebrow

9 / 15 · fact · ADR-REPO-CONTRACT

## Lead

The contract names the command, its parameters and its promise; the reference pages are built from it, and a drift between contract and code is a gate finding.

## Image

.assets/public-by-contract.png

## Caption

From the catalogue, reduced: build verify then copy the folder.

## Notes

Check it: the record ADR-REPO-CONTRACT in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/build-verify-then-copy-the-folder.drawio.png.
