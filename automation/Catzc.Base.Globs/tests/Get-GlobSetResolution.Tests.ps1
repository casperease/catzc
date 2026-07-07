# The working-tree resolution (ADR-GLOBS:11): Included = git ∩ Matches (the package, the durable-SHA input);
# Filtered = untracked ∩ include FOOTPRINT (what is on disk but NOT in the package). Both sorted; each carries
# a list-identity SHA. Tracked files a '-' exclude drops are in NEITHER list.
Describe 'Get-GlobSetResolution' -Tag 'L1', 'logic' {
    BeforeAll {
        $script:make = {
            param([string[]] $inc, [string[]] $exc = @())
            [Catzc.Base.Globs.GlobSet]::new('unit', 'd', 'loose-fileset', $inc, $exc, @(), @(), -1, $null)
        }
    }

    It 'splits the tree into Included (git ∩ Matches) and Filtered (untracked ∩ footprint)' {
        Mock Get-TrackedFile { @('src/a.cs', 'src/gen/keep.cs', 'other/x.cs') } -ModuleName Catzc.Base.Globs
        Mock Get-UntrackedFile { @('src/new.cs', 'src/gen/ignored.tmp', 'out/plan.md', 'other/y.cs') } -ModuleName Catzc.Base.Globs

        $result = Get-GlobSetResolution -GlobSet (& $script:make @('src/**') @('src/gen/**'))

        # Included: src/a.cs matches; src/gen/keep.cs is dropped by the exclude; other/x.cs is not matched.
        $result.Included | Should -Be @('src/a.cs')
        # Filtered: the untracked files the include FOOTPRINT ('+ src/**') touches — ignoring the exclude — so
        # both src/new.cs and src/gen/ignored.tmp; out/plan.md and other/y.cs are outside the footprint.
        $result.Filtered | Should -Be @('src/gen/ignored.tmp', 'src/new.cs')
    }

    It 'ScopedSha / FilteredSha are the list-identity SHAs of Included / Filtered' {
        Mock Get-TrackedFile { @('src/a.cs') } -ModuleName Catzc.Base.Globs
        Mock Get-UntrackedFile { @() } -ModuleName Catzc.Base.Globs

        $result = Get-GlobSetResolution -GlobSet (& $script:make @('src/**'))

        $result.ScopedSha | Should -Be ([Catzc.Base.Globs.DurableHash]::HashPathList([string[]] @('src/a.cs')))
        $result.FilteredSha | Should -Be ([Catzc.Base.Globs.DurableHash]::HashPathList([string[]] @()))
    }
}
