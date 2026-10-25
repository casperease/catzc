---
catzc:
  config:
    pattern: fact
    deck: vendor-for-sre-lead
    order: 10
    picture:
      mode: reduce
      source: ../../design/.assets/deploy-bicep-delegates-to-az.drawio.png
      scale: 0.4
---

# Azure: a name that does not fit fails, it does not shrink

## Eyebrow

10 / 30 · fact for the SRE Lead · ADR-AZ-NAMING-NEVERTRUNCATE

## Lead

For the SRE Lead, who owns reliability, monitoring and the switch: The rule chooses an error over a silently shortened, colliding name.

## Image

.assets/adr-az-naming-nevertruncate-10.png

## Caption

From the catalogue, reduced: deploy bicep delegates to az.

## Notes

Check it: the record ADR-AZ-NAMING-NEVERTRUNCATE in docs/drs/index.md, and the diagram
docs/explanation/design/.assets/deploy-bicep-delegates-to-az.drawio.png.
