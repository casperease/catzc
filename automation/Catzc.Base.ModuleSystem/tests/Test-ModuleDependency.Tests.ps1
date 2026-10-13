# cspell:ignore tpols
# Test-ModuleDependency is a quality gate
# ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)): each L0 case runs it with
# -PassThru over mocked boundaries and reads the collected issues; the report goes to $TestDrive.
Describe 'Test-ModuleDependency' {
    Context 'logic (mocked boundaries)' -Tag 'L0', 'logic' {
        It 'reports no issues when actual edges are a subset of declared' {
            InModuleScope Catzc.Base.ModuleSystem {
                Mock Get-ModuleDependencyConfig { [ordered]@{ A = @('B'); B = @() } }
                Mock Get-ModuleGroupConfig { [ordered]@{} }
                Mock Get-AutomationModules { @('A', 'B') }
                Mock Get-ModuleDependency { @([pscustomobject]@{ From = 'A'; To = 'B'; Functions = @('f->g:1') }) }
                Mock Get-CSharpTypeDependency { @() }

                (Test-ModuleDependency -PassThru -OutputFolder (Join-Path $TestDrive 'md')).IssueCount | Should -Be 0
            }
        }

        It 'does not throw when the code conforms' -Tag 'ADR-AUTO-TEST#35' {
            InModuleScope Catzc.Base.ModuleSystem {
                Mock Get-ModuleDependencyConfig { [ordered]@{ A = @('B'); B = @() } }
                Mock Get-ModuleGroupConfig { [ordered]@{} }
                Mock Get-AutomationModules { @('A', 'B') }
                Mock Get-ModuleDependency { @([pscustomobject]@{ From = 'A'; To = 'B'; Functions = @('f->g:1') }) }
                Mock Get-CSharpTypeDependency { @() }

                { Test-ModuleDependency -OutputFolder (Join-Path $TestDrive 'md') } | Should -Not -Throw
            }
        }

        It 'throws once listing every violation' -Tag 'ADR-AUTO-TEST#35' {
            InModuleScope Catzc.Base.ModuleSystem {
                Mock Get-ModuleDependencyConfig { [ordered]@{ A = @('B'); B = @(); 'Catzc.Tpols' = @() } }
                Mock Get-ModuleGroupConfig { [ordered]@{} }
                Mock Get-AutomationModules { @('A', 'B', 'C') }
                Mock Get-ModuleDependency { @([pscustomobject]@{ From = 'A'; To = 'C'; Functions = @('f->h:9') }) }
                Mock Get-CSharpTypeDependency { @() }

                $thrown = { Test-ModuleDependency -OutputFolder (Join-Path $TestDrive 'md') } | Should -Throw -PassThru
                $thrown.Exception.Message | Should -BeLike 'Test-ModuleDependency failed: 2 issue(s)*'
                $thrown.Exception.Message | Should -BeLike '*UndeclaredDependency*A -> C*'
                $thrown.Exception.Message | Should -BeLike '*UnknownModule*Catzc.Tpols*'
            }
        }

        It 'reports an undeclared function dependency' {
            InModuleScope Catzc.Base.ModuleSystem {
                Mock Get-ModuleDependencyConfig { [ordered]@{ A = @('B'); B = @() } }
                Mock Get-ModuleGroupConfig { [ordered]@{} }
                Mock Get-AutomationModules { @('A', 'B', 'C') }
                Mock Get-ModuleDependency { @([pscustomobject]@{ From = 'A'; To = 'C'; Functions = @('f->h:9') }) }
                Mock Get-CSharpTypeDependency { @() }

                $result = Test-ModuleDependency -PassThru -OutputFolder (Join-Path $TestDrive 'md')
                $result.IssueCount | Should -Be 1
                $result.Issues[0] | Should -BeLike '*UndeclaredDependency*A -> C*'
            }
        }

        It 'reports an undeclared TYPE dependency (cross-module C# reference)' {
            InModuleScope Catzc.Base.ModuleSystem {
                Mock Get-ModuleDependencyConfig { [ordered]@{ A = @('B'); B = @() } }
                Mock Get-ModuleGroupConfig { [ordered]@{} }
                Mock Get-AutomationModules { @('A', 'B', 'C') }
                Mock Get-ModuleDependency { @() }
                Mock Get-CSharpTypeDependency { @([pscustomobject]@{ From = 'A'; To = 'C'; References = @('Foo.cs -> C.Bar') }) }

                $result = Test-ModuleDependency -PassThru -OutputFolder (Join-Path $TestDrive 'md')
                $result.IssueCount | Should -Be 1
                $result.Issues[0] | Should -BeLike '*UndeclaredTypeDependency*A -> C*'
            }
        }

        It 'ignores edges from an undeclared (unconstrained) source module' {
            InModuleScope Catzc.Base.ModuleSystem {
                Mock Get-ModuleDependencyConfig { [ordered]@{ A = @('B'); B = @() } }
                Mock Get-ModuleGroupConfig { [ordered]@{} }
                Mock Get-AutomationModules { @('A', 'B', 'C') }
                Mock Get-ModuleDependency { @([pscustomobject]@{ From = 'C'; To = 'A'; Functions = @('x->y:2') }) }
                Mock Get-CSharpTypeDependency { @() }

                (Test-ModuleDependency -PassThru -OutputFolder (Join-Path $TestDrive 'md')).IssueCount | Should -Be 0
            }
        }

        It 'reports a declared module that is missing on disk' {
            InModuleScope Catzc.Base.ModuleSystem {
                Mock Get-ModuleDependencyConfig { [ordered]@{ A = @('B'); B = @(); 'Catzc.Tpols' = @() } }
                Mock Get-ModuleGroupConfig { [ordered]@{} }
                Mock Get-AutomationModules { @('A', 'B') }
                Mock Get-ModuleDependency { @() }
                Mock Get-CSharpTypeDependency { @() }

                $result = Test-ModuleDependency -PassThru -OutputFolder (Join-Path $TestDrive 'md')
                $result.IssueCount | Should -Be 1
                $result.Issues[0] | Should -BeLike '*UnknownModule*Catzc.Tpols*'
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

                (Test-ModuleDependency -PassThru -OutputFolder (Join-Path $TestDrive 'md')).IssueCount | Should -Be 0
            }
        }

        It 'an intra-group edge within the declared internal DAG is allowed' {
            InModuleScope Catzc.Base.ModuleSystem {
                Mock Get-ModuleDependencyConfig { [ordered]@{ A = @('G') } }
                Mock Get-ModuleGroupConfig { [ordered]@{ G = [ordered]@{ M1 = @(); M2 = @('M1') } } }
                Mock Get-AutomationModules { @('A', 'M1', 'M2') }
                Mock Get-ModuleDependency { @([pscustomobject]@{ From = 'M2'; To = 'M1'; Functions = @('m2->m1:1') }) }
                Mock Get-CSharpTypeDependency { @() }

                (Test-ModuleDependency -PassThru -OutputFolder (Join-Path $TestDrive 'md')).IssueCount | Should -Be 0
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

                $result = Test-ModuleDependency -PassThru -OutputFolder (Join-Path $TestDrive 'md')
                $result.IssueCount | Should -Be 1
                $result.Issues[0] | Should -BeLike '*UndeclaredDependency*M1 -> M2*'
            }
        }

        It 'reports a group member that is missing on disk' {
            InModuleScope Catzc.Base.ModuleSystem {
                Mock Get-ModuleDependencyConfig { [ordered]@{ A = @('G') } }
                Mock Get-ModuleGroupConfig { [ordered]@{ G = [ordered]@{ M1 = @(); M2 = @('M1') } } }
                Mock Get-AutomationModules { @('A', 'M1') }     # M2 absent on disk
                Mock Get-ModuleDependency { @() }
                Mock Get-CSharpTypeDependency { @() }

                $result = Test-ModuleDependency -PassThru -OutputFolder (Join-Path $TestDrive 'md')
                $result.IssueCount | Should -Be 1
                $result.Issues[0] | Should -BeLike "*UnknownModule*M2*group 'G'*"
            }
        }
    }

    Context 'integrity (shipped config + real code)' -Tag 'L1', 'integrity', 'source-only' {
        It 'the real code conforms to the declared graph' {
            (Test-ModuleDependency -PassThru -OutputFolder (Join-Path $TestDrive 'module-dependency')).IssueCount | Should -Be 0
        }
    }
}
