# Get-ModuleDependencyClosure is private (breadth-first over the declared dependency map). Tested via InModuleScope with
# the map mocked to a small fixture graph, so the breadth-first/closure logic is exercised independent of the real graph.
Describe 'Get-ModuleDependencyClosure' -Tag 'L0', 'logic' {
    BeforeAll {
        # A -> B, C ; B -> C ; C -> (none) ; D -> (none)
        Mock Get-ModuleDependencyMap -ModuleName Catzc.Base.ModuleSystem {
            @{ 'A' = @('B', 'C'); 'B' = @('C'); 'C' = @(); 'D' = @() }
        }
    }

    It 'returns the seed plus its transitive dependencies, ordinal-sorted' {
        InModuleScope Catzc.Base.ModuleSystem {
            Get-ModuleDependencyClosure -Module 'A' | Should -Be @('A', 'B', 'C')
        }
    }

    It 'a leaf module closes to just itself' {
        InModuleScope Catzc.Base.ModuleSystem {
            Get-ModuleDependencyClosure -Module 'D' | Should -Be @('D')
        }
    }

    It 'merges the closures of multiple seeds without duplicates' {
        InModuleScope Catzc.Base.ModuleSystem {
            Get-ModuleDependencyClosure -Module 'B', 'D' | Should -Be @('B', 'C', 'D')
        }
    }

    It 'a seed absent from the map contributes only itself' {
        InModuleScope Catzc.Base.ModuleSystem {
            Get-ModuleDependencyClosure -Module 'Z' | Should -Be @('Z')
        }
    }
}
