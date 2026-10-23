---
catzc:
  config:
    pattern: fact
    deck: vendor-for-release-manager
    order: 8
    picture:
      mode: reduce
      source: ../../azure/.assets/three-kinds-of-infrastructure-code.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-DATAMOD
---

# Azure: one file, one subscription; the data model is a tree of named slots

## Eyebrow

8 / 30 · fact for the Release Manager · ADR-AZ-DATAMOD

## Lead

For the Release Manager, who serves the signatures and watches the ladder: A coordinate names a subscription, an environment and a slot; a bad coordinate stops discovery.

## Image

.assets/adr-az-datamod-8.png

## Caption

From the catalogue, reduced: three kinds of infrastructure code.

## Notes

Check it: the record ADR-AZ-DATAMOD in docs/drs/index.md, and the diagram docs/explanation/azure/.assets/three-kinds-of-infrastructure-code.drawio.png.
