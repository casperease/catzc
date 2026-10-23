---
catzc:
  config:
    pattern: fact
    deck: vendor-for-head-of-platform
    order: 19
    picture:
      mode: reduce
      source: ../../../../docs/references/pwsh/.assets/module-graph-declared-vs-observed.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-CAF-SEC
---

# Azure CAF security: secrets are injected at deploy time and never stored in the tree

## Eyebrow

19 / 30 · fact for the Head of Platform · ADR-AZ-CAF-SEC

## Lead

For the Head of Platform, who runs the platform other teams build on: The repository holds a template through BVT; the value arrives only at deploy.

## Image

.assets/adr-az-caf-sec-19.png

## Caption

From the catalogue, reduced: module graph declared vs observed.

## Notes

Check it: the record ADR-AZ-CAF-SEC in docs/drs/index.md, and the diagram docs/references/pwsh/.assets/module-graph-declared-vs-observed.drawio.png.
