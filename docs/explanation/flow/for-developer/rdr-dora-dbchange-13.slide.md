---
catzc:
  config:
    pattern: fact
    deck: for-developer
    order: 13
    picture:
      mode: reduce
      source: ../../design/.assets/ingress-gated-the-rest-by-review.drawio.png
      scale: 0.4
---

# Database and config change travel in the same commit as the code

## Eyebrow

13 / 30 · fact for the Developer · EDR-DORA-DBCHANGE

## Lead

For the Developer, who edits one file, runs one gate, pushes one topic: A config entry is a catalogue item; it climbs the same ladder, in
the same artifact.

## Image

.assets/rdr-dora-dbchange-13.png

## Caption

From the catalogue, reduced: ingress gated the rest by review.

## Notes

Check it: the record EDR-DORA-DBCHANGE in docs/drs/index.md, and the diagram
docs/explanation/design/.assets/ingress-gated-the-rest-by-review.drawio.png.
