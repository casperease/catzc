---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - DDR-ASPECT-ASPECTISAGLOBSET
      - DDR-TRACK-SUBSCRIBABLENOTPATHCOUPLED
---

# An aspect is a globset with its own identity and tracks are never path coupled (DDR-ASPECT-ASPECTISAGLOBSET + DDR-TRACK-SUBSCRIBABLENOTPATHCOUPLED)

This article is one rule: [DDR-ASPECT-ASPECTISAGLOBSET](../../drs/design/module-aspects.md#rule-ddr-aspect-aspectisaglobset) and
[DDR-TRACK-SUBSCRIBABLENOTPATHCOUPLED](../../drs/design/tracks.md#rule-ddr-track-subscribablenotpathcoupled) merged into one. It holds
nothing beyond what those two rules say.

Each aspect is its own derived globset, `<unit>-<aspect>`, with its own live durable-SHA identity: a `tests`-only change never re-keys
`live` and a runtime change never re-keys `tests`. A unit's rolled-up identity is the fold of its aspect identities. Consumers meet these
identities the way they meet tracks: subscribed to through module dependencies or a globset's native trigger projection, never by
hand-matching source paths. The globsets, computed from git, are the source of truth for which tracks and deployable units carry changes in
a commit, so a change in one track does not rebuild every customer of every other.
