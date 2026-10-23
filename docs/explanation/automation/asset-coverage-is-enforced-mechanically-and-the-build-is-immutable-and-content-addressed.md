---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-ASSETDEP-ENFORCEDMECHANICALLY
      - ADR-AUTO-BUNDLE-IMMUTABLEBUILD
---

# Asset coverage is enforced mechanically and the build is immutable and content addressed

This article is one rule:
[ADR-AUTO-ASSETDEP-ENFORCEDMECHANICALLY](../../drs/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-enforcedmechanically)
and [ADR-AUTO-BUNDLE-IMMUTABLEBUILD](../../drs/automation/platform-bundle.md#rule-adr-auto-bundle-immutablebuild) merged into one. It holds
nothing beyond what those two rules say.

The asset-dependency rule is enforced mechanically: a coverage check fails the run when a function listed by `Get-InternalAssetDependency`
has no test that reads the real asset, naming the function and its uncovered child paths, and a presence check fails `Build-Modules` when a
listed child path is absent. The build those checks guard is immutable and content-addressed: the same commit yields a byte-identical build
on any machine and an identical durable-SHA content hash.
