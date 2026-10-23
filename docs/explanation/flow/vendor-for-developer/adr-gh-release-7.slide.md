---
catzc:
  config:
    pattern: fact
    deck: vendor-for-developer
    order: 7
    picture:
      mode: reduce
      source: ../../flow/.assets/three-views-derived-live-from-one-program.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-GH-RELEASE
---

# GitHub: the same CI gate runs there as in Azure DevOps, on the same paths

## Eyebrow

7 / 30 · fact for the Developer · ADR-GH-RELEASE

## Lead

For the Developer, who edits one file, runs one gate, pushes one topic: ci-pwsh runs on pushes and pull requests that touch pwsh/**, in both engines, running the same test level.

## Image

.assets/adr-gh-release-7.png

## Caption

From the catalogue, reduced: three views derived live from one program.

## Notes

Check it: the record ADR-GH-RELEASE in docs/drs/index.md, and the diagram docs/explanation/flow/.assets/three-views-derived-live-from-one-program.drawio.png.
