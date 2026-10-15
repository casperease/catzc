<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/tests/Get-GlobSetMember.Tests.ps1
    kind: test
---
#>

# The single 'what is IN the package' source
# ([ADR-FLOW-CD-GLOBS#4](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs4)): `git ls-files` ∩
# GlobSet.Matches, ordinal-sorted.
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

    It 'selects from a passed tracked-file list without fetching its own' {
        Mock Get-TrackedFile { @('src/never.cs') } -ModuleName Catzc.Base.Globs
        & (Get-Module Catzc.Base.Globs) {
            $set = [Catzc.Base.Globs.GlobSet]::new('unit', 'd', 'loose-fileset', @('src/**'), @(), @(), @(), -1, $null)
            Get-GlobSetMember -GlobSet $set -TrackedFile @('src/b.cs', 'other/x.cs', 'src/a.cs')
        } | Should -Be @('src/a.cs', 'src/b.cs')
        Should -Invoke Get-TrackedFile -ModuleName Catzc.Base.Globs -Exactly -Times 0
    }
}
