---
catzc:
  config:
    pattern: fact
    deck: for-security-officer
    order: 23
    picture:
      mode: reduce
      source: ../../design/.assets/every-vendor-call-leaves-through-az.drawio.png
      scale: 0.4
  edges:
    cites:
      - RDR-DORA-MAINTAIN
---

# Code maintainability: one function per file, one default declared once, one resolution order

## Eyebrow

23 / 30 · fact for the Security Officer · RDR-DORA-MAINTAIN

## Lead

For the Security Officer, who owns identity, policy and the audit trail: A gate counts the functions; a type holds the default; every consumer resolves the same way.

## Image

.assets/rdr-dora-maintain-23.png

## Caption

From the catalogue, reduced: every vendor call leaves through az.

## Notes

Check it: the record RDR-DORA-MAINTAIN in docs/drs/index.md, and the diagram docs/explanation/design/.assets/every-vendor-call-leaves-through-az.drawio.png.
