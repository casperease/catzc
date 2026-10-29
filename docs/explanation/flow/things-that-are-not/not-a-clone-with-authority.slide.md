---
catzc:
  config:
    pattern: fact
    deck: things-that-are-not
    order: 10
    picture:
      mode: reduce
      source: ../../design/.assets/how-clients-reach-the-server-remote.drawio.png
      scale: 0.4
      rotate: -4
---

# A local clone has no authority, however many tests it ran

## Eyebrow

10 / 12 · fact · DDR-REMOTE

## Lead

Identity, branch policy and audit history live on the server; the clone writes only its own topic branch.

## Image

[not-a-clone-with-authority](.assets/not-a-clone-with-authority.png)

## Caption

From the catalogue, reduced: clients bridge to one server.

## Notes

Check it: the record DDR-REMOTE in docs/drs/index.md, and the diagram
docs/explanation/design/.assets/how-clients-reach-the-server-remote.drawio.png.
