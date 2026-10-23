---
catzc:
  config:
    pattern: fact
    deck: a-day-in-cats
    order: 5
    picture:
      mode: reduce
      source: ../../design/.assets/two-roots-one-importer-same-modules.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AUTO-TEST
---

# A gate claimed passed is a gate that was run and read

## Eyebrow

5 / 12 · fact · ADR-AUTO-TEST

## Lead

The command runs under the time safeguard, the report lands under out/, and the output is the verdict, failures included.

## Image

.assets/run-the-gate.png

## Caption

From the catalogue, reduced: two roots one importer same modules.

## Notes

Check it: the record ADR-AUTO-TEST in docs/drs/index.md, and the diagram docs/explanation/design/.assets/two-roots-one-importer-same-modules.drawio.png.
