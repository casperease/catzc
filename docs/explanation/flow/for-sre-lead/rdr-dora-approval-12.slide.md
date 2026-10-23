---
catzc:
  config:
    pattern: fact
    deck: for-sre-lead
    order: 12
    picture:
      mode: reduce
      source: ../../design/.assets/partition-integrity-runs-only-in-unit-tests.drawio.png
      scale: 0.4
  edges:
    cites:
      - RDR-DORA-APPROVAL
---

# Streamlined change approval: two signatures in one registry, after an automated test

## Eyebrow

12 / 30 · fact for the SRE Lead · RDR-DORA-APPROVAL

## Lead

For the SRE Lead, who owns reliability, monitoring and the switch: RC and RBC are one release signature each by a user with access; chat and tickets serve no gate.

## Image

.assets/rdr-dora-approval-12.png

## Caption

From the catalogue, reduced: partition integrity runs only in unit tests.

## Notes

Check it: the record RDR-DORA-APPROVAL in docs/drs/index.md, and the diagram docs/explanation/design/.assets/partition-integrity-runs-only-in-unit-tests.drawio.png.
