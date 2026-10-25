---
catzc:
  config:
    pattern: fact
    deck: vendor-for-sre-lead
    order: 7
    picture:
      mode: reduce
      source: ../../flow/.assets/apex-thirteen-rules-seven-includes-six-excludes.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
---

# GitHub: the same CI gate runs there as in Azure DevOps, on the same paths

## Eyebrow

7 / 30 · fact for the SRE Lead · ADR-GH-RELEASE

## Lead

For the SRE Lead, who owns reliability, monitoring and the switch: ci-pwsh runs on pushes and pull requests that touch pwsh/**, in both
engines, running the same test level.

## Image

.assets/adr-gh-release-7.png

## Caption

From the catalogue, reduced: apex thirteen rules seven includes six excludes.

## Notes

Check it: the record ADR-GH-RELEASE in docs/drs/index.md, and the diagram
docs/explanation/flow/.assets/apex-thirteen-rules-seven-includes-six-excludes.drawio.png.
