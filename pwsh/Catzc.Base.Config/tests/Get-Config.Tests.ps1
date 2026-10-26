<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-config/tests/Get-Config.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'Get-Config' -Tag 'L0' {
    Context 'discovery + raw default' -Tag 'integrity' {
        # A real shipped config, so discovery in its owning module is proven; the raw default is pinned on a fixture
        # below.
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
        # A bundled config and an overlay, both fixtures behind their seams, so a merge is tested without a real
        # consumer.
        BeforeEach {
            $script:bundled = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
            $script:overlay = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
            New-Item -ItemType Directory -Path $bundled | Out-Null
            New-Item -ItemType Directory -Path (Join-Path $overlay 'Catzc.Base.Widget/configs') | Out-Null
            Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -MockWith {
                @{ Name = $Config; Module = 'Catzc.Base.Widget'; Path = (Join-Path $bundled "$Config.yml") }
            }
            Mock Get-ConfigOverlayRoot -ModuleName Catzc.Base.Config -MockWith { $overlay }
            Mock Get-ConfigRegistry -ModuleName Catzc.Base.Config -MockWith {
                [ordered]@{ 'widget-sealed' = [ordered]@{ type = 'System.Collections.Hashtable'; overridable = $false } }
            }
        }

        It 'merges the fragment onto the bundled config before it is returned' {
            Set-Content -Path (Join-Path $bundled 'widget-merged.yml') -Value @('owner: widget', 'limit: 3', 'gadgets:',
                '  lever: 1', '  sprung: 2')
            Set-Content -Path (Join-Path $overlay 'Catzc.Base.Widget/configs/widget-merged.yml') -Value @('limit: 5',
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
            $fragment = Join-Path $overlay 'Catzc.Base.Widget/configs/widget-edited.yml'
            Set-Content -Path $fragment -Value 'limit: 5'
            (Get-Config -Config widget-edited).limit | Should -Be 5
            Set-Content -Path $fragment -Value 'limit: 70'
            [System.IO.File]::SetLastWriteTimeUtc($fragment, [datetime]::UtcNow.AddMinutes(1))
            (Get-Config -Config widget-edited).limit | Should -Be 70
        }

        It 'refuses a fragment of a sealed config' {
            Set-Content -Path (Join-Path $bundled 'widget-sealed.yml') -Value 'limit: 3'
            Set-Content -Path (Join-Path $overlay 'Catzc.Base.Widget/configs/widget-sealed.yml') -Value 'limit: 5'
            { Get-Config -Config widget-sealed } |
                Should -Throw "*Config 'widget-sealed' is sealed*remove*widget-sealed.yml*"
        }

        It 'refuses a fragment that is not a map' {
            Set-Content -Path (Join-Path $bundled 'widget-list.yml') -Value 'limit: 3'
            Set-Content -Path (Join-Path $overlay 'Catzc.Base.Widget/configs/widget-list.yml') -Value @('- gadget',
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
namespace CatzcGetConfigTest {
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
            Mock Get-ConfigRegistry -ModuleName Catzc.Base.Config -MockWith { @{ fixtype = @{ type = 'CatzcGetConfigTest.FixtureConfig' } } }

            $result = Get-Config -Config fixtype
            $result -is [CatzcGetConfigTest.FixtureConfig] | Should -BeTrue
            $result.Raw['k'] | Should -Be 'v'
        }

        It 'builds a registered type with no shipped file from an empty map, and merges the repository''s fragment onto it' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
            $overlay = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
            New-Item -ItemType Directory -Path (Join-Path $overlay 'Catzc.Base.Widget/configs') | Out-Null
            Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -like 'widget-bare*' } -MockWith {
                @{ Name = $Config; Module = 'Catzc.Base.Widget'; Path = $null }
            }
            Mock Get-ConfigRegistry -ModuleName Catzc.Base.Config -MockWith {
                [ordered]@{ 'widget-bare' = @{ type = 'CatzcGetConfigTest.FixtureConfig' }; 'widget-bare-merged' = @{ type = 'CatzcGetConfigTest.FixtureConfig' } }
            }
            Mock Get-ConfigOverlayRoot -ModuleName Catzc.Base.Config -MockWith { $overlay }

            (Get-Config -Config widget-bare).Raw.Count | Should -Be 0
            Set-Content -Path (Join-Path $overlay 'Catzc.Base.Widget/configs/widget-bare-merged.yml') -Value 'limit: 5'
            (Get-Config -Config widget-bare-merged).Raw['limit'] | Should -Be 5
        }
    }

    Context 'a registered type with no shipped file (Resolve-ConfigEntry)' -Tag 'logic' {
        It 'lists it under the module its type''s namespace names, with no path' {
            $root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
            New-Item -ItemType Directory -Path (Join-Path $root 'Catzc.Base.Widget') | Out-Null
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
    }

    Context 'registry self-validation (Catzc.Base.Config.ConfigsConfig)' -Tag 'logic' {
        # Inline registries, so the validator's rules are proven apart from whatever the shipped registry holds today.
        It 'accepts a valid registry (one type per entry)' {
            { [Catzc.Base.Config.ConfigsConfig]::new(@{ configs = [ordered]@{ a = @{ type = 'Foo' }; b = @{ type = 'Bar' } } }) } |
                Should -Not -Throw
        }

        It 'exposes the registry as config name to type, in file order' {
            $registry = [Catzc.Base.Config.ConfigsConfig]::new(@{ configs = [ordered]@{ widget = @{ type = 'Tst.Widget' }; gadget = @{ type = ' Tst.Gadget ' } } })
            @($registry.configs.Keys) | Should -Be @('widget', 'gadget')
            $registry.configs['gadget'] | Should -Be 'Tst.Gadget'
        }

        It 'rejects an unknown top-level key and a non-map configs value' {
            { [Catzc.Base.Config.ConfigsConfig]::new(@{ widget = 1 }) } |
                Should -Throw "*unknown top-level key 'widget' (allowed: configs)*"
            { [Catzc.Base.Config.ConfigsConfig]::new(@{ configs = 'gadget' }) } |
                Should -Throw "*'configs' must be a map*"
        }

        It 'accepts an absent or empty configs map' {
            { [Catzc.Base.Config.ConfigsConfig]::new(@{}) } | Should -Not -Throw
            { [Catzc.Base.Config.ConfigsConfig]::new(@{ configs = [ordered]@{} }) } | Should -Not -Throw
        }

        It 'throws once listing every entry with no type or an unknown key' {
            $thrown = { [Catzc.Base.Config.ConfigsConfig]::new(@{ configs = [ordered]@{ a = @{ module = 'X' }; b = @{ type = 'Foo'; pwsh = 'Bar' }; c = $null } }) } |
                Should -Throw -PassThru
            $thrown.Exception.Message | Should -BeLike "*config 'a': an entry must specify a 'type'*"
            $thrown.Exception.Message |
                Should -BeLike "*config 'b': unknown key 'pwsh' (allowed: type, overridable, differs)*"
            $thrown.Exception.Message | Should -BeLike "*config 'c': an entry must specify a 'type'*"
        }

        It 'lists the sealed configs (overridable: false); absent means overridable' {
            $registry = [Catzc.Base.Config.ConfigsConfig]::new(@{ configs = [ordered]@{
                        widget = @{ type = 'Tst.Widget' }
                        gadget = @{ type = 'Tst.Gadget'; overridable = $false }
                        gizmo  = @{ type = 'Tst.Gizmo'; overridable = $true }
                    }
                })
            @($registry.sealedConfigs) | Should -Be @('gadget')
        }

        It 'reads each key a shipped value may differ on with its reason, and rejects a blank reason or a list' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
            $registry = [Catzc.Base.Config.ConfigsConfig]::new(@{ configs = [ordered]@{
                        widget = @{ type = 'Tst.Widget'; differs = [ordered]@{ size = 'The widgets ship large.' } }
                        gadget = @{ type = 'Tst.Gadget' }
                    }
                })
            $registry.differs['widget']['size'] | Should -BeExactly 'The widgets ship large.'
            $registry.differs.ContainsKey('gadget') | Should -BeFalse
            { [Catzc.Base.Config.ConfigsConfig]::new(@{ configs = [ordered]@{ widget = @{ type = 'Tst.Widget'; differs = @{ size = ' ' } } } }) } |
                Should -Throw "*config 'widget': differs 'size' needs its reason*"
            { [Catzc.Base.Config.ConfigsConfig]::new(@{ configs = [ordered]@{ widget = @{ type = 'Tst.Widget'; differs = @('size') } } }) } |
                Should -Throw "*config 'widget': differs must be a map*"
        }

        It 'compares a shipped key with the type''s Default constant of that key, scalars only' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
            $type = [Catzc.Base.Variants.VariantsConfig]
            $same = [Catzc.Base.Config.ConfigDefaultDifference]::Compare($type,
                [ordered]@{ ado_naming = 'standard'; have_customers = $false })
            @($same).Count | Should -Be 0
            $differs = @([Catzc.Base.Config.ConfigDefaultDifference]::Compare($type,
                [ordered]@{ ado_naming = 'gadget'; tracks = @{ widgets = @{} }; widget_size = 3 }))
            $differs.Count | Should -Be 1
            $differs[0].key | Should -BeExactly 'ado_naming'
            $differs[0].shipped | Should -BeExactly 'gadget'
            $differs[0].declared | Should -BeExactly 'standard'
            [Catzc.Base.Config.ConfigDefaultDifference]::Pascal('have_customers') | Should -BeExactly 'HaveCustomers'
        }

        It 'rejects an overridable that is not true or false' {
            { [Catzc.Base.Config.ConfigsConfig]::new(@{ configs = [ordered]@{ widget = @{ type = 'Tst.Widget'; overridable = 'no' } } }) } |
                Should -Throw "*config 'widget': overridable must be true or false*"
        }

        It 'the shipped registry seals the engine-intrinsic configs' -Tag 'integrity' {
            $raw = Get-Content (Get-CatzcModuleRoot -Module Catzc.Base.Config 'configs/configs.yml') -Raw |
                ConvertFrom-Yaml -Ordered
            $registry = [Catzc.Base.Config.ConfigsConfig]::new($raw)
            foreach ($name in 'configs', 'dependencies', 'profiles', 'exporter', 'glossary') {
                @($registry.sealedConfigs) | Should -Contain $name
            }
        }
    }
}
