---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - DDR-TRACK-FILELANGUAGE
      - DDR-MODTYPE-TRACKTYPEADMITSMODULETYPES
---

# A file language is named by its extension and a track type admits module types

This article is one rule: [DDR-TRACK-FILELANGUAGE](../../drs/design/tracks.md#rule-ddr-track-filelanguage) and
[DDR-MODTYPE-TRACKTYPEADMITSMODULETYPES](../../drs/design/module-types.md#rule-ddr-modtype-tracktypeadmitsmoduletypes) merged into one. It
holds nothing beyond what those two rules say.

A file language is the language a tracked file is written in, named by its extension, and every extension belongs to exactly one file
language. A track's tech-stack is the set of file languages it owns. Each track type admits a set of module types and a module's type must
be admitted by the type of the track that holds it.
