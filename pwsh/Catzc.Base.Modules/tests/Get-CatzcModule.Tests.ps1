# Rests on [ADR-AUTO-TEST](/docs/drs/automation/test-automation.md).
Describe 'Get-CatzcModule' -Tag 'L0', 'logic', 'ADR-AUTO-MODULE-DEPLOYABLETRACKMODULE' {
    BeforeAll {
        $script:first = [Catzc.Base.Engines.ExecutionEngines]::Names[0]
        $script:second = [Catzc.Base.Engines.ExecutionEngines]::Names[1]
        $script:tracks = [Catzc.Base.Variants.VariantsConfig]::new([ordered]@{
                tracks = [ordered]@{
                    widgets        = [ordered]@{ places = @('widgetry'); type = 'widget-works'; languages = @('widget-script', 'widget-data')
                        execution_engines = @($script:first); module_execution_engines = [ordered]@{ Gadget = @($script:first, $script:second) }
                    }
                    gizmos         = [ordered]@{ places = @('gizmo'); type = 'gizmo-shelf'; languages = @('gizmo-script') }
                    notes          = [ordered]@{ places = @('notes'); type = 'note-pile'; languages = @('widget-data') }
                    # A third language's track, the shape every language track takes: folder modules, the track's own
                    # test holder, a nested vendor track.
                    shelves        = [ordered]@{ places = @('shelf'); type = 'shelf-works'; languages = @('shelf-script') }
                    'shelf-vendor' = [ordered]@{ places = @('shelf/.vendor'); type = 'note-pile'; languages = @('shelf-script') }
                }
            }).tracks
        $script:trackTypes = [Catzc.Base.Variants.TrackTypesConfig]::new(@{
                track_types = [ordered]@{
                    'widget-works' = [ordered]@{ definition = 'Widgets.'; role = 'deployable'; admits = @('widget-folder', 'widget-file') }
                    'gizmo-shelf'  = [ordered]@{ definition = 'Gizmos.'; role = 'deployable'; admits = @('gizmo-folder') }
                    'note-pile'    = [ordered]@{ definition = 'Notes.'; role = 'holder'; admits = @('widget-folder') }
                    'shelf-works'  = [ordered]@{ definition = 'Shelves.'; role = 'deployable'; admits = @('shelf-folder') }
                }
            })
        $script:moduleTypes = [Catzc.Base.Variants.ModuleTypesConfig]::new(@{
                module_types = [ordered]@{
                    'widget-folder' = [ordered]@{ definition = 'A widget folder.'; places = @(
                            @{ root = 'widgetry'; name = 'folder' }
                            @{ root = 'widgetry/.core'; name = 'folder'; prefix = 'Widget.Core.'; internal = $true }
                        )
                    }
                    'widget-file'   = [ordered]@{ definition = 'A widget file.'; places = @(@{ root = 'widgetry/.core'; name = 'file'; extension = 'wdg'; internal = $true }) }
                    'gizmo-folder'  = [ordered]@{ definition = 'A gizmo folder.'; places = @(@{ root = 'gizmo'; name = 'folder' }) }
                    'shelf-folder'  = [ordered]@{ definition = 'A shelf folder, or the shelf itself.'; places = @(
                            @{ root = 'shelf'; name = 'folder'; except = @('tests') }
                            @{ root = 'shelf'; name = 'root' }
                        )
                    }
                }
            })
        $script:languages = [Catzc.Base.Languages.LanguagesConfig]::new([ordered]@{ languages = [ordered]@{
                    'widget-script' = [ordered]@{ extensions = @('.wdg'); no_formatter = 'fixture'; layout = @(
                            [ordered]@{ folder = '.'; role = 'public-widget'; extensions = @('.wdg') }
                            [ordered]@{ folder = 'inner'; role = 'private-widget' }
                        )
                    }
                    'widget-data'   = [ordered]@{ extensions = @('.wdd'); no_formatter = 'fixture' }
                    'gizmo-script'  = [ordered]@{ extensions = @('.gzm'); no_formatter = 'fixture' }
                    'shelf-script'  = [ordered]@{ extensions = @('.shf'); no_formatter = 'fixture'; layout = @(
                            [ordered]@{ folder = '.'; role = 'script'; extensions = @('.shf') }
                        )
                    }
                }
            })

        $script:root = Join-Path $TestDrive 'tree'
        $touch = { param($Path) $full = Join-Path $script:root $Path; New-Item -ItemType File -Path $full -Force |
            Out-Null }
        'widgetry/Gadget/Gadget.wdg', 'widgetry/Gadget/inner/Cog.wdg', 'widgetry/Gadget/tests/Gadget.Tests.wdg', 'widgetry/Gadget/assets/a/b.wdd',
        'widgetry/Sprocket/Sprocket.wdg', 'widgetry/Sprocket/stray.wdd', 'widgetry/Sprocket/oddity/Cog.wdg', 'widgetry/.hidden/Cog.wdg',
        'widgetry/.core/Widget.Core.Kit.wdg', 'widgetry/.core/tests/Cog.wdg', 'widgetry/loose.wdg', 'gizmo/Doodad/Doodad.gzm', 'notes/Memo/Memo.wdd',
        'shelf/Gadget.Kit/kit.shf', 'shelf/Gadget.Kit/tests/test_kit.shf', 'shelf/tests/gadget-kit/test_kit.shf', 'shelf/project.toml',
        'shelf/.vendor/thing/thing.shf', 'shelf/.cache/stale.shf' |
            ForEach-Object { & $touch $_ }

        Mock Get-Config -ModuleName Catzc.Base.Modules -ParameterFilter { $Config -eq 'track-types' } { $script:trackTypes }
        Mock Get-Config -ModuleName Catzc.Base.Modules -ParameterFilter { $Config -eq 'module-types' } { $script:moduleTypes }
        Mock Get-Config -ModuleName Catzc.Base.Modules -ParameterFilter { $Config -eq 'languages' } { $script:languages }
        Mock Get-Track -ModuleName Catzc.Base.Modules { $script:tracks }
        Mock Get-Track -ModuleName Catzc.Base.Modules -ParameterFilter { $Name } { $script:tracks |
            Where-Object { $Name -contains $_.name } }
    }

    It 'returns the modules of the deployable tracks only, as Module values, ordinal by name inside a track in declared track order' {
        $modules = @(Get-CatzcModule -RepositoryRoot $script:root)
        $modules[0] | Should -BeOfType [Catzc.Base.Modules.Module]
        $modules.name | Should -Be @('Gadget', 'Sprocket', 'Doodad', 'Gadget.Kit', 'shelf')
        $modules.track | Should -Be @('widgets', 'widgets', 'gizmos', 'shelves', 'shelves')
        $modules.type | Should -Be @('widget-folder', 'widget-folder', 'gizmo-folder', 'shelf-folder', 'shelf-folder')
    }

    It 'returns the modules of the track whose modules run under this engine when asked for the engine track' -Tag 'ADR-AUTO-MODULE-EVERYLANGUAGETRACKALIKE' {
        (Get-CatzcModule -EngineTrack -RepositoryRoot $script:root).name | Should -Be @('Gadget', 'Sprocket')
        (Get-CatzcModule -EngineTrack -Track gizmos -RepositoryRoot $script:root) | Should -BeNullOrEmpty
    }

    It 'gives a language track its folder modules and the track''s own module, every file in exactly one of them' -Tag 'ADR-AUTO-MODULE-EVERYLANGUAGETRACKALIKE' {
        $kit = Get-CatzcModule -Name Gadget.Kit -RepositoryRoot $script:root
        $kit.shape | Should -Be 'folder'
        $kit.root | Should -Be 'shelf/Gadget.Kit'
        $kit.files | Should -Be @('kit.shf', 'tests/test_kit.shf')
        $kit.unplaced | Should -Be @()
        $kit.languages | Should -Be @('shelf-script')
        $own = Get-CatzcModule -Name shelf -RepositoryRoot $script:root
        $own.shape | Should -Be 'root'
        $own.root | Should -Be 'shelf'
        # Not the folder module's files, not the nested vendor track's, not a dot folder's cache.
        $own.files | Should -Be @('project.toml', 'tests/gadget-kit/test_kit.shf')
        $own.unplaced | Should -Be @()
    }

    It 'gives each module its place, root, shape and files relative to the root' {
        $gadget = Get-CatzcModule -Name Gadget -RepositoryRoot $script:root
        $gadget.place | Should -Be 'widgetry'
        $gadget.root | Should -Be 'widgetry/Gadget'
        $gadget.shape | Should -Be 'folder'
        $gadget.files | Should -Be @('Gadget.wdg', 'assets/a/b.wdd', 'inner/Cog.wdg', 'tests/Gadget.Tests.wdg')
    }

    It 'reads a module''s languages from its files, ordinal and once each' {
        (Get-CatzcModule -Name Gadget -RepositoryRoot $script:root).languages | Should -Be @('widget-data',
            'widget-script')
        (Get-CatzcModule -Name Doodad -RepositoryRoot $script:root).languages | Should -Be @('gizmo-script')
    }

    It 'takes the engines of the track, and a module''s own override when it names one' -Tag 'ADR-AUTO-MODULE-ENGINESUBSET' {
        (Get-CatzcModule -Name Sprocket -RepositoryRoot $script:root).engines | Should -Be @($script:first)
        (Get-CatzcModule -Name Gadget -RepositoryRoot $script:root).engines | Should -Be @($script:first,
            $script:second)
        @((Get-CatzcModule -Name Doodad -RepositoryRoot $script:root).engines) | Should -HaveCount 0
    }

    It 'reports a file the layout places in no row, only for a module whose track''s primary language owns a layout' -Tag 'ADR-AUTO-MODULE-EXISTSBYLAYOUT' {
        (Get-CatzcModule -Name Gadget -RepositoryRoot $script:root).unplaced | Should -Be @()
        (Get-CatzcModule -Name Sprocket -RepositoryRoot $script:root).unplaced | Should -Be @('oddity/Cog.wdg',
            'stray.wdd')
        @((Get-CatzcModule -Name Doodad -RepositoryRoot $script:root).unplaced) | Should -HaveCount 0
    }

    It 'leaves out a dot folder and a file beside the modules, and the nested place unless it is asked for' {
        (Get-CatzcModule -RepositoryRoot $script:root).name | Should -Not -Contain '.hidden'
        (Get-CatzcModule -RepositoryRoot $script:root).name | Should -Not -Contain 'loose'
        $all = @(Get-CatzcModule -IncludeInternal -RepositoryRoot $script:root)
        $all.name | Should -Be @('Gadget', 'Sprocket', 'Widget.Core.Kit', 'Widget.Core.Tests', 'Doodad', 'Gadget.Kit',
            'shelf')
        $kit = $all | Where-Object name -CEQ 'Widget.Core.Kit'
        $kit.shape | Should -Be 'file'
        $kit.root | Should -Be 'widgetry/.core/Widget.Core.Kit.wdg'
        $kit.files | Should -Be @('Widget.Core.Kit.wdg')
        ($all | Where-Object name -CEQ 'Widget.Core.Tests').place | Should -Be 'widgetry/.core'
    }

    It 'takes a nested place with no internal flag as public, and skips a place declared internal unless it is asked for' {
        $tree = Join-Path $TestDrive 'nested'
        'gizmo/Doodad/Doodad.gzm', 'gizmo/.extra/Whatsit/Whatsit.gzm' | ForEach-Object {
            New-Item -ItemType File -Path (Join-Path $tree $_) -Force | Out-Null
        }
        $nested = { param([bool] $Internal)
            [Catzc.Base.Variants.ModuleTypesConfig]::new(@{
                    module_types = [ordered]@{
                        'gizmo-folder' = [ordered]@{ definition = 'A gizmo folder.'; places = @(
                                @{ root = 'gizmo'; name = 'folder' }
                                @{ root = 'gizmo/.extra'; name = 'folder'; internal = $Internal }
                            )
                        }
                    }
                })
        }
        $script:public = & $nested $false
        $script:flagged = & $nested $true
        Mock Get-Config -ModuleName Catzc.Base.Modules -ParameterFilter { $Config -eq 'module-types' } { $script:public }
        (Get-CatzcModule -Track gizmos -RepositoryRoot $tree).name | Should -Be @('Doodad', 'Whatsit')
        Mock Get-Config -ModuleName Catzc.Base.Modules -ParameterFilter { $Config -eq 'module-types' } { $script:flagged }
        (Get-CatzcModule -Track gizmos -RepositoryRoot $tree).name | Should -Be @('Doodad')
        (Get-CatzcModule -Track gizmos -IncludeInternal -RepositoryRoot $tree).name | Should -Be @('Doodad', 'Whatsit')
    }

    It 'filters by track and by name, and returns nothing for a name no module has' {
        (Get-CatzcModule -Track gizmos -RepositoryRoot $script:root).name | Should -Be @('Doodad')
        (Get-CatzcModule -TrackType gizmo-shelf -RepositoryRoot $script:root).name | Should -Be @('Doodad')
        (Get-CatzcModule -TrackType widget-works, gizmo-shelf -RepositoryRoot $script:root).name |
            Should -Be @('Gadget', 'Sprocket', 'Doodad')
        @(Get-CatzcModule -TrackType note-pile -RepositoryRoot $script:root) | Should -HaveCount 0
        @(Get-CatzcModule -Track shelf-vendor -RepositoryRoot $script:root) | Should -HaveCount 0
        (Get-CatzcModule -Name Sprocket, Doodad -RepositoryRoot $script:root).name | Should -Be @('Sprocket', 'Doodad')
        @(Get-CatzcModule -Name Nonesuch -RepositoryRoot $script:root) | Should -HaveCount 0
    }

    It 'skips a place whose folder is missing' {
        Get-CatzcModule -Track gizmos -RepositoryRoot (Join-Path $TestDrive 'nowhere') | Should -BeNullOrEmpty
    }
}

Describe 'Get-CatzcModule on the repository' -Tag 'L1', 'integrity', 'ADR-AUTO-MODULE-DEPLOYABLETRACKMODULE', 'DDR-MODTYPE-MODULEISPLACEDUNIT' {
    BeforeAll {
        $script:modules = @(Get-CatzcModule)
        $script:codeTrack = Get-Track -Path (Get-CatzcModulesFolder)
        $script:codeModules = @(Get-CatzcModule -EngineTrack)
    }

    It 'resolves every module folder of the code track, the same set the loader imports' {
        $script:codeModules.track | Should -Be @($script:codeModules | ForEach-Object { $script:codeTrack.name })
        $folders = [System.IO.Directory]::EnumerateDirectories((Get-CatzcModulesRoot)).Where({ -not [System.IO.Path]::GetFileName($_).StartsWith('.') }).ForEach({ [System.IO.Path]::GetFileName($_) })
        $sorted = [string[]]$folders
        [System.Array]::Sort($sorted, [System.StringComparer]::Ordinal)
        $script:codeModules.name | Should -Be $sorted
    }

    It 'resolves the modules through the track, so each root sits under a place of its track' {
        foreach ($module in $script:modules) {
            $places = (Get-Track -Name $module.track).places
            ($places | Where-Object { $module.root -ceq $_ -or $module.root.StartsWith("$_/",
                [System.StringComparison]::Ordinal) }) | Should -Not -BeNullOrEmpty -Because $module.name
        }
    }

    It 'keeps every language of a code module within its track''s declared languages' -Tag 'ADR-AUTO-MODULE-LANGUAGESFROMFILES' {
        $declared = $script:codeTrack.languages
        foreach ($module in $script:codeModules) {
            @($module.languages | Where-Object { $declared -cnotcontains $_ }) |
                Should -HaveCount 0 -Because $module.name
        }
    }

    It 'places every file inside a code module in the layout' -Tag 'ADR-AUTO-MODULE-EXISTSBYLAYOUT' {
        foreach ($module in $script:codeModules) {
            @($module.unplaced) |
                Should -HaveCount 0 -Because "$($module.name) holds a file in no layout row: $($module.unplaced -join ', ')"
        }
    }

    It 'resolves every template folder and every Bicep module file of the infrastructure track' -Tag 'DDR-MODTYPE-MODULEISPLACEDUNIT' {
        $root = Get-RepositoryRoot
        $templates = @([System.IO.Directory]::EnumerateDirectories((Join-Path $root 'infrastructure/templates')).ForEach({ [System.IO.Path]::GetFileName($_) }))
        $bicepModules = @([System.IO.Directory]::EnumerateFiles((Join-Path $root 'infrastructure/modules'),
            '*.bicep').ForEach({ [System.IO.Path]::GetFileNameWithoutExtension($_) }))
        $names = @(Get-CatzcModule -TrackType infrastructure).ForEach({ $_.name })
        $templates.Count | Should -BeGreaterThan 0
        $bicepModules.Count | Should -BeGreaterThan 0
        foreach ($name in $templates + $bicepModules) {
            $names | Should -Contain $name
        }
    }
}
