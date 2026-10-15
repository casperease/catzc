<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Objects/tests/types/RepoRelativePath.Tests.ps1
    kind: pester-test
    relatives:
      page: docs/references/automation/catzc-base-objects/tests/types/RepoRelativePath.Tests.ps1.md
      source: automation/Catzc.Base.Objects/types/RepoRelativePath.cs
---
#>

Describe 'RepoRelativePath' -Tag 'L0', 'logic' {
    It 'strips a leading ./ from a relative path' {
        [Catzc.Base.Objects.RepoRelativePath]::new('./automation/mod/file.ps1').Relative | Should -Be 'automation/mod/file.ps1'
    }

    It 'collapses a .. segment' {
        [Catzc.Base.Objects.RepoRelativePath]::new('automation/mod/../mod/file.ps1').Relative | Should -Be 'automation/mod/file.ps1'
    }

    It 'converts backslashes to forward slashes' {
        [Catzc.Base.Objects.RepoRelativePath]::new('automation\mod\file.ps1').Relative | Should -Be 'automation/mod/file.ps1'
    }

    It 'collapses duplicate separators' {
        [Catzc.Base.Objects.RepoRelativePath]::new('automation//mod///file.ps1').Relative | Should -Be 'automation/mod/file.ps1'
    }

    It 'renders the relative form from ToString' {
        $p = [Catzc.Base.Objects.RepoRelativePath]::new('automation/mod/file.ps1')
        "$p" | Should -Be 'automation/mod/file.ps1'
    }

    It 'is not rooted for a relative input' {
        [Catzc.Base.Objects.RepoRelativePath]::new('automation/mod/file.ps1').IsRooted | Should -BeFalse
    }

    It 'resolves to absolute against the given root, not $PWD' {
        $root = [IO.Path]::GetFullPath((Join-Path ([IO.Path]::GetTempPath()) ('catzc-root-' + [Guid]::NewGuid())))
        $expected = [IO.Path]::GetFullPath((Join-Path $root 'automation/mod/file.ps1'))
        [Catzc.Base.Objects.RepoRelativePath]::new('automation/mod/file.ps1').ToAbsolute($root) | Should -Be $expected
    }

    It 'degrades a rooted input to a normalized absolute path' {
        $abs = [IO.Path]::GetFullPath((Join-Path ([IO.Path]::GetTempPath()) ('catzc-' + [Guid]::NewGuid() + '/file.ps1')))
        $p = [Catzc.Base.Objects.RepoRelativePath]::new($abs)
        $p.IsRooted | Should -BeTrue
        $p.Relative | Should -Be $abs
        $p.ToAbsolute('ignored-root') | Should -Be $abs
    }

    It 'throws when a relative path escapes the repository root' {
        { [Catzc.Base.Objects.RepoRelativePath]::new('../outside/file.ps1') } | Should -Throw '*escapes the repository root*'
    }

    It 'throws on an empty path' {
        { [Catzc.Base.Objects.RepoRelativePath]::new('   ') } | Should -Throw '*non-empty*'
    }

    It 'has value equality on the relative form' {
        $a = [Catzc.Base.Objects.RepoRelativePath]::new('automation/mod/file.ps1')
        $b = [Catzc.Base.Objects.RepoRelativePath]::new('./automation/mod/file.ps1')
        $c = [Catzc.Base.Objects.RepoRelativePath]::new('automation/mod/other.ps1')
        $a.Equals($b) | Should -BeTrue
        $a.Equals($c) | Should -BeFalse
    }
}
