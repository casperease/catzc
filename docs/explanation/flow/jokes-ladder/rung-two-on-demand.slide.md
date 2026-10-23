---
catzc:
  config:
    pattern: fact
    deck: jokes-ladder
    order: 2
    picture:
      mode: reduce
      source: ../../../../docs/references/pwsh/.assets/az-cli-test-assert-share-one-state.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
  edges:
    cites:
      - FDR-CD
---

# On-demand L3 is where CD runs the system tests before it touches the always-on environment; Pete calls it the rehearsal

## Eyebrow

2 / 10 · fact · FDR-CD

## Lead

CD runs the L3 end-to-end tests on the on-demand environment before it rolls onto the always-on one.

## Image

.assets/rung-two-on-demand.png

## Caption

From the catalogue, reduced: az cli test assert share one state.

## Notes

Check it: the record FDR-CD in docs/drs/index.md, and the diagram docs/references/pwsh/.assets/az-cli-test-assert-share-one-state.drawio.png.
