---
catzc:
  config:
    pattern: fact
    deck: repository-shape
    order: 10
    picture:
      mode: reduce
      source: ../../automation/.assets/three-layers-edges-point-down.drawio.png
      scale: 0.4
---

# out/ holds scripts and reports, never a second copy of a render or a rule

## Eyebrow

10 / 14 · fact · ADR-REPO-OUTDIR

## Lead

A costly render lands at its place in the source catalogue; out/ is gitignored, wiped at will, and nothing in the tree depends on it.

## Image

.assets/out-is-scratch.png

## Caption

From the catalogue, reduced: three layers edges point down.

## Notes

Check it: the record ADR-REPO-OUTDIR in docs/drs/index.md, and the diagram
docs/explanation/automation/.assets/three-layers-edges-point-down.drawio.png.
