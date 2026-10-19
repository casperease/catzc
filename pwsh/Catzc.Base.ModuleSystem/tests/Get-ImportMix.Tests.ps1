Describe 'Get-ImportMix' -Tag 'L0', 'logic' {
    BeforeAll {
        Mock Get-Config -ModuleName Catzc.Base.ModuleSystem -ParameterFilter { $Config -eq 'importer' } {
            [Catzc.Base.ModuleSystem.ImporterConfig]::new(@{})
        }
        Mock Get-Config -ModuleName Catzc.Base.ModuleSystem -ParameterFilter { $Config -eq 'languages' } {
            [pscustomobject]@{ languages = @(
                    [pscustomobject]@{ name = 'widget'; executable = $true }
                    [pscustomobject]@{ name = 'gadget'; executable = $false }
                ) }
        }
        Mock Get-CatzcModule -ModuleName Catzc.Base.ModuleSystem {
            [Catzc.Base.Modules.Module]::new('Widget.Alpha', 'widgets', 'widget-folder', 'widgetry', 'widgetry/Widget.Alpha', 'folder', $null,
                [string[]] @('gadget', 'widget'), $null, $null)
        }
        Mock Resolve-EngineExecutable -ModuleName Catzc.Base.ModuleSystem -ParameterFilter { $Engine -eq 'zsh' } { throw 'not found' }
        Mock Resolve-EngineExecutable -ModuleName Catzc.Base.ModuleSystem { "/widgetry/$Engine" }
    }

    It 'reports the session''s mix from the configuration and the located engines' -Tag 'ADR-AUTO-IMPORTER-DECIDESMIX' {
        $mix = Get-ImportMix
        $mix | Should -BeOfType ([Catzc.Base.ModuleSystem.ImportMix])
        $mix.engines | Should -Be @('pwsh', 'bash')
        $mix.skipped_engines | Should -Be @('zsh')
        $mix.languages | Should -Be @('widget')
        $mix.modules | Should -Be @('Widget.Alpha')
    }

    It 'takes the caller''s -Languages and -Engines over the configuration' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        $mix = Get-ImportMix -Languages gadget -Engines pwsh
        $mix.languages | Should -Be @('gadget')
        $mix.engines | Should -Be @('pwsh')
    }
}
