<#
---
catzc:
  immutable:
    with_body_sha: "5ebc96817059"
  edges:
    docs: "[Get-ModuleDependency.Tests.ps1.md](docs/references/pwsh/catzc-base-modulesystem/tests/Get-ModuleDependency.Tests.ps1.md)"
    code: pwsh/Catzc.Base.ModuleSystem/Get-ModuleDependency.ps1
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
