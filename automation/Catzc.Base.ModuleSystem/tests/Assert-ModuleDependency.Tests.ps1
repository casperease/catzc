Describe 'Assert-ModuleDependency' {
    Context 'logic (mocked boundaries)' -Tag 'L0', 'logic' {
        It 'does not throw when the code conforms' {
            InModuleScope Catzc.Base.ModuleSystem {
                Mock Get-ModuleDependencyConfig { [ordered]@{ A = @('B'); B = @() } }
                Mock Get-ModuleGroupConfig { [ordered]@{} }
                Mock Get-AutomationModules { @('A', 'B') }
                Mock Get-ModuleDependency { @([pscustomobject]@{ From = 'A'; To = 'B'; Functions = @('f->g:1') }) }
                Mock Get-CSharpTypeDependency { @() }

                { Assert-ModuleDependency } | Should -Not -Throw
            }
        }

        It 'throws listing the undeclared function dependency' {
            InModuleScope Catzc.Base.ModuleSystem {
                Mock Get-ModuleDependencyConfig { [ordered]@{ A = @('B'); B = @() } }
                Mock Get-ModuleGroupConfig { [ordered]@{} }
                Mock Get-AutomationModules { @('A', 'B', 'C') }
                Mock Get-ModuleDependency { @([pscustomobject]@{ From = 'A'; To = 'C'; Functions = @('f->h:9') }) }
                Mock Get-CSharpTypeDependency { @() }

                { Assert-ModuleDependency } | Should -Throw '*UndeclaredDependency*A -> C*'
            }
        }

        It 'throws listing an undeclared TYPE dependency (cross-module C# reference)' {
            InModuleScope Catzc.Base.ModuleSystem {
                Mock Get-ModuleDependencyConfig { [ordered]@{ A = @('B'); B = @() } }
                Mock Get-ModuleGroupConfig { [ordered]@{} }
                Mock Get-AutomationModules { @('A', 'B', 'C') }
                Mock Get-ModuleDependency { @() }
                Mock Get-CSharpTypeDependency { @([pscustomobject]@{ From = 'A'; To = 'C'; References = @('Foo.cs -> C.Bar') }) }

                { Assert-ModuleDependency } | Should -Throw '*UndeclaredTypeDependency*A -> C*'
            }
        }

        It 'throws listing an intra-group edge that violates the internal DAG' {
            InModuleScope Catzc.Base.ModuleSystem {
                Mock Get-ModuleDependencyConfig { [ordered]@{ A = @('G') } }
                Mock Get-ModuleGroupConfig { [ordered]@{ G = [ordered]@{ M1 = @(); M2 = @('M1') } } }
                Mock Get-AutomationModules { @('A', 'M1', 'M2') }
                Mock Get-ModuleDependency { @([pscustomobject]@{ From = 'M1'; To = 'M2'; Functions = @('m1->m2:1') }) }
                Mock Get-CSharpTypeDependency { @() }

                { Assert-ModuleDependency } | Should -Throw '*UndeclaredDependency*M1 -> M2*'
            }
        }
    }

    Context 'integrity (shipped config + real code)' -Tag 'L1', 'integrity' {
        It 'the real code conforms to the declared graph' {
            { Assert-ModuleDependency } | Should -Not -Throw
        }
    }
}
