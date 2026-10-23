---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-MODULE-TOPOLOGICALORDER
      - ADR-PWSH-MANIFEST-NOMODULEIMPORTS
---

# Modules load in topological order and no module imports another

This article is one rule: [ADR-AUTO-MODULE-TOPOLOGICALORDER](../../drs/automation/module-model.md#rule-adr-auto-module-topologicalorder) and
[ADR-PWSH-MANIFEST-NOMODULEIMPORTS](../../drs/automation/pwsh/dynamic-module-manifests.md#rule-adr-pwsh-manifest-nomoduleimports) merged
into one. It holds nothing beyond what those two rules say.

The order of modules is the topological order of the declared graph, foundation first, ties broken ordinally. No catzc module imports
another: dot-sourcing `importer.ps1` imports every module into one global function namespace, so a function calls any catzc function by
name, with no `Import-Module`, no `using module`, no `RequiredModules` and no hand-written export list.
