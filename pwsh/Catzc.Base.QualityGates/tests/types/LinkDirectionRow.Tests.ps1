# A row names its relations, from, to, verdict and the rule code that decides it; every malformed row is refused.
Describe 'LinkDirectionRow' -Tag 'L0', 'logic', 'ADR-REPO-LINKS-DIRECTIONSAREROWS' {
    BeforeAll {
        $script:row = { param([hashtable] $Raw) [Catzc.Base.QualityGates.LinkDirectionRow]::new($Raw, 'row 1') }
        $script:end = { param([string] $Path, [string] $Class) [Catzc.Base.QualityGates.LinkEndpoint]::new($Path,
                $Class, '', '', '', '') }
    }

    It 'maps every key and matches its relation and both ends' {
        $row = & $row @{ relations = @('code_link'); from = @{ classes = @('code') }; to = @{ classes = @('adr') }; verdict = 'allow'; because = 'ADR-WIDGET-ONE' }
        $row.verdict | Should -Be ([Catzc.Base.QualityGates.LinkVerdict]::Allow)
        $row.because | Should -Be 'ADR-WIDGET-ONE'
        $row.Matches('CodeLink', (& $end 'mods/a.ps1' 'code'), (& $end 'docs/drs/w.md' 'adr')) | Should -BeTrue
        $row.Matches('MarkdownLink', (& $end 'mods/a.ps1' 'code'), (& $end 'docs/drs/w.md' 'adr')) | Should -BeFalse
    }

    It 'covers every relation when it lists none' {
        $row = & $row @{ verdict = 'deny'; because = 'ADR-WIDGET-TWO' }
        foreach ($relation in 'MarkdownLink', 'CodeLink', 'DocsEdge', 'Convention') {
            $row.Matches($relation, (& $end 'a.md' 'readme'), (& $end 'b.md' 'readme')) | Should -BeTrue
        }
    }

    It 'reads the convention relation, and a row that names it covers no written relation' {
        $row = & $row @{ relations = @('convention'); verdict = 'allow'; because = 'ADR-WIDGET-ONE' }
        $row.relations | Should -Be @([Catzc.Base.QualityGates.LinkRelation]::Convention)
        $row.Matches('Convention', (& $end 'mods/a.Tests.ps1' 'test'), (& $end 'mods/a.ps1' 'code')) | Should -BeTrue
        $row.Matches('CodeLink', (& $end 'mods/a.Tests.ps1' 'test'), (& $end 'mods/a.ps1' 'code')) | Should -BeFalse
    }

    It 'reads a require row with its condition, and refuses one that requires nothing or a condition on another verdict' {
        $required = & $row @{ relations = @('docs_edge'); when = @('convention'); to = @{ classes = @('comment-page') }; verdict = 'require'; because = 'ADR-WIDGET-ONE' }
        $required.verdict | Should -Be ([Catzc.Base.QualityGates.LinkVerdict]::Require)
        $required.when | Should -Be @([Catzc.Base.QualityGates.LinkRelation]::Convention)
        { & $row @{ verdict = 'require'; because = 'ADR-WIDGET-ONE' } } |
            Should -Throw '*a require row names the relations it requires*'
        { & $row @{ when = @('convention'); verdict = 'allow'; because = 'ADR-WIDGET-ONE' } } |
            Should -Throw '*when belongs to a require row only*'
        { & $row @{ relations = @('docs_edge'); when = @('gadget_link'); verdict = 'require'; because = 'ADR-WIDGET-ONE' } } | Should -Throw '*when*convention*'
    }

    It 'refuses a row with no because, an unknown key, an empty or unknown verdict and an unknown relation' {
        { & $row @{ verdict = 'allow' } } | Should -Throw '*because is required*'
        { & $row @{ verdict = 'allow'; because = '  ' } } | Should -Throw '*because is required*'
        { & $row @{ verdict = 'allow'; because = 'ADR-WIDGET-ONE'; note = 'x' } } |
            Should -Throw '*unknown key ''note''*'
        { & $row @{ verdict = ''; because = 'ADR-WIDGET-ONE' } } | Should -Throw '*verdict*allow, deny*'
        { & $row @{ verdict = 'maybe'; because = 'ADR-WIDGET-ONE' } } | Should -Throw '*verdict*allow, deny*'
        { & $row @{ verdict = 1; because = 'ADR-WIDGET-ONE' } } | Should -Throw '*verdict*allow, deny*'
        { & $row @{ relations = @('gadget_link'); verdict = 'deny'; because = 'ADR-WIDGET-ONE' } } |
            Should -Throw '*relations*markdown_link*'
    }
}
