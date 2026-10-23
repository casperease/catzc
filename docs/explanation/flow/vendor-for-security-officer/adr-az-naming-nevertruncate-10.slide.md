---
catzc:
  config:
    pattern: fact
    deck: vendor-for-security-officer
    order: 10
    picture:
      mode: reduce
      source: ../../azure/.assets/coordinate-resolved-file-by-file-at-discovery.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
  edges:
    cites:
      - ADR-AZ-NAMING-NEVERTRUNCATE
---

# Azure: a name that does not fit fails, it does not shrink

## Eyebrow

10 / 30 · fact for the Security Officer · ADR-AZ-NAMING-NEVERTRUNCATE

## Lead

For the Security Officer, who owns identity, policy and the audit trail: The rule chooses an error over a silently shortened, colliding name.

## Image

.assets/adr-az-naming-nevertruncate-10.png

## Caption

From the catalogue, reduced: coordinate resolved file by file at discovery.

## Notes

Check it: the record ADR-AZ-NAMING-NEVERTRUNCATE in docs/drs/index.md, and the diagram docs/explanation/azure/.assets/coordinate-resolved-file-by-file-at-discovery.drawio.png.
