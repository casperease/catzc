# Import-Catzc loads a build: Test-BuildArtifact builds the selection once into a temporary destination (Build-Modules,
# which verifies the bundle with Assert-CatzcBundle), loads it cold in a child pwsh (loaded assemblies and $env: are
# process-global), and checks the load facet by facet — build mode, both roots, every built module once and from
# the build root, the types DLL and its accelerators, every shipped config, help, privates, InModuleScope.

Describe 'Import-Catzc loads a full build (walking skeleton)' -Tag 'L2', 'integrity', 'greedy', 'source-only' {
    It 'a full build passes the bundle check and loads in build mode (Test-BuildArtifact)' {
        $result = Test-BuildArtifact -ModuleProfile full -Facet Load -PassThru -OutputFolder (Join-Path $TestDrive 'build-artifact')
        $result.Modules | Should -BeGreaterThan 0
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}

Describe 'Import-Catzc loads a reduced build' -Tag 'L2', 'integrity', 'greedy', 'source-only' {
    # A build of one module and its dependency closure still ships the full type set: the selected modules'
    # sources in their types/ folders, the rest under .compiled/types/, so the load-time hash finds the full DLL.
    It 'a reduced build ships the full type set and loads exactly its modules (Test-BuildArtifact)' {
        $result = Test-BuildArtifact -Module 'Catzc.Base.Config' -Facet Load -PassThru -OutputFolder (Join-Path $TestDrive 'build-artifact')
        $result.Modules | Should -BeLessThan (Get-ChildItem -Directory (Join-Path (Get-RepositoryRoot) 'automation') | Where-Object Name -NotLike '.*').Count
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
