---
catzc:
  config:
    pattern: fact
    deck: delivery-ladder
    order: 5
    picture:
      mode: reduce
      source: ../../design/.assets/every-vendor-call-leaves-through-az.drawio.png
      scale: 0.4
      rotate: -4
  edges:
    cites:
      - DDR-REMOTE
---

# The pull request is the ingress engine: it authenticates, runs the merge gates and merges

## Eyebrow

5 / 12 · fact · DDR-REMOTE

## Lead

It is not merely a review; the server's own topic HEAD is what it verifies and what it merges into main.

## Image

.assets/pull-request-is-ingress.png

## Caption

From the catalogue, reduced: every vendor call leaves through az.

## Notes

Check it: the record DDR-REMOTE in docs/drs/index.md, and the diagram docs/explanation/design/.assets/every-vendor-call-leaves-through-az.drawio.png.
