---
catzc:
  config:
    pattern: fact
    deck: jokes-gates
    order: 9
    picture:
      mode: reduce
      source: ../../../../docs/references/pwsh/.assets/get-config-merge-seal-type.drawio.png
      scale: 0.4
      rotate: -4
  edges:
    cites:
      - ADR-REPO-OUTDIR
---

# Every gate writes its report under out/, the one folder that is allowed to be messy

## Eyebrow

9 / 10 · fact · ADR-REPO-OUTDIR

## Lead

out/ holds scripts and reports; it is gitignored and wiped at will; nothing in the tree depends on it.

## Image

.assets/gate-report-in-out.png

## Caption

From the catalogue, reduced: get config merge seal type.

## Notes

Check it: the record ADR-REPO-OUTDIR in docs/drs/index.md, and the diagram docs/references/pwsh/.assets/get-config-merge-seal-type.drawio.png.
