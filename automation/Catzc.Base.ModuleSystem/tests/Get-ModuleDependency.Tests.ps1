<#
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/tests/Get-ModuleDependency.Tests.ps1
    kind: pester-test
---
#>

Describe 'Get-ModuleDependency' -Tag 'integrity', 'source-only' {
    BeforeAll {
        $script:edges = Get-ModuleDependency
    }

    It 'CallCount is greater than zero for all edges' -Tag 'L0' {
        # One Should over the violating set — a Should per edge pays Pester's per-assertion cost
        # times the whole discovered graph.
        $violations = @($edges | Where-Object { $_.CallCount -le 0 })
        $violations | Should -BeNullOrEmpty
    }

    It 'works with pipeline input' -Tag 'L1' {
        $piped = Get-FunctionDependency | Get-ModuleDependency
        $piped | Should -Not -BeNullOrEmpty
        $piped.Count | Should -Be $edges.Count
    }
}
