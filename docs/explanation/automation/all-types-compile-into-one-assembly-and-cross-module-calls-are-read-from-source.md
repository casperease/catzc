---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-BCL-TYPES-ONEASSEMBLY
      - ADR-PWSH-MANIFEST-CROSSMODULECALLS
---

# All types compile into one assembly and cross module calls are read from source

This article is one rule: [ADR-BCL-TYPES-ONEASSEMBLY](../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-oneassembly) and
[ADR-PWSH-MANIFEST-CROSSMODULECALLS](../../drs/automation/pwsh/dynamic-module-manifests.md#rule-adr-pwsh-manifest-crossmodulecalls) merged
into one. It holds nothing beyond what those two rules say.

Every module's `types/*.cs` compile together into one assembly for the whole repository, so a type in any module can reference a type in any
other. Because every module shares one function namespace, a cross-module call resolves at runtime whether its edge is declared or not, so
the function-call edges of the module graph are read from the source by `Get-FunctionDependency`.
