---
catzc:
  config:
    pattern: fact
    deck: vendor-for-compliance-auditor
    order: 7
    picture:
      mode: reduce
      source: ../../design/.assets/guard-and-policies-by-command.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-GH-RELEASE
---

# GitHub: the same CI gate runs there as in Azure DevOps, on the same paths

## Eyebrow

7 / 30 · fact for the Compliance Auditor · ADR-GH-RELEASE

## Lead

For the Compliance Auditor, who reads the history and the registry: ci-pwsh runs on pushes and pull requests that touch pwsh/**, in both engines, running the same test level.

## Image

.assets/adr-gh-release-7.png

## Caption

From the catalogue, reduced: guard and policies by command.

## Notes

Check it: the record ADR-GH-RELEASE in docs/drs/index.md, and the diagram docs/explanation/design/.assets/guard-and-policies-by-command.drawio.png.
