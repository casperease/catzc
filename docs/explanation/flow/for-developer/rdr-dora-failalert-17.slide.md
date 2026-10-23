---
catzc:
  config:
    pattern: fact
    deck: for-developer
    order: 17
    picture:
      mode: reduce
      source: ../../flow/.assets/pipeline-kinds-keyed-by-one-artifact.drawio.png
      scale: 0.4
  edges:
    cites:
      - RDR-DORA-FAILALERT
---

# Proactive failure notification: a denied call is logged and raised, never swallowed

## Eyebrow

17 / 30 · fact for the Developer · RDR-DORA-FAILALERT

## Lead

For the Developer, who edits one file, runs one gate, pushes one topic: The time safeguard logs every denial; a gate turns the pipeline red by throwing.

## Image

.assets/rdr-dora-failalert-17.png

## Caption

From the catalogue, reduced: pipeline kinds keyed by one artifact.

## Notes

Check it: the record RDR-DORA-FAILALERT in docs/drs/index.md, and the diagram docs/explanation/flow/.assets/pipeline-kinds-keyed-by-one-artifact.drawio.png.
