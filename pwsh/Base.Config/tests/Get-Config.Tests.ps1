Describe 'Get-Config' -Tag 'L0' {
    Context 'discovery + raw default' -Tag 'integrity' {
        # A real shipped config, so discovery in its owning module is proven; the raw default is pinned on a fixture below.
        It 'discovers and loads a shipped config from its owning module' {
            $configuration = Get-Config -Config tools                       # registry type: Catzc.Base.Execution.ToolsConfig
            $configuration.Keys | Should -Contain 'python'
        }
    }

    Context 'caching, errors, and name binding' -Tag 'logic' {
        # The function's own behaviour on a fixture reached through its seam, so no case depends on which configs ship.
        It 'returns the same cached object reference on repeat calls' {
            $dir = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
            New-Item -ItemType Directory -Path $dir | Out-Null
            Set-Content -Path (Join-Path $dir 'myconfig.yml') -Value 'k: v'
            Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -eq 'myconfig' } -MockWith {
                @{ Name = 'myconfig'; Module = 'Catzc.Base.Config'; Path = (Join-Path $dir 'myconfig.yml') }
            }
            $first = Get-Config -Config myconfig
            $second = Get-Config -Config myconfig
            [object]::ReferenceEquals($first, $second) | Should -BeTrue
        }

        It 'returns a config with no registry entry raw, as an ordered dictionary' {
            $dir = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
            New-Item -ItemType Directory -Path $dir | Out-Null
            Set-Content -Path (Join-Path $dir 'widget-raw.yml') -Value @('gadget: tst', 'widget: 1')
            Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -eq 'widget-raw' } -MockWith {
                @{ Name = 'widget-raw'; Module = 'Catzc.Base.Config'; Path = (Join-Path $dir 'widget-raw.yml') }
            }
            $configuration = Get-Config -Config widget-raw
            $configuration | Should -BeOfType [System.Collections.Specialized.OrderedDictionary]
            @($configuration.Keys) | Should -Be @('gadget', 'widget')
        }

        It 'merges a config folder''s parts in ordinal name order, and fails a key two parts both set' {
            $dir = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
            New-Item -ItemType Directory -Path $dir | Out-Null
            Set-Content -Path (Join-Path $dir 'gadget.yml') -Value @('parts:', '  gadget: 2')
            Set-Content -Path (Join-Path $dir 'widget.yml') -Value @('parts:', '  widget: 1')
            Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -eq 'widget-parts' } -MockWith {
                @{ Name = 'widget-parts'; Module = 'Catzc.Base.Config'; Path = $dir }
            }
            @((Get-Config -Config widget-parts).parts.Keys) | Should -Be @('gadget', 'widget')

            $clash = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
            New-Item -ItemType Directory -Path $clash | Out-Null
            Set-Content -Path (Join-Path $clash 'gadget.yml') -Value @('parts:', '  widget: 2')
            Set-Content -Path (Join-Path $clash 'widget.yml') -Value @('parts:', '  widget: 1')
            Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -eq 'widget-clash' } -MockWith {
                @{ Name = 'widget-clash'; Module = 'Catzc.Base.Config'; Path = $clash }
            }
            { Get-Config -Config widget-clash } | Should -Throw "*key 'widget' is set by more than one part*"
        }

        It 'reads a file and a folder''s parts from the active source, cached apart from the working tree''s' {
            $root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
            New-Item -ItemType Directory -Path (Join-Path $root 'configs/widget-parts') -Force | Out-Null
            Set-Content -Path (Join-Path $root 'configs/widget-source.yml') -Value 'gadget: working'
            Set-Content -Path (Join-Path $root 'configs/widget-parts/a.yml') -Value @('parts:', '  gadget: working')
            Mock Get-RepositoryRoot -ModuleName Catzc.Base.Repository { $root }
            Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -eq 'widget-source' } -MockWith {
                @{ Name = 'widget-source'; Module = 'Catzc.Base.Config'; Path = (Join-Path $root 'configs/widget-source.yml') }
            }
            Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -eq 'widget-source-parts' } -MockWith {
                @{ Name = 'widget-source-parts'; Module = 'Catzc.Base.Config'; Path = (Join-Path $root 'configs/widget-parts') }
            }
            $commit = @{
                Name = 'c' * 40
                Path = [string[]] @('configs/widget-source.yml', 'configs/widget-parts/b.yml')
                Text = @{ 'configs/widget-source.yml' = 'gadget: committed'; 'configs/widget-parts/b.yml' = "parts:`n  sprocket: committed" }
            }
            (Get-Config -Config widget-source).gadget | Should -BeExactly 'working'
            $read = Use-RepositoryTextSource @commit -ScriptBlock {
                (Get-Config -Config widget-source).gadget
                @((Get-Config -Config widget-source-parts).parts.Keys)
            }
            $read | Should -Be @('committed', 'sprocket')
            (Get-Config -Config widget-source).gadget | Should -BeExactly 'working'
            @((Get-Config -Config widget-source-parts).parts.Keys) | Should -Be @('gadget')
        }

        It 'throws for a shipped file the active source does not hold, naming the source' {
            $root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
            New-Item -ItemType Directory -Path $root | Out-Null
            Set-Content -Path (Join-Path $root 'widget-new.yml') -Value 'k: v'
            Mock Get-RepositoryRoot -ModuleName Catzc.Base.Repository { $root }
            Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -eq 'widget-new' } -MockWith {
                @{ Name = 'widget-new'; Module = 'Catzc.Base.Config'; Path = (Join-Path $root 'widget-new.yml') }
            }
            { Use-RepositoryTextSource -Name ('c' * 40) -Path @() -Text @{} -ScriptBlock { Get-Config -Config widget-new } } |
                Should -Throw "*widget-new.yml (in source $('c' * 40))*"
        }

        It 'throws for an unknown config name' {
            { Get-Config -Config does-not-exist } | Should -Throw '*No config*'
        }

        It 'fails fast on an empty file, naming its path and length, instead of handing a null to the type' {
            $dir = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
            New-Item -ItemType Directory -Path $dir | Out-Null
            $path = Join-Path $dir 'widget-empty.yml'
            [System.IO.File]::WriteAllText($path, '')
            Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -eq 'widget-empty' } -MockWith {
                @{ Name = 'widget-empty'; Module = 'Catzc.Base.Config'; Path = $path }
            }
            { Get-Config -Config widget-empty } | Should -Throw "*widget-empty.yml' is empty (0 bytes)*"
        }

        It 'rejects a non-kebab name at parameter binding' {
            { Get-Config -Config 'Bad_Name' } | Should -Throw
        }
    }

    Context 'a consumer overlay fragment' -Tag 'logic' {
        # A bundled config and an overlay, both fixtures behind their seams, so a merge is tested without a real consumer.
        BeforeEach {
            $script:bundled = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
            $script:overlay = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
            New-Item -ItemType Directory -Path $bundled | Out-Null
            New-Item -ItemType Directory -Path (Join-Path $overlay 'Base.Widget/configs') | Out-Null
            Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -MockWith {
                @{ Name = $Config; Module = 'Catzc.Base.Widget'; Path = (Join-Path $bundled "$Config.yml") }
            }
            Mock Get-ConfigOverlayRoot -ModuleName Catzc.Base.Config -MockWith { $overlay }
            Mock Get-ConfigRegistry -ModuleName Catzc.Base.Config -MockWith {
                [ordered]@{ 'widget-sealed' = [ordered]@{ type = 'System.Collections.Hashtable'; scope = 'engine' } }
            }
            # The overlay folder is the bundled module's folder, without the namespace its full name carries.
            Mock Get-Module -ModuleName Catzc.Base.Config -ParameterFilter { $Name -eq 'Catzc.Base.Widget' } -MockWith {
                [pscustomobject]@{ Name = 'Catzc.Base.Widget'; ModuleBase = (Join-Path $TestDrive 'modules/Base.Widget') }
            }
        }

        It 'merges the fragment onto the bundled config before it is returned' {
            Set-Content -Path (Join-Path $bundled 'widget-merged.yml') -Value @('owner: widget', 'limit: 3', 'gadgets:',
                '  lever: 1', '  sprung: 2')
            Set-Content -Path (Join-Path $overlay 'Base.Widget/configs/widget-merged.yml') -Value @('limit: 5',
                'gadgets:', '  sprung: null')
            $configuration = Get-Config -Config widget-merged
            $configuration.owner | Should -Be 'widget'
            $configuration.limit | Should -Be 5
            $configuration.gadgets.lever | Should -Be 1
            $configuration.gadgets.Contains('sprung') | Should -BeFalse
        }

        It 'finds the fragment of a built root''s namespaced folder under the overlay''s bare folder' -Tag 'ADR-AUTO-OVERLAY-CONFIGFRAGMENT' {
            Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -MockWith {
                @{ Name = $Config; Module = 'Catzc.Base.Widget'; Folder = 'Catzc.Base.Widget'; Path = (Join-Path $bundled "$Config.yml") }
            }
            Mock Resolve-CodeModuleFolder -ModuleName Catzc.Base.Config -ParameterFilter { $BareName -ceq 'Catzc.Base.Widget' } -MockWith { 'Base.Widget' }
            Set-Content -Path (Join-Path $bundled 'widget-built.yml') -Value @('limit: 3')
            Set-Content -Path (Join-Path $overlay 'Base.Widget/configs/widget-built.yml') -Value 'limit: 5'
            (Get-Config -Config widget-built).limit | Should -Be 5
        }

        It 'returns the bundled config unchanged when the overlay has no fragment of it' {
            Set-Content -Path (Join-Path $bundled 'widget-plain.yml') -Value 'limit: 3'
            (Get-Config -Config widget-plain).limit | Should -Be 3
        }

        It 'serves an edited fragment, never a stale merge' {
            Set-Content -Path (Join-Path $bundled 'widget-edited.yml') -Value 'limit: 3'
            $fragment = Join-Path $overlay 'Base.Widget/configs/widget-edited.yml'
            Set-Content -Path $fragment -Value 'limit: 5'
            (Get-Config -Config widget-edited).limit | Should -Be 5
            Set-Content -Path $fragment -Value 'limit: 70'
            [System.IO.File]::SetLastWriteTimeUtc($fragment, [datetime]::UtcNow.AddMinutes(1))
            (Get-Config -Config widget-edited).limit | Should -Be 70
        }

        It 'refuses a fragment of a sealed config' {
            Set-Content -Path (Join-Path $bundled 'widget-sealed.yml') -Value 'limit: 3'
            Set-Content -Path (Join-Path $overlay 'Base.Widget/configs/widget-sealed.yml') -Value 'limit: 5'
            { Get-Config -Config widget-sealed } |
                Should -Throw "*Config 'widget-sealed' is sealed*remove*widget-sealed.yml*"
        }

        It 'refuses a fragment that is not a map' {
            Set-Content -Path (Join-Path $bundled 'widget-list.yml') -Value 'limit: 3'
            Set-Content -Path (Join-Path $overlay 'Base.Widget/configs/widget-list.yml') -Value @('- gadget',
                '- gizmo')
            { Get-Config -Config widget-list } | Should -Throw '*must both be maps*'
        }
    }

    Context 'a working-root config' -Tag 'logic' {
        # A bundled file, a working root and the registry, all fixtures behind their seams; the type keeps the dictionary it was given.
        BeforeAll {
            Add-Type -TypeDefinition @'
namespace WidgetConfigTest {
    public class FixtureConfig {
        public System.Collections.IDictionary Raw;
        public FixtureConfig(System.Collections.IDictionary d) { Raw = d; }
    }
}
'@ -ErrorAction SilentlyContinue
        }

        BeforeEach {
            $script:bundled = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
            $script:workingRoot = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
            New-Item -ItemType Directory -Path $bundled | Out-Null
            New-Item -ItemType Directory -Path (Join-Path $workingRoot '.catzc/configs') | Out-Null
            Set-Content -Path (Join-Path $bundled 'widget-root.yml') -Value @('gadget: shipped', 'widget: shipped')
            Set-Content -Path (Join-Path $bundled 'widget-module.yml') -Value @('gadget: shipped', 'widget: shipped')
            Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -MockWith {
                @{ Name = $Config; Module = 'Catzc.Base.Widget'; Path = (Join-Path $bundled "$Config.yml") }
            }
            Mock Get-RepositoryRoot -ModuleName Catzc.Base.Config -MockWith { $workingRoot }
            Mock Get-ConfigRegistry -ModuleName Catzc.Base.Config -MockWith {
                [ordered]@{
                    'widget-root'   = @{ type = 'WidgetConfigTest.FixtureConfig'; scope = 'working-root' }
                    'widget-module' = @{ type = 'WidgetConfigTest.FixtureConfig'; scope = 'module' }
                }
            }
        }

        It 'reads the working root''s file whole in build mode, so a key only the bundled file holds is absent' -Tag 'ADR-CONF-LOADING-WORKINGROOTREADWHOLE' {
            Mock Get-CatzcRunMode -ModuleName Catzc.Base.Config -MockWith { 'build' }
            Set-Content -Path (Join-Path $workingRoot '.catzc/configs/widget-root.yml') -Value 'gadget: consumer'
            $raw = (Get-Config -Config widget-root).Raw
            $raw['gadget'] | Should -Be 'consumer'
            $raw.Contains('widget') | Should -BeFalse
        }

        It 'gives the type''s default in build mode when the working root has no file, leaking nothing from the bundled one' -Tag 'ADR-CONF-LOADING-WORKINGROOTREADWHOLE' {
            Mock Get-CatzcRunMode -ModuleName Catzc.Base.Config -MockWith { 'build' }
            (Get-Config -Config widget-root).Raw.Count | Should -Be 0
        }

        It 'serves an edited working-root file, never a stale read' -Tag 'ADR-CONF-LOADING-CACHEBYPATH' {
            Mock Get-CatzcRunMode -ModuleName Catzc.Base.Config -MockWith { 'build' }
            $file = Join-Path $workingRoot '.catzc/configs/widget-root.yml'
            Set-Content -Path $file -Value 'gadget: one'
            (Get-Config -Config widget-root).Raw['gadget'] | Should -Be 'one'
            Set-Content -Path $file -Value 'gadget: two'
            [System.IO.File]::SetLastWriteTimeUtc($file, [datetime]::UtcNow.AddMinutes(1))
            (Get-Config -Config widget-root).Raw['gadget'] | Should -Be 'two'
        }

        It 'reads the bundled file unchanged in source mode' -Tag 'ADR-CONF-LOADING-WORKINGROOTREADWHOLE' {
            Mock Get-CatzcRunMode -ModuleName Catzc.Base.Config -MockWith { 'source' }
            Mock Get-ConfigOverlayRoot -ModuleName Catzc.Base.Config -MockWith { }
            Set-Content -Path (Join-Path $workingRoot '.catzc/configs/widget-root.yml') -Value 'gadget: consumer'
            $raw = (Get-Config -Config widget-root).Raw
            $raw['gadget'] | Should -Be 'shipped'
            $raw['widget'] | Should -Be 'shipped'
        }

        It 'still merges a fragment onto a module-scope config in build mode' -Tag 'ADR-CONF-LOADING-THREESCOPES' {
            Mock Get-CatzcRunMode -ModuleName Catzc.Base.Config -MockWith { 'build' }
            $overlay = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
            New-Item -ItemType Directory -Path (Join-Path $overlay 'Base.Widget/configs') | Out-Null
            Set-Content -Path (Join-Path $overlay 'Base.Widget/configs/widget-module.yml') -Value 'gadget: consumer'
            Mock Get-ConfigOverlayRoot -ModuleName Catzc.Base.Config -MockWith { $overlay }
            Mock Get-Module -ModuleName Catzc.Base.Config -ParameterFilter { $Name -eq 'Catzc.Base.Widget' } -MockWith {
                [pscustomobject]@{ Name = 'Catzc.Base.Widget'; ModuleBase = (Join-Path $TestDrive 'modules/Base.Widget') }
            }
            $raw = (Get-Config -Config widget-module).Raw
            $raw['gadget'] | Should -Be 'consumer'
            $raw['widget'] | Should -Be 'shipped'
        }
    }

    Context 'collision handling (Resolve-ConfigEntry)' -Tag 'logic' {
        It 'throws when a name exists in multiple modules, and -Module disambiguates' {
            InModuleScope Catzc.Base.Config {
                $list = [System.Collections.Generic.List[hashtable]]::new()
                $list.Add(@{ Name = 'dup'; Module = 'A'; Path = 'a.yml' })
                $list.Add(@{ Name = 'dup'; Module = 'B'; Path = 'b.yml' })
                $script:configIndex = @{ Catzc = @{ dup = $list } }
                try {
                    { Resolve-ConfigEntry -Config dup } | Should -Throw '*multiple modules*'
                    (Resolve-ConfigEntry -Config dup -Module B).Module | Should -Be 'B'
                }
                finally {
                    $script:configIndex = $null
                }
            }
        }

        It 'lists every owner of a name sorted by module (ordinal), and nothing for an unknown name' {
            InModuleScope Catzc.Base.Config {
                $list = [System.Collections.Generic.List[hashtable]]::new()
                $list.Add(@{ Name = 'widget'; Module = 'b'; Path = 'b.yml' })
                $list.Add(@{ Name = 'widget'; Module = 'B'; Path = 'B.yml' })
                $list.Add(@{ Name = 'widget'; Module = 'A'; Path = 'A.yml' })
                $script:configIndex = @{ Catzc = @{ widget = $list } }
                try {
                    (Get-Config -Config widget -ListOwners).Module | Should -Be @('A', 'B', 'b')
                    @(Get-Config -Config gadget -ListOwners).Count | Should -Be 0
                }
                finally {
                    $script:configIndex = $null
                }
            }
        }

        It 'refuses a config that is both a file and a same-named folder in one module, naming both paths' {
            $root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
            New-Item -ItemType Directory -Path (Join-Path $root 'Base.Widget/configs/sprocket') | Out-Null
            Set-Content -LiteralPath (Join-Path $root 'Base.Widget/configs/sprocket.yml') -Value 'teeth: 12'
            Set-Content -LiteralPath (Join-Path $root 'Base.Widget/configs/sprocket/cog.yml') -Value 'teeth: 8'
            Mock Get-CatzcModulesRoot -ModuleName Catzc.Base.Config -MockWith { $root }
            Mock Get-ConfigOverlayRoot -ModuleName Catzc.Base.Config -MockWith { }
            Mock Get-ConfigRegistry -ModuleName Catzc.Base.Config -MockWith { [ordered]@{} }
            InModuleScope Catzc.Base.Config { $script:configIndex = $null }
            try {
                { Get-Config -Config sprocket } |
                    Should -Throw "*'sprocket' in module 'Base.Widget' is both a file and a same-named folder*sprocket.yml' and '*sprocket'*"
            }
            finally {
                InModuleScope Catzc.Base.Config { $script:configIndex = $null }
            }
        }

        It 'lists a single owner without loading its config' {
            InModuleScope Catzc.Base.Config {
                $list = [System.Collections.Generic.List[hashtable]]::new()
                $list.Add(@{ Name = 'widget'; Module = 'A'; Path = 'TestDrive:/absent/widget.yml' })
                $script:configIndex = @{ Catzc = @{ widget = $list } }
                try {
                    $owners = @(Get-Config -Config widget -ListOwners)
                    $owners.Count | Should -Be 1
                    $owners[0].Path | Should -Be 'TestDrive:/absent/widget.yml'
                }
                finally {
                    $script:configIndex = $null
                }
            }
        }
    }

    Context 'registry types' -Tag 'logic' {
        BeforeAll {
            Add-Type -TypeDefinition @'
namespace WidgetConfigTest {
    public class FixtureConfig {
        public System.Collections.IDictionary Raw;
        public FixtureConfig(System.Collections.IDictionary d) { Raw = d; }
    }
}
'@ -ErrorAction SilentlyContinue
        }

        It 'constructs the registered C# type from the parsed dict' {
            $dir = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
            New-Item -ItemType Directory -Path $dir | Out-Null
            Set-Content -Path (Join-Path $dir 'fixtype.yml') -Value 'k: v'

            Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -eq 'fixtype' } -MockWith {
                @{ Name = 'fixtype'; Module = 'Catzc.Base.Config'; Path = (Join-Path $dir 'fixtype.yml') }
            }
            Mock Get-ConfigRegistry -ModuleName Catzc.Base.Config -MockWith { @{ fixtype = @{ type = 'WidgetConfigTest.FixtureConfig' } } }

            $result = Get-Config -Config fixtype
            $result -is [WidgetConfigTest.FixtureConfig] | Should -BeTrue
            $result.Raw['k'] | Should -Be 'v'
        }

        It 'builds a registered type with no shipped file from an empty map, and merges the repository''s fragment onto it' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
            $overlay = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
            New-Item -ItemType Directory -Path (Join-Path $overlay 'Base.Widget/configs') | Out-Null
            Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -like 'widget-bare*' } -MockWith {
                @{ Name = $Config; Module = 'Catzc.Base.Widget'; Path = $null }
            }
            Mock Get-ConfigRegistry -ModuleName Catzc.Base.Config -MockWith {
                [ordered]@{ 'widget-bare' = @{ type = 'WidgetConfigTest.FixtureConfig' }; 'widget-bare-merged' = @{ type = 'WidgetConfigTest.FixtureConfig' } }
            }
            Mock Get-ConfigOverlayRoot -ModuleName Catzc.Base.Config -MockWith { $overlay }
            Mock Get-Module -ModuleName Catzc.Base.Config -ParameterFilter { $Name -eq 'Catzc.Base.Widget' } -MockWith {
                [pscustomobject]@{ Name = 'Catzc.Base.Widget'; ModuleBase = (Join-Path $TestDrive 'modules/Base.Widget') }
            }

            (Get-Config -Config widget-bare).Raw.Count | Should -Be 0
            Set-Content -Path (Join-Path $overlay 'Base.Widget/configs/widget-bare-merged.yml') -Value 'limit: 5'
            (Get-Config -Config widget-bare-merged).Raw['limit'] | Should -Be 5
        }
    }

    Context 'a registered type with no shipped file (Resolve-ConfigEntry)' -Tag 'logic' {
        It 'lists it under the module its type''s namespace names, with no path' {
            $root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
            New-Item -ItemType Directory -Path (Join-Path $root 'Base.Widget') | Out-Null
            Mock Get-CatzcModulesRoot -ModuleName Catzc.Base.Config -MockWith { $root }
            Mock Get-ConfigOverlayRoot -ModuleName Catzc.Base.Config -MockWith { }
            Mock Get-ConfigRegistry -ModuleName Catzc.Base.Config -MockWith { [ordered]@{ gadgetry = @{ type = 'Catzc.Base.Widget.GadgetryConfig' } } }
            $entry = InModuleScope Catzc.Base.Config {
                $script:configIndex = $null
                Resolve-ConfigEntry -Config gadgetry
            }
            InModuleScope Catzc.Base.Config { $script:configIndex = $null }
            $entry.Module | Should -Be 'Catzc.Base.Widget'
            $entry.Path | Should -BeNullOrEmpty
        }

        It 'names a shipped config''s module by its manifest, and keeps the folder that drops the namespace' -Tag 'DDR-TRACK-MODULENAMESPACE' {
            $root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
            New-Item -ItemType Directory -Path (Join-Path $root 'Base.Widget/configs') | Out-Null
            Set-Content -LiteralPath (Join-Path $root 'Base.Widget/Catzc.Base.Widget.psd1') -Value '@{}'
            Set-Content -LiteralPath (Join-Path $root 'Base.Widget/configs/sprocket.yml') -Value 'teeth: 12'
            New-Item -ItemType Directory -Path (Join-Path $root 'Gadget/configs') | Out-Null
            Set-Content -LiteralPath (Join-Path $root 'Gadget/configs/cog.yml') -Value 'teeth: 8'
            Mock Get-CatzcModulesRoot -ModuleName Catzc.Base.Config -MockWith { $root }
            Mock Get-ConfigOverlayRoot -ModuleName Catzc.Base.Config -MockWith { }
            Mock Get-ConfigRegistry -ModuleName Catzc.Base.Config -MockWith { [ordered]@{} }
            $entries = InModuleScope Catzc.Base.Config {
                $script:configIndex = $null
                Resolve-ConfigEntry -Config sprocket
                Resolve-ConfigEntry -Config cog
            }
            InModuleScope Catzc.Base.Config { $script:configIndex = $null }
            @($entries[0].Module, $entries[0].Folder) | Should -Be @('Catzc.Base.Widget', 'Base.Widget')
            $entries[1].Module | Should -BeExactly 'Gadget' -Because 'a folder with no manifest is its own name'
        }

        It 'indexes a built root''s namespaced folder once, and the overlay''s bare folder of it as a fragment folder, not a second module' -Tag 'ADR-AUTO-OVERLAY-CONFIGFRAGMENT' {
            $root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
            $overlay = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
            New-Item -ItemType Directory -Path (Join-Path $root 'Catzc.Base.Widget/configs') | Out-Null
            Set-Content -LiteralPath (Join-Path $root 'Catzc.Base.Widget/Catzc.Base.Widget.psd1') -Value '@{}'
            Set-Content -LiteralPath (Join-Path $root 'Catzc.Base.Widget/configs/sprocket.yml') -Value 'teeth: 12'
            New-Item -ItemType Directory -Path (Join-Path $overlay 'Base.Widget/configs') | Out-Null
            Set-Content -LiteralPath (Join-Path $overlay 'Base.Widget/configs/sprocket.yml') -Value 'teeth: 8'
            Mock Get-CatzcModulesRoot -ModuleName Catzc.Base.Config -MockWith { $root }
            Mock Get-ConfigOverlayRoot -ModuleName Catzc.Base.Config -MockWith { $overlay }
            Mock Get-ConfigRegistry -ModuleName Catzc.Base.Config -MockWith { [ordered]@{} }
            $entry = InModuleScope Catzc.Base.Config {
                $script:configIndex = $null
                Resolve-ConfigEntry -Config sprocket
            }
            InModuleScope Catzc.Base.Config { $script:configIndex = $null }
            @($entry).Count | Should -Be 1
            $entry.Module | Should -BeExactly 'Catzc.Base.Widget'
            $entry.Folder | Should -BeExactly 'Catzc.Base.Widget'
        }
    }

    Context 'the namespace a bare name resolves in' -Tag 'logic' {
        # Calls from fixture modules named <Namespace>.<Folder>, with the discovery seam answering from a fixture table keyed (namespace, name).
        BeforeAll {
            Add-Type -TypeDefinition @'
namespace WidgetConfigTest {
    public class FixtureConfig {
        public System.Collections.IDictionary Raw;
        public FixtureConfig(System.Collections.IDictionary d) { Raw = d; }
    }
}
'@ -ErrorAction SilentlyContinue
        }

        BeforeEach {
            $dir = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
            New-Item -ItemType Directory -Path $dir | Out-Null
            Set-Content -Path (Join-Path $dir 'catzc-gadget.yml') -Value 'owner: catzc'
            Set-Content -Path (Join-Path $dir 'widget-gadget.yml') -Value 'owner: widget'
            Set-Content -Path (Join-Path $dir 'catzc-sprocket.yml') -Value 'owner: catzc'
            $script:table = @{
                'Catzc/gadget'   = @{ Namespace = 'Catzc'; Name = 'gadget'; Module = 'Catzc.Base.Widget'; Path = (Join-Path $dir 'catzc-gadget.yml') }
                'Widget/gadget'  = @{ Namespace = 'Widget'; Name = 'gadget'; Module = 'Widget.Local'; Path = (Join-Path $dir 'widget-gadget.yml') }
                'Catzc/sprocket' = @{ Namespace = 'Catzc'; Name = 'sprocket'; Module = 'Catzc.Base.Widget'; Path = (Join-Path $dir 'catzc-sprocket.yml') }
            }
            Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -MockWith {
                $hit = $script:table["$Namespace/$Config"]
                if (Get-Variable -Name All -ValueOnly -ErrorAction SilentlyContinue) {
                    if ($hit) {
                        $hit
                    }
                    return
                }
                if (-not $hit) {
                    throw "No config '$Config' found in any module's configs/ folder of the namespace '$Namespace'."
                }
                $hit
            }
            Mock Get-ConfigRegistry -ModuleName Catzc.Base.Config -MockWith { [ordered]@{} }
            Mock Get-ConfigOverlayRoot -ModuleName Catzc.Base.Config -MockWith { }
            $widgetModule = New-Module -Name Widget.Fixture -ScriptBlock {
                function Read-WidgetFixture {
                    param([string] $Name)
                    Get-Config -Config $Name
                }
                function Read-WidgetFixtureInBlock {
                    param([string] $Name)
                    'x' | ForEach-Object { Get-Config -Config $Name }
                }
            }
            $catzcModule = New-Module -Name Catzc.Fixture -ScriptBlock {
                function Read-CatzcFixture {
                    param([string] $Name)
                    Get-Config -Config $Name
                }
            }
            $widgetModule | Import-Module -Force
            $catzcModule | Import-Module -Force
        }

        AfterEach {
            Remove-Module Widget.Fixture, Catzc.Fixture -Force -ErrorAction SilentlyContinue
        }

        It 'resolves a bare name in the namespace of a Widget module that calls' -Tag 'ADR-AUTO-CONSUMER-OWNCONFIGS' {
            (Read-WidgetFixture -Name gadget)['owner'] | Should -Be 'widget'
        }

        It 'resolves a bare name in the namespace of the nearest module when a script block of it calls' -Tag 'ADR-AUTO-CONSUMER-OWNCONFIGS' {
            (Read-WidgetFixtureInBlock -Name gadget)['owner'] | Should -Be 'widget'
        }

        It 'resolves a bare name in the Catzc namespace for a Catzc module and for a call from no module' -Tag 'ADR-AUTO-CONSUMER-OWNCONFIGS' {
            (Read-CatzcFixture -Name gadget)['owner'] | Should -Be 'catzc'
            (Get-Config -Config gadget)['owner'] | Should -Be 'catzc'
        }

        It 'reads a consumer''s config from a call outside it when -Namespace names it' -Tag 'ADR-AUTO-CONSUMER-OWNCONFIGS' {
            (Get-Config -Config gadget -Namespace Widget)['owner'] | Should -Be 'widget'
            (Read-CatzcFixture -Name sprocket)['owner'] | Should -Be 'catzc'
        }

        It 'builds the type the consumer registry names, and looks for no overlay fragment' -Tag 'ADR-AUTO-CONSUMER-OWNCONFIGS' {
            Mock Get-CatzcRunMode -ModuleName Catzc.Base.Config -MockWith { 'build' }
            $script:table['Widget/gadget'].Registry = @{ type = 'WidgetConfigTest.FixtureConfig' }
            $result = Get-Config -Config gadget -Namespace Widget
            $result -is [WidgetConfigTest.FixtureConfig] | Should -BeTrue
            $result.Raw['owner'] | Should -Be 'widget'
            Should -Invoke Get-ConfigOverlayRoot -ModuleName Catzc.Base.Config -Times 0 -Exactly
        }

        It 'throws for a name only Catzc has when a Widget module asks, naming both namespaces and the way to read it' -Tag 'ADR-AUTO-CONSUMER-OWNCONFIGS' {
            { Read-WidgetFixture -Name sprocket } | Should -Throw "*namespace 'Widget'*namespace 'Catzc'*-Namespace Catzc*"
        }

        It 'throws the discovery error, with no hint, for a name no namespace has' {
            { Read-WidgetFixture -Name cog } | Should -Throw "*No config 'cog'*namespace 'Widget'*"
        }

        It 'lists the owners of the namespace the call resolves in' -Tag 'ADR-AUTO-CONSUMER-OWNCONFIGS' {
            (Get-Config -Config gadget -ListOwners -Namespace Widget).Module | Should -Be 'Widget.Local'
            (Get-Config -Config gadget -ListOwners).Module | Should -Be 'Catzc.Base.Widget'
        }
    }

    Context 'a config of a consumer namespace (Resolve-ConfigEntry)' -Tag 'logic' {
        # A catzc code root and a consumer working root, both fixtures behind their seams; the consumer's track is declared as the variants config would.
        BeforeEach {
            $script:catzcRoot = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
            $script:workingRoot = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
            New-Item -ItemType Directory -Path (Join-Path $catzcRoot 'Catzc.Base.Widget/configs') -Force | Out-Null
            Set-Content -LiteralPath (Join-Path $catzcRoot 'Catzc.Base.Widget/Catzc.Base.Widget.psd1') -Value '@{}'
            Set-Content -LiteralPath (Join-Path $catzcRoot 'Catzc.Base.Widget/configs/gadget.yml') -Value 'teeth: 12'
            foreach ($folder in 'widget/Local/configs', 'widget/Other/configs', 'widget/tests/configs', '.catzc/configs') {
                New-Item -ItemType Directory -Path (Join-Path $workingRoot $folder) -Force | Out-Null
            }
            Set-Content -LiteralPath (Join-Path $workingRoot '.catzc/configs/variants.yml') -Value 'tracks: {}'
            Set-Content -LiteralPath (Join-Path $workingRoot 'widget/Local/configs/gadget.yml') -Value 'teeth: 8'
            Set-Content -LiteralPath (Join-Path $workingRoot 'widget/Local/configs/configs.yml') -Value @('configs:', '  gadget:', '    type: Widget.GadgetConfig')
            Set-Content -LiteralPath (Join-Path $workingRoot 'widget/Other/configs/sprocket.yml') -Value 'teeth: 4'
            Set-Content -LiteralPath (Join-Path $workingRoot 'widget/tests/configs/cog.yml') -Value 'teeth: 2'
            Mock Get-CatzcModulesRoot -ModuleName Catzc.Base.Config -MockWith { $catzcRoot }
            Mock Get-ConfigOverlayRoot -ModuleName Catzc.Base.Config -MockWith { }
            Mock Get-ConfigRegistry -ModuleName Catzc.Base.Config -MockWith { [ordered]@{} }
            Mock Get-RepositoryRoot -ModuleName Catzc.Base.Config -MockWith { $workingRoot }
            Mock Get-CatzcRunMode -ModuleName Catzc.Base.Config -MockWith { 'build' }
            Mock Get-Config -ModuleName Catzc.Base.Config -ParameterFilter { $Config -eq 'variants' } -MockWith {
                $member = [Catzc.Base.Variants.VariantMember]::new('widget')
                $track = [Catzc.Base.Variants.VariantTrack]::new('widget', [Catzc.Base.Variants.VariantMember[]]@($member), 'modules', $null,
                    [string[]]@('powershell'), $null, $null, $null, 'Widget')
                [pscustomobject]@{ tracks = @($track) }
            }
            Mock Get-Config -ModuleName Catzc.Base.Config -ParameterFilter { $Config -eq 'module-types' } -MockWith {
                $place = [pscustomobject]@{ name = 'folder'; except = @('tests') }
                [pscustomobject]@{ types = @([pscustomobject]@{ places = @($place) }) }
            }
            InModuleScope Catzc.Base.Config { $script:configIndex = $null }
        }

        AfterEach {
            InModuleScope Catzc.Base.Config { $script:configIndex = $null }
        }

        It 'indexes a consumer track module''s config under the track''s namespace, with the registry entry beside it' -Tag 'ADR-AUTO-CONSUMER-OWNCONFIGS' {
            $entry = InModuleScope Catzc.Base.Config { Resolve-ConfigEntry -Name gadget -Namespace Widget }
            $entry.Namespace | Should -BeExactly 'Widget'
            $entry.Module | Should -BeExactly 'Widget.Local'
            $entry.Folder | Should -BeExactly 'Local'
            [System.IO.Path]::GetFullPath($entry.Path) | Should -Be ([System.IO.Path]::GetFullPath((Join-Path $workingRoot 'widget/Local/configs/gadget.yml')))
            $entry.Registry['type'] | Should -BeExactly 'Widget.GadgetConfig'
        }

        It 'resolves one name in catzc and in a consumer namespace as two configs, without a throw' -Tag 'ADR-AUTO-CONSUMER-OWNCONFIGS' {
            $entries = InModuleScope Catzc.Base.Config {
                Resolve-ConfigEntry -Config gadget
                Resolve-ConfigEntry -Config gadget -Namespace Widget
            }
            @($entries).Count | Should -Be 2
            $entries[0].Module | Should -BeExactly 'Catzc.Base.Widget'
            $entries[1].Module | Should -BeExactly 'Widget.Local'
            $entries[0].Path | Should -Not -Be $entries[1].Path
        }

        It 'throws for a name two modules of one consumer namespace both ship, and -Module disambiguates' -Tag 'ADR-CONF-LOADING-EXISTENCEDISCOVERED' {
            Set-Content -LiteralPath (Join-Path $workingRoot 'widget/Other/configs/gadget.yml') -Value 'teeth: 6'
            InModuleScope Catzc.Base.Config {
                { Resolve-ConfigEntry -Config gadget -Namespace Widget } | Should -Throw "*multiple modules of the namespace 'Widget' (Widget.Local, Widget.Other)*"
                (Resolve-ConfigEntry -Config gadget -Namespace Widget -Module Widget.Other).Module | Should -BeExactly 'Widget.Other'
                (Resolve-ConfigEntry -Config gadget).Module | Should -BeExactly 'Catzc.Base.Widget'
            }
        }

        It 'refuses a consumer registry that names a type in the system''s namespace' -Tag 'ADR-AUTO-CONSUMER-OWNCONFIGS' {
            Set-Content -LiteralPath (Join-Path $workingRoot 'widget/Local/configs/configs.yml') -Value @('configs:', '  gadget:', '    type: Catzc.Base.Widget.GadgetConfig')
            InModuleScope Catzc.Base.Config {
                { Resolve-ConfigEntry -Config gadget -Namespace Widget } | Should -Throw "*names the type 'Catzc.Base.Widget.GadgetConfig'*system's namespace*"
            }
        }

        It 'accepts a consumer registry that names a type the system ships' -Tag 'ADR-AUTO-CONSUMER-OWNCONFIGS' {
            Set-Content -LiteralPath (Join-Path $workingRoot 'widget/Local/configs/configs.yml') -Value @('configs:', '  gadget:', '    type: Catzc.Base.Config.ConfigsConfig')
            $entry = InModuleScope Catzc.Base.Config { Resolve-ConfigEntry -Config gadget -Namespace Widget }
            $entry.Registry['type'] | Should -BeExactly 'Catzc.Base.Config.ConfigsConfig'
        }

        It 'merges the registries of one namespace, and lists a registered type with no file under its registering module' -Tag 'ADR-AUTO-CONSUMER-OWNCONFIGS' {
            Set-Content -LiteralPath (Join-Path $workingRoot 'widget/Other/configs/configs.yml') -Value @('configs:', '  sprocket-bare:', '    type: Widget.SprocketBareConfig')
            $entries = InModuleScope Catzc.Base.Config {
                Resolve-ConfigEntry -Config gadget -Namespace Widget
                Resolve-ConfigEntry -Config sprocket-bare -Namespace Widget
            }
            $entries[0].Registry['type'] | Should -BeExactly 'Widget.GadgetConfig'
            $entries[1].Module | Should -BeExactly 'Widget.Other'
            $entries[1].Path | Should -BeNullOrEmpty
            $entries[1].Registry['type'] | Should -BeExactly 'Widget.SprocketBareConfig'
        }

        It 'refuses a config two registries of one namespace both register' -Tag 'ADR-AUTO-CONSUMER-OWNCONFIGS' {
            Set-Content -LiteralPath (Join-Path $workingRoot 'widget/Other/configs/configs.yml') -Value @('configs:', '  gadget:', '    type: Widget.OtherGadgetConfig')
            InModuleScope Catzc.Base.Config {
                { Resolve-ConfigEntry -Config gadget -Namespace Widget } | Should -Throw "*registered twice in the namespace 'Widget'*"
            }
        }

        It 'keeps the registry out of the configs, and the track''s test holder and the other namespaces out of the default lookup' {
            InModuleScope Catzc.Base.Config {
                @(Resolve-ConfigEntry -Config configs -Namespace Widget -All).Count | Should -Be 0
                @(Resolve-ConfigEntry -Config cog -Namespace Widget -All).Count | Should -Be 0
                @(Resolve-ConfigEntry -Config sprocket -All).Count | Should -Be 0
                @(Resolve-ConfigEntry -Config sprocket -Namespace Widget -All).Count | Should -Be 1
                { Resolve-ConfigEntry -Config sprocket } | Should -Throw "*No config 'sprocket'*namespace 'Catzc'*"
            }
        }

        It 'indexes no consumer namespace in a source run, and no catzc config changes' -Tag 'ADR-AUTO-CONSUMER-OWNCONFIGS' {
            Mock Get-CatzcRunMode -ModuleName Catzc.Base.Config -MockWith { 'source' }
            InModuleScope Catzc.Base.Config {
                @(Resolve-ConfigEntry -Config gadget -Namespace Widget -All).Count | Should -Be 0
                (Resolve-ConfigEntry -Config gadget).Module | Should -BeExactly 'Catzc.Base.Widget'
            }
        }

        It 'fails the index whole when a read fails, so a later call reads a fresh one' {
            Set-Content -LiteralPath (Join-Path $workingRoot 'widget/Local/configs/configs.yml') -Value @('configs:', '  gadget:', '    type: Catzc.Base.Widget.GadgetConfig')
            InModuleScope Catzc.Base.Config {
                { Resolve-ConfigEntry -Config gadget } | Should -Throw '*system''s namespace*'
                $script:configIndex | Should -BeNullOrEmpty
            }
        }
    }
}
