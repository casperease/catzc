<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.TypesSystem/tests/Assert-LoadedTypesCurrent.Tests.ps1
    folder: tests
    name: assert-loaded-types-current-tests
    filetype: ps1
    role: test
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.TypesSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[Assert-LoadedTypesCurrent.Tests.ps1.md](/docs/references/pwsh/catzc-base-typessystem/tests/Assert-LoadedTypesCurrent.Tests.ps1.md)"
    cites:
      - ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES
      - ADR-AUTO-TEST-NOOVERMOCKING
      - ADR-AUTO-TYPES-ONEDRIFTMEASURE
---
#>

Describe 'Assert-LoadedTypesCurrent' -Tag 'L0', 'logic', 'ADR-AUTO-TYPES-ONEDRIFTMEASURE' {
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
