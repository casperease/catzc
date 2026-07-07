# The single 'what is IN the package' source (ADR-GLOBS:4): `git ls-files` ∩ GlobSet.Matches, ordinal-sorted.
# Tested through the module (private). The '_' args in the scriptblock take the set and mocked tree.
Describe 'Get-GlobSetMember' -Tag 'L0', 'logic' {
    It 'returns tracked files the set matches, ordinal-sorted (case-sensitive)' {
        Mock Get-TrackedFile { @('src/b.cs', 'src/a.cs', 'other/x.cs', 'src/B.cs') } -ModuleName Catzc.Base.Globs
        & (Get-Module Catzc.Base.Globs) {
            $set = [Catzc.Base.Globs.GlobSet]::new('unit', 'd', 'loose-fileset', @('src/**'), @(), @(), @(), -1, $null)
            Get-GlobSetMember -GlobSet $set
        } | Should -Be @('src/B.cs', 'src/a.cs', 'src/b.cs')
    }

    It 'drops excluded files and returns empty when nothing matches' {
        Mock Get-TrackedFile { @('src/a.cs', 'src/gen/x.cs') } -ModuleName Catzc.Base.Globs
        & (Get-Module Catzc.Base.Globs) {
            $set = [Catzc.Base.Globs.GlobSet]::new('unit', 'd', 'loose-fileset', @('src/**'), @('src/gen/**'), @(), @(), -1, $null)
            Get-GlobSetMember -GlobSet $set
        } | Should -Be @('src/a.cs')

        Mock Get-TrackedFile { @('other/x.cs') } -ModuleName Catzc.Base.Globs
        @(& (Get-Module Catzc.Base.Globs) {
                $set = [Catzc.Base.Globs.GlobSet]::new('unit', 'd', 'loose-fileset', @('src/**'), @(), @(), @(), -1, $null)
                Get-GlobSetMember -GlobSet $set
            }).Count | Should -Be 0
    }
}
