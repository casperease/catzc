Describe 'Get-ModuleGroupConfig' {
    Context 'logic (mocked Get-Config)' -Tag 'L0', 'logic' {
        It 'returns the groups map when the config declares groups' {
            InModuleScope Catzc.Base.ModuleSystem {
                Mock Get-Config { [ordered]@{
                        groups  = [ordered]@{ G = [ordered]@{ M1 = @() } }
                        modules = [ordered]@{ A = @('G') }
                    } } -ParameterFilter { $Config -eq 'dependencies' }

                $groups = Get-ModuleGroupConfig
                $groups.Contains('G') | Should -BeTrue
                @($groups['G'].Keys) | Should -Be @('M1')
            }
        }

        It 'returns an empty ordered dictionary when the config declares no groups' {
            InModuleScope Catzc.Base.ModuleSystem {
                Mock Get-Config { [ordered]@{ modules = [ordered]@{ A = @() } } } -ParameterFilter { $Config -eq 'dependencies' }

                $groups = Get-ModuleGroupConfig
                @($groups.Keys).Count | Should -Be 0
            }
        }
    }

    Context 'integrity (shipped config)' -Tag 'L1', 'integrity' {
        It 'the shipped dependencies.yml groups load without throwing' {
            InModuleScope Catzc.Base.ModuleSystem {
                { Get-ModuleGroupConfig } | Should -Not -Throw
            }
        }
    }
}
