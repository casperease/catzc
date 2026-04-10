Describe 'Get-CatsAdrRules' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:adrPath = Join-Path $TestDrive 'alpha-thing.md'
        $content = @(
            '# ADR: Alpha thing'
            ''
            '## Rules: ADR-ALPHA'
            ''
            '### Rule ADR-ALPHA:1'
            ''
            'Alpha does the first thing deterministically.'
            ''
            '- [pointer](#anchor)'
            ''
            '### Rule ADR-ALPHA:2'
            ''
            'Beta never happens without alpha.'
        ) -join "`n"
        [System.IO.File]::WriteAllText($script:adrPath, $content)
    }

    It 'returns one entry per rule heading with its first-line summary' {
        $rules = & (Get-Module Catzc.Base.Docs) { param($p) Get-CatsAdrRules -AdrPath $p } $script:adrPath
        @($rules).Count | Should -Be 2
        $rules[0].Id | Should -Be 'ADR-ALPHA:1'
        $rules[0].Summary | Should -Be 'Alpha does the first thing deterministically.'
        $rules[1].Id | Should -Be 'ADR-ALPHA:2'
        $rules[1].Summary | Should -Be 'Beta never happens without alpha.'
    }
}
