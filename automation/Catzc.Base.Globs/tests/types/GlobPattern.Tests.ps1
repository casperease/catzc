# The dialect's truth table (ADR-FLOW-CD-GLOBS:2) and the constructor gate (ADR-FLOW-CD-GLOBS:3): per-segment PowerShell
# wildcards, '**' as the only cross-segment operator (zero or more whole segments), case-sensitive; a
# malformed pattern never produces an instance.
Describe 'GlobPattern' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:match = {
            param([string] $pattern, [string] $path)
            [Catzc.Base.Globs.GlobPattern]::new($pattern).Matches($path)
        }
    }

    Context 'per-segment wildcards (the -like dialect)' {
        It 'matches <path> against <pattern> => <expected>' -ForEach @(
            @{ pattern = 'importer.ps1'; path = 'importer.ps1'; expected = $true }
            @{ pattern = 'importer.ps1'; path = 'importer.ps2'; expected = $false }
            @{ pattern = 'pipelines/ci-*.yaml'; path = 'pipelines/ci-automation.yaml'; expected = $true }
            @{ pattern = 'pipelines/ci-*.yaml'; path = 'pipelines/cd-apex.yaml'; expected = $false }
            @{ pattern = 'pipelines/ci-*.yaml'; path = 'pipelines/steps/ci-x.yaml'; expected = $false }
            @{ pattern = 'docs/?.md'; path = 'docs/a.md'; expected = $true }
            @{ pattern = 'docs/?.md'; path = 'docs/ab.md'; expected = $false }
            @{ pattern = 'src/[a-c]at.cs'; path = 'src/bat.cs'; expected = $true }
            @{ pattern = 'src/[a-c]at.cs'; path = 'src/rat.cs'; expected = $false }
        ) {
            & $script:match $pattern $path | Should -Be $expected
        }

        It 'is case-sensitive' {
            & $script:match 'Docs/*.md' 'docs/a.md' | Should -BeFalse
            & $script:match 'docs/*.MD' 'docs/a.md' | Should -BeFalse
        }

        It 'never lets a single * cross a segment boundary' {
            & $script:match 'automation/*' 'automation/module/file.ps1' | Should -BeFalse
        }
    }

    Context '** — zero or more whole segments' {
        It 'matches <path> against <pattern> => <expected>' -ForEach @(
            @{ pattern = 'automation/**'; path = 'automation/a.ps1'; expected = $true }
            @{ pattern = 'automation/**'; path = 'automation/x/y/z.cs'; expected = $true }
            @{ pattern = 'automation/**'; path = 'automation2/a.ps1'; expected = $false }
            @{ pattern = '**/*.md'; path = 'README.md'; expected = $true }
            @{ pattern = '**/*.md'; path = 'docs/adr/index.md'; expected = $true }
            @{ pattern = '**/*.md'; path = 'docs/adr/index.txt'; expected = $false }
            @{ pattern = '**/tests/**/*.ps1'; path = 'automation/M/tests/a.Tests.ps1'; expected = $true }
            @{ pattern = '**/tests/**/*.ps1'; path = 'automation/M/a.ps1'; expected = $false }
            @{ pattern = 'a/**/b'; path = 'a/b'; expected = $true }
            @{ pattern = 'a/**/b'; path = 'a/x/b'; expected = $true }
            @{ pattern = 'a/**/b'; path = 'a/x/y/b'; expected = $true }
            @{ pattern = 'a/**/b'; path = 'a/x/y/c'; expected = $false }
            @{ pattern = 'a/**/**/b'; path = 'a/b'; expected = $true }
        ) {
            & $script:match $pattern $path | Should -Be $expected
        }

        It 'backtracks across multiple ** operators' {
            & $script:match '**/x/**/y.txt' 'a/x/b/x/c/y.txt' | Should -BeTrue
        }
    }

    Context 'the constructor gate (ADR-FLOW-CD-GLOBS:3)' {
        It 'rejects <why>: <pattern>' -ForEach @(
            @{ pattern = ''; why = 'an empty pattern' }
            @{ pattern = '   '; why = 'a whitespace pattern' }
            @{ pattern = 'a\b.cs'; why = 'a backslash separator' }
            @{ pattern = '/automation/**'; why = 'a leading slash' }
            @{ pattern = 'automation//x.ps1'; why = 'a doubled slash (empty segment)' }
            @{ pattern = 'automation/'; why = 'a trailing slash (empty segment)' }
            @{ pattern = './automation/**'; why = 'a . segment' }
            @{ pattern = 'a/../b'; why = 'a .. segment' }
            @{ pattern = 'a/`*.md'; why = 'a backtick (no escape character)' }
            @{ pattern = 'a/x**/b'; why = '** embedded inside a segment' }
            @{ pattern = 'a/[ab.md'; why = 'a malformed wildcard segment (unclosed [)' }
        ) {
            { [Catzc.Base.Globs.GlobPattern]::new($pattern) } | Should -Throw
        }

        It 'reports the offending pattern in the error' {
            { [Catzc.Base.Globs.GlobPattern]::new('a/x**/b') } | Should -Throw '*a/x`*`*/b*'
        }
    }

    Context 'match input handling' {
        It 'matches nothing on a null or empty path' {
            $p = [Catzc.Base.Globs.GlobPattern]::new('**')
            $p.Matches($null) | Should -BeFalse
            $p.Matches('') | Should -BeFalse
        }

        It 'exposes the authored pattern' {
            [Catzc.Base.Globs.GlobPattern]::new('a/**/b').Pattern | Should -Be 'a/**/b'
            "$([Catzc.Base.Globs.GlobPattern]::new('a/**/b'))" | Should -Be 'a/**/b'
        }
    }
}
