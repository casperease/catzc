---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - DDR-TRACK-PRIMARYLANGUAGE
      - DDR-MODTYPE-TRACKTYPEADMITSMODULETYPES
---

# A track has one primary language and a track type admits module types

This article is one rule: [DDR-TRACK-PRIMARYLANGUAGE](../../drs/design/tracks.md#rule-ddr-track-primarylanguage) and
[DDR-MODTYPE-TRACKTYPEADMITSMODULETYPES](../../drs/design/module-types.md#rule-ddr-modtype-tracktypeadmitsmoduletypes) merged into one. It
holds nothing beyond what those two rules say.

A track has one primary language by default: the first file language its tech-stack declares, the one a single-language track is written in.
A second file language enters a track by being declared there, never by being tolerated. Each track type admits a set of module types,
declared on the track type, and a module's type must be admitted by the type of the track that holds it: `modules` admits `pwsh-folder`,
`pwsh-psm1`, `python`, `go` and `bash`.
