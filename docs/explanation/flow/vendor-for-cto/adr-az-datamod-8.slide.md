---
catzc:
  config:
    pattern: fact
    deck: vendor-for-cto
    order: 8
    picture:
      mode: reduce
      source: ../../../../docs/references/pwsh/.assets/tools-yml-install-dispatch.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-DATAMOD
---

# Azure: one file, one subscription; the data model is a tree of named slots

## Eyebrow

8 / 30 · fact for the CTO · ADR-AZ-DATAMOD

## Lead

For the CTO, who owns the delivery system and its cost: A coordinate names a subscription, an environment and a slot; a bad coordinate stops discovery.

## Image

.assets/adr-az-datamod-8.png

## Caption

From the catalogue, reduced: tools yml install dispatch.

## Notes

Check it: the record ADR-AZ-DATAMOD in docs/drs/index.md, and the diagram docs/references/pwsh/.assets/tools-yml-install-dispatch.drawio.png.
