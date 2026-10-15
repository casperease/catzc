<#
---
catzc:
  derived:
    path: automation/.internal/tests/Import-Catzc.Tests.ps1
    kind: pester-test
---
#>

# Import-Catzc loads a build: Test-BuildArtifact builds the selection once into a temporary destination...
# [comment:1](/docs/references/automation/internal/tests/Import-Catzc.Tests.ps1.md#comment1)

Describe 'Import-Catzc loads a full build (walking skeleton)' -Tag 'L2', 'integrity', 'greedy', 'source-only' {
    It 'a full build passes the bundle check and loads in build mode (Test-BuildArtifact)' {
        $result = Test-BuildArtifact -ModuleProfile full -Facet Load -PassThru -OutputFolder (Join-Path $TestDrive 'build-artifact')
        $result.Modules | Should -BeGreaterThan 0
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}

Describe 'Import-Catzc loads a reduced build' -Tag 'L2', 'integrity', 'greedy', 'source-only' {
    # A build of one module and its dependency closure still ships the full type set: the selected modules' sources...
    # [comment:2](/docs/references/automation/internal/tests/Import-Catzc.Tests.ps1.md#comment2)
    It 'a reduced build ships the full type set and loads exactly its modules (Test-BuildArtifact)' {
        $result = Test-BuildArtifact -Module 'Catzc.Base.Config' -Facet Load -PassThru -OutputFolder (Join-Path $TestDrive 'build-artifact')
        $result.Modules | Should -BeLessThan (Get-ChildPath (Join-Path (Get-RepositoryRoot) 'automation') -Directory -Depth 1 | Where-Object { -not [System.IO.Path]::GetFileName($_).StartsWith('.') }).Count
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
