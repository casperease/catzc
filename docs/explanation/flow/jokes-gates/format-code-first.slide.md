---
catzc:
  config:
    pattern: fact
    deck: jokes-gates
    order: 8
    picture:
      mode: reduce
      source: ../../configuration/.assets/callers-in-four-modules-share-one-resolver.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-REPO-FILEMETA
---

# Format-Code runs before the gate, so the gate judges the content and not Pete's tabs

## Eyebrow

8 / 10 · fact · ADR-REPO-FILEMETA

## Lead

Format-Code formats and regenerates heads; the gates read the formatted file.

## Image

.assets/format-code-first.png

## Caption

From the catalogue, reduced: callers in four modules share one resolver.

## Notes

Check it: the record ADR-REPO-FILEMETA in docs/drs/index.md, and the diagram docs/explanation/configuration/.assets/callers-in-four-modules-share-one-resolver.drawio.png.
