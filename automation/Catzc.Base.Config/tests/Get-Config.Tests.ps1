Describe 'Get-Config' -Tag 'L0' {
    Context 'discovery + raw default' -Tag 'integrity' {
        # Reads the shipped tools.yml — guards that a real config is discovered in its owning module and loads
        # ([ADR-AUTO-TEST#14](/docs/adr/automation/test-automation.md#rule-adr-auto-test14)). The raw default itself
        # is pinned hermetically below, on a fixture config with no validator and no registry entry.
        It 'discovers and loads a shipped config from its owning module' {
            $configuration = Get-Config -Config tools                       # registry type: Catzc.Tooling.Core.ToolsConfig
            $configuration.Keys | Should -Contain 'python'
        }
    }

    Context 'caching, errors, and name binding' -Tag 'logic' {
        # Function behaviour, independent of which configs are shipped: memoization, the not-found error
        # path, and parameter-binding validation
        # ([ADR-AUTO-TEST#14](/docs/adr/automation/test-automation.md#rule-adr-auto-test14)). The caching test owns a
        # fixture config
        # through the Resolve-ConfigEntry seam, so it never reads a shipped config
        # ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
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

        It 'returns a config with no validator and no registry entry raw, as an ordered dictionary' {
            $dir = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
            New-Item -ItemType Directory -Path $dir | Out-Null
            Set-Content -Path (Join-Path $dir 'widgetconfig.yml') -Value "gadget: tst`nwidget: 1"
            Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -eq 'widgetconfig' } -MockWith {
                @{ Name = 'widgetconfig'; Module = 'Catzc.Base.Config'; Path = (Join-Path $dir 'widgetconfig.yml') }
            }
            $configuration = Get-Config -Config widgetconfig
            $configuration | Should -BeOfType [System.Collections.Specialized.OrderedDictionary]
            @($configuration.Keys) | Should -Be @('gadget', 'widget')
        }

        It 'throws for an unknown config name' {
            { Get-Config -Config does-not-exist } | Should -Throw '*No config*'
        }

        It 'rejects a non-kebab name at parameter binding' {
            { Get-Config -Config 'Bad_Name' } | Should -Throw
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

    Context 'convention validation (owner scope)' -Tag 'integrity' {
        It 'loads a convention-validated config and passes (real dependencies.yml)' {
            # dependencies maps to the registered C# type Catzc.Base.ModuleSystem.DependenciesConfig, whose
            # dictionary view still answers the 'modules' key.
            (Get-Config -Config dependencies)['modules'] | Should -Not -BeNullOrEmpty
        }
    }

    Context 'registry overrides' -Tag 'logic' {
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

        It 'applies a `pwsh` override, running the named validator in the owner module scope' {
            $dir = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
            New-Item -ItemType Directory -Path $dir | Out-Null
            Set-Content -Path (Join-Path $dir 'fixpwsh.yml') -Value 'k: v'

            Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -eq 'fixpwsh' } -MockWith {
                @{ Name = 'fixpwsh'; Module = 'Catzc.Base.Config'; Path = (Join-Path $dir 'fixpwsh.yml') }
            }
            Mock Get-ConfigRegistry -ModuleName Catzc.Base.Config -MockWith { @{ fixpwsh = @{ pwsh = 'Assert-NotNull' } } }
            Mock Assert-NotNull -ModuleName Catzc.Base.Config

            Get-Config -Config fixpwsh | Out-Null
            Should -Invoke Assert-NotNull -ModuleName Catzc.Base.Config -Times 1
        }

        It 'applies a `type` override, constructing the C# type from the parsed dict' {
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
    }

    Context 'registry self-validation (Catzc.Base.Config.ConfigsConfig)' -Tag 'logic' {
        # Validator logic on inline (synthetic) registries — independent of any shipped configs.yml
        # ([ADR-AUTO-TEST#14](/docs/adr/automation/test-automation.md#rule-adr-auto-test14)).
        It 'accepts a valid registry (type or pwsh per entry)' {
            { [Catzc.Base.Config.ConfigsConfig]::new(@{ configs = [ordered]@{ a = @{ type = 'Foo' }; b = @{ pwsh = 'Bar' } } }) } |
                Should -Not -Throw
        }

        It 'accepts an absent or empty configs map' {
            { [Catzc.Base.Config.ConfigsConfig]::new(@{}) } | Should -Not -Throw
            { [Catzc.Base.Config.ConfigsConfig]::new(@{ configs = [ordered]@{} }) } | Should -Not -Throw
        }

        It 'throws when an entry has both type and pwsh' {
            { [Catzc.Base.Config.ConfigsConfig]::new(@{ configs = [ordered]@{ a = @{ type = 'Foo'; pwsh = 'Bar' } } }) } |
                Should -Throw '*not both*'
        }

        It 'throws when an entry has neither type nor pwsh' {
            { [Catzc.Base.Config.ConfigsConfig]::new(@{ configs = [ordered]@{ a = @{ module = 'X' } } }) } |
                Should -Throw '*must specify*'
        }
    }
}
