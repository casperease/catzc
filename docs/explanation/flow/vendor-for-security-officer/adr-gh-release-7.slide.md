---
catzc:
  config:
    pattern: fact
    deck: vendor-for-security-officer
    order: 7
    picture:
      mode: reduce
      source: ../../design/.assets/get-aspect-names-the-remainder.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-GH-RELEASE
---

# GitHub: the same CI gate runs there as in Azure DevOps, on the same paths

## Eyebrow

7 / 30 · fact for the Security Officer · ADR-GH-RELEASE

## Lead

For the Security Officer, who owns identity, policy and the audit trail: ci-pwsh runs on pushes and pull requests that touch pwsh/**, in both engines, running the same test level.

## Image

.assets/adr-gh-release-7.png

## Caption

From the catalogue, reduced: get aspect names the remainder.

## Notes

Check it: the record ADR-GH-RELEASE in docs/drs/index.md, and the diagram docs/explanation/design/.assets/get-aspect-names-the-remainder.drawio.png.
