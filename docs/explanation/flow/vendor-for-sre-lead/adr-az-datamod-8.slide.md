---
catzc:
  config:
    pattern: fact
    deck: vendor-for-sre-lead
    order: 8
    picture:
      mode: reduce
      source: ../../design/.assets/code-wires-only-the-first-rungs.drawio.png
      scale: 0.4
---

# Azure: one file, one subscription; the data model is a tree of slots, each with its name

## Eyebrow

8 / 30 · fact for the SRE Lead · ADR-AZ-DATAMOD

## Lead

For the SRE Lead, who owns reliability, monitoring and the switch: A coordinate names a subscription, an environment and a slot; a bad
coordinate stops discovery.

## Image

.assets/adr-az-datamod-8.png

## Caption

From the catalogue, reduced: code wires only the first rungs.

## Notes

Check it: the record ADR-AZ-DATAMOD in docs/drs/index.md, and the diagram
docs/explanation/design/.assets/code-wires-only-the-first-rungs.drawio.png.
