---
catzc:
  config:
    pattern: fact
    deck: for-compliance-auditor
    order: 23
    picture:
      mode: reduce
      source: ../../design/.assets/gate-checks-order-not-liveness.drawio.png
      scale: 0.4
  edges:
    cites:
      - RDR-DORA-MAINTAIN
---

# Code maintainability: one function per file, one default declared once, one resolution order

## Eyebrow

23 / 30 · fact for the Compliance Auditor · RDR-DORA-MAINTAIN

## Lead

For the Compliance Auditor, who reads the history and the registry: A gate counts the functions; a type holds the default; every consumer resolves the same way.

## Image

.assets/rdr-dora-maintain-23.png

## Caption

From the catalogue, reduced: gate checks order not liveness.

## Notes

Check it: the record RDR-DORA-MAINTAIN in docs/drs/index.md, and the diagram docs/explanation/design/.assets/gate-checks-order-not-liveness.drawio.png.
