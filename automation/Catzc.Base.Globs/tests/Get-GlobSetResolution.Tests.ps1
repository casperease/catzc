# The working-tree resolution (ADR-GLOBS:11): Included = git ∩ Matches (the package, the durable-SHA input),
# ordinal-sorted; Count is its size (the marker's readable `files:` digest); ScopedSha its list-identity SHA.
# Deterministic and bound to the committed file names only — no 'filtered' local-tree half.
Describe 'Get-GlobSetResolution' -Tag 'L1', 'logic' {
    BeforeAll {
        $script:make = {
            param([string[]] $inc, [string[]] $exc = @())
            [Catzc.Base.Globs.GlobSet]::new('unit', 'd', 'loose-fileset', $inc, $exc, @(), @(), -1, $null)
        }
    }

    It 'resolves Included = git ∩ Matches (a "-" exclude drops a tracked file from the package)' {
        Mock Get-TrackedFile { @('src/a.cs', 'src/gen/keep.cs', 'other/x.cs') } -ModuleName Catzc.Base.Globs

        $result = Get-GlobSetResolution -GlobSet (& $script:make @('src/**') @('src/gen/**'))

        # src/a.cs matches; src/gen/keep.cs is dropped by the exclude; other/x.cs is not matched.
        $result.Included | Should -Be @('src/a.cs')
        $result.Count | Should -Be 1
    }

    It 'Count and ScopedSha are the size and list-identity SHA of the ordinal-sorted Included' {
        Mock Get-TrackedFile { @('src/b.cs', 'src/a.cs') } -ModuleName Catzc.Base.Globs

        $result = Get-GlobSetResolution -GlobSet (& $script:make @('src/**'))

        $result.Count | Should -Be 2
        $result.ScopedSha | Should -Be ([Catzc.Base.Globs.DurableHash]::HashPathList([string[]] @('src/a.cs', 'src/b.cs')))
    }
}
