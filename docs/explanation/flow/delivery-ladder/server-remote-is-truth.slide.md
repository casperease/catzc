---
catzc:
  config:
    pattern: fact
    deck: delivery-ladder
    order: 4
    picture:
      mode: reduce
      source: ../../design/.assets/clients-bridge-to-one-server.drawio.png
      scale: 0.4
---

# The server remote is the single source of truth; every clone is a bridge

## Eyebrow

4 / 12 · fact · DDR-REMOTE

## Lead

Identity, branch policy and the audit history live on the server; a clone has no authority and writes only its own topic branch.

## Image

[server-remote-is-truth](.assets/server-remote-is-truth.png)

## Caption

From the catalogue, reduced: clients bridge to one server.

## Notes

Check it: the record DDR-REMOTE in docs/drs/index.md, and the diagram
docs/explanation/design/.assets/clients-bridge-to-one-server.drawio.png.
