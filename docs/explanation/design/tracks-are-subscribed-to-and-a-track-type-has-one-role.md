---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - DDR-TRACK-SUBSCRIBABLENOTPATHCOUPLED
      - DDR-TRACKTYPE-ONEROLE
---

# Tracks are subscribed to and a track type has one role

This article is one rule: [DDR-TRACK-SUBSCRIBABLENOTPATHCOUPLED](../../drs/design/tracks.md#rule-ddr-track-subscribablenotpathcoupled) and
[DDR-TRACKTYPE-ONEROLE](../../drs/design/track-types.md#rule-ddr-tracktype-onerole) merged into one. It holds nothing beyond what those two
rules say.

Tracks are subscribable, never path-coupled: a consumer binds to a track through its module dependencies or its globset's native trigger
projection, never by hand-matching the track's source paths. A track type has one role: a deployable track owns deployable units, the
collections of modules the repository delivers through CI/CD, while a holder track is a module more than it owns modules.
