---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - DDR-TRACK-DEPLOYABLEUNIT
      - DDR-TRACKTYPE-ONEROLE
---

# A deployable unit is what ships and a deployable track owns deployable units

This article is one rule: [DDR-TRACK-DEPLOYABLEUNIT](../../drs/design/tracks.md#rule-ddr-track-deployableunit) and
[DDR-TRACKTYPE-ONEROLE](../../drs/design/track-types.md#rule-ddr-tracktype-onerole) merged into one. It holds nothing beyond what those two
rules say.

A deployable-unit is what ships: a reduced composition of tracks, determining CD pipelines one to one. A track type has one role, and a
deployable track, `modules`, `infrastructure` and the future `services` and `frontend`, owns deployable-units, the collections of the
track's modules that the repository delivers through CI/CD.
