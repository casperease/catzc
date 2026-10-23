---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-IMPORTER-MODEANDHOSTORTHOGONAL
      - ADR-AUTO-MODULE-DEPLOYABLETRACKMODULE
---

# Run mode and host are orthogonal to mix and a deployable module has one resolver

This article is one rule:
[ADR-AUTO-IMPORTER-MODEANDHOSTORTHOGONAL](../../drs/automation/importer.md#rule-adr-auto-importer-modeandhostorthogonal) and
[ADR-AUTO-MODULE-DEPLOYABLETRACKMODULE](../../drs/automation/module-model.md#rule-adr-auto-module-deployabletrackmodule) merged into one. It
holds nothing beyond what those two rules say.

The run mode, source or build, and the host, console or headless, are orthogonal to the mix: they choose where the modules are read from and
how the native types load, while the mix chooses which modules, languages and engines. A module of a deployable track is resolved through
the track that holds it, by one resolver, `Get-CatzcModule`.
