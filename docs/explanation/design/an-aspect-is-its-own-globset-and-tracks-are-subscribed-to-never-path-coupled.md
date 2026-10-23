---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - DDR-ASPECT-ASPECTISAGLOBSET
      - DDR-TRACK-SUBSCRIBABLENOTPATHCOUPLED
---

# An aspect is its own globset and tracks are subscribed to never path coupled

This article is one rule: [DDR-ASPECT-ASPECTISAGLOBSET](../../drs/design/module-aspects.md#rule-ddr-aspect-aspectisaglobset) and
[DDR-TRACK-SUBSCRIBABLENOTPATHCOUPLED](../../drs/design/tracks.md#rule-ddr-track-subscribablenotpathcoupled) merged into one. It holds
nothing beyond what those two rules say.

Each aspect is its own derived globset, `<unit>-<aspect>`, with its own live durable-SHA identity and nothing committed per set, so a
`tests`-only change never re-keys `live` and a runtime change never re-keys `tests`. Tracks are subscribable, never path-coupled: a consumer
binds to a track through its module dependencies or its globset's native trigger projection, never by hand-matching the track's source
paths.
