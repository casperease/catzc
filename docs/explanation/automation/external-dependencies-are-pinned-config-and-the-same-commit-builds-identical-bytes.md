---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-DEPM-STITCHISCONFIG
      - ADR-AUTO-BUNDLE-IMMUTABLEBUILD
---

# External dependencies are pinned config and the same commit builds identical bytes (ADR-AUTO-DEPM-STITCHISCONFIG + ADR-AUTO-BUNDLE-IMMUTABLEBUILD)

This article is one rule:
[ADR-AUTO-DEPM-STITCHISCONFIG](../../drs/automation/controlling-module-dependencies.md#rule-adr-auto-depm-stitchisconfig) and
[ADR-AUTO-BUNDLE-IMMUTABLEBUILD](../../drs/automation/platform-bundle.md#rule-adr-auto-bundle-immutablebuild) merged into one. It holds
nothing beyond what those two rules say.

The stitch is config, and the config is ours: which external dependencies exist, at which pinned versions, from which feeds is declared in
the repository, a reviewed change and not an ambient fact of a build machine, so the whole graph is reproducible from the checkout. The
build is held to the same standard: immutable and content-addressed, the same commit yields a byte-identical build on any machine and an
identical durable-SHA content hash.
