---
catzc:
  config:
    pattern: fact
    deck: for-release-manager
    order: 8
    picture:
      mode: reduce
      source: ../../../../docs/references/pwsh/.assets/module-graph-declared-vs-observed.drawio.png
      scale: 0.4
  edges:
    cites:
      - RDR-DORA-CD
---

# Continuous delivery: the trunk is always releasable because the ladder says what verified means

## Eyebrow

8 / 30 · fact for the Release Manager · RDR-DORA-CD

## Lead

For the Release Manager, who serves the signatures and watches the ladder: The BVT-verified head is the stable point; the dirty HEAD never feeds a rung.

## Image

.assets/rdr-dora-cd-8.png

## Caption

From the catalogue, reduced: module graph declared vs observed.

## Notes

Check it: the record RDR-DORA-CD in docs/drs/index.md, and the diagram docs/references/pwsh/.assets/module-graph-declared-vs-observed.drawio.png.
