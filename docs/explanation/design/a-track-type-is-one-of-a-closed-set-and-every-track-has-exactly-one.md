---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - DDR-TRACKTYPE-CLOSEDSETOFTYPES
      - DDR-TRACK-ONETRACKTYPE
---

# A track type is one of a closed set and every track has exactly one

This article is one rule: [DDR-TRACKTYPE-CLOSEDSETOFTYPES](../../drs/design/track-types.md#rule-ddr-tracktype-closedsetoftypes) and
[DDR-TRACK-ONETRACKTYPE](../../drs/design/tracks.md#rule-ddr-track-onetracktype) merged into one. It holds nothing beyond what those two
rules say.

A track type is the sort of cluster a track is, and it is one of a closed set: `modules`, `infrastructure`, `pipelines`, `vendor-settings`,
`vendored-code`, `contracts`, `documentation` and `unordered`. Every track has exactly one track type, stated once and carrying no second
classification beside it. Configuration is no track type: it is a file role.
