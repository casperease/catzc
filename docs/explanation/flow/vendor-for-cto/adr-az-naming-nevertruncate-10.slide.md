---
catzc:
  config:
    pattern: fact
    deck: vendor-for-cto
    order: 10
    picture:
      mode: reduce
      source: ../../flow/.assets/one-scan-program-feeds-three-roles.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-NAMING-NEVERTRUNCATE
---

# Azure: a name that does not fit fails, it does not shrink

## Eyebrow

10 / 30 · fact for the CTO · ADR-AZ-NAMING-NEVERTRUNCATE

## Lead

For the CTO, who owns the delivery system and its cost: The rule chooses an error over a silently shortened, colliding name.

## Image

.assets/adr-az-naming-nevertruncate-10.png

## Caption

From the catalogue, reduced: one scan program feeds three roles.

## Notes

Check it: the record ADR-AZ-NAMING-NEVERTRUNCATE in docs/drs/index.md, and the diagram docs/explanation/flow/.assets/one-scan-program-feeds-three-roles.drawio.png.
