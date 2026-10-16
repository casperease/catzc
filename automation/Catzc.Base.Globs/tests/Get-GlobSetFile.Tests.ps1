<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/tests/Get-GlobSetFile.Tests.ps1
    kind: pester-test
    language: powershell
    track: automation
    module: Catzc.Base.Globs
    relatives:
      page: docs/references/automation/catzc-base-globs/tests/Get-GlobSetFile.Tests.ps1.md
      source: automation/Catzc.Base.Globs/Get-GlobSetFile.ps1
    adrs:
      - ADR-FLOW-CD-GLOBS#{4,5}
---
#>

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
