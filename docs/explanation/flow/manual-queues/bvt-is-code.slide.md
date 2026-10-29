---
catzc:
  config:
    pattern: fact
    deck: manual-queues
    order: 4
    picture:
      mode: reduce
      source: ../../design/.assets/which-ladder-stretch-each-pipeline-runs.drawio.png
      scale: 0.4
---

# BVT is the only gate code runs, and it asks nobody

## Eyebrow

4 / 10 · fact · FDR-LIFE-DISCARDISTERMINAL

## Lead

Every push to main runs the BVT level of all tests. A failing run rejects the commit on its own; discard is terminal. No person stands here,
so it is not a queue.

## Image

[bvt-is-code](.assets/bvt-is-code.png)

## Caption

Reduced: six pipeline shapes, each a run of the promotion ladder in which BVT is the one gate that is code; every state a commit reaches can
be discarded.

## Notes

Check it: docs/drs/flow/commit-lifecycle.md, rule DISCARDISTERMINAL; the ci-pwsh pipeline under vendor_ado.pipelines.
