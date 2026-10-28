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
                [ordered]@{ 'widget-sealed' = [ordered]@{ type = 'System.Collections.Hashtable'; overridable = $false } }
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

    Context 'collision handling (Resolve-ConfigEntry)' -Tag 'logic' {
        It 'throws when a name exists in multiple modules, and -Module disambiguates' {
            InModuleScope Catzc.Base.Config {
                $list = [System.Collections.Generic.List[hashtable]]::new()
                $list.Add(@{ Name = 'dup'; Module = 'A'; Path = 'a.yml' })
                $list.Add(@{ Name = 'dup'; Module = 'B'; Path = 'b.yml' })
                $script:configIndex = @{ dup = $list }
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
                $script:configIndex = @{ widget = $list }
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
                $script:configIndex = @{ widget = $list }
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
            $entries[1].Module | Should -BeExactly 'Gadget' -Because 'a folder with no manifest, such as a local module, is its own name'
        }
    }
}
