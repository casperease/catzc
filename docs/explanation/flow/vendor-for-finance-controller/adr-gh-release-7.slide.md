---
catzc:
  config:
    pattern: fact
    deck: vendor-for-finance-controller
    order: 7
    picture:
      mode: reduce
      source: ../../automation/.assets/decide-returns-null-or-a-reason.drawio.png
      scale: 0.4
      rotate: -4
  edges:
    cites:
      - ADR-GH-RELEASE
---

# GitHub: the same CI gate runs there as in Azure DevOps, on the same paths

## Eyebrow

7 / 30 · fact for the Finance Controller · ADR-GH-RELEASE

## Lead

For the Finance Controller, who pays for every environment and every wait: ci-pwsh runs on pushes and pull requests that touch pwsh/**, in both engines, running the same test level.

## Image

.assets/adr-gh-release-7.png

## Caption

From the catalogue, reduced: decide returns null or a reason.

## Notes

Check it: the record ADR-GH-RELEASE in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/decide-returns-null-or-a-reason.drawio.png.
