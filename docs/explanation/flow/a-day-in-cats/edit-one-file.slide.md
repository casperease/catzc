---
catzc:
  config:
    pattern: fact
    deck: a-day-in-cats
    order: 3
    picture:
      mode: reduce
      source: ../../design/.assets/sync-from-the-bvt-verified-head.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-REPO-AI
---

# A change is one file at a time, verified before the next

## Eyebrow

3 / 12 · fact · ADR-REPO-AI

## Lead

No sed sweep across many files: a batch edit fails silently here and costs more to unwind than it saved.

## Image

.assets/edit-one-file.png

## Caption

From the catalogue, reduced: sync from the bvt verified head.

## Notes

Check it: the record ADR-REPO-AI in docs/drs/index.md, and the diagram docs/explanation/design/.assets/sync-from-the-bvt-verified-head.drawio.png.
