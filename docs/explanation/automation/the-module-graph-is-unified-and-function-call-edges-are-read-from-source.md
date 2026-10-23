---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-DEPM-UNIFIEDGRAPH
      - ADR-PWSH-MANIFEST-CROSSMODULECALLS
---

# The module graph is unified and function call edges are read from source

This article is one rule:
[ADR-AUTO-DEPM-UNIFIEDGRAPH](../../drs/automation/controlling-module-dependencies.md#rule-adr-auto-depm-unifiedgraph) and
[ADR-PWSH-MANIFEST-CROSSMODULECALLS](../../drs/automation/pwsh/dynamic-module-manifests.md#rule-adr-pwsh-manifest-crossmodulecalls) merged
into one. It holds nothing beyond what those two rules say.

The graph is unified across both kinds of module content: a cross-module function call and a cross-module C# type reference are the same
relationship, module A needs module B, so they live in one graph. Because every module shares one function namespace, the function-call
edges are read from the source by `Get-FunctionDependency`, and the `Test-ModuleDependency` quality gate checks their union against the
declaration.
