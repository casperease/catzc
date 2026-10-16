<#
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/tests/Get-ModuleDependency.Tests.ps1
    kind: pester-test
    language: powershell
    track: automation
    module: Catzc.Base.ModuleSystem
    relatives:
      page: docs/references/automation/catzc-base-modulesystem/tests/Get-ModuleDependency.Tests.ps1.md
      source: automation/Catzc.Base.ModuleSystem/Get-ModuleDependency.ps1
---
#>

Describe 'Get-ModuleDependency' -Tag 'integrity', 'source-only' {
    BeforeAll {
        $script:edges = Get-ModuleDependency
    }

    It 'CallCount is greater than zero for all edges' -Tag 'L0' {
        $violations = @($edges | Where-Object { $_.CallCount -le 0 })
        $violations | Should -BeNullOrEmpty
    }

    It 'works with pipeline input' -Tag 'L1' {
        $piped = Get-FunctionDependency | Get-ModuleDependency
        $piped | Should -Not -BeNullOrEmpty
        $piped.Count | Should -Be $edges.Count
    }
}
