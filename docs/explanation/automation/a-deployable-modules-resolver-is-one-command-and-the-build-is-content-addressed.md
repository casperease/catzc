---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-BUNDLE-IMMUTABLEBUILD
      - ADR-AUTO-MODULE-DEPLOYABLETRACKMODULE
---

# A deployable modules resolver is one command and the build is content addressed

This article is one rule: [ADR-AUTO-BUNDLE-IMMUTABLEBUILD](../../drs/automation/platform-bundle.md#rule-adr-auto-bundle-immutablebuild) and
[ADR-AUTO-MODULE-DEPLOYABLETRACKMODULE](../../drs/automation/module-model.md#rule-adr-auto-module-deployabletrackmodule) merged into one. It
holds nothing beyond what those two rules say.

A module of a deployable track is resolved through the track that holds it, by one resolver, `Get-CatzcModule`, the track being the one the
longest place names. The build of such modules is immutable and content-addressed: the same commit yields a byte-identical build on any
machine and an identical durable-SHA content hash over all of it.
