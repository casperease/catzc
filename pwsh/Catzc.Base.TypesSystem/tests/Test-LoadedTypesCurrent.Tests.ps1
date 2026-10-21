<#
---
catzc:
  immutable:
    with_body_sha: f83b52c27c3f
  edges:
    docs: "[Test-LoadedTypesCurrent.Tests.ps1.md](docs/references/pwsh/catzc-base-typessystem/tests/Test-LoadedTypesCurrent.Tests.ps1.md)"
    code: pwsh/Catzc.Base.TypesSystem/Test-LoadedTypesCurrent.ps1
    cites:
      - ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES
      - ADR-AUTO-TEST-NOOVERMOCKING
      - ADR-BCL-TYPES-ONEDRIFTMEASURE
---
#>

Describe 'Test-LoadedTypesCurrent' -Tag 'L0', 'logic', 'ADR-BCL-TYPES-ONEDRIFTMEASURE' {
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
