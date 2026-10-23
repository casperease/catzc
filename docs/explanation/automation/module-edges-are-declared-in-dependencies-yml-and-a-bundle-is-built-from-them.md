---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-DEPM-CODEBUILTFROM
      - ADR-AUTO-BUNDLE-BUNDLEISBUILD
---

# Module edges are declared in dependencies yml and a bundle is built from them (ADR-AUTO-DEPM-CODEBUILTFROM + ADR-AUTO-BUNDLE-BUNDLEISBUILD)

This article is one rule:
[ADR-AUTO-DEPM-CODEBUILTFROM](../../drs/automation/controlling-module-dependencies.md#rule-adr-auto-depm-codebuiltfrom) and
[ADR-AUTO-BUNDLE-BUNDLEISBUILD](../../drs/automation/platform-bundle.md#rule-adr-auto-bundle-bundleisbuild) merged into one. It holds
nothing beyond what those two rules say.

A module dependency is code the toolset is built from. Its internal edges, module A needing module B among the repository's own modules, are
declared in `pwsh/Catzc.Base.ModuleSystem/configs/dependencies.yml`; the declaration is the allow-list, and an actual edge with no
declaration fails the build. The bundle is the toolset's build that results: one installable, versioned `Catzc` package of one named bundle.
