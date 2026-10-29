---
catzc:
  config:
    pattern: fact
    deck: pairs-of-rules
    order: 6
    picture:
      mode: reduce
      source: ../../repository/.assets/how-the-contract-reference-is-built.drawio.png
      scale: 0.4
---

# A contract names a function it can find: ADR-REPO-CONTRACT rests on ADR-PWSH-ONEFUNC

## Eyebrow

6 / 14 · fact · ADR-REPO-CONTRACT

## Lead

One function per file, public by location, is what lets the reference pages be built from the contract and compared to the code.

## Image

[contract-needs-onefunc](.assets/contract-needs-onefunc.png)

## Caption

From the catalogue, reduced: building the contract reference writes one page per unit.

## Notes

Check it: the record ADR-REPO-CONTRACT in docs/drs/index.md, and the diagram
docs/explanation/repository/.assets/how-the-contract-reference-is-built.drawio.png.
