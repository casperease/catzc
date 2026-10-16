<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.ModuleSystem/tests/Get-ModuleDependency.Tests.ps1
    folder: tests
    name: get-module-dependency-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-modulesystem/tests/Get-ModuleDependency.Tests.ps1.md
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
