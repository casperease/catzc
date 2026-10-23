---
catzc:
  config:
    pattern: fact
    deck: vendor-for-cto
    order: 7
    picture:
      mode: reduce
      source: ../../flow/.assets/one-boolean-answer-from-one-function.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
  edges:
    cites:
      - ADR-GH-RELEASE
---

# GitHub: the same CI gate runs there as in Azure DevOps, on the same paths

## Eyebrow

7 / 30 · fact for the CTO · ADR-GH-RELEASE

## Lead

For the CTO, who owns the delivery system and its cost: ci-pwsh runs on pushes and pull requests that touch pwsh/**, in both engines, running the same test level.

## Image

.assets/adr-gh-release-7.png

## Caption

From the catalogue, reduced: one boolean answer from one function.

## Notes

Check it: the record ADR-GH-RELEASE in docs/drs/index.md, and the diagram docs/explanation/flow/.assets/one-boolean-answer-from-one-function.drawio.png.
