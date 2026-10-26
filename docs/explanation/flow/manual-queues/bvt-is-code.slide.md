---
catzc:
  config:
    pattern: fact
    deck: manual-queues
    order: 4
    picture:
      mode: zoom
      source: ../../design/.assets/sync-point-rules-are-drs-only.drawio.png
      box: [20, 254, 700, 570]
      scale: 0.6
---

# BVT is the only gate code runs, and it asks nobody

## Eyebrow

4 / 10 · fact · FDR-LIFE-DISCARDISTERMINAL

## Lead

Every push to main runs the BVT level of all tests. A failing run rejects the commit on its own; discard is terminal. No person stands here,
so it is not a queue.

## Image

.assets/bvt-is-code.png

## Caption

Zoomed: ci-pwsh, the first rung and the one BVT gate, with on-demand and main-UAT above it.

## Notes

Check it: docs/drs/flow/commit-lifecycle.md, rule DISCARDISTERMINAL; the ci-pwsh pipeline under vendor_ado.pipelines.
