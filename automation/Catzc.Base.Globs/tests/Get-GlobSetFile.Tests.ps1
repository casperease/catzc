# The member list: tracked universe ∩ globset membership, ordinally sorted (ADR-GLOBS:4, ADR-GLOBS:5).
Describe 'Get-GlobSetFile' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:config = [Catzc.Base.Globs.GlobsConfig]::new(@{
                globsets = @{
                    unit = @{ description = 'd'; layer = 'loose-fileset'; include = @('src/**'); exclude = @('**/*.md') }
                }
            })
    }

    BeforeEach {
        Mock Get-Config { $script:config } -ModuleName Catzc.Base.Globs
        Mock Get-TrackedFile {
            @('src/z.cs', 'src/a.cs', 'src/readme.md', 'other/x.cs', 'src/sub/b.cs')
        } -ModuleName Catzc.Base.Globs
    }

    It 'returns only matching tracked files' {
        Get-GlobSetFile -Name unit | Should -Be @('src/a.cs', 'src/sub/b.cs', 'src/z.cs')
    }

    It 'applies excludes' {
        Get-GlobSetFile -Name unit | Should -Not -Contain 'src/readme.md'
    }

    It 'sorts ordinally regardless of git order' {
        Mock Get-TrackedFile { @('src/b.cs', 'src/B.cs', 'src/a.cs') } -ModuleName Catzc.Base.Globs
        # ordinal: uppercase letters sort before lowercase
        Get-GlobSetFile -Name unit | Should -Be @('src/B.cs', 'src/a.cs', 'src/b.cs')
    }

    It 'returns an empty list when nothing matches' {
        Mock Get-TrackedFile { @('other/x.cs') } -ModuleName Catzc.Base.Globs
        @(Get-GlobSetFile -Name unit).Count | Should -Be 0
    }

    It 'throws on an unknown globset' {
        { Get-GlobSetFile -Name nope } | Should -Throw "*no globset named 'nope'*"
    }
}
