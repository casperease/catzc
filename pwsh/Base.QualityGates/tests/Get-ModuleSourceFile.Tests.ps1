Describe 'Get-ModuleSourceFile' -Tag 'L0', 'logic' {
    BeforeAll {
        function New-FixtureFile {
            param([string] $Root, [string] $Relative)
            $path = Join-Path $Root $Relative
            [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($path))
            [System.IO.File]::WriteAllText($path, '')
        }
        $script:repo = Join-Path $TestDrive 'repo'
        New-FixtureFile $script:repo 'widget-modules/Widget.Kit/Get-Widget.ps1'
        New-FixtureFile $script:repo 'widget-modules/Widget.Kit/private/Get-Gadget.ps1'
        New-FixtureFile $script:repo 'widget-modules/Widget.Kit/tests/Get-Widget.Tests.ps1'
        New-FixtureFile $script:repo 'widget-modules/.internal/Widget.Internal.psm1'
        New-FixtureFile $script:repo 'importer.ps1'
    }

    BeforeEach {
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $script:repo }
        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { }
    }

    It 'reads the working root''s own modules tracks by layout in build mode, never the engine''s tree' -Tag 'ADR-AUTO-CONSUMER-CATZCGATES' {
        Mock Get-CatzcRunMode -ModuleName Catzc.Base.QualityGates { 'build' }
        Mock Get-Track -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Name -ceq 'pwsh' } {
            [pscustomobject]@{ name = 'pwsh'; type = 'modules'; places = @('pwsh') }
        }
        Mock Get-Track -ModuleName Catzc.Base.QualityGates -ParameterFilter { -not $Name } {
            [pscustomobject]@{ name = 'pwsh'; type = 'modules'; places = @('pwsh') }
            [pscustomobject]@{ name = 'widgets'; type = 'modules'; places = @('widget-modules') }
        }
        $relatives = @(InModuleScope Catzc.Base.QualityGates { Get-ModuleSourceFile }).ForEach({
                [System.IO.Path]::GetRelativePath($script:repo, $_).Replace('\', '/')
            })
        $relatives | Should -Be @('widget-modules/Widget.Kit/Get-Widget.ps1',
            'widget-modules/Widget.Kit/private/Get-Gadget.ps1', 'widget-modules/Widget.Kit/tests/Get-Widget.Tests.ps1')
    }
}
