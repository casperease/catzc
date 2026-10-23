---
catzc:
  config:
    pattern: fact
    deck: vendor-for-product-owner
    order: 7
    picture:
      mode: reduce
      source: ../../flow/.assets/print-projection-then-drift-names-the-filter.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-GH-RELEASE
---

# GitHub: the same CI gate runs there as in Azure DevOps, on the same paths

## Eyebrow

7 / 30 · fact for the Product Owner · ADR-GH-RELEASE

## Lead

For the Product Owner, who wants small batches and visible work: ci-pwsh runs on pushes and pull requests that touch pwsh/**, in both engines, running the same test level.

## Image

.assets/adr-gh-release-7.png

## Caption

From the catalogue, reduced: print projection then drift names the filter.

## Notes

Check it: the record ADR-GH-RELEASE in docs/drs/index.md, and the diagram docs/explanation/flow/.assets/print-projection-then-drift-names-the-filter.drawio.png.
