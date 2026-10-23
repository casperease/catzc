---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-BCL-TYPES-BCLREFERENCESET
      - ADR-PWSH-TYPES-POWERSHELLPRIMITIVES
---

# A type references only the base class library unless a host binding is configured (ADR-BCL-TYPES-BCLREFERENCESET + ADR-PWSH-TYPES-POWERSHELLPRIMITIVES)

This article is one rule:
[ADR-BCL-TYPES-BCLREFERENCESET](../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-bclreferenceset) and
[ADR-PWSH-TYPES-POWERSHELLPRIMITIVES](../../drs/automation/pwsh/hosting-csharp-types.md#rule-adr-pwsh-types-powershellprimitives) merged
into one. It holds nothing beyond what those two rules say.

A type references the Base Class Library and nothing else, which is the BCL language's reference set. A type that binds to its host, such as
one that needs a PowerShell primitive like `WildcardPattern`, `TypeAccelerators` or `PSObject`, is a host binding, a configured exception
with one row in `bcl.yml` naming the file and its reason, and it takes the primitive from `System.Management.Automation` through a `using`
namespace, never through a copy of its own.
