---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - DDR-TRACK-VALUECHAINCONCERN
      - DDR-VISUAL-FIXEDCOMMITPALETTE
---

# A value chain concern says where a record acts and commit colours are fixed (DDR-TRACK-VALUECHAINCONCERN + DDR-VISUAL-FIXEDCOMMITPALETTE)

This article is one rule: [DDR-TRACK-VALUECHAINCONCERN](../../drs/design/tracks.md#rule-ddr-track-valuechainconcern) and
[DDR-VISUAL-FIXEDCOMMITPALETTE](../../drs/design/visual-design.md#rule-ddr-visual-fixedcommitpalette) merged into one. It holds nothing
beyond what those two rules say.

A value-chain concern is one of six columns that say where along delivery a decision record acts, in value-chain order, from `automation`
(loading the modules, reading configuration, selecting files through globsets) through `build` to `quality-control`. The commit-colour
palette is fixed the same way: brown is a development commit on topic branches, and grey is integrated onto main, master or release and
never appears on a topic branch.
