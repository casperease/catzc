---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - DDR-TRACK-TRACKISPLACEDCLUSTER
      - DDR-MODTYPE-DEPLOYABLEORHOLDERMODULE
---

# A track is a placed cluster and a deployable or holder track defines its module

This article is one rule: [DDR-TRACK-TRACKISPLACEDCLUSTER](../../drs/design/tracks.md#rule-ddr-track-trackisplacedcluster) and
[DDR-MODTYPE-DEPLOYABLEORHOLDERMODULE](../../drs/design/module-types.md#rule-ddr-modtype-deployableorholdermodule) merged into one. It holds
nothing beyond what those two rules say.

A track is a named, on-disk cluster of module contents selected by the place or places the track declares. A deployable track's module is a
unit of delivery, whereas a holder track's module is the holder itself, one module per track, so its `module` is the track's name. A
language track has, beside its folder modules, its own module, the root place named by the track.
