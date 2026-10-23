---
catzc:
  config:
    pattern: fact
    deck: setting-travels
    order: 10
    picture:
      mode: reduce
      source: ../../automation/.assets/one-command-lays-out-the-python-workspace.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-REPO-SLIDES
---

# A diagram's yml is its one source; put renders it, get folds an edit back

## Eyebrow

10 / 12 · fact · ADR-REPO-SLIDES

## Lead

The png carries the model, the yml carries the declaration, and both directions are deterministic, so a hand edit in draw.io never becomes a second source.

## Image

.assets/yml-is-the-source.png

## Caption

From the catalogue, reduced: one command lays out the python workspace.

## Notes

Check it: the record ADR-REPO-SLIDES in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/one-command-lays-out-the-python-workspace.drawio.png.
