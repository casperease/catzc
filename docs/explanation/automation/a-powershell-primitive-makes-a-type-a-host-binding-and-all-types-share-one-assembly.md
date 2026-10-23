---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-PWSH-TYPES-POWERSHELLPRIMITIVES
      - ADR-BCL-TYPES-ONEASSEMBLY
---

# A powershell primitive makes a type a host binding and all types share one assembly

This article is one rule:
[ADR-PWSH-TYPES-POWERSHELLPRIMITIVES](../../drs/automation/pwsh/hosting-csharp-types.md#rule-adr-pwsh-types-powershellprimitives) and
[ADR-BCL-TYPES-ONEASSEMBLY](../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-oneassembly) merged into one. It holds
nothing beyond what those two rules say.

A type that needs a PowerShell primitive, `WildcardPattern`, `TypeAccelerators` or `PSObject`, is a host binding: it has its row in
`bcl.yml` and takes the primitive from `System.Management.Automation` through a `using` namespace, never through a copy of its own. Every
module's `types/*.cs` compile together into one assembly for the whole repository, so only cross-namespace references exist inside a single
assembly.
