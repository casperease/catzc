---
catzc:
  config:
    pattern: fact
    deck: vendor-for-head-of-platform
    order: 7
    picture:
      mode: reduce
      source: ../../azure/.assets/coordinate-rules-and-their-gates.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-GH-RELEASE
---

# GitHub: the same CI gate runs there as in Azure DevOps, on the same paths

## Eyebrow

7 / 30 · fact for the Head of Platform · ADR-GH-RELEASE

## Lead

For the Head of Platform, who runs the platform other teams build on: ci-pwsh runs on pushes and pull requests that touch pwsh/**, in both engines, running the same test level.

## Image

.assets/adr-gh-release-7.png

## Caption

From the catalogue, reduced: coordinate rules and their gates.

## Notes

Check it: the record ADR-GH-RELEASE in docs/drs/index.md, and the diagram docs/explanation/azure/.assets/coordinate-rules-and-their-gates.drawio.png.
