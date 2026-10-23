---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - DDR-MODTYPE-MODULETYPEISSORT
      - DDR-TRACKTYPE-DECLAREDONCE
---

# A module type and a track are each declared once with their places

This article is one rule: [DDR-MODTYPE-MODULETYPEISSORT](../../drs/design/module-types.md#rule-ddr-modtype-moduletypeissort) and
[DDR-TRACKTYPE-DECLAREDONCE](../../drs/design/track-types.md#rule-ddr-tracktype-declaredonce) merged into one. It holds nothing beyond what
those two rules say.

A module type is the sort of module, named without the word module (`pwsh-folder`, `bicep`, `python`, `go`, `bash`), and the module-types
registry declares it once, with its definition and its places, the paths where modules of the type are found. A track is declared once as
well, in the `tracks` map of `variants.yml`, as its name, its type, its places, its vendor when it has one and its file languages.
