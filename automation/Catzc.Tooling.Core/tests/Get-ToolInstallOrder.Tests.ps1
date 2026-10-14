Describe 'Get-ToolInstallOrder' -Tag 'L0' {
    Context 'topological sort (fixture graph)' -Tag 'logic' {
        # Isolate the sort from the shipped tools.yml by mocking the config seam to a controlled graph: this
        # verifies the ALGORITHM (dependencies-before-dependents, a diamond, an independent root, and cycle
        # detection), never the production tool set
        # ([ADR-AUTO-PESTER#2](/docs/adr/automation/powershell/pester-testing.md#rule-adr-auto-pester2)/[ADR-AUTO-PESTER#3](/docs/adr/automation/powershell/pester-testing.md#rule-adr-auto-pester3)). 'base/mid1/mid2/top/lone' are fixture
        # identities ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)) — nothing here
        # binds to a real tool name.
        It 'orders every dependency before its dependents (diamond + independent root)' {
            $fixture = [ordered]@{
                base = @{}
                mid1 = @{ depends_on = 'base' }
                mid2 = @{ depends_on = 'base' }
                top  = @{ depends_on = @('mid1', 'mid2') }   # diamond: both mids depend on base, top on both
                lone = @{}                                    # no edges either way
            }
            Mock Get-Config -ModuleName Catzc.Tooling.Core -ParameterFilter { $Config -eq 'tools' } -MockWith { $fixture }

            $order = & (Get-Module Catzc.Tooling.Core) { Get-ToolInstallOrder }

            @($order).Count | Should -Be 5
            @($order | Select-Object -Unique).Count | Should -Be 5                         # each exactly once
            @($order | Sort-Object) | Should -Be @('base', 'lone', 'mid1', 'mid2', 'top')  # all returned
            foreach ($pair in @(@('base', 'mid1'), @('base', 'mid2'), @('mid1', 'top'), @('mid2', 'top'))) {
                [array]::IndexOf($order, $pair[0]) |
                    Should -BeLessThan ([array]::IndexOf($order, $pair[1])) -Because "$($pair[0]) must precede $($pair[1])"
            }
        }

        It 'returns every tool of an all-independent graph (no ordering constraints)' {
            $fixture = [ordered]@{ a = @{}; b = @{}; c = @{} }
            Mock Get-Config -ModuleName Catzc.Tooling.Core -ParameterFilter { $Config -eq 'tools' } -MockWith { $fixture }

            $order = & (Get-Module Catzc.Tooling.Core) { Get-ToolInstallOrder }
            @($order | Sort-Object) | Should -Be @('a', 'b', 'c')
        }

        It 'throws on a circular dependency, naming the tools in the cycle' {
            $fixture = [ordered]@{ a = @{ depends_on = 'b' }; b = @{ depends_on = 'a' } }
            Mock Get-Config -ModuleName Catzc.Tooling.Core -ParameterFilter { $Config -eq 'tools' } -MockWith { $fixture }

            $err = { & (Get-Module Catzc.Tooling.Core) { Get-ToolInstallOrder } } | Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike '*Circular*'
            $err.Exception.Message | Should -BeLike '*a*'
            $err.Exception.Message | Should -BeLike '*b*'
        }
    }

    Context 'shipped tools.yml (generic invariant)' -Tag 'integrity' {
        # Binds to the shipped config as a SET, asserting invariants that hold for every tool — never a
        # specific tool name or a hardcoded pairing
        # ([ADR-AUTO-TEST#17](/docs/adr/automation/test-automation.md#rule-adr-auto-test17)). The ordering algorithm
        # itself is proven by the
        # logic Context above.
        BeforeAll {
            $script:order = & (Get-Module Catzc.Tooling.Core) { Get-ToolInstallOrder }
            # The shipped file wherever its owning module keeps it (Catzc.Base.Execution), read raw so the set
            # compared against is the YAML itself, not the typed model Get-ToolInstallOrder reads.
            $script:allTools = Get-Content (Get-Config -Config tools -ListOwners).Path -Raw | ConvertFrom-Yaml
        }

        It 'returns exactly the shipped tool set, each exactly once' {
            @($order).Count | Should -Be $allTools.Keys.Count
            @($order | Select-Object -Unique).Count | Should -Be @($order).Count
            foreach ($name in $order) {
                $allTools.Keys | Should -Contain $name
            }
        }

        It 'orders every shipped dependency before its dependent' {
            foreach ($name in $allTools.Keys) {
                $dependency = $allTools[$name]['depends_on']
                if ($dependency) {
                    foreach ($dependencyName in @($dependency)) {
                        [array]::IndexOf($order, $dependencyName) |
                            Should -BeLessThan ([array]::IndexOf($order, $name)) -Because "$name depends on $dependencyName"
                    }
                }
            }
        }
    }
}
