<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1
    kind: test
---
#>

# The matching universe ([ADR-FLOW-CD-GLOBS#4](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs4)): tracked
# files as `git ls-files` defines them, repo-relative — answered by Get-GitTrackedPath for the whole repository.
Describe 'Get-TrackedFile' -Tag 'L0', 'logic' {
    It "returns the whole repository's tracked set from Get-GitTrackedPath" {
        Mock Get-GitTrackedPath { @('a.txt', 'src/b.cs') } -ModuleName Catzc.Base.Globs

        InModuleScope Catzc.Base.Globs { Get-TrackedFile } | Should -Be @('a.txt', 'src/b.cs')
        Should -Invoke Get-GitTrackedPath -ModuleName Catzc.Base.Globs -Times 1 -Exactly -ParameterFilter { $Path -eq '.' }
    }
}

# The real universe: this repository's own tracked files come back repo-relative with forward slashes,
# including this test file — read in-process from the real index, so no git process runs.
Describe 'Get-TrackedFile (real index)' -Tag 'L1', 'integrity', 'source-only' {
    It 'lists this repository''s tracked files as /-separated repo-relative paths' {
        # @()-wrap both counts: under the importer's strict mode, .Count on a scalar (or an empty pipeline
        # result) throws instead of adapting.
        $files = @(InModuleScope Catzc.Base.Globs { Get-TrackedFile })
        $files.Count | Should -BeGreaterThan 100
        $files | Should -Contain 'importer.ps1'
        @($files | Where-Object { $_ -like '*\*' }).Count | Should -Be 0
    }
}
