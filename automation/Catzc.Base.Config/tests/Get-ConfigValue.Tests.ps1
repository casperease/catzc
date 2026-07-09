Describe 'Get-ConfigValue' -Tag 'L0' {
    Context 'address resolution over a raw dictionary' -Tag 'logic' {
        BeforeAll {
            $script:fixture = [ordered]@{
                name     = 'app'
                database = [ordered]@{
                    host    = 'db1'
                    port    = 5432
                    options = [ordered]@{ ssl = $true }
                }
            }
        }

        BeforeEach {
            # Get-ConfigValue reads through Get-Config (ADR-CONF-LOADING:1); mock the reader, not a file.
            Mock Get-Config -ModuleName Catzc.Base.Config -MockWith { $script:fixture }
        }

        It 'resolves a scalar leaf' {
            Get-ConfigValue -Address 'global.myconfig.name' | Should -Be 'app'
        }

        It 'resolves a deep scalar leaf' {
            Get-ConfigValue -Address 'global.myconfig.database.host' | Should -Be 'db1'
        }

        It 'resolves a subtree node' {
            $node = Get-ConfigValue -Address 'global.myconfig.database'
            $node['port'] | Should -Be 5432
            $node['options']['ssl'] | Should -BeTrue
        }

        It 'addresses the whole config when no key path is given' {
            $node = Get-ConfigValue -Address 'global.myconfig'
            $node['name'] | Should -Be 'app'
        }

        It 'returns the live reference from the config (a resolved node is a read, ADR-CONF-ADDRESSING:5)' {
            $node = Get-ConfigValue -Address 'global.myconfig.database'
            [object]::ReferenceEquals($node, $script:fixture['database']) | Should -BeTrue
        }
    }

    Context 'traversal over a typed object' -Tag 'logic' {
        BeforeAll {
            Add-Type -TypeDefinition @'
namespace CatzcGetConfigValueTest {
    public class Node {
        public string Name;
        public Node Child;
        public Node() {}
        public Node(string n) { Name = n; }
    }
}
'@ -ErrorAction SilentlyContinue
        }

        It 'walks properties on a typed (non-dictionary) node' {
            $obj = [CatzcGetConfigValueTest.Node]::new('root')
            $obj.Child = [CatzcGetConfigValueTest.Node]::new('leaf')
            Mock Get-Config -ModuleName Catzc.Base.Config -MockWith { $obj }

            Get-ConfigValue -Address 'global.myconfig.Child.Name' | Should -Be 'leaf'
        }
    }

    Context 'fail-fast (ADR-CONF-ADDRESSING:4)' -Tag 'logic' {
        BeforeEach {
            Mock Get-Config -ModuleName Catzc.Base.Config -MockWith {
                [ordered]@{ database = [ordered]@{ host = 'db1' } }
            }
        }

        It 'throws naming the failing segment on an unknown key' {
            { Get-ConfigValue -Address 'global.myconfig.database.nope' } | Should -Throw "*'nope'*"
        }

        It 'throws when a mid-path segment is not a container' {
            # 'host' is a scalar; walking 'deeper' into it cannot resolve.
            { Get-ConfigValue -Address 'global.myconfig.database.host.deeper' } | Should -Throw "*'deeper'*"
        }
    }

    Context 'malformed addresses rejected at parameter binding (ValidatePattern)' -Tag 'logic' {
        It 'rejects an address without the global. prefix' {
            { Get-ConfigValue -Address 'myconfig.name' } | Should -Throw
        }

        It 'rejects a bare config name with no config after global.' {
            { Get-ConfigValue -Address 'global.' } | Should -Throw
        }

        It 'rejects a trailing dot' {
            { Get-ConfigValue -Address 'global.myconfig.' } | Should -Throw
        }

        It 'rejects an uppercase config name' {
            { Get-ConfigValue -Address 'global.MyConfig.name' } | Should -Throw
        }
    }

    Context '-Module passthrough' -Tag 'logic' {
        It 'forwards -Module and the parsed config name to Get-Config' {
            Mock Get-Config -ModuleName Catzc.Base.Config -MockWith { [ordered]@{ name = 'app' } }

            Get-ConfigValue -Address 'global.myconfig.name' -Module 'Some.Module' | Out-Null

            Should -Invoke Get-Config -ModuleName Catzc.Base.Config -Times 1 -ParameterFilter {
                $Config -eq 'myconfig' -and $Module -eq 'Some.Module'
            }
        }
    }

    Context 'against a real shipped config' -Tag 'integrity' {
        It 'resolves a real config subtree through the live Get-Config' {
            # tools.yml is a raw (validator-less) config; guards the real wiring end to end (ADR-AUTO-TEST:14).
            (Get-ConfigValue -Address 'global.tools').Contains('python') | Should -BeTrue
        }
    }
}
