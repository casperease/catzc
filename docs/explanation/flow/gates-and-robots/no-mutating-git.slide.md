---
catzc:
  config:
    pattern: fact
    deck: gates-and-robots
    order: 10
    picture:
      mode: reduce
      source: ../../automation/.assets/every-code-root-is-a-copy.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-REPO-AI
---

# No robot runs a mutating git command; the person commits

## Eyebrow

10 / 14 · fact · ADR-REPO-AI

## Lead

Status, log, diff and blame are read-only probes; add, commit, push, checkout and rebase are the user's hands, by request only.

## Image

.assets/no-mutating-git.png

## Caption

From the catalogue, reduced: every code root is a copy.

## Notes

Check it: the record ADR-REPO-AI in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/every-code-root-is-a-copy.drawio.png.
