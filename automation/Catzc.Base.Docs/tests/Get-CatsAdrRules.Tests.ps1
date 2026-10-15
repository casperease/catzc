<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/tests/Get-CatsAdrRules.Tests.ps1
    kind: pester-test
    adrs:
      - ADR-REPO-VOCAB#1
---
#>

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
            'Beta never happens without alpha. A **widget'
            'suite** wraps onto a second line.'
            ''
            '- [**gadget**](#anchor)'
            ''
            '### Rule ADR-ALPHA:3'
            ''
            '## Context'
        ) -join "`n"
        [System.IO.File]::WriteAllText($script:adrPath, $content)
        $script:rules = & (Get-Module Catzc.Base.Docs) { param($p) Get-CatsAdrRules -AdrPath $p } $script:adrPath
    }

    It 'returns one entry per rule heading with its first-line summary' {
        @($script:rules).Count | Should -Be 3
        $script:rules[0].Id | Should -Be 'ADR-ALPHA:1'
        $script:rules[0].Summary | Should -Be 'Alpha does the first thing deterministically.'
        $script:rules[1].Id | Should -Be 'ADR-ALPHA:2'
        $script:rules[1].Summary | Should -Be 'Beta never happens without alpha. A **widget'
    }

    It 'returns the whole normative paragraph as one line, without the linked bullets' -Tag 'ADR-REPO-VOCAB#1' {
        $script:rules[0].Statement | Should -Be 'Alpha does the first thing deterministically.'
        $script:rules[1].Statement | Should -Be 'Beta never happens without alpha. A **widget suite** wraps onto a second line.'
    }

    It 'returns an empty summary and statement for a rule with no body' {
        $script:rules[2].Id | Should -Be 'ADR-ALPHA:3'
        $script:rules[2].Summary | Should -Be ''
        $script:rules[2].Statement | Should -Be ''
    }
}
