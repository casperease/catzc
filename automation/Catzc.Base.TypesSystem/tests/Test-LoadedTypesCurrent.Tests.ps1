<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.TypesSystem/tests/Test-LoadedTypesCurrent.Tests.ps1
    folder: tests
    name: test-loaded-types-current-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.TypesSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-typessystem/tests/Test-LoadedTypesCurrent.Tests.ps1.md
    cites:
      - ADR-AUTO-TEST#{3,6}
      - ADR-AUTO-TYPES#15
---
#>

Describe 'Test-LoadedTypesCurrent' -Tag 'L0', 'logic', 'ADR-AUTO-TYPES#15' {
    BeforeEach {
        Mock Import-InternalModule -ModuleName Catzc.Base.TypesSystem { }
        Mock Get-LoadedTypeDrift -ModuleName Catzc.Base.TypesSystem { [pscustomobject]@{ Current = $script:isCurrent } }
    }

    It 'returns whether the loaded types are current: <Expected>' -ForEach @(@{ Expected = $true }, @{ Expected = $false }) {
        $script:isCurrent = $Expected
        Test-LoadedTypesCurrent -ModulesRoot 'C:\widget\automation' | Should -Be $Expected
        Should -Invoke Get-LoadedTypeDrift -ModuleName Catzc.Base.TypesSystem -Times 1 -Exactly -ParameterFilter { $ModulesRoot -eq 'C:\widget\automation' }
    }

    It 'defaults to the loaded code root' {
        $script:isCurrent = $true
        $null = Test-LoadedTypesCurrent
        Should -Invoke Get-LoadedTypeDrift -ModuleName Catzc.Base.TypesSystem -Times 1 -Exactly -ParameterFilter { $ModulesRoot -eq (Get-CatzcModulesRoot) }
    }
}
