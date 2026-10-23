---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - DDR-MODTYPE-TRACKTYPEADMITSMODULETYPES
      - DDR-TRACKTYPE-VENDOREDCODE
---

# A track type admits module types and vendored code is nested in another track

This article is one rule:
[DDR-MODTYPE-TRACKTYPEADMITSMODULETYPES](../../drs/design/module-types.md#rule-ddr-modtype-tracktypeadmitsmoduletypes) and
[DDR-TRACKTYPE-VENDOREDCODE](../../drs/design/track-types.md#rule-ddr-tracktype-vendoredcode) merged into one. It holds nothing beyond what
those two rules say.

Each track type admits a set of module types, and a module's type must be admitted by the type of the track that holds it. A track of
vendored code holds code written by a third party that the repository does not author, such as `pwsh/.vendor` and `bash/.vendor`, nested
under another track's root and getting its files by the longest place.
