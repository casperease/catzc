---
catzc:
  config:
    pattern: fact
    deck: vendor-for-sre-lead
    order: 22
    picture:
      mode: reduce
      source: ../../design/.assets/globs-yml-pipeline-field-is-the-binding.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-CAF-NAME
---

# Azure CAF naming: one standard, one builder, one gate

## Eyebrow

22 / 30 · fact for the SRE Lead · ADR-AZ-CAF-NAME

## Lead

For the SRE Lead, who owns reliability, monitoring and the switch: The naming standard is a record; the builder is code; a gate checks every name.

## Image

.assets/adr-az-caf-name-22.png

## Caption

From the catalogue, reduced: globs yml pipeline field is the binding.

## Notes

Check it: the record ADR-AZ-CAF-NAME in docs/drs/index.md, and the diagram docs/explanation/design/.assets/globs-yml-pipeline-field-is-the-binding.drawio.png.
