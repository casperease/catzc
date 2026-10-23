---
catzc:
  config:
    pattern: fact
    deck: vendor-for-compliance-auditor
    order: 8
    picture:
      mode: reduce
      source: ../../azure/.assets/coordinate-resolved-file-by-file-at-discovery.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
  edges:
    cites:
      - ADR-AZ-DATAMOD
---

# Azure: one file, one subscription; the data model is a tree of named slots

## Eyebrow

8 / 30 · fact for the Compliance Auditor · ADR-AZ-DATAMOD

## Lead

For the Compliance Auditor, who reads the history and the registry: A coordinate names a subscription, an environment and a slot; a bad coordinate stops discovery.

## Image

.assets/adr-az-datamod-8.png

## Caption

From the catalogue, reduced: coordinate resolved file by file at discovery.

## Notes

Check it: the record ADR-AZ-DATAMOD in docs/drs/index.md, and the diagram docs/explanation/azure/.assets/coordinate-resolved-file-by-file-at-discovery.drawio.png.
