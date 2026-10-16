<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Git/tests/types/GitIgnorePattern.Tests.ps1
    folder: tests/types
    name: git-ignore-pattern-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.Git
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'GitIgnorePattern' -Tag 'L0', 'logic' {
    It 'constructs from a bare string' {
        $p = [Catzc.Base.Git.GitIgnorePattern]::new('out/*')
        $p.pattern | Should -Be 'out/*'
        $p.note | Should -BeNullOrEmpty
    }

    It 'constructs from a pattern + note mapping' {
        $p = [Catzc.Base.Git.GitIgnorePattern]::new(@{ pattern = '!out/.gitkeep'; note = 'keep the folder' })
        $p.pattern | Should -Be '!out/.gitkeep'
        $p.note | Should -Be 'keep the folder'
    }

    It 'presents as a read-only dictionary (DictionaryRecord)' {
        $p = [Catzc.Base.Git.GitIgnorePattern]::new(@{ pattern = 'tmp'; note = 'scratch' })
        $p.Contains('pattern') | Should -BeTrue
        $p['note'] | Should -Be 'scratch'
    }

    It 'throws on an empty pattern' {
        { [Catzc.Base.Git.GitIgnorePattern]::new('') } | Should -Throw '*non-empty*'
        { [Catzc.Base.Git.GitIgnorePattern]::new(@{ note = 'no pattern' }) } | Should -Throw '*pattern is required*'
    }
}
