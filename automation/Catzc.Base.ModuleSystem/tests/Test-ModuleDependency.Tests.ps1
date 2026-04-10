# cspell:ignore tpols
Describe 'Test-ModuleDependency' {
    Context 'logic (mocked boundaries)' -Tag 'L0', 'logic' {
        It 'returns true when actual edges are a subset of declared' {
            InModuleScope Catzc.Base.ModuleSystem {
                Mock Get-ModuleDependencyConfig { [ordered]@{ A = @('B'); B = @() } }
                Mock Get-ModuleGroupConfig { [ordered]@{} }
                Mock Get-AutomationModules { @('A', 'B') }
                Mock Get-ModuleDependency { @([pscustomobject]@{ From = 'A'; To = 'B'; Functions = @('f->g:1') }) }
                Mock Get-CSharpTypeDependency { @() }

                Test-ModuleDependency | Should -BeTrue
            }
        }

        It 'returns false on an undeclared function dependency' {
            InModuleScope Catzc.Base.ModuleSystem {
                Mock Get-ModuleDependencyConfig { [ordered]@{ A = @('B'); B = @() } }
                Mock Get-ModuleGroupConfig { [ordered]@{} }
                Mock Get-AutomationModules { @('A', 'B', 'C') }
                Mock Get-ModuleDependency { @([pscustomobject]@{ From = 'A'; To = 'C'; Functions = @('f->h:9') }) }
                Mock Get-CSharpTypeDependency { @() }

                Test-ModuleDependency | Should -BeFalse
            }
        }

        It 'returns false on an undeclared TYPE dependency (cross-module C# reference)' {
            InModuleScope Catzc.Base.ModuleSystem {
                Mock Get-ModuleDependencyConfig { [ordered]@{ A = @('B'); B = @() } }
                Mock Get-ModuleGroupConfig { [ordered]@{} }
                Mock Get-AutomationModules { @('A', 'B', 'C') }
                Mock Get-ModuleDependency { @() }
                Mock Get-CSharpTypeDependency { @([pscustomobject]@{ From = 'A'; To = 'C'; References = @('Foo.cs -> C.Bar') }) }

                Test-ModuleDependency | Should -BeFalse
            }
        }

        It 'ignores edges from an undeclared (unconstrained) source module' {
            InModuleScope Catzc.Base.ModuleSystem {
                Mock Get-ModuleDependencyConfig { [ordered]@{ A = @('B'); B = @() } }
                Mock Get-ModuleGroupConfig { [ordered]@{} }
                Mock Get-AutomationModules { @('A', 'B', 'C') }
                Mock Get-ModuleDependency { @([pscustomobject]@{ From = 'C'; To = 'A'; Functions = @('x->y:2') }) }
                Mock Get-CSharpTypeDependency { @() }

                Test-ModuleDependency | Should -BeTrue
            }
        }

        It 'returns false when a declared module is missing on disk' {
            InModuleScope Catzc.Base.ModuleSystem {
                Mock Get-ModuleDependencyConfig { [ordered]@{ A = @('B'); B = @(); 'Catzc.Tpols' = @() } }
                Mock Get-ModuleGroupConfig { [ordered]@{} }
                Mock Get-AutomationModules { @('A', 'B') }
                Mock Get-ModuleDependency { @() }
                Mock Get-CSharpTypeDependency { @() }

                Test-ModuleDependency | Should -BeFalse
            }
        }
    }

    Context 'logic — groups (mocked boundaries)' -Tag 'L0', 'logic' {
        # A group 'G' bundles members M1, M2 with an internal DAG M2 -> M1.
        It 'a consumer pinning the GROUP may edge to any member' {
            InModuleScope Catzc.Base.ModuleSystem {
                Mock Get-ModuleDependencyConfig { [ordered]@{ A = @('G') } }
                Mock Get-ModuleGroupConfig { [ordered]@{ G = [ordered]@{ M1 = @(); M2 = @('M1') } } }
                Mock Get-AutomationModules { @('A', 'M1', 'M2') }
                Mock Get-ModuleDependency { @([pscustomobject]@{ From = 'A'; To = 'M2'; Functions = @('a->m:1') }) }
                Mock Get-CSharpTypeDependency { @() }

                Test-ModuleDependency | Should -BeTrue
            }
        }

        It 'an intra-group edge within the declared internal DAG is allowed' {
            InModuleScope Catzc.Base.ModuleSystem {
                Mock Get-ModuleDependencyConfig { [ordered]@{ A = @('G') } }
                Mock Get-ModuleGroupConfig { [ordered]@{ G = [ordered]@{ M1 = @(); M2 = @('M1') } } }
                Mock Get-AutomationModules { @('A', 'M1', 'M2') }
                Mock Get-ModuleDependency { @([pscustomobject]@{ From = 'M2'; To = 'M1'; Functions = @('m2->m1:1') }) }
                Mock Get-CSharpTypeDependency { @() }

                Test-ModuleDependency | Should -BeTrue
            }
        }

        It 'an intra-group edge NOT in the internal DAG is a violation' {
            InModuleScope Catzc.Base.ModuleSystem {
                Mock Get-ModuleDependencyConfig { [ordered]@{ A = @('G') } }
                Mock Get-ModuleGroupConfig { [ordered]@{ G = [ordered]@{ M1 = @(); M2 = @('M1') } } }
                Mock Get-AutomationModules { @('A', 'M1', 'M2') }
                # M1 -> M2 reverses the declared M2 -> M1 layering.
                Mock Get-ModuleDependency { @([pscustomobject]@{ From = 'M1'; To = 'M2'; Functions = @('m1->m2:1') }) }
                Mock Get-CSharpTypeDependency { @() }

                Test-ModuleDependency | Should -BeFalse
            }
        }

        It 'returns false when a group member is missing on disk' {
            InModuleScope Catzc.Base.ModuleSystem {
                Mock Get-ModuleDependencyConfig { [ordered]@{ A = @('G') } }
                Mock Get-ModuleGroupConfig { [ordered]@{ G = [ordered]@{ M1 = @(); M2 = @('M1') } } }
                Mock Get-AutomationModules { @('A', 'M1') }     # M2 absent on disk
                Mock Get-ModuleDependency { @() }
                Mock Get-CSharpTypeDependency { @() }

                Test-ModuleDependency | Should -BeFalse
            }
        }
    }

    Context 'integrity (shipped config + real code)' -Tag 'L1', 'integrity' {
        It 'the real code conforms to the declared graph' {
            Test-ModuleDependency | Should -BeTrue
        }
    }
}
