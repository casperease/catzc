<#
---
catzc:
  immutable:
    with_body_sha: "61504654b966"
  edges:
    code: pwsh/Catzc.Base.Maps/private/Get-WorldMapOutputRoot.ps1
---
#>

Describe 'Get-WorldMapOutputRoot' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:outputRoot = Join-Path $TestDrive 'widget-out'
        Mock Get-OutputRoot -ModuleName Catzc.Base.Maps { $script:outputRoot }
    }

    It 'joins the output root with the default output folder' {
        Mock Get-Config -ModuleName Catzc.Base.Maps -ParameterFilter { $Config -eq 'maps' } { [Catzc.Base.Maps.MapsConfig]::new([ordered]@{}) }
        InModuleScope Catzc.Base.Maps { Get-WorldMapOutputRoot } | Should -Be (Join-Path $script:outputRoot 'world-map')
        Test-Path (Join-Path $script:outputRoot 'world-map') | Should -BeFalse
    }

    It 'joins the output root with the configured output folder' {
        Mock Get-Config -ModuleName Catzc.Base.Maps -ParameterFilter { $Config -eq 'maps' } {
            [Catzc.Base.Maps.MapsConfig]::new([ordered]@{ output_folder = 'gadget-map' })
        }
        InModuleScope Catzc.Base.Maps { Get-WorldMapOutputRoot } | Should -Be (Join-Path $script:outputRoot 'gadget-map')
    }

    It 'creates the folder with -EnsureExists' {
        Mock Get-Config -ModuleName Catzc.Base.Maps -ParameterFilter { $Config -eq 'maps' } { [Catzc.Base.Maps.MapsConfig]::new([ordered]@{}) }
        $folder = InModuleScope Catzc.Base.Maps { Get-WorldMapOutputRoot -EnsureExists }
        Test-Path -LiteralPath $folder -PathType Container | Should -BeTrue
        Should -Invoke Get-OutputRoot -ModuleName Catzc.Base.Maps -ParameterFilter { $EnsureExists } -Times 1 -Exactly
    }
}
