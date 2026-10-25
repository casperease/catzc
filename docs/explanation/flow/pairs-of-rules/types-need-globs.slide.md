---
catzc:
  config:
    pattern: fact
    deck: pairs-of-rules
    order: 13
    picture:
      mode: reduce
      source: ../../design/.assets/partition-integrity-runs-only-in-unit-tests.drawio.png
      scale: 0.4
---

# A pipeline type triggers on a globset: FDR-CD-TYPE rests on FDR-CD-GLOBS

## Eyebrow

13 / 14 · fact · FDR-CD-TYPE

## Lead

The closed set of types needs a durable way to say which paths wake which type; the globsets project into the native filters.

## Image

.assets/types-need-globs.png

## Caption

From the catalogue, reduced: partition integrity runs only in unit tests.

## Notes

Check it: the record FDR-CD-TYPE in docs/drs/index.md, and the diagram
docs/explanation/design/.assets/partition-integrity-runs-only-in-unit-tests.drawio.png.
