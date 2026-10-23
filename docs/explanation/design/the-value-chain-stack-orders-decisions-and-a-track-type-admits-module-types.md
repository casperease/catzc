---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - DDR-TRACK-VALUECHAINSTACK
      - DDR-MODTYPE-TRACKTYPEADMITSMODULETYPES
---

# The value chain stack orders decisions and a track type admits module types

This article is one rule: [DDR-TRACK-VALUECHAINSTACK](../../drs/design/tracks.md#rule-ddr-track-valuechainstack) and
[DDR-MODTYPE-TRACKTYPEADMITSMODULETYPES](../../drs/design/module-types.md#rule-ddr-modtype-tracktypeadmitsmoduletypes) merged into one. It
holds nothing beyond what those two rules say.

The value-chain stack is the ordered set of rows a decision sits on, from the axioms down to the vendor: `PRIN` (what catzc is for, its
principles, its process and the research they rest on), `DSGN` (how the platform and its delivery flow are shaped) and `AUTO` (the tooling
that enacts them), through to the pipelines. Each track type admits a set of module types, and a module's type must be admitted by the type
of the track that holds it.
