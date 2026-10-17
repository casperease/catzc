<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Contracts/tests/Get-ContractCommandRoot.Tests.ps1
    folder: tests
    name: get-contract-command-root-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    cites:
      - ADR-REPO-CMDCONTRACT#{3,4}
---
#>

Describe 'Get-ContractCommandRoot' -Tag 'L0', 'logic', 'ADR-REPO-CMDCONTRACT#3' {
    BeforeAll {
        function Get-Root {
            param([string] $Module)
            InModuleScope Catzc.Base.Contracts -Parameters @{ Module = $Module } {
                param($Module)
                Get-ContractCommandRoot -Module $Module -RepositoryRoot $TestDrive
            }
        }
    }

    It 'returns the root of the module the one resolver finds' {
        Mock -ModuleName Catzc.Base.Contracts Get-CatzcModule {
            [pscustomobject]@{ name = 'Catzc.Widget'; root = 'automation/Catzc.Widget'; languages = @('csharp', 'powershell') }
        }
        Get-Root 'Catzc.Widget' | Should -Be 'automation/Catzc.Widget'
        Should -Invoke -ModuleName Catzc.Base.Contracts Get-CatzcModule -Times 1 -Exactly -ParameterFilter { $Name -eq 'Catzc.Widget' -and $TrackType -eq 'modules' }
    }

    It 'throws when no module of that name exists' {
        Mock -ModuleName Catzc.Base.Contracts Get-CatzcModule { }
        { Get-Root 'Catzc.Gadget' } | Should -Throw "*no module named 'Catzc.Gadget'*"
    }

    It 'throws NotImplemented for a module in a language with no checker' -Tag 'ADR-REPO-CMDCONTRACT#4' {
        Mock -ModuleName Catzc.Base.Contracts Get-CatzcModule {
            [pscustomobject]@{ name = 'Catzc.Gadget'; root = 'go/Catzc.Gadget'; languages = @('go') }
        }
        { Get-Root 'Catzc.Gadget' } | Should -Throw -ExceptionType ([System.NotImplementedException])
    }
}
