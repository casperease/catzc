<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.TypesSystem/tests/Test-LoadedTypesCurrent.Tests.ps1
    folder: tests
    name: test-loaded-types-current-tests
    filetype: ps1
    role: test
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.TypesSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[Test-LoadedTypesCurrent.Tests.ps1.md](docs/references/pwsh/catzc-base-typessystem/tests/Test-LoadedTypesCurrent.Tests.ps1.md)"
    cites:
      - ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES
      - ADR-AUTO-TEST-NOOVERMOCKING
      - ADR-AUTO-TYPES-ONEDRIFTMEASURE
---
#>

Describe 'Test-LoadedTypesCurrent' -Tag 'L0', 'logic', 'ADR-AUTO-TYPES-ONEDRIFTMEASURE' {
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
