<#
---
catzc:
  immutable:
    with_body_sha: "49ead1c732f9"
  edges:
    docs: "[Import-Catzc.Tests.ps1.md](docs/references/pwsh/internal/tests/Import-Catzc.Tests.ps1.md)"
---
#>

Describe 'Import-Catzc loads a full build (walking skeleton)' -Tag 'L2', 'integrity', 'greedy', 'source-only' {
    It 'a full build passes the bundle check and loads in build mode (Test-BuildArtifact)' {
        $result = Test-BuildArtifact -ModuleProfile full -Facet Load -PassThru -OutputFolder (Join-Path $TestDrive 'build-artifact')
        $result.Facts['Modules'] | Should -BeGreaterThan 0
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}

Describe 'Import-Catzc loads a reduced build' -Tag 'L2', 'integrity', 'greedy', 'source-only' {
    It 'a reduced build ships the full type set and loads exactly its modules (Test-BuildArtifact)' {
        $result = Test-BuildArtifact -Module 'Catzc.Base.Config' -Facet Load -PassThru -OutputFolder (Join-Path $TestDrive 'build-artifact')
        $result.Facts['Modules'] | Should -BeLessThan (Get-ChildPath (Get-CatzcModulesRoot) -Directory -Depth 1 | Where-Object { -not [System.IO.Path]::GetFileName($_).StartsWith('.') }).Count
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
