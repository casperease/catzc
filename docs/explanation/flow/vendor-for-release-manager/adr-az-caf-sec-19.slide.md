---
catzc:
  config:
    pattern: fact
    deck: vendor-for-release-manager
    order: 19
    picture:
      mode: reduce
      source: ../../automation/.assets/one-rule-per-stage-and-two-gaps.drawio.png
      scale: 0.4
      rotate: -4
  edges:
    cites:
      - ADR-AZ-CAF-SEC
---

# Azure CAF security: secrets are injected at deploy time and never stored in the tree

## Eyebrow

19 / 30 · fact for the Release Manager · ADR-AZ-CAF-SEC

## Lead

For the Release Manager, who serves the signatures and watches the ladder: The repository holds a template through BVT; the value arrives only at deploy.

## Image

.assets/adr-az-caf-sec-19.png

## Caption

From the catalogue, reduced: one rule per stage and two gaps.

## Notes

Check it: the record ADR-AZ-CAF-SEC in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/one-rule-per-stage-and-two-gaps.drawio.png.
