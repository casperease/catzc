---
catzc:
  config:
    pattern: fact
    deck: vendor-for-release-manager
    order: 7
    picture:
      mode: reduce
      source: ../../automation/.assets/building-the-english-dictionary-writes-one-stamped-word-list.drawio.png
      scale: 0.4
      rotate: -4
  edges:
    cites:
      - ADR-GH-RELEASE
---

# GitHub: the same CI gate runs there as in Azure DevOps, on the same paths

## Eyebrow

7 / 30 · fact for the Release Manager · ADR-GH-RELEASE

## Lead

For the Release Manager, who serves the signatures and watches the ladder: ci-pwsh runs on pushes and pull requests that touch pwsh/**, in both engines, running the same test level.

## Image

.assets/adr-gh-release-7.png

## Caption

From the catalogue, reduced: building the english dictionary writes one stamped word list.

## Notes

Check it: the record ADR-GH-RELEASE in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/building-the-english-dictionary-writes-one-stamped-word-list.drawio.png.
