<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-types-system/tests/Test-LoadedTypesCurrent.Tests.ps1.md"
  warning: "Generated Header"
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
