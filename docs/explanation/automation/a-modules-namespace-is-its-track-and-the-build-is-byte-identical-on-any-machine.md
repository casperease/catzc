---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-MODULE-NAMESPACEISTRACK
      - ADR-AUTO-BUNDLE-IMMUTABLEBUILD
---

# A modules namespace is its track and the build is byte identical on any machine

This article is one rule: [ADR-AUTO-MODULE-NAMESPACEISTRACK](../../drs/automation/module-model.md#rule-adr-auto-module-namespaceistrack) and
[ADR-AUTO-BUNDLE-IMMUTABLEBUILD](../../drs/automation/platform-bundle.md#rule-adr-auto-bundle-immutablebuild) merged into one. It holds
nothing beyond what those two rules say.

A module's namespace is the name of the track that holds it, derived from placement and never written into the module's name: the modules of
the `pwsh` track keep their `Catzc.Base.*`, `Catzc.Azure.*` and `Catzc.Tooling.*` names, and their namespace is `pwsh`. The build that ships
them is immutable and content-addressed: the same commit yields a byte-identical build on any machine.
