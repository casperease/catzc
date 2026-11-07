Describe 'New-ImporterCore' -Tag 'L0', 'logic' {
    BeforeAll {
        # The core module needs widget, widget needs gadget; sprocket is declared but nothing in the core needs it.
        Mock Get-ModuleDependencyMap -ModuleName Catzc.Base.ModuleSystem {
            @{
                'Catzc.Base.ModuleSystem' = @('Catzc.Base.Widget')
                'Catzc.Base.Widget'       = @('Catzc.Base.Gadget')
                'Catzc.Base.Gadget'       = @()
                'Catzc.Base.Sprocket'     = @('Catzc.Base.Gadget')
            }
        }
        Mock Get-CatzcModule -ModuleName Catzc.Base.ModuleSystem {
            'Catzc.Base.ModuleSystem', 'Catzc.Base.Widget', 'Catzc.Base.Gadget', 'Catzc.Base.Sprocket' |
                ForEach-Object {
                    [Catzc.Base.Modules.Module]::new($_, 'widgets', 'widget-folder', 'widgetry',
                        "widgetry/$($_.Substring('Catzc.'.Length))", 'folder', $null, $null, $null, $null)
                }
        }
    }

    It 'lists the folder of the core module and of every module it needs, sorted, one per line' {
        New-ImporterCore | Should -Be "Base.Gadget`nBase.ModuleSystem`nBase.Widget`n"
    }

    It 'leaves out a module the core does not need' {
        New-ImporterCore | Should -Not -Match 'Sprocket'
    }

    It 'reads the modules of the engine track' {
        New-ImporterCore | Out-Null
        Should -Invoke Get-CatzcModule -ModuleName Catzc.Base.ModuleSystem -ParameterFilter { $EngineTrack }
    }

    It 'stops with a named error when a module of the closure has no folder' {
        Mock Get-ModuleDependencyMap -ModuleName Catzc.Base.ModuleSystem {
            @{ 'Catzc.Base.ModuleSystem' = @('Catzc.Base.Missing') }
        }
        { New-ImporterCore } | Should -Throw "*module 'Catzc.Base.Missing' of the core's closure has no folder*"
    }
}

Describe 'New-ImporterCore - real dependencies.yml' -Tag 'L1', 'integrity' {
    It 'the written list equals the declared closure of the core module, as folder names' {
        $closure = & (Get-Module Catzc.Base.ModuleSystem) { Get-ModuleDependencyClosure -Module 'Catzc.Base.ModuleSystem' }
        $folders = foreach ($module in Get-CatzcModule -EngineTrack) {
            if ($module.name -in $closure) {
                [System.IO.Path]::GetFileName($module.root)
            }
        }
        $sorted = [string[]] @($folders)
        [System.Array]::Sort($sorted, [System.StringComparer]::Ordinal)
        (New-ImporterCore).TrimEnd("`n") | Should -BeExactly ($sorted -join "`n")
    }
}
