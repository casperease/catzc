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

    It 'renders the track''s normal-form folder to the module name and returns the root the one resolver finds' {
        Mock -ModuleName Catzc.Base.Contracts Get-CatzcModule {
            [pscustomobject]@{ name = 'Catzc.WidgetGadget'; root = 'widgets/Catzc.WidgetGadget'; languages = @('bcl',
                    'powershell')
            }
        }
        Get-Root 'pwsh.widget_gadget' | Should -Be 'widgets/Catzc.WidgetGadget'
        Should -Invoke -ModuleName Catzc.Base.Contracts Get-CatzcModule -Times 1 -Exactly -ParameterFilter { $Name -ceq 'Catzc.WidgetGadget' -and $EngineTrack }
    }

    It 'refuses the namespace as a track: catzc is a namespace, never a track' -Tag 'DDR-TRACK-MODULENAMESPACE' {
        Mock -ModuleName Catzc.Base.Contracts Get-CatzcModule { }
        { Get-Root 'catzc.widget' } | Should -Throw "*Unknown track 'catzc'*"
    }

    It 'throws when the folder is not in the normal form' {
        Mock -ModuleName Catzc.Base.Contracts Get-CatzcModule { }
        { Get-Root 'pwsh.Widget' } | Should -Throw "*'pwsh.Widget' is not in the repository normal form*"
    }

    It 'throws when no module of that name exists' {
        Mock -ModuleName Catzc.Base.Contracts Get-CatzcModule { }
        { Get-Root 'pwsh.gadget' } | Should -Throw "*no module named 'Catzc.Gadget'*"
    }

    It 'throws NotImplemented for a module in a language with no checker' -Tag 'ADR-REPO-CMDCONTRACT-CHECKERPERLANGUAGE' {
        Mock -ModuleName Catzc.Base.Contracts Get-CatzcModule {
            [pscustomobject]@{ name = 'Catzc.Gadget'; root = 'go/Catzc.Gadget'; languages = @('go') }
        }
        { Get-Root 'pwsh.gadget' } | Should -Throw -ExceptionType ([System.NotImplementedException])
    }
}
