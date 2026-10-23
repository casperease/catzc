---
catzc:
  config:
    pattern: fact
    deck: vendor-for-compliance-auditor
    order: 11
    picture:
      mode: reduce
      source: ../../design/.assets/manifest-and-aspects-from-one-folder.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-IACKIND
---

# Azure: infrastructure as code comes in three kinds, templates, configs and modules

## Eyebrow

11 / 30 · fact for the Compliance Auditor · ADR-AZ-IACKIND

## Lead

For the Compliance Auditor, who reads the history and the registry: A kind says where a file lives and what reads it; a template is filled by a config slot.

## Image

.assets/adr-az-iackind-11.png

## Caption

From the catalogue, reduced: manifest and aspects from one folder.

## Notes

Check it: the record ADR-AZ-IACKIND in docs/drs/index.md, and the diagram docs/explanation/design/.assets/manifest-and-aspects-from-one-folder.drawio.png.
