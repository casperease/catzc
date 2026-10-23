---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-PWSH-TYPES-POWERSHELLPRIMITIVES
      - ADR-PWSH-PESTER-INTEGRITYPARSESFILES
---

# A powershell primitive makes a type a host binding and integrity tests parse files

This article is one rule:
[ADR-PWSH-TYPES-POWERSHELLPRIMITIVES](../../drs/automation/pwsh/hosting-csharp-types.md#rule-adr-pwsh-types-powershellprimitives) and
[ADR-PWSH-PESTER-INTEGRITYPARSESFILES](../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-integrityparsesfiles) merged into
one. It holds nothing beyond what those two rules say.

A type that needs a PowerShell primitive, `WildcardPattern`, `TypeAccelerators` or `PSObject`, is a host binding with its row in `bcl.yml`,
taking the primitive from `System.Management.Automation` through a `using` namespace. An integrity test reads its fact from the files by
parsing them with the PowerShell parser or by reading a `.ps1` basename, never through `Import-Module`, `Get-Command` or `Get-Module` on a
loaded session.
