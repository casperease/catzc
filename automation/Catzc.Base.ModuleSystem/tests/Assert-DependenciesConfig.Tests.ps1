Describe 'Assert-DependenciesConfig' -Tag 'L0' {
    Context 'logic (fixture configs)' -Tag 'logic' {
        It 'passes a valid acyclic config' {
            InModuleScope Catzc.Base.ModuleSystem {
                $configuration = @{ modules = [ordered]@{ A = @('B'); B = @() } }
                { Assert-DependenciesConfig $configuration } | Should -Not -Throw
            }
        }

        It 'allows a declared module with no dependencies' {
            InModuleScope Catzc.Base.ModuleSystem {
                $configuration = @{ modules = [ordered]@{ A = @() } }
                { Assert-DependenciesConfig $configuration } | Should -Not -Throw
            }
        }

        It 'throws when a dependency target is not declared' {
            InModuleScope Catzc.Base.ModuleSystem {
                $configuration = @{ modules = [ordered]@{ A = @('B') } }
                { Assert-DependenciesConfig $configuration } | Should -Throw '*not declared in configuration*'
            }
        }

        It 'throws on a two-way cycle' {
            InModuleScope Catzc.Base.ModuleSystem {
                $configuration = @{ modules = [ordered]@{ A = @('B'); B = @('A') } }
                { Assert-DependenciesConfig $configuration } | Should -Throw '*cycle*'
            }
        }

        It 'throws on a longer cycle' {
            InModuleScope Catzc.Base.ModuleSystem {
                $configuration = @{ modules = [ordered]@{ A = @('B'); B = @('C'); C = @('A') } }
                { Assert-DependenciesConfig $configuration } | Should -Throw '*cycle*'
            }
        }

        It 'throws on a self-dependency' {
            InModuleScope Catzc.Base.ModuleSystem {
                $configuration = @{ modules = [ordered]@{ A = @('A') } }
                { Assert-DependenciesConfig $configuration } | Should -Throw '*itself*'
            }
        }

        It 'throws when a module maps to a single string instead of a list' {
            InModuleScope Catzc.Base.ModuleSystem {
                $configuration = @{ modules = [ordered]@{ A = 'B'; B = @() } }
                { Assert-DependenciesConfig $configuration } | Should -Throw '*must map to a list*'
            }
        }

        It 'throws when the modules key is missing' {
            InModuleScope Catzc.Base.ModuleSystem {
                { Assert-DependenciesConfig @{} } | Should -Throw "*'modules'*"
            }
        }
    }

    Context 'groups (fixture configs)' -Tag 'logic' {
        It 'passes a valid config with a group and a module pinning it' {
            InModuleScope Catzc.Base.ModuleSystem {
                $configuration = [ordered]@{
                    groups  = [ordered]@{ G = [ordered]@{ M1 = @(); M2 = @('M1') } }
                    modules = [ordered]@{ A = @('G') }
                }
                { Assert-DependenciesConfig $configuration } | Should -Not -Throw
            }
        }

        It 'lets a module pin a group name as a dependency target' {
            InModuleScope Catzc.Base.ModuleSystem {
                $configuration = [ordered]@{
                    groups  = [ordered]@{ G = [ordered]@{ M1 = @() } }
                    modules = [ordered]@{ A = @('G', 'B'); B = @() }
                }
                { Assert-DependenciesConfig $configuration } | Should -Not -Throw
            }
        }

        It 'throws when a group member depends on a non-member' {
            InModuleScope Catzc.Base.ModuleSystem {
                $configuration = [ordered]@{
                    groups  = [ordered]@{ G = [ordered]@{ M1 = @('Outsider') } }
                    modules = [ordered]@{ A = @('G') }
                }
                { Assert-DependenciesConfig $configuration } | Should -Throw '*not a member of group*'
            }
        }

        It 'throws on a self-dependency inside a group' {
            InModuleScope Catzc.Base.ModuleSystem {
                $configuration = [ordered]@{
                    groups  = [ordered]@{ G = [ordered]@{ M1 = @('M1') } }
                    modules = [ordered]@{ A = @('G') }
                }
                { Assert-DependenciesConfig $configuration } | Should -Throw '*itself*'
            }
        }

        It 'throws on a cycle inside a group' {
            InModuleScope Catzc.Base.ModuleSystem {
                $configuration = [ordered]@{
                    groups  = [ordered]@{ G = [ordered]@{ M1 = @('M2'); M2 = @('M1') } }
                    modules = [ordered]@{ A = @('G') }
                }
                { Assert-DependenciesConfig $configuration } | Should -Throw '*cycle*'
            }
        }

        It 'throws when a group maps to a list instead of a member map' {
            InModuleScope Catzc.Base.ModuleSystem {
                $configuration = [ordered]@{
                    groups  = [ordered]@{ G = @('M1', 'M2') }
                    modules = [ordered]@{ A = @('G') }
                }
                { Assert-DependenciesConfig $configuration } | Should -Throw '*map of member modules*'
            }
        }

        It 'throws when a module depends on a name that is neither a module nor a group' {
            InModuleScope Catzc.Base.ModuleSystem {
                $configuration = [ordered]@{
                    groups  = [ordered]@{ G = [ordered]@{ M1 = @() } }
                    modules = [ordered]@{ A = @('Nope') }
                }
                { Assert-DependenciesConfig $configuration } | Should -Throw '*not declared in configuration*'
            }
        }
    }

    Context 'integrity (shipped config)' -Tag 'integrity' {
        It 'the shipped dependencies.yml loads and validates' {
            InModuleScope Catzc.Base.ModuleSystem {
                { Get-ModuleDependencyConfig } | Should -Not -Throw
            }
        }
    }
}
