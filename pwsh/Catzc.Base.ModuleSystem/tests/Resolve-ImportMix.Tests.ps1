Describe 'Resolve-ImportMix' -Tag 'L0', 'logic' {
    BeforeAll {
        Mock Get-Config -ModuleName Catzc.Base.ModuleSystem -ParameterFilter { $Config -eq 'importer' } {
            [Catzc.Base.ModuleSystem.ImporterConfig]::new(@{})
        }
        Mock Get-Config -ModuleName Catzc.Base.ModuleSystem -ParameterFilter { $Config -eq 'languages' } {
            $widget = [pscustomobject]@{ name = 'widget'; executable = $true; handled = $true }
            $gadget = [pscustomobject]@{ name = 'gadget'; executable = $true; handled = $true }
            $note = [pscustomobject]@{ name = 'note'; executable = $false; handled = $false }
            $config = [pscustomobject]@{ languages = @($widget, $gadget, $note) }
            $byExtension = @{ '.wdg' = $widget; '.gdg' = $gadget; '.note' = $note }
            # The widget language owns the module root, the gadget language owns gizmos/; assets/ and tests/ are the shared rows.
            $rows = @{
                '.'      = [pscustomobject]@{ language = 'widget' }
                'gizmos' = [pscustomobject]@{ language = 'gadget' }
                'assets' = [pscustomobject]@{ language = $null }
                'tests'  = [pscustomobject]@{ language = $null }
            }
            $config | Add-Member -MemberType ScriptMethod -Name ForPath -Value { param($path) $byExtension[[System.IO.Path]::GetExtension($path)] }.GetNewClosure()
            $config | Add-Member -MemberType ScriptMethod -Name PlaceOf -Value {
                param($path)
                $slash = $path.IndexOf('/')
                $rows[($slash -lt 0 ? '.' : $path.Substring(0, $slash))]
            }.GetNewClosure()
            $config
        }
        Mock Get-CatzcModule -ModuleName Catzc.Base.ModuleSystem {
            [Catzc.Base.Modules.Module]::new('Widget.Alpha', 'widgets', 'widget-folder', 'widgetry', 'widgetry/Widget.Alpha', 'folder',
                [string[]] @('Get-Widget.wdg', 'README.note', 'assets/sample.gdg', 'tests/Get-Widget.Tests.gdg'), $null, $null, $null)
            [Catzc.Base.Modules.Module]::new('Widget.Beta', 'widgets', 'widget-folder', 'widgetry', 'widgetry/Widget.Beta', 'folder',
                [string[]] @('Get-Gadget.wdg', 'gizmos/Gadget.gdg'), $null, $null, $null)
        }
        Mock Resolve-EngineExecutable -ModuleName Catzc.Base.ModuleSystem -ParameterFilter { $Engine -eq 'zsh' } { throw 'not found' }
        Mock Resolve-EngineExecutable -ModuleName Catzc.Base.ModuleSystem { "/widgetry/$Engine" }
    }

    It 'reports the located engines and skips the missing one' -Tag 'ADR-AUTO-IMPORTER-DECIDESMIX' {
        InModuleScope Catzc.Base.ModuleSystem {
            $mix = Resolve-ImportMix
            $mix.engines | Should -Be @('pwsh', 'bash')
            $mix.skipped_engines | Should -Be @('zsh')
        }
    }

    It 'takes a module''s code languages from its language-owned layout rows only, never assets/ or tests/' -Tag 'ADR-AUTO-IMPORTER-CODELANGUAGESSELECTMODULES' {
        InModuleScope Catzc.Base.ModuleSystem {
            $mix = Resolve-ImportMix -Languages widget
            $mix.modules | Should -Be @('Widget.Alpha')
            $mix.skipped_modules | Should -Be @('Widget.Beta')
        }
    }

    It 'resolves auto languages to the code languages of the modules' -Tag 'ADR-AUTO-IMPORTER-DECIDESMIX' {
        InModuleScope Catzc.Base.ModuleSystem {
            $mix = Resolve-ImportMix
            $mix.languages | Should -Be @('widget', 'gadget')
            $mix.modules | Should -Be @('Widget.Alpha', 'Widget.Beta')
        }
    }

    It 'stops with NotImplemented on a configured language without a handler' -Tag 'ADR-AUTO-IMPORTER-UNHANDLEDLANGUAGESTOPS' {
        InModuleScope Catzc.Base.ModuleSystem {
            { Resolve-ImportMix -Languages note } | Should -Throw -ExceptionType ([System.NotImplementedException]) -ExpectedMessage '*''note''*no handler*'
        }
    }

    It 'takes the caller''s -Engines over the configuration' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        InModuleScope Catzc.Base.ModuleSystem {
            (Resolve-ImportMix -Engines pwsh).engines | Should -Be @('pwsh')
        }
    }
}
