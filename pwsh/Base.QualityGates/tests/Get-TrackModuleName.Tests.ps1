Describe 'Get-TrackModuleName' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:repo = [System.IO.Path]::GetFullPath((Join-Path $TestDrive 'repo'))
        function Get-Name {
            param([string] $Relative)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Path = [System.IO.Path]::GetFullPath((Join-Path $script:repo $Relative)) } {
                param($Path)
                Get-TrackModuleName $Path
            }
        }
    }

    BeforeEach {
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $script:repo }
        Mock Get-Track -ModuleName Catzc.Base.QualityGates {
            $engine = [pscustomobject]@{ name = 'engine'; type = 'modules'; places = @('bundle') }
            $engine | Add-Member -MemberType ScriptMethod -Name FullNameOf -Value { param($Folder) "Catzc.$Folder" }
            $engine
            $widget = [pscustomobject]@{ name = 'widget'; type = 'modules'; places = @('widget') }
            $widget | Add-Member -MemberType ScriptMethod -Name FullNameOf -Value { param($Folder) "Widget.$Folder" }
            $widget
            [pscustomobject]@{ name = 'docs'; type = 'documentation'; places = @('manuals') }
        }
        Mock Get-Track -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Name -eq 'pwsh' } {
            [pscustomobject]@{ name = 'engine' }
        }
    }

    It 'names the module of a path under a place of a non-engine modules track' -ForEach @(
        @{ Relative = 'widget/Local/tests/Get-LocalWidget.Tests.ps1'; Expected = 'Widget.Local' }
        @{ Relative = 'widget/Local'; Expected = 'Widget.Local' }
        @{ Relative = 'widget/Gadget/tests'; Expected = 'Widget.Gadget' }
    ) {
        Get-Name $Relative | Should -Be $Expected
    }

    It 'answers nothing for a path that is <Reason>' -ForEach @(
        @{ Reason = 'the place itself'; Relative = 'widget' }
        @{ Reason = 'only a name prefix of the place'; Relative = 'widgets/Local/tests/x.Tests.ps1' }
        @{ Reason = 'under the engine track'; Relative = 'bundle/Base.Widget/tests/x.Tests.ps1' }
        @{ Reason = 'under a track of another type'; Relative = 'manuals/Local/x.md' }
    ) {
        Get-Name $Relative | Should -BeNullOrEmpty
    }
}
