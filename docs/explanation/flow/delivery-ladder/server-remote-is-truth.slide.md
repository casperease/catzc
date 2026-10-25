---
catzc:
  config:
    pattern: fact
    deck: delivery-ladder
    order: 4
    picture:
      mode: reduce
      source: ../../automation/.assets/undeclared-edge-fails-with-one-line.drawio.png
      scale: 0.4
---

# The server remote is the single source of truth; every clone is a bridge

## Eyebrow

4 / 12 · fact · DDR-REMOTE

## Lead

Identity, branch policy and the audit history live on the server; a clone has no authority and writes only its own topic branch.

## Image

.assets/server-remote-is-truth.png

## Caption

From the catalogue, reduced: undeclared edge fails with one line.

## Notes

Check it: the record DDR-REMOTE in docs/drs/index.md, and the diagram
docs/explanation/automation/.assets/undeclared-edge-fails-with-one-line.drawio.png.
