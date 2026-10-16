<#
---
catzc:
  derived:
    path: automation/Catzc.Base.TypesSystem/tests/Assert-LoadedTypesCurrent.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.TypesSystem
    relatives:
      page: docs/references/automation/catzc-base-typessystem/tests/Assert-LoadedTypesCurrent.Tests.ps1.md
      source: automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1
    adrs:
      - ADR-AUTO-TEST#{3,6}
      - ADR-AUTO-TYPES#15
---
#>

Describe 'Assert-LoadedTypesCurrent' -Tag 'L0', 'logic', 'ADR-AUTO-TYPES#15' {
    BeforeEach {
        Mock Import-InternalModule -ModuleName Catzc.Base.TypesSystem { }
        Mock Get-LoadedTypeDrift -ModuleName Catzc.Base.TypesSystem { $script:state }
    }

    It 'is silent when the loaded types are current' {
        $script:state = [pscustomobject]@{ Current = $true; Drift = [string[]] @(); Summary = $null }
        { Assert-LoadedTypesCurrent -ModulesRoot 'C:\widget\automation' } | Should -Not -Throw
    }

    It 'throws naming the drift, both hashes, and the remedy when they are stale' {
        $script:state = [pscustomobject]@{
            Current = $false
            Drift   = [string[]] @('changed Catzc.Widget/Gadget', 'added Catzc.Widget/Sprocket')
            Summary = 'C# types changed since they were loaded (aaaa1111 -> bbbb2222).'
        }
        { Assert-LoadedTypesCurrent -ModulesRoot 'C:\widget\automation' } |
            Should -Throw '*aaaa1111 -> bbbb2222*Drifted: changed Catzc.Widget/Gadget; added Catzc.Widget/Sprocket.*open a new PowerShell*'
    }
}
