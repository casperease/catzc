---
catzc:
  config:
    pattern: fact
    deck: vendor-for-release-manager
    order: 10
    picture:
      mode: reduce
      source: ../../configuration/.assets/an-address-is-a-read-only-walk.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-NAMING-NEVERTRUNCATE
---

# Azure: a name that does not fit fails, it does not shrink

## Eyebrow

10 / 30 · fact for the Release Manager · ADR-AZ-NAMING-NEVERTRUNCATE

## Lead

For the Release Manager, who serves the signatures and watches the ladder: The rule chooses an error over a silently shortened, colliding name.

## Image

.assets/adr-az-naming-nevertruncate-10.png

## Caption

From the catalogue, reduced: an address is a read only walk.

## Notes

Check it: the record ADR-AZ-NAMING-NEVERTRUNCATE in docs/drs/index.md, and the diagram docs/explanation/configuration/.assets/an-address-is-a-read-only-walk.drawio.png.
