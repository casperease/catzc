---
catzc:
  config:
    pattern: fact
    deck: jokes-automation
    order: 5
    picture:
      mode: reduce
      source: ../../design/.assets/globs-yml-pipeline-field-is-the-binding.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AUTO-LAYERS
---

# John the computer guy asked which loader to use; there is one, and it was already running

## Eyebrow

5 / 10 · fact · ADR-AUTO-LAYERS

## Lead

Every module is dot-sourced by the one shared loader through the importer, in one load sequence, in code order.

## Image

.assets/one-loader-to-rule.png

## Caption

From the catalogue, reduced: globs yml pipeline field is the binding.

## Notes

Check it: the record ADR-AUTO-LAYERS in docs/drs/index.md, and the diagram docs/explanation/design/.assets/globs-yml-pipeline-field-is-the-binding.drawio.png.
