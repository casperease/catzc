Describe 'Get-ContractCommandRoot' -Tag 'L0', 'logic', 'ADR-REPO-CMDCONTRACT-NOPLACEMENTFACTS' {
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
            [pscustomobject]@{ name = 'Catzc.Widget'; root = 'widgets/Catzc.Widget'; languages = @('csharp', 'powershell') }
        }
        Get-Root 'Catzc.Widget' | Should -Be 'widgets/Catzc.Widget'
        Should -Invoke -ModuleName Catzc.Base.Contracts Get-CatzcModule -Times 1 -Exactly -ParameterFilter { $Name -eq 'Catzc.Widget' -and $TrackType -eq 'modules' }
    }

    It 'throws when no module of that name exists' {
        Mock -ModuleName Catzc.Base.Contracts Get-CatzcModule { }
        { Get-Root 'Catzc.Gadget' } | Should -Throw "*no module named 'Catzc.Gadget'*"
    }

    It 'throws NotImplemented for a module in a language with no checker' -Tag 'ADR-REPO-CMDCONTRACT-CHECKERPERLANGUAGE' {
        Mock -ModuleName Catzc.Base.Contracts Get-CatzcModule {
            [pscustomobject]@{ name = 'Catzc.Gadget'; root = 'go/Catzc.Gadget'; languages = @('go') }
        }
        { Get-Root 'Catzc.Gadget' } | Should -Throw -ExceptionType ([System.NotImplementedException])
    }
}
