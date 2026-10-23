---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-IMPORTER-RESOLVEDAFTERLOAD
      - ADR-AUTO-BUNDLE-IMMUTABLEBUILD
---

# The importer resolves the mix after loading and the build is content addressed

This article is one rule: [ADR-AUTO-IMPORTER-RESOLVEDAFTERLOAD](../../drs/automation/importer.md#rule-adr-auto-importer-resolvedafterload)
and [ADR-AUTO-BUNDLE-IMMUTABLEBUILD](../../drs/automation/platform-bundle.md#rule-adr-auto-bundle-immutablebuild) merged into one. It holds
nothing beyond what those two rules say.

The importer loads every module of the code root, resolves the mix once from the loaded toolset, keeps it as the session's record, and then
removes the modules outside the mix; there is no second, pre-load copy of the module model, languages configuration or engine locator. The
build is immutable and content-addressed: the same commit yields a byte-identical build on any machine.
