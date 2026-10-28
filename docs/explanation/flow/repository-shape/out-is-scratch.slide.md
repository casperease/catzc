---
catzc:
  config:
    pattern: fact
    deck: repository-shape
    order: 10
---

# out/ holds scripts and reports, never a second copy of a render or a rule

## Eyebrow

10 / 14 · fact · ADR-REPO-OUTDIR

## Lead

A costly render lands at its place in the source catalogue; out/ is gitignored, wiped at will, and nothing in the tree depends on it.

## Notes

Check it: the record ADR-REPO-OUTDIR in docs/drs/index.md.
