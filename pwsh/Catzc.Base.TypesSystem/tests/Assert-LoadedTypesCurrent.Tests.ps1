<#
---
catzc:
  immutable:
    with_body_sha: "06bee7f2e362"
  edges:
    docs: "[Assert-LoadedTypesCurrent.Tests.ps1.md](docs/references/pwsh/catzc-base-types-system/tests/Assert-LoadedTypesCurrent.Tests.ps1.md)"
    code: pwsh/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1
    cites:
      - ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES
      - ADR-AUTO-TEST-NOOVERMOCKING
      - ADR-BCL-TYPES-ONEDRIFTMEASURE
---
#>

Describe 'Assert-LoadedTypesCurrent' -Tag 'L0', 'logic', 'ADR-BCL-TYPES-ONEDRIFTMEASURE' {
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
