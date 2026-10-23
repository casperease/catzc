---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - DDR-VISUAL-FIXEDCOMMITPALETTE
      - DDR-TRACK-SUBSCRIBABLENOTPATHCOUPLED
---

# Commit colours are fixed and tracks are subscribed to never path coupled

This article is one rule: [DDR-VISUAL-FIXEDCOMMITPALETTE](../../drs/design/visual-design.md#rule-ddr-visual-fixedcommitpalette) and
[DDR-TRACK-SUBSCRIBABLENOTPATHCOUPLED](../../drs/design/tracks.md#rule-ddr-track-subscribablenotpathcoupled) merged into one. It holds
nothing beyond what those two rules say.

The commit-colour palette is fixed: brown is a development commit, living on topic branches and never an integrated mainline state, and grey
is integrated onto main, master or release and never appears on a topic branch. Tracks are held to the same fixedness in how they are
reached: they are subscribable, never path-coupled, so a consumer binds to a track through its module dependencies or its globset's native
trigger projection, never by hand-matching the track's source paths.
